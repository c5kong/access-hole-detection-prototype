function [ X ] = groundTruth(imageName, directory)
	close all;
	clc;
	
	%//=======================================================================
	%// Load Images
	%//=======================================================================
	imageName 
	img = imread(strcat(directory, imageName));

	
	%//=======================================================================
	%// Output File Name
	%//=======================================================================
	filename = strcat('groundTruth2.csv');

	%//=======================================================================
	%// Find Region
	%//=======================================================================
	%figure, imshow(labels, []), colormap(gray), axis off, hold on;
	figure, imshow(img, []), colormap(gray), axis off, hold on;
	
	b=[];
	x1=[]; y1=[];
	x2=[]; y2=[];
	
	[x1 y1 b] = ginput(1);
	
	if b ~= 27 		
		[x2 y2 b] = ginput(1);		
		 M{1, 1} = imageName;
		 M{1, 2} = x1;
		 M{1, 3} = y1;
		 M{1, 4} = abs(x2-x1);
		 M{1, 5} = abs(y2-y1);	
		dlmcell(filename, M, ',', '-a');
		rectangle('Position',[M{1, 2} M{1, 3}  M{1, 4} M{1, 5} ], 'LineWidth', 2, 'EdgeColor','b');
	
	end
	hold off;	
	%pause
	clear all;
end