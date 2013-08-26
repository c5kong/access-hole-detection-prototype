function find_blobs_in_image(image_file_name,xml_file_nameall,xml_file_nameremoved)

% This file is part of the Blob detection Toolbox - Copyright (C) 2009
% by Mohammad Jahangiri and Imperial College London.

% An image processing module that can extract blobs in an image. It
% consists of three main steps, including i)Toboggan edge-preserving smoothing,
% ii)applying an interest operator which is designed to be scale and colour
% invariant iii) Employing morphological operators and connected component analysis in order to 
% extract regions which are i)convex, ii) do not constitute straight lines
% iii) occupy considerable amount of the whole scene.

% image_file_name: Input image filename.

% xml_file_nameall: Results of the blobs before removal.

% xml_file_nameremoved: Results of the blobs after removal


%tic
Parameters=Initialze;

%If the user requires to change the default values, then he/she can uncomment the
%following six lines and change the values

% Parameters.Toboggan='disable';
% Parameters.Scale=5;
% Parameters.Thresholding='local';
% Parameters.Areaper=10;
% Parameters.Regularity=0.1;
% Parameters.Visualizing='enable';



% Running the blob detector algorithm using the initialized parameters.
%Parameters.Thresholdimage='unsave';
%for i=-15:5:15
Parameters.Thresholdingbias=0;

tic
[BlobDetectorall,BlobDetectorremoved]=blobdetector(image_file_name,Parameters);
toc
% Writing the extracted Polygons into an xml File
writexml(xml_file_nameall,BlobDetectorall);
writexml(xml_file_nameremoved,BlobDetectorremoved);
%ConvertXMLPROP(Polygons,image_file_name,xml_file_name,Parameters);

% Visualizing the results. Both the bounding boxes and the patches of the
% identified polygons are visualized
Parameters.Visualizing='enable';
if strcmp(Parameters.Visualizing,'enable')
Results=loadXML(xml_file_nameall);
Visualizing_Results(Results,image_file_name)
Results=loadXML(xml_file_nameremoved);
Visualizing_Results(Results,image_file_name)
end

%end
%toc