%function [ X ] = illuminationIntensity(depthImage, directory)

	clear all;
	close all;
	clc;
	
	directory='data\training data\';
	depthImage='rubble.jpg';
	
	%//=======================================================================
	%// Load Images
	%//=======================================================================
	depthImage
	img = imread(strcat(directory, depthImage));
	
	%//=======================================================================
	%// Output File Name
	%//=======================================================================
	filename = 'hole_intensities.csv';

	%//=======================================================================
	%// convert from RGB to YUV
	%//=======================================================================
	YCBCR = rgb2ycbcr(img);
	Y = YCBCR(:, :, 1);
	
	%back to RGB
	%RGB = ycbcr2rgb(YCBCR);
	%figure, imshow(RGB);
	
	
	%//=======================================================================
	%// Find Region
	%//=======================================================================	
	figure, imshow(img), axis off, hold on;
	b=0;
	x1=0; x2=0;
	y1=0; y2=0;
	count = 1;
	while (true)
		[x1 y1 b] = ginput(1);
		if b ==27
			break;
		end
		[x2 y2 b] = ginput(1);		
		if b ==27
			break;
		end		
		
		x1=uint64(x1);
		y1=uint64(y1);
		x2=uint64(x2);
		y2=uint64(y2);		
		
		sum = uint64(0);
		for i=y1:y2
			for j=x1:x2	
				sum= uint64(Y(i, j))+ sum;
			end			
		end
		
		avgLum = sum/((x2-x1)+(y2-y1));
		
		
	end

	% M{1, 1} = depthImage;
	% M{1, 2} = x(1);
	% M{1, 3} = y(1);
	% M{1, 4} = abs(x(2)-x(1));
	% M{1, 5} = abs(y(2)-y(1));	
	%dlmcell(filename, M, ',', '-a');
	%rectangle('Position',[M{1, 2} M{1, 3}  M{1, 4} M{1, 5} ], 'LineWidth', 4, 'EdgeColor','r');
	%hold off;

	
%end