function [ X ] = evaluate()

	clc;
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	gtFile = ('groundTruth_noExt.csv');
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	directory = ('data/openni_data/rgb/');
	gtDirectory = ('data/openni_data/');
	outputDirectory = ('data/openni_data/output/');

	fileID = fopen(strcat(gtDirectory, gtFile));
	C = textscan(fileID, '%s %d %d %d %d','delimiter', ',', 'EmptyValue', -Inf);
	fclose(fileID);

	groundTruthPosImgs = char(C{1});
	groundTruthPosRegionsX = int32(C{2});
	groundTruthPosRegionsY = int32(C{3});
	groundTruthPosRegionsW = int32(C{4});
	groundTruthPosRegionsH = int32(C{5});
	
	for i =1:length(groundTruthPosRegionsH)

		segmentation_gt_label(strtrim(groundTruthPosImgs(i,:)), gtDirectory, groundTruthPosRegionsX(i), groundTruthPosRegionsY(i), groundTruthPosRegionsW(i), groundTruthPosRegionsH(i));

	end
	
	
end

