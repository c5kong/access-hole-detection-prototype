
X = unitlength(zeromean(randnmulti(1000,[],[1 .6; .6 1]),1),1);
figure; setfigurepos([100 100 300 300]);
imagesc(X'*X,[0 1]);
axis image square;
colorbar;
title('Covariance matrix: X^TX');


[U,S,V] = svd(A);
angs = linspace(0,2*pi,100);
vectors = {};
circlevectors = {};
vectors{1} = eye(2);
circlevectors{1} = [cos(angs); sin(angs)];
vectors{2} = V'*vectors{1};
circlevectors{2} = V'*circlevectors{1};
vectors{3} = S'*S*vectors{2};
circlevectors{3} = S'*S*circlevectors{2};
vectors{4} = V*vectors{3};
circlevectors{4} = V*circlevectors{3};
  % now perform plotting
figure; setfigurepos([100 100 600 200]);
colors = 'rg';
titles = {'Original space' '(1) Rotate' '(2) Scale' '(3) Un-rotate'};
for p=1:4
  subplot(1,4,p);
  axis([-1.8 1.8 -1.8 1.8]); axis square; axis off;
  for q=1:2
    drawarrow(zeros(1,2),vectors{p}(:,q)',[colors(q) '-'],[],5);
  end
  plot(circlevectors{p}(1,:),circlevectors{p}(2,:),'k-');
  title(titles{p});
end
  
vectors = {};
vectors{1} = V;
vectors{2} = V'*vectors{1};
vectors{3} = S'*S*vectors{2};
vectors{4} = V*vectors{3};  
figure; setfigurepos([100 100 600 200]);
colors = 'rg';
titles = {'Original space' '(1) Rotate' '(2) Scale' '(3) Un-rotate'};
for p=1:4
  subplot(1,4,p);
  axis([-1.8 1.8 -1.8 1.8]); axis square; axis off;
  for q=1:2
    drawarrow(zeros(1,2),vectors{p}(:,q)',[colors(q) '-'],[],5);
  end
  plot(circlevectors{p}(1,:),circlevectors{p}(2,:),'k-');
  title(titles{p});
end
  