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
	gtX = int32(C{2});
	gtY = int32(C{3});
	gtW = int32(C{4});
	gtH = int32(C{5});
	
	for i =1:length(gtH)

		segmentation_gt_label(strtrim(groundTruthPosImgs(i,:)), gtDirectory, gtX(i), gtY(i), gtW(i), gtH(i));

	end
	
	
end

