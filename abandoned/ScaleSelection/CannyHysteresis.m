%Programmer: Chris Tralie

function [ ImageOut ] = CannyHysteresis( ImageIn, EdgeOrient, T_h, T_l )
PixelDim = size(ImageIn);
ImageOut = 0 .* ImageIn; %Make an output image that has the same
%dimensions as the input image

LevelSet = EdgeOrient + 90; %Level sets are perpendicular to the gradient
Angles = mod(round(LevelSet ./ 45.0), 4)  + 1;
%Tells how to look along the level set for each possible angle along
%a level set
NDir = [0  1 0 -1;  1  1 -1 -1;  1 0 -1 0; -1  1 1 -1];
Visited = 0 * ImageIn; %Mark the visited pixels as 1

for a=1:PixelDim(1), 
    for b=1:PixelDim(2),
        if (ImageIn(a, b) > T_h) 
            %If it exceeds the high threshold
            Connect(a, b, 0);
        end
    end
end

    function isinbounds = InBounds(ci, cj) 
        isinbounds = 1;
        if (ci < 1 || ci > PixelDim(1) || cj < 1 || cj > PixelDim(2))
                isinbounds = 0;
        end
    end

    function Connect(ci, cj, depth)
        if (depth > 450) %Prevent stack overflow in pathological cases
            %where more than 450 pixels are connected (stack overflow
            %occurs at 500 in matlab)
            Visited(ci, cj) = 0;
            return;
        end
        if (InBounds(ci, cj) == 0)
            return;
        end
        if (Visited(ci, cj) == 1)
            return;
        end
        Visited(ci, cj) = 1;
        %First check to make sure this pixel is strong enough
        if (ImageIn(ci, cj) < T_l)
            return;
        end
        
        %If it is strong enough, set it to "1" in the output image
        %since it's passed the threshold test
        ImageOut(ci, cj) = 1;

        ri = ci + NDir(Angles(ci, cj), 1);
        rj = cj + NDir(Angles(ci, cj), 2);
        li = ci + NDir(Angles(ci, cj), 3);
        lj = cj + NDir(Angles(ci, cj), 4);

        Connect(ri, rj, depth + 1);
        Connect(li, lj, depth + 1);
    end
    
end