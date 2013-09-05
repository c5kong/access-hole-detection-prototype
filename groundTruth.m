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
	filename = strcat('groundTruth.csv');

	%//=======================================================================
	%// Find Region
	%//=======================================================================
	%figure, imshow(labels, []), colormap(gray), axis off, hold on;
	figure, imshow(img, []), colormap(gray), axis off, hold on;
	[x y b] = ginput(2);
	
	if b ~= 0
		 M{1, 1} = imageName;
		 M{1, 2} = x(1);
		 M{1, 3} = y(1);
		 M{1, 4} = abs(x(2)-x(1));
		 M{1, 5} = abs(y(2)-y(1));	
		dlmcell(filename, M, ',', '-a');
		rectangle('Position',[M{1, 2} M{1, 3}  M{1, 4} M{1, 5} ], 'LineWidth', 2, 'EdgeColor','b');
	
	end
	hold off;	
	%pause
	clear all;
end