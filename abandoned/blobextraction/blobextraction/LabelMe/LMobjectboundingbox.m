function boundingbox = LMobjectboundingbox(annotation, name);
% boundingbox = LMobjectboundingbox(annotation, name) returns all the bounding boxes that
% belong to object class 'name'. Is it an array Ninstances*4
%
% boundingbox = [xmin ymin xmax ymax]

if nargin > 1
    jc = LMobjectindex(annotation, name);
elseif ~isfield(annotation,'object')
    jc = [];
else
    jc = 1:length(annotation.object);
end

Nobjects = length(jc);
if Nobjects == 0
    boundingbox = [];
else
    boundingbox = zeros(Nobjects,4);
    for n = 1:Nobjects
        [xn yn] = getLMpolygon(annotation.object(jc(n)).polygon);
        boundingbox(n,:) = [min(xn) min(yn) max(xn) max(yn)];
    end
end

