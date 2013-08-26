%Programmer: Chris Tralie

function [ SuppressedImage] = CannyNonmax( MagGrad, EdgeOrient )
%For each pixel, find the direction D* in (0, 45, 90, 135) that is closest
%to the orientation D at that pixel

SuppressedImage = MagGrad;

%(0, 45, 90, 135, 180, 225, 270, 315, 360)
%(1, 2,   3,  4,   1,   2,  3,   4,    1)
Angles = mod(round(EdgeOrient ./ 45.0), 4)  + 1;

%Tells how to look along the gradient for each angle
NDir = [0  1 0 -1;  1  1 -1 -1;  1 0 -1 0; -1  1 1 -1];
%Index 1 - 0 degrees, 180 degrees, 360 degrees
%Index 2 - 45 degrees, 225 degrees
%Index 3 - 90 degrees, 270 degrees
%Index 4 - 135 degrees, 315 degrees
PixelDim = size(Angles);
for i=2:PixelDim(1) - 1, 
    for j=2:PixelDim(2) - 1,
       %If the edge strength F(x,y) is smaller than at least one of 
       %its neighbors along D*, set I(x,y) = 0, else set I(x,y) = F(x,y).
       A = Angles(i, j);
       N1 = MagGrad(i + NDir(A, 1), j + NDir(A, 2));%Neighbor 1
       N2 = MagGrad(i + NDir(A, 3), j + NDir(A, 4));%Neighbor 2
       P = MagGrad(i, j);
       if (N1 > P) || (N2 > P)
          SuppressedImage(i, j) = 0;
       end
    end
end