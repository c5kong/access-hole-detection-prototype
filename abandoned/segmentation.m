close all;clear all;clc


scaleFactor = .25;
dialationFactor = 1;
edge_detector = 'canny'; %-- sobel / prewitt / roberts / log / zerocross / canny


im_rgb = im2double(imread('463_rgb.png'));
im_gray = rgb2gray(im_rgb);
im_d = imread('463_d.png');
%figure, imshow(im_rgb);
%figure, imshow(im_gray);
%figure, imshow(im_d, []);


%-- DEPTH FRAME EDGE DETECTION --%%
[~, threshold] = edge(im_d, edge_detector);
depth_edges = edge(im_d, edge_detector, threshold * scaleFactor);
%figure, imshow(depth_edges, []);


%-- DIALATE EDGE DETECTOR --%%
se90 = strel('line', dialationFactor, 5);
se0 = strel('line', dialationFactor, 0);
dilated_edges = imdilate(depth_edges, [se90 se0]);
%figure, imshow(dilated_edges, []);


%-- OVERLAY MASK ONTO DEPTH  --%%
depth_overlay = im_d;
depth_overlay(dilated_edges) = 255;
%figure, imshow(dilated_edges, []);
figure, imshow(depth_overlay, []);


%-- TODO RGB-DEPTH ALIGNMENT --%





%-- OVERLAY MASK ONTO IMAGE FRAMES  --%%
gray_overlay = imoverlay(im_gray, dilated_edges, [.1 1 .1]);
rgb_overlay = imoverlay(im_rgb, dilated_edges, [.1 1 .1]);
figure, imshow(gray_overlay);
%figure, imshow(rgb_overlay);
