function N=NUMOFOPENNING(BINARYIMAGE)
[LENGTH,WIDTH]=size(BINARYIMAGE);
XSCAN=[];
YSCAN=[];
countxscan=0;
countyscan=0;
for i=1:LENGTH    
        BB=BINARYIMAGE(i,:);
        LABEL=bwlabel(BB);
         AREA=[];
        if max(LABEL(:))>0            
        STATS=regionprops(LABEL);
       
        for ii=1:max(LABEL(:))
            AREA(ii)=STATS(ii).Area;
        end
        countxscan=countxscan+1;
        TEMP=mode(AREA);
        XSCAN(countxscan)=TEMP(1);
        end
end
for i=1:WIDTH    
        BB=BINARYIMAGE(:,i);
        LABEL=bwlabel(BB);
        AREA=[];
        if max(LABEL(:))>0            
        STATS=regionprops(LABEL);
        
        for ii=1:max(LABEL(:))
            AREA(ii)=STATS(ii).Area;
        end
        countyscan=countyscan+1;
        TEMP=mode(AREA);
        YSCAN(countyscan)=TEMP(1);
        end
end           
TOTAL=[XSCAN YSCAN];
N=max(mode(TOTAL));