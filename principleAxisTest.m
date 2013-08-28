close all;
clear all;

x =0;
y=0;
r=1;
ang=0:0.1:2*pi; 
xp=r*cos(ang);
yp=r*sin(ang);
xp=xp';
yp=yp';
%figure, plot(xp,yp);

% stretch
xp = 2*xp;
%figure, plot(xp,yp);

% rotation
t = pi/6;
rotAngle = t;
xRot  = xp*cos(rotAngle) - yp*sin(rotAngle);
yRot  = xp*sin(rotAngle) + yp*cos(rotAngle);
figure, plot(xRot, yRot);
axis equal

A =cov([xp yp]);
[U, S, V] = svd(A);


B =cov([xRot yRot]);
[U1, S1, V1] = svd(B);


%X = [xp yp];
X = [xRot yRot];

Xprime = X';

D = U1'*Xprime;
max(abs(D (1,:)))*2
max(abs(D (2,:)))*2