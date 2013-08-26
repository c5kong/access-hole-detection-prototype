function I1=gauss3(theta,sx,sy,winsz,x0,y0)
% fdelta=zeros(257);
% fdelta(128,128)=1;
% I1=mydiscgaussfft(fdelta,s^2);
A = 1;
% theta = theta-pi/2;
a = cos(theta)^2/2/sx^2 + sin(theta)^2/2/sy^2;
b = -sin(2*theta)/4/sx^2 + sin(2*theta)/4/sy^2 ;
c = sin(theta)^2/2/sx^2 + cos(theta)^2/2/sy^2;
 
[X, Y] = meshgrid(-winsz:winsz, -winsz:winsz);
I1 = A*exp( - (a*(X-x0).^2 + 2*b*(X-x0).*(Y-y0) + c*(Y-y0).^2)) ;
% surf(X,Y,Z);shading interp;view(-36,36);axis equal;drawnow
end