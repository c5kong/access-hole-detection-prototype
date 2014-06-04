%-- Access Hole Detection Prototype --%

function [ X ] = segmentation(frameNumber, baseDirectory)

	tic;
	close all;
	clc;
	
	%frameNumber='12_000180';
	%frameNumber='11_000000';
	%frameNumber='11_000060';
	%frameNumber='9_000720';
	%baseDirectory='data/openni_data/'; 

	outputDirectory = strcat(baseDirectory, 'output/');
	frameNumber		

	
	%//=======================================================================
	%// Load Images
	%//=======================================================================
	
	%--Code to read in IMG
	imageName = strcat(frameNumber, '.png');
	depthDirectory = strcat(baseDirectory, 'metric/');
	rgbDirectory = strcat(baseDirectory, 'rgb/');
	rgbImage = imread(strcat(rgbDirectory,strcat('rgb_', imageName)));	
	grey_img = rgb2gray(rgbImage);

	binaryName = strcat(frameNumber, '.dat');	
	fid = fopen(strcat(depthDirectory,strcat('x_', binaryName)));
	x = fread(fid, inf, '*short');	
	fclose(fid);
	xImage = vec2mat(x,640);
	
	fid = fopen(strcat(depthDirectory,strcat('y_', binaryName)));
	y = fread(fid, inf, '*short');	
	fclose(fid);
	yImage = vec2mat(y,640);
	
	fid = fopen(strcat(depthDirectory,strcat('z_', binaryName)));
	z = fread(fid, inf, '*short');	
	fclose(fid);
	zImage = vec2mat(z,640);
	img = zImage;		
	

	%//=======================================================================
	%// Superpixel segmentation
	%//=======================================================================
	nC = 40; % nC is the target number of superpixels.
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
	figure, imshow(bmapOnImg,[]);
	%figure, imshow(labels,[]);

	numOfRegions = nC;
	

	for k=1:5
		%//=======================================================================
		%// Find neighbours
		combineLoopCheck = numOfRegions;
		
		neighbours = zeros(numOfRegions, numOfRegions);
		for i=1:numOfRegions
			for j=1:numOfRegions
				regionA = find(labels==i);
				regionB = find(labels==j);		
				if (isempty(regionA) | isempty(regionB) )
					neighbours(i, j) = 0;
				else				
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
		end
			
			%%TODO
			%%if region is on the border, remove from the neighbourhood

		%//=======================================================================
		%// Find Absolute Brightness Intensity Score
		maxIntensity = 70;
		contrastScore =[];
		brightnessIntensity=[];
		YCBCR = rgb2ycbcr(rgbImage);
		Y = YCBCR(:, :, 1);
		for i = 1:numOfRegions
			%-- Calculate region brightness averagewidthS	
			rgbRegionSum = uint64(0);
			region_idx = find(labels==i);

			for j=1:length(region_idx)
				rgbRegionSum = uint64(Y(region_idx(j))) + rgbRegionSum;
			end
			brightnessIntensity(i,1) = rgbRegionSum/length(region_idx);	
		
			%Calculate Brightness Score
			if brightnessIntensity(i,1) > maxIntensity
				contrastScore(i,1) = 0;
			else
				contrastScore(i,1) = 1-(brightnessIntensity(i,1)/maxIntensity);
			end
			
		end	

		%//=======================================================================
		%// Combine dark superpixels who are neighbours
		listOfCombined=[];
		for i=1:numOfRegions
			combinedRegionA = find(listOfCombined == i);
			if isempty(combinedRegionA) 
				for j=1:numOfRegions
					combinedRegionB = find(listOfCombined == i);
					if isempty(combinedRegionB) 
						if neighbours(i, j) == 1 & contrastScore(i,1) > 0.6 & contrastScore(j,1) > 0.6;
							labels(labels == j) = i;
							listOfCombined = [listOfCombined; j];
						end
					end
				end
			end
		end

	end
	%figure, imshow(labels,[]);
		
	
	%//=======================================================================
	%// Find Principle Axes of Regions
	%//=======================================================================
	minHumanWidth = 368;  %368mm = 36.8cm
	minHumanLength = 655; %655mm = 65.5cm
	widthThreshold = 0.5;
	
	for i = 1:numOfRegions
		%-- Create list of rows/cols coordinates for perimeter of detection
		se90 = strel('line', 2, 90);
		se0 = strel('line', 2, 0);
		dilatedPerim = imdilate(labels==i, [se90 se0]);
		[r c ] = find(bwperim(dilatedPerim) > 0);
		
		%--filter depth data around the perimeter using standard deviation
		totalZPoints=[];
		k=1;
		r2=[];
		c2=[];		
		for j = 1:length(r)	
			if zImage(r(j), c(j)) ~= 0
				totalZPoints(k,1) = zImage(r(j), c(j));
				r2(k,1) = r(j);
				c2(k,1) = c(j);
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
				x(count,1) = xImage(r2(j), c2(j));
				y(count,1) = yImage(r2(j), c2(j));			
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
		Uprime=[];
		[m n] = size(C);
		if isnan(C) | m~=3 | n~=3
			principleAxis(i,1) = 0;
			principleAxis(i,2) = 0;
		else
			%find C = UDU' using single variable decomposition
			[U S V] = svd(C);
			
			%project x and y onto axes and take the max
			A = [x y z]';
			Uprime = U(:,1:2);
			B = Uprime'*A;
			principleAxis(i,1) = max(B (1,:))-min(B (1,:));
			principleAxis(i,2) = max(B (2,:))-min(B (2,:));
		end

		%Calculate Principle Axes Score	
		if max(principleAxis(i, :)) > (minHumanLength)
			widthScore(i,1) = 1; 
		elseif max(principleAxis(i, :)) > (widthThreshold*minHumanLength)
			widthScore(i,1) = (max(principleAxis(i, :))/minHumanLength); 		
		else
			widthScore(i,1) = 0; 
		end
	end

	
	%//=======================================================================
	%// Calculate Aspect Ratio Score
	%//=======================================================================
	aspectRatio=[];
	boundingBoxArea=[];
	for i = 1:numOfRegions	
	%if the region is not empty matrix
	%TODO
		[rows cols] = ind2sub(size(img), find(labels==i));
		aspectRatio(i,1)= length(find(labels==i))/(min(principleAxis(i, :)) * max(principleAxis(i, :)));
		if aspectRatio(i,1) > 1
			aspectRatioScore(i,1) = 1;		
		else
			aspectRatioScore(i,1) = aspectRatio(i,1);		
		end		
	end	

	
	%//=======================================================================
	%// Find average distance for each region (mm)
	%//=======================================================================
	regions = single(zeros(numOfRegions, 1));				
	for i=1:(numOfRegions)
		regionSum = uint64(0);
		region_idx = find(labels==i);

		for j=1:length(region_idx)
			if uint64(img(region_idx(j))) == 0
				regionSum = 4000 + regionSum;
			else
				regionSum = uint64(img(region_idx(j))) + regionSum;
			end
		end
		
		if regionSum ~=0
			regions(i, 1) = regionSum/length(region_idx);
		else
			regions(i, 1) = 0;
		end
	end	
		
	
	%//=======================================================================
	%// Corrupt Data Handling
	%//=======================================================================
	aRSThreshold = 0.3; %-- min aRS score
	for i = 1:numOfRegions
		distAvg=0;
		neighbourCount=0;
		if regions(i, 1) <=500 %--if the distance is less then 50cm away from the sensor, there is an error in the reading...set it far away
			
			if widthScore(i,1) > 0 & aspectRatioScore(i,1) > 0.3
				%if the widthScore and aspectRatioScore region is larger than x minWidth set the region far away
				regions(i, 1) = 4000; %-- 4m
			else
				%otherwise set the region to the avg of it's neighbours
				for j = i:numOfRegions
					if neighbours(i, j) == 1
						distAvg=distAvg+regions(j,1);
						neighbourCount=neighbourCount+1;
					end
				end
				regions(i, 1) = distAvg/neighbourCount;
			end
		end
		
	end
				
	
	%//=======================================================================
	%// Find Lowest Regions
	%//=======================================================================
	maxDepth = 1951; %-- 195.1cm  -avg height of adult male
	minDepth = 200; %-- 20cm
	depthTolerance = .31;  %-- 31% is baseline
	for i=1:numOfRegions
		flag = 0; %-- set to false
		closestNeighbour = regions(i);

		for j=1:numOfRegions
			if neighbours(i, j) == 1 
				if (regions(i) > regions(j)) 
					flag = 1; 
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
			if closestNeighbour > minDepth && closestNeighbour < (maxDepth*depthTolerance)
				depthScore(i,1) = closestNeighbour/((maxDepth*depthTolerance)-minDepth);
			elseif closestNeighbour > (maxDepth*depthTolerance)
				depthScore(i,1) = 1;
			end						
		end	
	end

	
	%//=======================================================================
	%// Find Relative Brightness Intensity Score
	%//=======================================================================
	avgBrightnessDiff = 68; %--statistically determined
	brightnessStd = 23.2367;
	relativeBrightness = single(zeros(numOfRegions, 1));
	for i = 1:numOfRegions
		brightnessSum = uint64(0);
		numNeighbours = 0;
		for j=1:numOfRegions
			if neighbours(i,j) == 1
				%avg the intensity
				brightnessSum = uint64(brightnessIntensity(j,1)) + brightnessSum;
				numNeighbours = numNeighbours + 1;
			end
		end		
		
		if brightnessSum ~=0
			relativeBrightness(i, 1) = (brightnessSum/numNeighbours)-brightnessIntensity(i,1);
		end
		
		if relativeBrightness(i, 1) > (avgBrightnessDiff + brightnessStd)
			relativeIntensityScore(i,1) = 1;
		else 
			relativeIntensityScore(i,1) = relativeBrightness(i, 1)/(avgBrightnessDiff + brightnessStd);
		end
	end	

	%//=======================================================================
	%// Find Absolute Brightness Intensity Score
	%//=======================================================================
	
	maxIntensity = 70;
	contrastScore =[];
	brightnessIntensity=[];
	YCBCR = rgb2ycbcr(rgbImage);
	Y = YCBCR(:, :, 1);
	for i = 1:numOfRegions
		%-- Calculate region brightness averagewidthS	
		rgbRegionSum = uint64(0);
		region_idx = find(labels==i);

		for j=1:length(region_idx)
			rgbRegionSum = uint64(Y(region_idx(j))) + rgbRegionSum;
		end
		brightnessIntensity(i,1) = rgbRegionSum/length(region_idx);	
	
		%Calculate Brightness Score
		if brightnessIntensity(i,1) > maxIntensity
			contrastScore(i,1) = 0;
		else
			contrastScore(i,1) = 1-(brightnessIntensity(i,1)/maxIntensity);
		end
		
	end		

	%//=======================================================================
	%// Calculate Detection Scores
	%//=======================================================================
	for i = 1:numOfRegions		
		regionBorder(i,1) = 0;
		[r c] = ind2sub(size(img), find(labels==i));		
		if min(r) == 1 ... %--top border
			| min(c) == 1 ... %--left border
			| max(c) == width ... %-- right border
			| min(r) == height %-- bottom border
			regionBorder(i,1) = 1;	
			%--if the region is along the border, then the score is 0
			detectionScore(i,1) = 0;
		else
			%-- assign a detection score based on the feature scores
			%detectionScore(i,1) = (depthScore(i,1) + widthScore(i,1) + aspectRatioScore(i,1) + contrastScore(i,1) + relativeIntensityScore(i,1))/5;
			%detectionScore(i,1) = depthScore(i,1) * contrastScore(i,1) * widthScore(i,1) * aspectRatioScore(i,1) * relativeIntensityScore(i,1);
			%detectionScore(i,1) = relativeIntensityScore(i,1);
			%detectionScore(i,1) = depthScore(i,1) * widthScore(i,1) * aspectRatioScore(i,1) * relativeIntensityScore(i,1);
			detectionScore(i,1) = (depthScore(i,1) + widthScore(i,1) + aspectRatioScore(i,1)+ contrastScore(i,1))/4;

		end
	end	

	
	%//=======================================================================
	%// Display
	%//=======================================================================
	%figure, imshow(bmapOnImg,[]);
	scoreVisualization = labels;
	for i = 1:numOfRegions
		scoreVisualization(scoreVisualization == i) = (detectionScore(i)*255); 
	end
	
	%--show scoreVisualization map
	%figure, imshow(scoreVisualization, []), colormap(gray), axis off, hold on

	
	M ={};		
    count=0;
	for i = 1:numOfRegions	
		if detectionScore(i,1) > 0		
			count= count + 1;
			[rows cols] = ind2sub(size(img), find(labels==i));
			
			%--display detection
			rectangle('Position',[min(cols) min(rows)  (max(cols)-min(cols)) (max(rows)-min(rows)) ], 'LineWidth', 3, 'EdgeColor','g');

			M{count, 1} = frameNumber;
			M{count, 2} = min(cols);
			M{count, 3} = min(rows);
			M{count, 4} = (max(cols)-min(cols));
			M{count, 5} = (max(rows)-min(rows));
			M{count, 6} = detectionScore(i,1);			
		end
	end
	
	%--save the scoreVisualization image to output directory
%	f=getframe(gca);
%	[X, map] = frame2im(f);
%	imwrite(X, strcat(outputDirectory, imageName));
%	hold off;
	
	%--write out CSV
	dlmcell(strcat(outputDirectory, 'avgOutput.csv'), M, ',', '-a');
	
	clear all;
	toc;
end

