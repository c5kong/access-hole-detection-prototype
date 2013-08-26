function relativearea = LMlabeledarea(D, objectname);
%
% Returns the percentage of pixels labeled for each image. 
%

n = length(D);
relativearea = zeros(n,1);

if nargin == 2
    [D, j] = LMquery(D, 'object.name', objectname);
else
    j = 1:n;
end

for i = 1:length(D);
    relativearea(j(i)) = 0; % default value
    
    if isfield(D(i).annotation, 'object')
        Nobjects = length(D(i).annotation.object);

        if Nobjects > 0
            % Get image size
            if isfield(D(i).annotation, 'imagesize')
                ncols = D(i).annotation.imagesize.ncols;
                nrows = D(i).annotation.imagesize.nrows;
            else
                ncols = 0; nrows = 0;
                for n = 1:Nobjects
                    [X,Y] = getLMpolygon(D(i).annotation.object(n).polygon);
                    ncols = max(ncols, max(X));
                    nrows = max(nrows, max(Y));
                end
            end

            % scaling
            nrows = fix(nrows/10);
            ncols = fix(ncols/10);
            
            % Labeled pixels
            mask = 0;
            for n = 1:Nobjects
                [X,Y] = getLMpolygon(D(i).annotation.object(n).polygon);
                mask = mask + poly2mask(X/10,Y/10,nrows,ncols);
            end
            area = sum(mask(:)>0);

            % Relative area
            relativearea(j(i)) = area/(nrows*ncols);
        end
    end
end
