function SEG=PCNNFUN(final,BB,TIMECON)
[XX,YY]=size(final);
M=max(final(:));
N=min(final(:));
final=(final-N)*255/(M-N);
K=ones(11,11);
K(6,6)=0;
F=(final+1)/max(final(:)+1);

%close all

L=zeros(XX,YY);
SEG=zeros(XX,YY);
NUMOFSPIKE=zeros(XX,YY);
t=zeros(XX,YY);
TT=0;
COUNT=0;
COUNT2=0;
for BETA=BB
    Y=zeros(XX,YY); A=ones(XX,YY);
    %VTHETA=((max(F(:)))^2/min(F(:)))*(1+BETA*9);
    while any(any(A<1e2))
        COUNT2=COUNT2+1;
        THRESH=A.*exp(-TIMECON.*t);
        THRESHS(COUNT2)=5*exp(-COUNT2/25);
        INTEG=Y;
        L=(imfilter(Y,K,'replicate'))>0;
        U=F.*(1+BETA*L);
        %TTHRESH=THRESH(:,:,t);
        Y=(U-THRESH)>0;
        if sum(Y(:))>0
            H=1;
        end
        if (sum(INTEG(:)-Y(:))==0)
            t=t+1;
            TT=TT+1;
            NUMOFSPIKE(find(Y==1))=NUMOFSPIKE(find(Y==1))+1;
            [m,n]=find(Y==1);
            A(find(Y==1))=1e20;
            if sum(Y(:))>0
            P=unique(Y(:).*F(:));
            FF=sort(P,'descend');
            FF(1);
            FF(end-1);
            end
            t(find(Y==1))=0;
            Y(Y==1)=0;
            if min(size(m))>0
                COUNT=COUNT+1;
                for i=1:max(size(m))                    
                    SEG(m(i),n(i))=COUNT;
                end
            end
        end
    end
end