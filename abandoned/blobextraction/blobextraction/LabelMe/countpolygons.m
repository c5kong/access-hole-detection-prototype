function [n,P,ji,jo] = countpolygons(D)
% returns the number of polygons in the database struct
%    n = countpolygons(D)
%
% It also returns the number of control points for each polygon and the
% image and object indices
%    [n,P,ji,jo] = countpolygons(D)

M = length(D);
n = 0;
P = zeros(1,M*10); ndx = 0;
for m = 1:M
    if isfield(D(m).annotation, 'object')
        npol = length(D(m).annotation.object);
        n = n + npol;
        for k = 1:npol
            ndx = ndx+1;
            [x,y] = getLMpolygon(D(m).annotation.object(k).polygon);
            P(ndx) = length(x);
            ji(ndx) = m;
            jo(ndx) = k;
        end
    end
end

P = P(1:ndx);
ji = ji(1:ndx);
jo = jo(1:ndx);
