function thumb = LMsceneThumbnail(annotation, HOMEIMAGES, img)
% thumb = LMsceneThumbnail(annotation, HOMEIMAGES)
%
% Returns a thumbnail with the style used on the online tool
%
% HOMEIMAGES = 'http://labelme.csail.mit.edu/Images'; 

% Thumbnail size (height)
tY = 96;

D.annotation = annotation;
if nargin < 3
    img = LMimread(D, 1, HOMEIMAGES);
end

% Re-scale image
[annotation, img] = LMimscale(annotation, img, (tY+1)/size(img,1), 'bilinear');
[annotation, img] = LMimcrop(annotation, img, [1 size(img,2) 1 tY]);

% sort layers
annotation = LMsortlayers(annotation, img);


if size(img,3) < 3
    img = repmat(img(:,:,1), [1 1 3]);
end

% get segmentation masks
[mask, cc, maskpol, classpol] = LMobjectmask(annotation, [size(img,1) size(img,2)]);

% Thumbnails with masks
seg = 128*ones(size(img));
if size(mask,3)>0
    M = double(colorSegments(mask, 'donotsort'))/255;
    if size(M,1)>0
        M = M + .5*repmat(sum(mask,3)==0, [1 1 3]);
        M = M / max(M(:));
        seg = M .* repmat(mean(double(img),3)/2+128, [1 1 3]);
    end
end

seg = uint8(seg);
thumb = [img 255*ones([size(img,1),2,size(img,3)]) seg];

if nargout == 0
    figure
    imshow(thumb)
end

