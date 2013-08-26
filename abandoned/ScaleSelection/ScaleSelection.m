%Programmer: Chris Tralie

function [ imout ] = ScaleSelection( filename, T, fileout )
imcolor = imread(filename);
if length(size(imcolor)) > 2
    gray = rgb2gray(imcolor);
else
    gray = imcolor;
end
im = double(gray) / 255;%Normalized grayscale image used for analysis
max_sigma = 32;
numG = uint8(log(max_sigma) / log(sqrt(2))) + 1;%The number of gaussians to compute
PixelDim = size(im);
Features = 0 * im;

%Compute versions of the image filtered by Gaussians with sigma = 1, 
%sqrt(2), 2, 2sqrt(2), ...
for i=1:numG
   sigma = exp(log(sqrt(2))*double((i - 1)));
   width = round(3*sigma);
   t = -width: 1: width;
   gaussf = exp(-t.*t ./ (2*sigma^2));%Unidirectional gaussian kernel
   gaussf = gaussf / sum(sum(gaussf));%Normalize the gaussian
   Gaussians{i} = conv2(gaussf, gaussf, im, 'same');%store the gaussian
   %in a list
end



%Compute the DOG: difference between images filtered with each
%pair of adjacent scales
for i = 2:numG
   DOG{i - 1} = Gaussians{i} - Gaussians{i - 1}; 
end

%Scale selection (leave padding of 2 around to allow for comparison
%with 26 spatial neighbors
for i = 3: PixelDim(1) - 2
   for j = 3:PixelDim(2) - 2 
       %First find the global maximum among the difference of
       %gaussians
       index = numG/2;
       greatest = 0;
       for k = numG/2:numG - 1
          if DOG{k}(i, j) > greatest
             index = k;
             greatest = DOG{k}(i, j);
          end
       end
       %Check to make sure this global max among difference of 
       %gaussians is above the minimum DOG threshold
       if (greatest > T)
           %Now check to make sure the global maximum among scale
           %is a global maximum spatially
           %if so, mark it as a feature point (and store the width
           %of the maximum DOG, which is sqrt(2)^index)
           if (greatestSpatially(i, j, index))
               Features(i, j) = exp(log(sqrt(2))*double(index));
           end
       end
   end
end

%Now draw squares around the global maxima with the appropriate width
imout = imcolor;
for i = 1:PixelDim(1)
   for j = 1:PixelDim(2)
       if (Features(i, j) > 0)
           drawSquare(i, j, round(Features(i, j)));
       end
   end
end

imwrite(imout, fileout, 'PNG');

    function ret = greatestSpatially(ci, cj, index)
        val = DOG{index}(ci, cj);
        ret = 1;
        if val ~= max(max(DOG{index}(ci-2:ci+2, cj-2:cj+2)))
           ret = 0; 
        end
    end

    function drawSquare(ci, cj, width)
        %Calculate the boundaries of the square (making sure
        %not to go out of bounds)
        l = max(1, ci - width); %start on left
        r = min(PixelDim(1), ci+width); %end on right
        t = max(1, cj - width);%start in top
        b = min(PixelDim(2), cj+width);%end on bottom
        
        %Draw top and bottom lines (in red)
        for leftright = l:r
            imout(leftright, t, 1) = 255;
            imout(leftright, t, 2) = 0;
            imout(leftright, t, 3) = 0;
            imout(leftright, b, 1) = 255;
            imout(leftright, b, 2) = 0;
            imout(leftright, b, 3) = 0;
        end
        %draw left and right lines
        for updown = t:b
            imout(l, updown, 1) = 255;
            imout(l, updown, 2) = 0;
            imout(l, updown, 3) = 0;
            imout(r, updown, 1) = 255;
            imout(r, updown, 2) = 0;
            imout(r, updown, 3) = 0;
        end
    end

end