function Visualizing_Results(ANOT,image_file_name)

% This file is part of the Blob detection Toolbox - Copyright (C) 2009
% by Mohammad Jahangiri and Imperial College London.

IM=imread(image_file_name,'jpg');
NUMOFREGS=max(size(ANOT.Blobdetection.object));
countwin=0;
RIALL=cell(1,1);

for i=1:NUMOFREGS    
        polysize=max(size(ANOT.Blobdetection.object(i).polygon.pt));       
        VERTICES=[];
        for ii=1:polysize
            VERTICES(ii,1)=str2num(ANOT.Blobdetection.object(i).polygon.pt(ii).x);
            VERTICES(ii,2)=str2num(ANOT.Blobdetection.object(i).polygon.pt(ii).y);
            if VERTICES(ii,1)==0;
                VERTICES(ii,1)=1;
            end
            if VERTICES(ii,2)==0;
                VERTICES(ii,2)=1;
            end
        end        
        RIALL{1,i}=VERTICES;
end

%PATCHOFREGIONS(IM,RIALL);
%set(gca,'XTickLabel',[])
%set(gca,'YTickLabel',[])
%Showing the Bounding Boxes
figure,imshow(IM);
iptsetpref('ImshowBorder','tight')

[LENGTH,WIDTH,Z]=size(IM);
IMMEDIUM=mean(double(IM),3);
[XX,YY]=meshgrid([1:WIDTH],[1:LENGTH]);
COUNTREGIONS=0;
outputimage=zeros(LENGTH,WIDTH);
for ii=1:max(size(RIALL))
    BOUNDING=[];
    vertices=RIALL{1,ii};
    if max(size(vertices))>1
        COUNTREGIONS=COUNTREGIONS+1;
       in=inpolygon(XX(:),YY(:),vertices(:,1),vertices(:,2));
       DETECTED=reshape(in,LENGTH,WIDTH);
       fff=bwlabel(DETECTED);
       grayvalue=sum(IMMEDIUM(:).*DETECTED(:))/sum(DETECTED(:));
       hhh=regionprops(fff,'BoundingBox');
       XMIN=min(vertices(:,1));
       XMAX=max(vertices(:,1));
       YMIN=min(vertices(:,2));
       YMAX=max(vertices(:,2));
       vertices2=[XMIN XMIN XMAX XMAX XMIN;YMIN YMAX YMAX YMIN YMIN];
       AREA=(XMAX-XMIN)*(YMAX-YMIN);
       %if AREA>1000 %Make it on for the eye tracker
       outputimage(YMIN:YMAX,XMIN:XMAX)=1;    
       if grayvalue>125
       hold on,plot(vertices2(1,:),vertices2(2,:),'g-','LineWidth',5);
       else
       hold on,plot(vertices2(1,:),vertices2(2,:),'g-','LineWidth',5);
       end
       %end
    end
end
%figure,imshow(outputimage)
% figure,imshow(IM);
% for ii=1:max(size(RIALL))
%     BOUNDING=[];
%     vertices=RIALL{1,ii};
%     if max(size(vertices))>1
%         COUNTREGIONS=COUNTREGIONS+1;
%        in=inpolygon(XX(:),YY(:),vertices(:,1),vertices(:,2));
%        DETECTED=reshape(in,LENGTH,WIDTH);
%        fff=bwlabel(DETECTED);
%        hhh=regionprops(fff,'BoundingBox');
%         vertices3=vertices;
%         hold on,plot(vertices3(:,1),vertices3(:,2),'r-','LineWidth',5);
%     end
% end

