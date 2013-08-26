close all;clear all;clc

im_rgb = im2double(imread('463_rgb.png'));
im_gray = rgb2gray(im_rgb);
im_d = imread('463_d.png');


[x y v ] = find(im_d < 2048 & im_d > 1536 );
temp = zeros(size(im_d));
for i = 1:length(x)
	temp(x(i), y(i)) = im_d(x(i), y(i));
end
figure, imshow(temp, []);

[x y v ] = find(im_d < 1536 & im_d > 1024 );
temp = zeros(size(im_d));
for i = 1:length(x)
	temp(x(i), y(i)) = im_d(x(i), y(i));
end
figure, imshow(temp, []);

[x y v ] = find(im_d < 1024 & im_d > 512 );
temp = zeros(size(im_d));
for i = 1:length(x)
	temp(x(i), y(i)) = im_d(x(i), y(i));
end
figure, imshow(temp, []);

[x y v ] = find(im_d < 512 & im_d > 256 );
temp = zeros(size(im_d));
for i = 1:length(x)
	temp(x(i), y(i)) = im_d(x(i), y(i));
end
figure, imshow(temp, []);