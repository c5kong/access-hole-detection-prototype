function A=Areaelim(LLFITTING,PER);
[WIDTH,LENGTH]=size(LLFITTING);
L=bwlabel(LLFITTING,8);
STATS=regionprops(L);
idx = find([STATS.Area] >((PER/100)*LENGTH*WIDTH));
BW2 = ismember(L,idx);
A=BW2;