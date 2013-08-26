function GOODCOLORIMAGE=ORIENTATION(im,LLFITTING,slot)

H=fspecial('sobel');
[XX1,YY1,ZZ1]=size(im);

IMEXAM=im(10:XX1-10,10:YY1-10);
THICKNESS=NUMOFOPENNING(LLFITTING);

NN=2*THICKNESS-1;
NUMOFONES=ones(NN,NN);

DENOM=conv2(double(LLFITTING),NUMOFONES,'same');
DENOM=DENOM.*LLFITTING;

%hh=1/NN^2*ones(NN,NN);

Ix=imfilter(double(uint8(IMEXAM(:,:,1))),H,'replicate');
Iy=imfilter(double(uint8(IMEXAM(:,:,1))),H','replicate');

Ix=Ix.*LLFITTING;
Iy=Iy.*LLFITTING;

NUMIX=conv2(Ix,NUMOFONES,'same');
NUMIY=conv2(Iy,NUMOFONES,'same');

NUMIX=LLFITTING.*NUMIX;
NUMIY=LLFITTING.*NUMIY;

MEANIX=NUMIX./(DENOM+eps);
MEANIY=NUMIY./(DENOM+eps);

%M=find(abs(MEANIX)>1e10);
MM=find((MEANIX==0)&(MEANIY==0));


MEANIX(MM)=1e-10;
MEANIY(MM)=1e10;

ANGLE1=acosd(MEANIX./sqrt(MEANIX.^2+MEANIY.^2));

ANGLE1(MM)=1000;

for i=1:slot
    SEGMENTATION(:,:,i)=ANGLE1>((i-1)*(180/slot))&(ANGLE1<=(i*(180/slot)));
    %SEGMENTATION(:,:,i)=ANGLE1>=((i-1)*(90/slot))&(ANGLE1<=(i*(90/slot)));
end
 [XX,YY]=size(LLFITTING);
COLORIMAGE=zeros(XX,YY);
for i=1:slot
    COLORIMAGE=i*SEGMENTATION(:,:,i)+COLORIMAGE;
end
GOODCOLORIMAGE=COLORIMAGE;





%IMEANX=imfilter(abs(Ix),hh,'replicate');
%IMEANY=imfilter(abs(Iy),hh,'replicate');

% Ix;%=IMEANX;
% Iy;%=IMEANY;

%Ix=1e20*double(~LLFITTING)+Ix;
%Iy=1e20*double(~LLFITTING)+Iy;   %FOR NEGLECTING THE PIXELS THAT ARE ZERO IN THE LLFITTING

%
% ANGLE1=1000*ones(XX,YY);
% ANGLE2=zeros(XX,YY);
% 
% for i=1:XX
%     for j=1:YY
%         i
%         j
%         
%         if LLFITTING(i,j)>0        
%             ii=i;
%             jj=j;
%             count=0;
%             ABX=[];
%             ABY=[];
%             RANGE=round((THICKNESS+1)/2);            
%             for ii=(i-RANGE):(i+RANGE)
%                 for jj=(j-RANGE):(j+RANGE)
%                     if (ii>0)&(jj>0)&(ii<XX+1)&(jj<YY+1)
%                         if LLFITTING(ii,jj)>0
%                             count=count+1;
%                             ABX(count)=Ix(ii,jj);
%                             ABY(count)=Iy(ii,jj);
%                         end
%                     end
%                 end
%             end
%             if min(size(ABX))>0
%                 MIX=mean(ABX);
%                 MIY=mean(ABY);
%                 ANGLE1(i,j)=acosd(MIX/sqrt(MIX^2+MIY^2));
%             end
% 
%             %end
%         end
%     end
% end


