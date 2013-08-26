function OUTPUT=MAPBUILDING3(im,SCALEMIN,SCALEMAX)
count=0;
[X,Y,Z]=size(im);
imm=zeros(X,Y,5*(SCALEMAX-SCALEMIN+1));
for II=SCALEMIN:SCALEMAX
    count=count+1;
    M=[-1000:1000];
    VAR=sqrt(2)^II;
    GAUSSIAN=(normcdf(M+0.5,0,VAR)-normcdf(M-0.5,0,VAR));
    [m,n]=find(abs(normcdf(M,0,VAR))>(1e-4)/2);
    M=min(n);
    G=GAUSSIAN(M:(2001-M+1));
    M=[-1000:1000];
    FD=(1/(sqrt(2*pi)*VAR))*(exp(-((M+0.5).^2)/(2*VAR^2))-...
        exp(-((M-0.5).^2)/(2*VAR^2)));
    HH=(1/(sqrt(2*pi)*VAR))*(exp(-((M).^2)/(2*VAR^2)));
    [m,n]=find(abs(HH)>(1e-4)/2);
    M=min(n);
    G1=FD(M:(2001-M+1));
    M=[-1000:1000];
    SD=(1/(sqrt(2*pi)*(VAR^3)))*(-(M+0.5).*exp(-((M+0.5).^2)/(2*VAR^2))-...
        (-(M-0.5)).*exp(-((M-0.5).^2)/(2*VAR^2)));
    HH=(1/(sqrt(2*pi)*(VAR^3)))*(-(M+0.5).*exp(-((M+0.5).^2)/(2*VAR^2)));
    [m,n]=find(abs(HH)>(1e-4)/2);
    M=min(n);
    G2=SD(M:(2001-M+1));
    for i=1:3
        imG1G(:,:,i)=GAUSS2_FILTER(im(:,:,i),'G1G',G,G1,G2);
        imGG1(:,:,i)=GAUSS2_FILTER(im(:,:,i),'GG1',G,G1,G2);
        imGG2(:,:,i)=GAUSS2_FILTER(im(:,:,i),'GG2',G,G1,G2);
        imG2G(:,:,i)=GAUSS2_FILTER(im(:,:,i),'G2G',G,G1,G2);
        imG2G2(:,:,i)=GAUSS2_FILTER(im(:,:,i),'2G2',G,G1,G2);        
        %imm=abs(imG1G(:,:,i))+abs(imGG1(:,:,i))...
         %   +abs(imG2G(:,:,i))+abs(imGG2(:,:,i))+abs(imG2G2(:,:,i));
    end    
        imm(:,:,(count-1)*5+1)=max(abs(imG1G),[],3);
        imm(:,:,(count-1)*5+2)=max(abs(imGG1),[],3);
        imm(:,:,(count-1)*5+3)=max(abs(imGG2),[],3);
        imm(:,:,(count-1)*5+4)=max(abs(imG2G),[],3);
        imm(:,:,(count-1)*5+5)=max(abs(imG2G2),[],3);
        
    
    %FINAL_IMM=zeros(size(imm,1),size(imm,2));
    %FINAL_SCALE(:,:,count)=max(abs(imG1G),[],3)+max(abs(imGG1),[],3)+...
        %+max(abs(imG2G),[],3)+max(abs(imGG2),[],3)+max(abs(imG2G2),[],3);

end
OUTPUT=max(imm,[],3);