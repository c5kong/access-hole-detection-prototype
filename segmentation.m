%function [ X ] = segmentation(frameNumber, baseDirectory)

	close all;
	clc;
	clear all;
	frameNumber='2000060';
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
	
	rgbImage = imread(strcat(rgbDirectory,strcat('rgb_', imageName)));	
	grey_img = rgb2gray(rgbImage);

	
	%//=======================================================================
	%// Superpixel segmentation
	%//=======================================================================
	nC = 25; % nC is the target number of superpixels.
	lambda_prime = .5;
	sigma = 5.0; 
	conn8 = 1; % flag for using 8 connected grid graph (default setting).

	[labels] = mex_ers(255*double(img)/double(max(img(:))),nC);%-- Call the mex function for superpixel segmentation\
	labels(labels == 0) = nC; %-- Normalize regions to matlab convention of 1:nC instead of 0:nC-1
		
	[height width] = size(labels);
	[bmap] = seg2bmap(labels,width,height);
	bmapOnImg = grey_img;
	idx = find(bmap>0);
	timg = grey_img;
	timg(idx) = 255;
	bmapOnImg(:,:,2) = timg;
	bmapOnImg(:,:,1) = grey_img;
	bmapOnImg(:,:,3) = grey_img;
	%figure, imshow(bmapOnImg,[]);
	%figure, imshow(labels,[]);

	
	%//=======================================================================
	%// Find pairwise superpixel combinations
	%//=======================================================================
	
	%--(In Progress)
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
	%// Find average distance for each region (mm)
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
	maxDepth = 4000; %-- 4 meters
	minDepth = 200; %-- 20cm
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
		
		%--Calculate relative depth score
		depthScore(i,1) = 0;
		if flag == 1					
			if closestNeighbour > minDepth && closestNeighbour < maxDepth 
				depthScore(i,1) = closestNeighbour/(maxDepth-minDepth);
			elseif closestNeighbour > maxDepth
				depthScore(i,1) = 1;
			end						
		end	
	end

	
	%//=======================================================================
	%// Find Primary Axes of Regions
	%//=======================================================================
	for i = 1:nC
		%-- Create list of rows/cols coordinates for perimeter of detection
		se90 = strel('line', 10, 90);
		se0 = strel('line', 10, 0);
		dilatedPerim = imdilate(labels==i, [se90 se0]);
		[r c ] = find(bwperim(dilatedPerim) > 0);
		
		%--filter depth data around the perimeter using standard deviation
		totalZPoints=[];
		k=1;
		for j = 1:length(r)	
			if zImage(r(j), c(j)) ~= 0
				totalZPoints(k,1) = zImage(r(j), c(j));
				k=k+1;
			end			
		end		
		
		stdZ=std(double(totalZPoints));
		medianZ=median(double(totalZPoints));
		count = 1;
		x=[];
		y=[];
		z=[];
		for j= 1:length(totalZPoints)
			if abs(totalZPoints(j)-medianZ) < (stdZ*0.5)
				%--add to list
				z(count,1) = totalZPoints(j);
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

		%TODO - Fix this score
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
	
	%TODO - Fix this score
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
	end	

	%//=======================================================================
	%// Find Absolute Brightness Intensity Score
	%//=======================================================================
	maxIntensity = 255;
	brightnessIntensity=[];
	YCBCR = rgb2ycbcr(rgbImage);
	Y = YCBCR(:, :, 1);
	for i = 1:nC
		%-- Calculate region brightness average
		rgbRegionSum = uint64(0);
		region_idx = find(labels==i);
		for j=1:length(region_idx)
			rgbRegionSum = uint64(Y(region_idx(j))) + rgbRegionSum;
		end
		brightnessIntensity(i,1) = rgbRegionSum/length(region_idx);	
	
		%Calculate Brightness Score
		contrastScore(i,1) = 1-(brightnessIntensity(i,1)/maxIntensity);
	end	

	
	%//=======================================================================
	%// Calculate Detection Scores
	%//=======================================================================
	for i = 1:nC		
		detectionScore(i,1) = (depthScore(i,1) + widthScore(i,1) + aspectRatioScore(i,1) + contrastScore(i,1))/4;
	end

	
	%//=======================================================================
	%// Display
	%//=======================================================================
	scoreVisualization = labels;
	for i = 1:nC
		scoreVisualization(scoreVisualization == i) = (detectionScore(i)*255); 
	end
	figure, imshow(scoreVisualization, []), colormap(gray), axis off, hold on
	
	M ={};	
	for i = 1:nC	
		if detectionScore(i,1) > .6		
			i
			[rows cols] = ind2sub(size(img), find(labels==i));
			rectangle('Position',[min(cols) min(rows)  (max(cols)-min(cols)) (max(rows)-min(rows)) ], 'LineWidth', 2, 'EdgeColor','g');
			M{i, 1} = frameNumber;
			M{i, 2} = min(cols);
			M{i, 3} = min(rows);
			M{i, 4} = (max(cols)-min(cols));
			M{i, 5} = (max(rows)-min(rows));
			M{i, 6} = detectionScore(i,1);
			
		end
	end
	outputDirectory = strcat(baseDirectory, 'output/output');
	%dlmcell(strcat(outputDirectory, '.csv'), M, ',', '-a');
	%f=getframe(gca);
	%[X, map] = frame2im(f);
	%imwrite(X, strcat(outputDirectory, depthImage));
	%hold off;

	
%end


