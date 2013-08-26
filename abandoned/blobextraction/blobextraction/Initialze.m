function Parameters=Initialze;
%*************************************************************************
%***********************************************************************
% In the first instance we have to initialize the parameters and
% coefficients that affect the output of the blob detector.
% The output of function "Initialize" is a structure of coefficients which
% consist of the following fields and default values. The values can be
% modified according to the application.

% field=Toboggan, default value='enable', This value enables the implementation 
%of the Toboggan enhancement prior to computing the interest map. Any other "char" value
% will disable this algorithm

% field =Scale, value=3, The number of scales which are used for
% constructing the interest map.

% field=thresholding, default value='global', a global thresholding
% algorithm is applied to the interest map. Any other "char" value otherwise 
% will enable a local thresholding algorithm.


% field=Area_per, default value=8. This parameter is a threshold for the
% ratio of the area of a detected blob to the area of the whole scene.
% Value 8 indicates that if the ratio of the area of a detected blob, to the are of the
% whole scene is bigger than 8% then that blob can be considered as a region of
% interest.

% field=Regularity, default value=0.2. This parameter is a measure of the
% convexity of an extracted blob. For an extracted blob if this measure is
% larger than the specified value, then that blob can be considered as a
% region of interest.

% field=Visualizing, default value=enable. It enables the visualization of the
% detected blobs.

Parameters=struct('Toboggan','enable','Scale',3,'Thresholding','global','AreaPer',8,'Regularity',0.2,'Visualizing','enable','Thresholdimage','unsave','Thresholdingbias',10);
