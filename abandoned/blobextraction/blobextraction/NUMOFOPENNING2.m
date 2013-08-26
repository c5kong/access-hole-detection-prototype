function N=NUMOFOPENNING2(BINARYIMAGE)
[LENGTH,WIDTH]=size(BINARYIMAGE);
XSCAN=[];
YSCAN=[];
countscan=0;
AREA=[];

for i=1:LENGTH
    BB=BINARYIMAGE(i,:);
    LABEL=bwlabel(BB);
    if max(LABEL(:))>0
        STATS=regionprops(LABEL);
        for ii=1:max(LABEL(:))
            countscan=countscan+1;
            AREA(countscan)=STATS(ii).Area;
        end
    end
end

for i=1:WIDTH
    BB=BINARYIMAGE(:,i);
    LABEL=bwlabel(BB);
    if max(LABEL(:))>0
        STATS=regionprops(LABEL);
        for ii=1:max(LABEL(:))
            countscan=countscan+1;
            AREA(countscan)=STATS(ii).Area;
        end
    end
end

N=mode2(AREA);