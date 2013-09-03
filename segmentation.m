%function [ X ] = segmentation(frameNumber, baseDirectory)

	close all;
	clc;
	clear all;
	frameNumber='000364';
	baseDirectory='data/openni_data/'; 
	frameNumber		

	
	%//=======================================================================
	%// initialize feature scores
	%//=======================================================================
	depthScore =[];
	widthScore =[];
	aspectRatioScore =[];
	contrastScore =[];
	detectionScore=[];

	
	%//=======================================================================
	%// Load Images
	%//=======================================================================
	imageName = strcat(frameNumber, '.png');
	depthDirectory = strcat(baseDirectory, 'metric/');
	rgbDirectory = strcat(baseDirectory, 'rgb/');
	xImage = imread(strcat(depthDirectory,strcat('x_', imageName)));
	yImage = imread(strcat(depthDirectory,strcat('y_', imageName)));
	
	zImage = imread(strcat(depthDirectory,strcat('z_', imageName)));
	img = zImage;
	
	rgbImage = imread(strcat(rgbDirectory,strcat('rgb', imageName)));	
	gray_img = rgb2gray(rgbImage);

	
	%//=======================================================================
	%// Superpixel segmentation
	%//=======================================================================
	nC = 20; % nC is the target number of superpixels.
	lambda_prime = 0.5;
	sigma = 5.0; 
	conn8 = 1; % flag for using 8 connected grid graph (default setting).

	[labels] = mex_ers(double(img),nC);%-- Call the mex function for superpixel segmentation\
	labels(labels == 0) = nC; %-- Normalize regions to matlab convention of 1:nC instead of 0:nC-1
	%figure, imshow(labels,[]);

	
	%//=======================================================================
	%// Find pairwise superpixel combinations
	%//=======================================================================

	count = 1;
	regionList=[];
	for i=1:nC
		regionList(count, 1) = count;
		count = count + 1;
	end
	
	for i=1:nC    
		for j=1:nC
			image1 = labels == i;
			image2 =  labels == j;
			image3 = image1 | image2;		
			[ L num ]  = bwlabel(image3);
			if num == 1 & i~=j
				regionList(count, 1) = i;
				regionList(count, 2) = j;
				count = count + 1;
			end
		end		
	end	
	
	
	%//=======================================================================
	%// Find average pixel intensity for each region and save Distance in cm
	%//=======================================================================
	regions = single(zeros(nC, 1));	
			
	for i=1:(nC)
		regionSum = uint64(0);
		region_idx = find(labels==i);
		for j=1:length(region_idx)
			regionSum = uint64(img(region_idx(j))) + regionSum;
		end
		
		if regionSum ~=0
			regions(i, 1) = regionSum/length(region_idx);
		else
			regions(i, 1) = 0;
		end
	end

	
	%//=======================================================================
	%// Find neighbours
	%//=======================================================================

	neighbours = zeros(nC, nC);
	for i=1:nC
		for j=1:nC
			image1 = labels == i;
			image2 =  labels == j;
			image3 = image1 | image2;		
			[ L num ]  = bwlabel(image3);
			if i==j
				neighbours(i, j) = 0;
			elseif num == 1
				neighbours(i, j) = 1;			
			end
		end		
	end

	%//=======================================================================
	%// Find Lowest Regions
	%//=======================================================================

	holes = zeros(size(img));
	count = 0;	
	holeList =[];
	for i=1:nC
		flag = 0; %-- set to false
		closestNeighbour = regions(i);
		numNeighbours = 0;
		for j=1:nC
		
			if neighbours(i, j) == 1 
				if (regions(i) > regions(j)) 
					flag = 1; 					
					numNeighbours = numNeighbours + 1;
					if closestNeighbour > regions(i)-regions(j);
						closestNeighbour = regions(i)-regions(j);
					end
				else
					flag = 0; 
					break;
				end			
			end		
		end
		
		if flag == 1			
			if closestNeighbour > 20 %minimum distance in cm
			
				count = count + 1;
				holeList(count, 1) = i;
				tempImage = labels == i;
				holes = holes | tempImage;		
				

				if closestNeighbour > 110
					depthScore(i,1) = 0.50;
				elseif closestNeighbour > 100
					depthScore(i,1) = 0.45;
				elseif closestNeighbour > 90
					depthScore(i,1) = 0.4;
				elseif closestNeighbour > 80
					depthScore(i,1) = 0.35;
				elseif closestNeighbour > 70
					depthScore(i,1) = 0.3;
				elseif closestNeighbour > 60
					depthScore(i,1) = 0.25;
				elseif closestNeighbour > 50
					depthScore(i,1) = 0.2;
				elseif closestNeighbour > 40
					depthScore(i,1) = 0.15;
				elseif closestNeighbour > 30
					depthScore(i,1) = 0.1;
				else
					depthScore(i,1) = 0.05;					
				end					
			end
		end	
	end

	%figure, imshow(holes);


	%//=======================================================================
	%// Find Primary Axes of Regions
	%//=======================================================================

	for i = 1:nC

		%-- Create list of rows/cols coordinates for perimeter of detection
		se90 = strel('line', 2, 90);
		se0 = strel('line', 2, 0);
		dilatedPerim = imdilate(labels==i, [se90 se0]);
		[r c ] = find(bwperim(dilatedPerim) > 0);
		
		%--filter depth data around the perimeter using standard deviation
		tempZ=[];
		for j = 1:length(r)		
			tempZ(j,1) = zImage(r(j), c(j));
		end		
		
		stdZ=std(double(tempZ));
		medianZ=median(double(tempZ));
		count = 1;
		x=[];
		y=[];
		z=[];
		for j= 1:length(tempZ)
			if abs(tempZ(j)-medianZ) < stdZ
				%--add to list
				z(count,1) = tempZ(j);
				x(count,1) = xImage(r(j), c(j));
				y(count,1) = yImage(r(j), c(j));			
				count=count+1;
			end
		end
		
		x=double(x);
		y=double(y);
		z=double(z);
		
		% draw data
		%figure, plot3( x, y, z, '.r' );
		%figure, plot( x, y, '.r' );
		%figure, hist(z);
		
		%find covariance matrix  (cov will subtract the mean (line 93 in cov.m file))
		C = cov([x y z]);
		
		%find C = UDU' using single variable decomposition
		[U S V] = svd(C);
		
		%project x and y onto axes and take the max
		A = [x y z]';
		Uprime = U(:,1:2);
		B = Uprime'*A;
		principleAxis1(i,1) = 2* max(abs(B (1,:)));
		principleAxis2(i,1) = 2* max(abs(B (2,:)));

		%scoring function
		widthScore(i,1) = 0; 
		
	end

	
	%//=======================================================================
	%// Find Difference of Candidate Region Area and Boundary Box Area
	%//=======================================================================
	aspectRatio=[];
	boundingBoxArea=[];
	for i = 1:nC	
		[rows cols] = ind2sub(size(img), find(labels==i));
		boundingBoxArea(i,1) = (max(rows)-min(rows))*(max(cols)-min(cols));
		aspectRatio(i,1)= boundingBoxArea(i,1) - length(find(labels==i));
	end	
	

	%//=======================================================================
	%// Find Grayscale Contrast Value for Low Regions
	%//=======================================================================
	%figure, imshow(gray_img, []);
	rbgRegionContrast=[];
	YCBCR = rgb2ycbcr(rgbImage);
	Y = YCBCR(:, :, 1);
	for i = 1:nC
		rgbRegionSum = uint64(0);
		region_idx = find(labels==i);
		for j=1:length(region_idx)
			rgbRegionSum = uint64(Y(region_idx(j))) + rgbRegionSum;
		end
		rbgRegionContrast(i,1) = rgbRegionSum/length(region_idx);	
	end
		

	%//=======================================================================
	%// Calculate Detection Scores
	%//=======================================================================
	for i = 1:nC	
		if (aspectRatio(i,1) < (boundingBoxArea(i,1) * 0.55))
			aspectRatioScore(i,1) = 0.05;
		elseif (aspectRatio(i,1) < (boundingBoxArea(i,1) * 0.45))
			aspectRatioScore(i,1) = 0.10;
		elseif (aspectRatio(i,1) < (boundingBoxArea(i,1) * 0.35))
			aspectRatioScore(i,1) = 0.15;
		else
			aspectRatioScore(i,1) = 0;
		end
		
		if (rbgRegionContrast(i,1) < 100)
			contrastScore(i,1) = 0.15;
		elseif (rbgRegionContrast(i,1) < 200)
			contrastScore(i,1) = 0.10;
		elseif (rbgRegionContrast(i,1) < 300)
			contrastScore(i,1) = 0.05;
		else
			contrastScore(i,1) = 0.0;
		end
		
		detectionScore(i,1) = depthScore(i,1) + widthScore(i,1) + aspectRatioScore(i,1) + contrastScore(i,1);
	end

	
	%//=======================================================================
	%// Display
	%//=======================================================================
	outputDirectory = strcat(baseDirectory, 'output/output');
	M ={};
	%figure, imshow(holes), colormap(gray), axis off, hold on
	for i = 1:nC	
		if detectionScore > 0
			[rows cols] = ind2sub(size(img), find(labels==i));
	%		rectangle('Position',[min(cols) min(rows)  (max(cols)-min(cols)) (max(rows)-min(rows)) ], 'LineWidth', 4, 'EdgeColor','g');
			M{i, 1} = frameNumber;
			M{i, 2} = min(cols);
			M{i, 3} = min(rows);
			M{i, 4} = (max(cols)-min(cols));
			M{i, 5} = (max(rows)-min(rows));
			M{i, 6} = detectionScore(i,1);
			
		end
	end
	%dlmcell(strcat(outputDirectory, '.csv'), M, ',', '-a');
	%f=getframe(gca);
	%[X, map] = frame2im(f);
	%imwrite(X, strcat(outputDirectory, depthImage));
	%hold off;

	
	
%end


