% This function finds the points on the vertices given the vertex points
function [LINES,A,regularity,LINEIMAGE]=VERTEX(vertices,LLFITTING,BINIMAGE)

LLFITTING=double(LLFITTING);
BINIMAGE=255*double(BINIMAGE);
LINEIMAGE=BINIMAGE;
X=size(vertices,1);
LINES=cell(1,X);
A=cell(1,X);
for i=1:X-1
    POINT1=vertices(i,:);
    POINT2=vertices(i+1,:);
    [LINES{i}(1,:),LINES{i}(2,:)]=brlinexya(round(POINT1(1)),round(POINT1(2)),round(POINT2(1)),round(POINT2(2))); 
end
LMAT=cell2mat(LINES);
[X,Y]=size(LLFITTING);
for i=1:size(LMAT,2)
    if (LMAT(2,i)>X)|(LMAT(1,i)>Y)|(LMAT(2,i)<1)|(LMAT(1,i)<1)
        Amat(i)=0;
    else
        Amat(i)=LLFITTING(LMAT(2,i),LMAT(1,i));
        LINEIMAGE(LMAT(2,i),LMAT(1,i))=100;
    end
end
regularity=sum(Amat(:))/(size(Amat,1)*size(Amat,2));

