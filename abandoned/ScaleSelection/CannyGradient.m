%Programmer: Chris Tralie
%Purpose: To provide the intial part of the Canny edge detector pipeline
%where the maginitude and orientation of the edges is computed
%after some rudimentary lowpass filtering

function [Fx, Fy, MagGrad, EdgeOrient ] = CannyGradient( im, sigma )
%Find the x and y components of the gradient Fx and Fy of the image
%smoothed with a gaussian; do so with with a separable gaussian

%scale = 1.0 / (2*pi*sigma^2);
width = round(3*sigma);
t = -width: 1: width;
gaussf = exp(-t.*t ./ (2*sigma^2));%Unidirectional gaussian kernel
xgaussf = -t.*exp(-t.*t ./ (2*sigma^2)); %Unidirectional gradient of gaussian kernel
%plot(xgaussf);

gaussf = gaussf / sum(gaussf);%Normalize the gaussian

%Now find a proper normalization scale for the gaussian gradient, such 
%that a region with slope 1 will come out to have slope 1
ramp = 1:width*2 + 1;
xgaussf = xgaussf / abs((ramp * xgaussf'));

Fx = conv2(gaussf, xgaussf, im, 'same');
Fy = conv2(xgaussf, gaussf, im, 'same');

%3. Compute the edge strength F (the magnitude of the gradient) and edge
%orientation D = arctan(Fy / Fx) at each pixel
MagGrad = sqrt(Fx.*Fx + Fy.*Fy);
EdgeOrient = (180 / pi) * atan2(Fy, Fx);

end