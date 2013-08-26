clear;
col = 'w';
%-pi/2 pi/2
angle = -pi/2 + pi.*rand(1000,1);
%2-15
radius = 2  + 13.*rand(1000,1);
% radius =  10 + 0.*rand(1000,1);
baseline=rand(1000,1);
%1,9
aspect_ratio = 1 + 8.*rand(1000,1);
% aspect_ratio = 1 + 0.*rand(1000,1);
x = -40 + 80.*rand(1000,1);
y = -40 + 80.*rand(1000,1);
all = [];
all_asp=[];
WINSIZ=127;
r = [];
for j=1:10
    fprintf('%d.',j);
    d = baseline(j);
    c = -d + rand();
    ang = angle(j);
    norm_r = radius(j);
    asp = aspect_ratio(j);
    I1=gauss3(ang,norm_r/sqrt(asp),norm_r*sqrt(asp),WINSIZ,x(j),y(j));
    I1=I1-min(I1(:)) ;
    I1=I1/max(I1(:)) ;
    I1=I1*c + d ;
    
    if mod(j,2)==1
        I1(end,:) = [];
        I1(:,end) = [];
    end
    [frames1] = doh_detector( I1) ;
%     [frames1] = log_detector( I1) ;
    
    if isempty(frames1)
        continue;
    end
    figure(1);
    clf;
    imshow(I1);
    for ii=1:size(frames1,2)
        x0=frames1(1,ii);
        y0=frames1(2,ii);
        fprintf(' %f\t%f\t%f\t%f\t%f\t%f\t%f\n',x0-128-x(j), y0-128-y(j),100*(frames1(6,ii)-c)./c, 100*(frames1(7,ii)-d)./d, 100*(frames1(4,ii)-norm_r/sqrt(asp))./(norm_r/sqrt(asp)),100*(frames1(5,ii)-norm_r*sqrt(asp))./(norm_r*sqrt(asp)),100*(frames1(8,ii)-ang)./ang);
        
        aa = frames1(8,ii);
        s1 = frames1(4,ii);
        s2 = frames1(5,ii);
        rmat=[cos(aa) sin(aa); -sin(aa) cos(aa)]';
        sigma1=transpose(rmat)*[s1^2 0; 0 s2^2]*rmat;
        sigma=sqrtm(sigma1);
        X = sigma*[cos(linspace(0,2*pi,30)) ; sin(linspace(0,2*pi,30)) ;] ;
        X(1,:) = X(1,:) + x0;
        X(2,:) = X(2,:) + y0;
        hold on;
        line(X(1,:),X(2,:),'Color','g','LineWidth',1);
    end
    pause(1);
end