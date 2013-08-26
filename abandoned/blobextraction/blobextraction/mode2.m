function y=mode2(x)
% MODE finds the mode of a sample.  The mode is the
% observation with the greatest frequency.
%
% i.e. in a sample x=[0, 1, 0, 0, 0, 3, 0, 1, 3, 1, 2, 2, 0, 1]
% the mode is the most frequent item, 0.


% IT'S NOT FANCY BUT IT WORKS
% Michael Robbins
% robbins@bloomberg.net
% michael.robbins@us.cibc.com

%tic;
% 
A=min(x);
B=max(x);
NUMOFBINS=20;
BINS=A:((B-A)/NUMOFBINS):(B);
BINS(end)=BINS(end)+1;
CC=[0.5 0.5];
BINSMODE=conv(BINS,CC);
BINSMODEMAIN=BINSMODE(2:end-1);
BINS2=A:((B-A)/(2*NUMOFBINS)):(B);
BINS22=[BINS2,B+1];
% for ii=1:max(size(BINS))
% %hold on, plot([BINS(ii) BINS(ii)],[0,1],'g*-')
% end
CC=repmat(BINS',1,max(size(x)));
MODEAREA2REP=repmat(x,NUMOFBINS+1,1);
JJJ=sum(MODEAREA2REP>=CC);
Regions=JJJ;
LL1=[];
LL2=[];
for i=1:(NUMOFBINS)
    LL1(i)=sum(Regions==i);
    LL2(i)=sum(x(Regions==i));
end
[MM,NN]=max(LL1);
y=ceil((BINS(NN)+BINS(NN+1))/2);

% 
% [b,i,j] = unique(x);
% h = hist(j,length(b));
% m=max(h);
% y=b(h==m);

%toc

% FEX SUGGESTION IS SLOWER
% tic;
% sorted=sort(x(:));
% [d1, i1]=unique(sorted);
% h=[i1(1); diff(i1)];
% m=max(h);
% m=d1(h==m); 
% toc
