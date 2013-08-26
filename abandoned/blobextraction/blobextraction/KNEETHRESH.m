function LLFITTING=KNEETHRESH(final,Parameters,MODE);

VAR=Parameters.Scale;
M=max(final(:));
N=min(final(:));
final=(final-N)*255/(M-N);
iptsetpref('ImshowBorder','tight');
X=0:1/255:1;
X2=(0:1/1000:1);
II=cdfmine(double(uint8(final)));
%figure,imshow(-final,[]);

Y=(II(end)-II(1))/(X2(end)-X2(1)).*(X2)+II(1);
% figure,plot(X,II,'r.');
% axis square
% hold on, plot(X2,Y,'g');
% axis square
II2=II;
DIST=[];
for ii=1:256
x=X(ii);
y=II2(ii);
DIST(ii,:)=sqrt((Y-y).^2+(X2-x).^2);
%DIST(ii,:)=abs(X2-x);
%DIST(ii,:)=sqrt((II-y).^2);
[m(ii),n(ii)]=min(DIST(ii,:));
%II2(n(ii))=100;
%FF(ii,:)=[m(ii) n(ii) ii];
PERR=[X(ii) II(ii);X2(n(ii)) Y(n(ii))];
%hold on,plot(PERR(:,1),PERR(:,2));
end
% PERR=[X' Y';X(n)' II(n)'];
% hold on,plot(PERR(:,1),PERR(:,2),'g')

[MM,NN]=max(m);
% PER=[X2(n(NN)) Y(n(NN));X(NN) II(NN)];
% hold on, plot(PER(:,1),PER(:,2),'r');
% axis square
% PER2=[X(NN) II(NN);X(NN) 0]
% hold on, plot(PER2(:,1),PER2(:,2),'r');
% axis square

n=NN-Parameters.Thresholdingbias;



% [LENGTH,WIDTH]=size(final);
% XX=0:1:255;
% M1=mean(gradient(II(2:ceil(0.04*(sqrt(2)^VAR)*125))));
% Y1=M1*XX+II(1);
% M2=mean(gradient(II(245:255)));
% Y2=M2*(XX-255)+1;
% [m,n]=min(abs(Y1-Y2));



%********************USING THE ESTIMATED KNEE****************
if sum(MODE=='KNEE')==4
LLFITTING=final>n;
end
%********************Using PCNN and the information from knee
if sum(MODE=='PCNN')==4
TIMECON=-log((n)/255);
SEG=PCNNFUN(final,0.5,TIMECON);            %If using PCNN
LLFITTING=SEG==1;
end

% figure,plot(II,'b');
% axis([0 256 0 1.2]);
% hold on,plot(Y1,'r');
% hold on,plot(Y2,'g');
% [m,n]=min(abs(Y1-Y2));
% THX=n*ones(1,50);
% THY=0:1/50:1;
% hold on,plot(THX,THY(1:50),'r.','LineWidth',3.0)
