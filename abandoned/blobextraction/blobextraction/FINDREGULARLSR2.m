function [ACCEPTED,OUTPUT]=FINDREGULARLSR2(LLFITTINGFORIG,LLFITTING,MAINGOODCOLORIMAGE,regthresh)
    
L=bwlabel(LLFITTINGFORIG);
REGION_NUM=max(L(:));
STATS=regionprops(L,'all');
OUTPUT=LLFITTING;
 
[LENGTH,WIDTH]=size(LLFITTING);
ACCEPTED=cell(1,1);
BOUNDIM=zeros(LENGTH,WIDTH);
slot=3;

COUNTREG=0;
for i=1:REGION_NUM
    JJJ=L==i;
    JJJC=JJJ.*MAINGOODCOLORIMAGE;
    for ii=1:slot
            FFF(ii)=sum(sum(JJJC==ii))/sum(JJJ(:));
    end
    II=STATS(i).ConvexHull;
    CONVIM=STATS(i).ConvexHull;
    vertices=CONVIM;
    [LINES,A,regularity,LINEIMAGE]=VERTEX(vertices,L==i,LLFITTINGFORIG);
    LINEMAT=cell2mat(LINES);
    BOUNDIM=bitor(BOUNDIM,LINEIMAGE);
    A=(STATS(i).PixelList(:,1)<4)|(STATS(i).PixelList(:,2)<4)|((STATS(i).PixelList(:,2))>(WIDTH-4));%|(STATS(i).PixelList(:,1)>(WIDTH-4))
    
    if (regularity>regthresh)&&(std(FFF(:))<0.4)&&(~any(A(:)==1))
        COUNTREG=COUNTREG+1;
        ACCEPTED{1,COUNTREG}=CONVIM;        
        OUTPUT(STATS(i).PixelIdxList)=0;       
    end
end
