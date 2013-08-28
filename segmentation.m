%function [ X ] = segmentation(frameNumber, baseDirectory)

	close all;
	clc;
	clear all;
	frameNumber='480';
	baseDirectory='data/SSRR2013/'; 
	frameNumber		

	%//=======================================================================
	%// Kinect Calibration
	%//=======================================================================
	transFudgedVals = [-1.0051469877240551e-02, 3.6296501168410337e-02, -5.6312216296436068e-03];
	rgbIntrinsicVals = [5.1997666258124059e+02, 0, 3.2035780640775630e+02, 0, 5.1906823659381246e+02, 2.5225475675063598e+02, 0, 0, 1];
	rgbDistortionVals =	[2.3282269533065048e-01, -9.2676911644431559e-01, 1.3785293110664286e-03, -3.0566975301827910e-03, 1.4220722610860992];
	dIntrinsicVals = [5.8607137222498295e+02, 0, 3.1056890695602476e+02, 0, 5.8567560309796363e+02, 2.4912535666434175e+02, 0, 0, 1];
	dDistortionVals = [-2.1835400781694411e-01, 1.7910224568641626, 3.8831737257415703e-03, -7.9254527156540370e-04, -5.6385675132989217];
	rotationVals = [9.9997653425563382e-01, 6.8485245163549995e-03, -1.6926322742441872e-04, -6.8493271512092896e-03, 9.9996243174913368e-01, -5.3124201579767246e-03, 1.3287462880795254e-04,  5.3134548373026313e-03, 9.9998587467125000e-01];
	translationVals = [2.3951469877240551e-02, -3.6296501168410337e-03, -5.6312216296436068e-03];
	
	
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
			
	depthDirectory = strcat(baseDirectory, 'depth/');
	rgbDirectory = strcat(baseDirectory, 'rgb/');
	depthImage = strcat(frameNumber, '_d.png');
	rgbImage = strcat(frameNumber, '_rgb.png');
	img = imread(strcat(depthDirectory, depthImage));
	gray_img = rgb2gray(imread(strcat(rgbDirectory, rgbImage)));

	%//=======================================================================
	%// Superpixel segmentation
	%//=======================================================================
	nC = 10; % nC is the target number of superpixels.
	lambda_prime = 0.5;
	sigma = 5.0; 
	conn8 = 1; % flag for using 8 connected grid graph (default setting).

	[labels] = mex_ers(double(img),nC);%-- Call the mex function for superpixel segmentation\
	labels(labels == 0) = nC; %-- Normalize regions to matlab convention of 1:nC instead of 0:nC-1
	%figure, imshow(labels,[]);

	%//=======================================================================
	%// Create Depth Table
	%//=======================================================================
	depthTable = single(zeros(2048, 1));
	for i = 1:2048
		depthTable(i) = 0.1236 * tan(i/2842.5 + 1.1863);
	end
	
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
	meterToCentimetersRatio = 100;
		
	
	for i=1:(nC)
		regionSum = uint64(0);
		region_idx = find(labels==i);
		for j=1:length(region_idx)
			regionSum = uint64(img(region_idx(j))) + regionSum;
		end
		
		if regionSum ~=0
			regions(i, 1) = depthTable(regionSum/length(region_idx))*meterToCentimetersRatio;
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
	%// Find Grayscale Contrast Value for Low Regions
	%//=======================================================================
	%figure, imshow(gray_img, []);
	rbgRegionContrast=[];
	for i = 1:length(holeList)
		rgbRegionSum = uint64(0);
		region_idx = find(labels==i);
		for j=1:length(region_idx)
			rgbRegionSum = uint64(gray_img(region_idx(j))) + rgbRegionSum;
		end
		rbgRegionContrast(i,1) = rgbRegionSum/length(region_idx);	
	end
	

	%//=======================================================================
	%// Find Difference of Candidate Region Area and Boundary Box Area
	%//=======================================================================
	aspectRatio=[];
	boundingBoxArea=[];
	for i = 1:length(holeList)	
		[rows cols] = ind2sub(size(img), find(labels==holeList(i)));
		boundingBoxArea(i,1) = (max(rows)-min(rows))*(max(cols)-min(cols));
		aspectRatio(i,1)= boundingBoxArea(i,1) - length(find(labels==holeList(i)));
	end

	%//=======================================================================
	%// Find Ratio of Region Area to Perimeter
	%//=======================================================================
	perimAreaRatio=[];
	for i = 1:length(holeList)			
		perim = length(find(bwperim(labels==holeList(i))>0));		
		perimAreaRatio(i,1)=perim/length(find(labels==holeList(i)));
	
		%-- Create list of rows/cols coordinates for perimeter of detection
		
		 
		%[r c ] = find(bwperim(labels==holeList(i), 8) > 0);
		%figure,imshow(bwmorph(labels==holeList(i),'remove'));
		%figure,imshow(bwperim(labels==holeList(i)));
		
		se90 = strel('line', 2, 90);
		se0 = strel('line', 2, 0);
		BWsdil = imdilate(labels==holeList(i), [se90 se0]);
		A= bwperim(BWsdil);
		
		%A= bwperim(bwperim(labels==holeList(i)) - (labels==holeList(i)));
		%figure,imshow(A);
		[r c ] = find(A > 0);
	end
		
	
	for i = 1:length(r)		
		tempZ(i,1) = depthTable(img(r(i), c(i)));		
	end
	
	stdZ=std(tempZ);
	medianZ=median(tempZ);
	
	j = 1;
	for i= 1:length(tempZ)
		if abs(tempZ(i)-medianZ) < stdZ
			%--add to list
			z(j,1) = tempZ(i);
			x(j,1) = ((c(i)- dIntrinsicVals(3))*z(j)/dIntrinsicVals(1));
			y(j,1) = ((r(i)- dIntrinsicVals(6))*z(j)/dIntrinsicVals(5));			
			j=j+1;
		end
	end
	

	% draw data
	%figure, plot3( x, y, z, '.r' );
	%figure, plot( x, y, '.r' );
	%figure, hist(z);

	C = cov([x y z]);
	[U S V] = svd(C);
	
	A = [x y z]';
	Uprime = U(:,1:2);
	B = Uprime'*A;
	principleAxis1 = 2* max(abs(B (1,:)));
	principleAxis2 = 2* max(abs(B (2,:)));
	


	%//=======================================================================
	%// Find Minimum Width/Height
	%//=======================================================================
	minWidth=[];
	for i = 1:length(holeList)	
		[rows cols] = ind2sub(size(img), find(labels==holeList(i)));
		holeWidth = (max(rows)-min(rows));
		holeHeight = (max(cols)-min(cols));
		minWidth(i,1)= min(holeWidth, holeHeight);
	end

	
	%//=======================================================================
	%// Calculate Detection Scores
	%//=======================================================================
	for i = 1:length(holeList)
		if minWidth(i,1) > 150
			widthScore(i,1) = 0.2; 
		elseif minWidth(i,1) > 150
			widthScore(i,1) = 0.15; 
		elseif minWidth(i,1) > 100
			widthScore(i,1) = 0.1; 
		elseif minWidth(i,1) > 50
			widthScore(i,1) = 0.05; 
		else
			widthScore(i,1) = 0; 
		end
		
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
	for i = 1:length(detectionScore)	
		if detectionScore > 0
			[rows cols] = ind2sub(size(img), find(labels==holeList(i)));
	%		rectangle('Position',[min(cols) min(rows)  (max(cols)-min(cols)) (max(rows)-min(rows)) ], 'LineWidth', 4, 'EdgeColor','g');
			M{i, 1} = depthImage;
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


