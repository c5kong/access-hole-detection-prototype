%Programmer: Chris Tralie

%function [ MagGrad, EdgeOrient ] = CannyGradient( filename, sigma )
%function [ SuppressedImage ] = CannyNonmax( MagGrad, EdgeOrient )

function [ image ] = Canny (filename, sigma, T_h, T_l, baseout)
imcolor = imread(filename);
if length(size(imcolor)) > 2
    gray = rgb2gray(imcolor);
else
    gray = imcolor;
end
im = double(gray) / 255;%Normalized grayscale image used for analysis
[Fx, Fy, MagGrad, EdgeOrient] = CannyGradient(im, sigma);
SuppressedImage = CannyNonmax(MagGrad, EdgeOrient);
PixelDim = size(im);

%If the high threshold is set to zero, then choose automatic thresholds
if T_h == 0
    'Doing automatic thresholding'
    avg = sum(sum(SuppressedImage)) / (PixelDim(1)*PixelDim(2));
    numbelow = 0;
    numabove = 0;
    T_h = 0; T_l = 0;
    for i = 1:PixelDim(1),
       for j = 1:PixelDim(2),
           if (SuppressedImage(i, j) < avg)
               numbelow = numbelow + 1;
               T_l = T_l + SuppressedImage(i, j);
           else
               numabove = numabove + 1;
               T_h = T_h + SuppressedImage(i, j);
           end
       end
    end
    T_h = T_h / (numabove + 1)
    T_l = T_l / (numbelow + 1)
end
%sprintf('(%s, %s)', T_h, T_l)%output the results of automatically 
%determining the thresholds

image = CannyHysteresis(SuppressedImage, EdgeOrient, T_h, T_l);


%Now write everything out as image files for the writeup:
mkdir(baseout);
imwrite(imcolor, sprintf('%s\\input.png', baseout), 'PNG');
imwrite(Fx / max(max(Fx)), sprintf('%s\\Fx.png', baseout), 'PNG');
imwrite(Fy / max(max(Fy)), sprintf('%s\\Fy.png', baseout)', 'PNG');
imwrite(MagGrad / max(max(MagGrad)), sprintf('%s\\Mag.png', baseout), 'PNG');
imwrite(SuppressedImage / max(max(SuppressedImage)), sprintf('%s\\Nonmax.png', baseout), 'PNG');
imwrite(image, sprintf('%s\\image.png', baseout), 'PNG');
end