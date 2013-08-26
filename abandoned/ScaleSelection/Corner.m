%Programmer: Chris Tralie

function [ ImOut ] = Corner (filein, sigma, N, T, fileout)
imcolor = imread(filein);
gray = rgb2gray(imcolor);
PixelDim = size(gray);
im = double(gray) / 255;%Normalized grayscale image used for analysis
[Fx, Fy, MagGrad, EdgeOrient] = CannyGradient(im, sigma);

[cornerloc, maxeig] = CornerFind(Fx, Fy, N, T);
ImOut = imcolor;
Rs = 2;%Rect size

%Draw Rectangles centered at all of the corners
for i = 1:PixelDim(1)
   for j = 1:PixelDim(2) 
      if cornerloc(i, j) == 1
         drawRect; 
      end
   end
end

%Save the file with the rectangles drawn
imwrite(ImOut, fileout, 'PNG');

    function drawRect
        for a = i-Rs:i+Rs
           %Check boundaries
           if ((a < 1) || (a > PixelDim(1))) 
               continue
           end
           for b = j-Rs:j+Rs 
               if ((b < 1) || (b > PixelDim(2))) 
                    continue
               end
               %Highlight each corner in red
               ImOut(a, b, 1) = 255;
           end
        end
    end

end