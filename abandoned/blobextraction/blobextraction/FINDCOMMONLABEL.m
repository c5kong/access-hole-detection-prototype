function [COMMONMATRIX,LABELCOMMON]=FINDCOMMONLABEL(LLFITTING,PixelsBounding,PixelsBlob,im,CMAP)

[LENGTH,WIDTH]=size(LLFITTING);
[XX,YY]=meshgrid([1:WIDTH],[1:LENGTH]);
COUNTREGIONS=0;
OUT=zeros(LENGTH,WIDTH);
MODEAREA=[];
[XX2,YY2,ZZ2]=size(im);
IMM=im(10:XX2-10,10:YY2-10,:);
%figure,imshow(IMM);
in22=zeros(LENGTH,WIDTH);
in222=zeros(LENGTH,WIDTH);


for ii=1:max(size(PixelsBlob))
    BOUNDING=[];
    vertices=PixelsBlob{ii};
    if max(size(vertices))>1
        %in=inpolygon(XX(:),YY(:),vertices(:,1),vertices(:,2));
        %DETECTED=reshape(in,LENGTH,WIDTH);
        %fff=bwlabel(DETECTED);
        %hhh=regionprops(fff,'BoundingBox');
        %XMIN=hhh(1).BoundingBox(1);
        %XMAX=hhh(1).BoundingBox(1)+hhh(1).BoundingBox(3);
        %YMIN=hhh(1).BoundingBox(2);
        %YMAX=hhh(1).BoundingBox(2)+hhh(1).BoundingBox(4);
        %vertices2=[XMIN XMIN XMAX XMAX XMIN;YMIN YMAX YMAX YMIN YMIN];
        %vertices2=vertices2';
        %in2=inpolygon(XX(:),YY(:),vertices2(:,1),vertices2(:,2));
        %DETECTED2=reshape(in2,LENGTH,WIDTH);
        DETECTED2=zeros(LENGTH,WIDTH);
        DETECTED2(PixelsBlob{ii})=1;
        DETECTED22=ii*DETECTED2;
        in22=in22+DETECTED2;
        in222=in222+DETECTED22;
    end
end

LABELCOMMON=bwlabel(in22>1);
COMMONMATRIX=zeros(max(LABELCOMMON(:)),10);

for ii=1:max(size(PixelsBlob))
    BOUNDING=[];
    vertices=PixelsBlob{ii};
    if max(size(vertices))>1
%         in=inpolygon(XX(:),YY(:),vertices(:,1),vertices(:,2));
%         DETECTED=reshape(in,LENGTH,WIDTH);
%         fff=bwlabel(DETECTED);
%         hhh=regionprops(fff,'BoundingBox');
%         XMIN=hhh(1).BoundingBox(1);
%         XMAX=hhh(1).BoundingBox(1)+hhh(1).BoundingBox(3);
%         YMIN=hhh(1).BoundingBox(2);
%         YMAX=hhh(1).BoundingBox(2)+hhh(1).BoundingBox(4);
%         vertices2=[XMIN XMIN XMAX XMAX XMIN;YMIN YMAX YMAX YMIN YMIN];
%         vertices2=vertices2';
%         in2=inpolygon(XX(:),YY(:),vertices2(:,1),vertices2(:,2));
%         DETECTED2=reshape(in2,LENGTH,WIDTH);
        DETECTED2=zeros(LENGTH,WIDTH);
        DETECTED2(PixelsBlob{ii})=1;
        COMMONREGIONS=DETECTED2.*LABELCOMMON;
        a=unique(COMMONREGIONS(:));
        for i=1:max(size(a))
            if a(i)~=0
                M=find(COMMONMATRIX(a(i),:)==0);
                if min(size(M))>0
                    COMMONMATRIX(a(i),M(1))=ii;
                end
            end
        end
    end
end