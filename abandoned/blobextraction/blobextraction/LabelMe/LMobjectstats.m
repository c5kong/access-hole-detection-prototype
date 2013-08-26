function [objectnames, instancecounts, areacounts] = LMobjectstats(D, HOMEIMAGES)
% 
% Creates a matrix with object counts:
%
% [objectnames, instancecounts] = LMobjectstats(D);
%
% instancecounts(i,j) = number of times object class i is present in image j.
%    j is the index to the image D(j)
%    i is the index for an object class objectnames{i}
%
% [objectnames, instancecounts, areacounts] = LMobjectstats(D, HOMEIMAGES);
%
% areacounts(i,j) = proportion of pixels occupied by object class i in
%    image j.

% Created: A. Torralba, 2006

objectnames = LMobjectnames(D);

Nimages = length(D);
Nobjects = length(objectnames);

instancecounts = zeros(Nobjects, Nimages);
areacounts = zeros(Nobjects, Nimages);

for i = 1:Nimages
    i
    if isfield(D(i).annotation, 'object')
        if nargout == 2 | nargout == 0
            objectsinimage = {D(i).annotation.object.name};
            
            [TF, ndx] = ismember(strtrim(lower(objectsinimage)),objectnames);
            for n = 1:length(ndx)
                instancecounts(ndx(n),i) = instancecounts(ndx(n),i)+1;
            end
        else
            [mask, objectsinimage] = LMobjectmask(D(i).annotation, HOMEIMAGES);
            [nrows ncols no] = size(mask);
            
            [TF, ndx] = ismember(strtrim(lower(objectsinimage)), objectnames);
            for n = 1:length(ndx)
                instancecounts(ndx(n),i) = instancecounts(ndx(n),i)+1;
                areacounts(ndx(n),i) = areacounts(ndx(n),i) + sum(sum(mask(:,:,n), 1),2)/nrows/ncols;
            end
        end

    end
end


if nargout == 0
    frequency = sum(instancecounts,2);
    [ff, ndx] = sort(frequency);

    % sort by frequency:
    instancecounts = instancecounts(ndx, :);
    objectnames = objectnames(ndx);

    % Show object counts sorted by frequency
    figure
    imagesc(instancecounts)
    colormap(gray(256))
    set(gca, 'YTick', 1:Nobjects)
    set(gca, 'YtickLabel', objectnames)
    ylabel('Object index')
    xlabel('Image index')
    title('Each entry counts the number of times the object y is in the image x')
    axis('on')
    axis('tight')
end
