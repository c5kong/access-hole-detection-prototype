%-- Access Hole Detection Prototype --%

%function [ X ] = segmentation(frameNumber, baseDirectory)

	tic;
	close all;
	clc;
	
	frameNumber='12_000180';
	%frameNumber='11_000000';
	%frameNumber='11_000060';
	%frameNumber='9_000720';
	baseDirectory='data/openni_data/'; 

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
	nC = 20; % nC is the target number of superpixels.
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

	numOfRegions = nC;
	

	for k=1:3
		%//=======================================================================
		%// Find neighbours
		combineLoopCheck = numOfRegions;
		
		neighbours = zeros(numOfRegions, numOfRegions);
		for i=1:numOfRegions
			for j=i:numOfRegions
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
		%//=======================================================================
		listOfCombined=[];
		for i=1:numOfRegions
			combinedRegionA = find(listOfCombined == i);
			if isempty(combinedRegionA) 
				for j=i:numOfRegions
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


		


