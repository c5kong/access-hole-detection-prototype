%Programmer: Chris Tralie

function [EigM, MaxEig] = CornerFind( Fx, Fy, N, T )
%Precompute the cross-terms matrix and squared matrices
FxFy = Fx .* Fy; 
FxFx = Fx .* Fx;
FyFy = Fy .* Fy;

%Use convolution with a kernel of all ones to accomplish the
%summing of a neighborhood of size 2N+1 around each point
M = ones(1, 2*N + 1);
sFxFx = conv2(M, M, FxFx, 'same');
sFyFy = conv2(M, M, FyFy, 'same');
sFxFy = conv2(M, M, FxFy, 'same');

'Done convolution'

PixelDim = size(Fy);

%Preallocate space for the list that holds the eigenvalues
%and for the eigenvalue matrix
L = zeros(PixelDim(1)*PixelDim(2), 3);
C = zeros(2, 2);

%Also create a matrix the size of the image
%that will hold the eigenvalues at their proper locations
EigM = 0 * Fx;

index = 1;

for i=1:PixelDim(1), 
    for j=1:PixelDim(2),
        %Check the covariance matrix for eigenvalues
        %[sFx^2     sFxFy]
        %[sFxFy     sFy^2]
        C(1, 1) = sFxFx(i, j);
        C(1, 2) = sFxFy(i, j);
        C(2, 1) = C(1, 2);
        C(2, 2) = sFyFy(i, j);
        Eigs = eig(C);
        if (Eigs(1) > T)
            EigM(i, j) = Eigs(1);
            L(index, 1) = Eigs(1);
            L(index, 2) = i;
            L(index, 3) = j;
            index = index + 1;
        end
    end
end

'Done Eigenvalues'

%Sort the list in descending order by the
%smaller eigenvalue (first column)
L = sortrows(L, -1);
MaxEig = L(1, 1);

%For each point p, remove all points in the neighborhood 
%of p that occur lower in L. 
for k=1:index - 1
    i = L(k, 2);
    j = L(k, 3);
    if EigM(i, j) > 0
        RemovePoints(i, j)
    end
end

    function RemovePoints(i, j)
        %Set everything in the corner's neighborhood to 0
        for a = i-N:i+N
           %Check boundaries
           if ((a < 1) || (a > PixelDim(1))) 
               continue
           end
           for b = j-N:j+N 
               if ((b < 1) || (b > PixelDim(2))) 
                    continue
               end
               EigM(a, b) = 0;
           end
        end
        EigM(i, j) = 1; %Mark all corner locations with a "1"
    end

end