function plotBoundingBox(img, bb)
% Visualices and image and a set of bounding boxes
%
%   img = image
%   bb = each row is [xmin ymin xmax ymax]

image(img); axis('off'); axis('equal')
if size(img,3)==1; colormap(gray(256)); end
hold on

colors = 'rgbcmy';
Nbb = size(bb,1);
for i = 1:Nbb
    plot([bb(i,1) bb(i,3) bb(i,3) bb(i,1) bb(i,1)], [bb(i,2) bb(i,2) bb(i,4) bb(i,4) bb(i,2)], 'k', 'linewidth', 3)
    plot([bb(i,1) bb(i,3) bb(i,3) bb(i,1) bb(i,1)], [bb(i,2) bb(i,2) bb(i,4) bb(i,4) bb(i,2)], colors(mod(i,6)+1))
end

title(sprintf('There are %d boxes', Nbb))
