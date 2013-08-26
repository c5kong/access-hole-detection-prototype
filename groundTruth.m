function [ X ] = groundTruth(depthImage, directory, nC)
	close all;
	clc;
	%//=======================================================================
	%// Load Images
	%//=======================================================================
	depthImage
	im_d = imread(strcat(directory, depthImage));
	img = im_d;
	grey_img = img;
	
	%//=======================================================================
	%// Output File Name
	%//=======================================================================
	filename = strcat(num2str(nC), '_test.csv');

	%//=======================================================================
	%// Superpixel segmentation
	%//=======================================================================
	
	lambda_prime = 0.5;
	sigma = 5.0; 
	conn8 = 1; % flag for using 8 connected grid graph (default setting).

	%[labels] = mex_ers(double(img),nC);%// Call the mex function for superpixel segmentation
	%labels(labels == 0) = nC; %-- Normalize regions to matlab convention of 1:nC instead of 0:nC-1
	%figure, imshow(labels,[]);

	%//=======================================================================
	%// Find Region
	%//=======================================================================
	%figure, imshow(labels, []), colormap(gray), axis off, hold on;
	figure, imshow(im_d, []), colormap(gray), axis off, hold on;
	[x y b] = ginput(2);
x
y

	 M{1, 1} = depthImage;
	 M{1, 2} = x(1);
	 M{1, 3} = y(1);
	 M{1, 4} = abs(x(2)-x(1));
	 M{1, 5} = abs(y(2)-y(1));	
	dlmcell(filename, M, ',', '-a');
	rectangle('Position',[M{1, 2} M{1, 3}  M{1, 4} M{1, 5} ], 'LineWidth', 4, 'EdgeColor','r');
	hold off;

	clear all;
end