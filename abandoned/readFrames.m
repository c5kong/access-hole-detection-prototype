function [ rgbIm, grayIm, depthIm ] = readFrames( )
    tic
        rgbIm = im2double(imread('463_rgb.png'));
        grayIm = rgb2gray(rgbIm);
        depthIm = im2double(imread('463_d.png'));

        
        
        figure, imshow(rgbIm);
        figure, imshow(grayIm, []);
        figure, imshow(depthIm, []);
    toc
end

