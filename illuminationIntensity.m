function [ X ] = illuminationIntensity(imageName, directory)

	clear all;
	close all;
	clc;
	
	directory='data\training data\';
	imageName='rubble.jpg';
	
	%//=======================================================================
	%// Load Images
	%//=======================================================================
	imageName
	img = imread(strcat(directory, imageName));
	
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
	x1=0;	y1=0; 
	x2=0;	y2=0;
	x3=0;	y3=0;
	x4=0;	y4=0;

	while (true)
	
		%--interior rect
		[x1 y1 b] = ginput(1);
		if b ==27
			break;
		end
		[x2 y2 b] = ginput(1);		
		if b ==27
			break;
		end		
		x1=uint64(x1);		y1=uint64(y1);
		x2=uint64(x2);		y2=uint64(y2);		
		rectangle('Position',[x1 y1 abs(x2-x1) abs(y2-y1) ], 'LineWidth', 2, 'EdgeColor','b');
		
		%--interior rect
		[x3 y3 b] = ginput(1);
		if b ==27
			break;
		end
		[x4 y4 b] = ginput(1);		
		if b ==27
			break;
		end						
		x3=uint64(x3);		y3=uint64(y3);
		x4=uint64(x4);		y4=uint64(y4);		
		rectangle('Position',[x3 y3 abs(x4-x3) abs(y4-y3) ], 'LineWidth', 2, 'EdgeColor','g');

		%--find sum of external rect
		extSum = uint64(0);
		for i=y1:y2
			for j=x1:x2	
				extSum= uint64(Y(i, j))+ extSum;
			end			
		end

		%--find sum of internal rect
		intSum = uint64(0);
		for i=y3:y4
			for j=x3:x4	
				intSum= uint64(Y(i, j))+ intSum;
			end			
		end
		
		intRectArea=abs(x4-x3)*abs(y4-y3);
		avgIntLum=intSum/intRectArea;

		extRectArea=abs(x2-x1)*abs(y2-y1);
		avgExtLumDiff=(extSum-intSum)/(extRectArea-intRectArea);
		
		M{1, 1} = imageName;
		M{1, 2} = avgIntLum;
		M{1, 3} = avgExtLumDiff;	
		dlmcell(filename, M, ',', '-a');		
						
	end
	
end