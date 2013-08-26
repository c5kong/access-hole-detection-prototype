function ACCEPTEDNEW=REMOVEREGIONS2(LLFITTING,ACCEPTED,PixelsBlob,PixelsBounding,im,CMAP);

[LENGTH,WIDTH]=size(LLFITTING);
[XX,YY]=meshgrid([1:WIDTH],[1:LENGTH]);
COUNTREGIONS=0;
OUT=zeros(LENGTH,WIDTH);
MODEAREA=[];
[XX2,YY2,ZZ2]=size(im);
IMM=im(10:XX2-10,10:YY2-10,:);
%figure,imshow(IMM);
in22=zeros(LENGTH,WIDTH);

ACCEPTEDNEW=ACCEPTED;
PixelsBoundingNew=PixelsBounding;
PixelsBlobNew=PixelsBlob;
[COMMONMATRIX,LABELCOMMON]=FINDCOMMONLABEL(LLFITTING,PixelsBounding,PixelsBlob,im,CMAP);
i=1;
flag=1;
warning off all
if min(size(COMMONMATRIX))>0
    A=unique(COMMONMATRIX(:));


    while flag

        [M,N]=find(COMMONMATRIX==A(i));
        clear REGIONS
        count=0;
        if (max(size(M))>1)&&(A(i)~=0)
            count=count+1;
            REGIONS(count,:)=[A(i) 100];
            %finding the REGIONS WHICH HAVE OVERLAP WITH the A(i)th region
            for j=1:max(size(M(:)))
                MM=find((COMMONMATRIX(M(j),:)~=0)&(COMMONMATRIX(M(j),:)~=A(i)));
                if min(size(MM))>0
                    for jjjj=1:max(size(MM))
                        count=count+1;
                        REGIONS(count,:)=[COMMONMATRIX(M(j),MM(jjjj)) M(j)];   %M is the overlap number
                    end
                end
            end
            %**************************** REGIONS WHICH HAVE OVERLAP WITH
            %A(i)th region are stored in the REGIONS
            PMAP=zeros(1,max(size(REGIONS)));
            AREA=zeros(1,max(size(REGIONS)));
            in222=zeros(LENGTH,WIDTH);
            if min(size(REGIONS))>1
                for jj=1:max(size(REGIONS))
                    vertices=ACCEPTED{1,REGIONS(jj,1)};
                    countt=0;
                    if max(size(vertices))>1
                        in=inpolygon(XX(:),YY(:),vertices(:,1),vertices(:,2));
                        DETECTED=reshape(in,LENGTH,WIDTH);
                        fff=bwlabel(DETECTED);
                        hhh=regionprops(fff,'BoundingBox');
                        XMIN=hhh(1).BoundingBox(1);
                        XMAX=hhh(1).BoundingBox(1)+hhh(1).BoundingBox(3);
                        YMIN=hhh(1).BoundingBox(2);
                        YMAX=hhh(1).BoundingBox(2)+hhh(1).BoundingBox(4);
                        vertices2=[XMIN XMIN XMAX XMAX XMIN;YMIN YMAX YMAX YMIN YMIN];
                        vertices2=vertices2';
                        in2=inpolygon(XX(:),YY(:),vertices2(:,1),vertices2(:,2));
                        DETECTED2=reshape(in2,LENGTH,WIDTH);
                        in222=in222+DETECTED2;
                        if jj==1;
                            OWNPIXELS=DETECTED2-bitand(DETECTED2,LABELCOMMON>0);
                            PMAP(1)=sum(CMAP(OWNPIXELS(:)==1));
                            AREA(1)=sum(OWNPIXELS(:));
                            if (AREA(1)/sum(DETECTED2(:)))<0.1
                                AREA(1)=0;
                            end
                        else
                            OWNPIXELS=DETECTED2-bitand(DETECTED2,LABELCOMMON>0);
                            PMAP(jj)=sum(CMAP(OWNPIXELS(:)==1));
                            AREA(jj)=sum(OWNPIXELS(:));
                            if (AREA(jj)/sum(DETECTED2(:)))<0.1
                                AREA(jj)=0;
                            end
                        end
                    end
                end
            end
            if min(size(REGIONS))>1
                PNORMALIZED=PMAP./AREA;
                [MJ,NJ]=min(PNORMALIZED);
                PixelsBoundingNew{REGIONS(NJ,1)}=[];
                PixelsBlobNew{REGIONS(NJ,1)}=[];
                ACCEPTEDNEW{1,REGIONS(NJ,1)}=[];
                COMMONMATRIX(COMMONMATRIX==REGIONS(NJ,1))=0;
            end
            ACCEPTED=ACCEPTEDNEW;
            PixelsBlob=PixelsBlobNew;
            PixelsBounding=PixelsBoundingNew;
        end
        AAA=sum(COMMONMATRIX'>0);
        MROW=find(AAA==1);
        if min(size(MROW))>0
            for mo=1:max(size(MROW))
                MCOL=find(COMMONMATRIX(MROW(mo),:));
                COMMONMATRIX(MROW(mo),MCOL)=0;
            end
        end

        if i==max(size(A(:)))
            i=1;
            [COMMONMATRIX,LABELCOMMON]=FINDCOMMONLABEL(LLFITTING,PixelsBoundingNew,PixelsBlobNew,im,CMAP);
            A=unique(COMMONMATRIX);
        else
            i=i+1;
        end
        for ii=1:max(size(A(:)))
            if numel(COMMONMATRIX)>0
                [M,N]=find(COMMONMATRIX==A(ii));
                if (max(size(M))>1)&&(A(ii)~=0)
                    flag=1;
                    break
                else
                    flag=0;
                end
            else
                flag=0;
            end
        end
    end

    [COMMONMATRIX,LABELCOMMON]=FINDCOMMONLABEL(LLFITTING,PixelsBoundingNew,PixelsBlobNew,im,CMAP);
    AAA=sum(COMMONMATRIX'>0);
    MROW=find(AAA>2);
    flag=1;
    i=1;
    if min(size(MROW))==0
        flag=0;
    end

    while flag
        count=0;
        MM=find(COMMONMATRIX(MROW(i),:)>0);
        clear REGIONS
        if min(size(MM))>0
            for jjjj=1:max(size(MM))
                count=count+1;
                REGIONS(count,:)=[COMMONMATRIX(MROW(i),MM(jjjj)) MROW(i)];   %M is the overlap number
            end
        end

        %**************************** REGIONS WHICH HAVE OVERLAP WITH
        %A(i)th region are stored in the REGIONS
        PMAP=zeros(1,max(size(REGIONS)));
        AREA=zeros(1,max(size(REGIONS)));
        in222=zeros(LENGTH,WIDTH);
        if min(size(REGIONS))>1
            for jj=1:max(size(REGIONS))
                vertices=ACCEPTED{1,REGIONS(jj,1)};
                countt=0;
                if max(size(vertices))>1
                    in=inpolygon(XX(:),YY(:),vertices(:,1),vertices(:,2));
                    DETECTED=reshape(in,LENGTH,WIDTH);
                    fff=bwlabel(DETECTED);
                    hhh=regionprops(fff,'BoundingBox');
                    XMIN=hhh(1).BoundingBox(1);
                    XMAX=hhh(1).BoundingBox(1)+hhh(1).BoundingBox(3);
                    YMIN=hhh(1).BoundingBox(2);
                    YMAX=hhh(1).BoundingBox(2)+hhh(1).BoundingBox(4);
                    vertices2=[XMIN XMIN XMAX XMAX XMIN;YMIN YMAX YMAX YMIN YMIN];
                    vertices2=vertices2';
                    in2=inpolygon(XX(:),YY(:),vertices2(:,1),vertices2(:,2));
                    DETECTED2=reshape(in2,LENGTH,WIDTH);
                    in222=in222+DETECTED2;
                    if jj==1;
                        OWNPIXELS=DETECTED2-bitand(DETECTED2,LABELCOMMON>0);
                        PMAP(1)=sum(CMAP(OWNPIXELS(:)==1));
                        AREA(1)=sum(OWNPIXELS(:));
                        if (AREA(1)/sum(DETECTED2(:)))<0.1
                            AREA(1)=0;
                        end
                    else
                        OWNPIXELS=DETECTED2-bitand(DETECTED2,LABELCOMMON>0);
                        PMAP(jj)=sum(CMAP(OWNPIXELS(:)==1));
                        AREA(jj)=sum(OWNPIXELS(:));
                        if (AREA(jj)/sum(DETECTED2(:)))<0.1
                            AREA(jj)=0;
                        end
                    end
                end
            end
        end

        if min(size(REGIONS))>1
            PNORMALIZED=PMAP./AREA;
            [MJ,NJ]=min(PNORMALIZED);
            ACCEPTEDNEW{1,REGIONS(NJ,1)}=[];
            PixelsBoundingNew{REGIONS(NJ,1)}=[];
            PixelsBlobNew{REGIONS(NJ,1)}=[];
            COMMONMATRIX(COMMONMATRIX==REGIONS(NJ,1))=0;
        end

        ACCEPTED=ACCEPTEDNEW;
        if i==max(size(MROW))
            i=1;
            [COMMONMATRIX,LABELCOMMON]=FINDCOMMONLABEL(LLFITTING,PixelsBoundingNew,PixelsBlobNew,im,CMAP);
            AAA=sum(COMMONMATRIX'>0);
            MROW=find(AAA>2);
        else
            i=i+1;
        end
        if min(size(MROW))==0
            flag=0;
        end
    end

    AAA=sum(COMMONMATRIX'>0);
    MROW=find(AAA==2);
    flag=1;
    i=1;
    if min(size(MROW))==0
        flag=0;
    end
    clear REGIONS
    if min(size(MROW))>0
        for i=1:max(size(MROW(:)))
            count=0;
            MM=find(COMMONMATRIX(MROW(i),:)>0);
            clear REGIONS
            if min(size(MM))>0
                for jjjj=1:max(size(MM))
                    count=count+1;
                    REGIONS(count,:)=[COMMONMATRIX(MROW(i),MM(jjjj)) MROW(i)];   %M is the overlap number
                end
            end
            %**************************** REGIONS WHICH HAVE OVERLAP WITH
            %A(i)th region are stored in the REGIONS
            PMAP=zeros(1,max(size(REGIONS)));
            AREA=zeros(1,max(size(REGIONS)));
            in222=zeros(LENGTH,WIDTH);
            if min(size(REGIONS))>1
                for jj=1:max(size(REGIONS))
                    vertices=ACCEPTED{1,REGIONS(jj,1)};
                    countt=0;
                    if max(size(vertices))>1
                        in=inpolygon(XX(:),YY(:),vertices(:,1),vertices(:,2));
                        DETECTED=reshape(in,LENGTH,WIDTH);
                        fff=bwlabel(DETECTED);
                        hhh=regionprops(fff,'BoundingBox');
                        XMIN=hhh(1).BoundingBox(1);
                        XMAX=hhh(1).BoundingBox(1)+hhh(1).BoundingBox(3);
                        YMIN=hhh(1).BoundingBox(2);
                        YMAX=hhh(1).BoundingBox(2)+hhh(1).BoundingBox(4);
                        vertices2=[XMIN XMIN XMAX XMAX XMIN;YMIN YMAX YMAX YMIN YMIN];
                        vertices2=vertices2';
                        in2=inpolygon(XX(:),YY(:),vertices2(:,1),vertices2(:,2));
                        DETECTED2=reshape(in2,LENGTH,WIDTH);
                        in222=in222+DETECTED2;
                        if jj==1;
                            OWNPIXELS=DETECTED2-bitand(DETECTED2,LABELCOMMON>0);
                            PMAP(1)=sum(CMAP(OWNPIXELS(:)==1));
                            AREA(1)=sum(OWNPIXELS(:));
                            if (AREA(1)/sum(DETECTED2(:)))<0.1
                                AREA(1)=0;
                            end
                        else
                            OWNPIXELS=DETECTED2-bitand(DETECTED2,LABELCOMMON>0);
                            PMAP(jj)=sum(CMAP(OWNPIXELS(:)==1));
                            AREA(jj)=sum(OWNPIXELS(:));
                            if (AREA(jj)/sum(DETECTED2(:)))<0.1
                                AREA(jj)=0;
                            end
                        end
                    end
                end
            end
            if min(size(REGIONS))>1
                PNORMALIZED=PMAP./AREA;
                [MJ,NJ]=min(PNORMALIZED);
                ACCEPTEDNEW{1,REGIONS(NJ,1)}=[];
                PixelsBoundingNew{REGIONS(NJ,1)}=[];
                PixelsBlobNew{REGIONS(NJ,1)}=[];
                COMMONMATRIX(COMMONMATRIX==REGIONS(NJ,1))=0;
            end
        end
    end
end




