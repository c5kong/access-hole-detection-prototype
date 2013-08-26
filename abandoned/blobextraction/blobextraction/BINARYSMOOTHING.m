function OUT=BINARYSMOOTHING(LLFITTING);
EL=strel('diamond',1);
OUT=imerode(LLFITTING,EL);
OUT=imdilate(OUT,EL);
OUT=imdilate(OUT,EL);
OUT=imerode(OUT,EL);