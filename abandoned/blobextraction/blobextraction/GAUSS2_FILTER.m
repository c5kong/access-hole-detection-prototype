function OUT=GAUSS2_FILTER(INPUT,TYPE,G,G1,G2)



if TYPE=='G1G'
    
% Convolve with the first derivative in x direction    
sub = 1+floor(length(G1)/2):(1+size(INPUT,2)+length(G1)/2-1);
fi1 = zeros(size(INPUT));
for i=1:size(INPUT,1)
    new = conv(INPUT(i,:),G1);
    fi1(i,:) = new(sub);
end

% Smooth the resulting derivative in y
OUT = zeros(size(fi1));
sub = 1+floor(length(G)/2):(1+size(fi1,1)+length(G)/2-1);
for i=1:size(fi1,2)
    new = conv(fi1(:,i)',G');
    OUT(:,i) = new(sub)';
end

elseif TYPE=='GG1'
    
% Calculate the derivative of a Gaussian in y convolved with INPUT
fi3 = zeros(size(INPUT));
sub = 1+floor(length(G1)/2):(1+size(INPUT,1)+length(G1)/2-1);
for i=1:size(INPUT,2)
    new = conv(INPUT(:,i)',G1');
    fi3(:,i) = new(sub)';
end

% Smooth the resulting derivative in x
sub = 1+floor(length(G)/2):(1+size(INPUT,2)+length(G)/2-1);
OUT = zeros(size(fi3));
for i=1:size(fi3,1)
    new = conv(fi3(i,:),G);
    OUT(i,:) = new(sub);
end


elseif TYPE=='GG2'
    
% Calculate the second derivative of a Gaussian in y convolved with INPUT
fi3 = zeros(size(INPUT));
sub = 1+floor(length(G2)/2):(1+size(INPUT,1)+length(G2)/2-1);
for i=1:size(INPUT,2)
    new = conv(INPUT(:,i)',G2');
    fi3(:,i) = new(sub)';
end

% Smooth the resulting derivative in x
sub = 1+floor(length(G)/2):(1+size(INPUT,2)+length(G)/2-1);
OUT = zeros(size(fi3));
for i=1:size(fi3,1)
    new = conv(fi3(i,:),G);
    OUT(i,:) = new(sub);
end


elseif TYPE=='G2G'
    
% Convolve with the first derivative in x direction    
sub = 1+floor(length(G2)/2):(1+size(INPUT,2)+length(G2)/2-1);
fi1 = zeros(size(INPUT));
for i=1:size(INPUT,1)
    new = conv(INPUT(i,:),G2);
    fi1(i,:) = new(sub);
end

% Smooth the resulting derivative in y
OUT = zeros(size(fi1));
sub = 1+floor(length(G)/2):(1+size(fi1,1)+length(G)/2-1);
for i=1:size(fi1,2)
    new = conv(fi1(:,i)',G');
    OUT(:,i) = new(sub)';
end

elseif TYPE=='2G2'

sub = 1+floor(length(G2)/2):(1+size(INPUT,2)+length(G2)/2-1);
fi1 = zeros(size(INPUT));
for i=1:size(INPUT,1)
    new = conv(INPUT(i,:),G2);
    fi1(i,:) = new(sub);
end

% Smooth the resulting derivative in y
OUT = zeros(size(fi1));
sub = 1+floor(length(G2)/2):(1+size(fi1,1)+length(G2)/2-1);
for i=1:size(fi1,2)
    new = conv(fi1(:,i)',G2');
    OUT(:,i) = new(sub)';
end  
    

end
