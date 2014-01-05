function [ X ] = evaluate(detectionThreshold)

	clc;
	%detectionThreshold = 0.5;
	
	%//=======================================================================
	%// Open detection output
	%//=======================================================================

	
%	inputFile = ('aspectRatioScore.csv'); 
%	inputFile = ('aspectRatioScore_relativeIntensityScore.csv'); 
%	inputFile = ('contrastScore.csv'); 
%	inputFile = ('contrastScore_aspectRatioScore.csv'); 
%	inputFile = ('contrastScore_aspectRatioScore_relativeIntensityScore.csv'); 
	%inputFile = ('contrastScore_relativeIntensityScore.csv'); 
%	inputFile = ('depthScore.csv'); 
%	inputFile = ('depthScore_aspectRatioScore.csv'); 
%	inputFile = ('depthScore_aspectRatioScore_relativeIntensityScore.csv'); 
%	inputFile = ('depthScore_contrastScore.csv'); 
%	inputFile = ('depthScore_contrastScore_aspectRatioScore.csv'); 
%	inputFile = ('depthScore_contrastScore_aspectRatioScore_relativeIntensityScore.csv'); 
%	inputFile = ('depthScore_contrastScore_relativeIntensityScore.csv'); 
%	inputFile = ('depthScore_relativeIntensityScore.csv'); 
%	inputFile = ('relativeIntensityScore.csv'); 
%	inputFile = ('widthScore.csv'); 
%	inputFile = ('widthScore_aspectRatioScore.csv'); 
%	inputFile = ('widthScore_aspectRatioScore_relativeIntensityScore.csv'); 
%	inputFile = ('widthScore_aspectRatioScore_relativeIntensityScore_depthScore.csv'); 
%	inputFile = ('widthScore_aspectRatioScore_relativeIntensityScore_depthScore_relativeIntensityScore.csv'); 
%	inputFile = ('widthScore_contrastScore.csv'); 
%	inputFile = ('widthScore_contrastScore_aspectRatioScore.csv'); 
%	inputFile = ('widthScore_contrastScore_aspectRatioScore_relativeIntensityScore.csv'); 
%	inputFile = ('widthScore_contrastScore_relativeIntensityScore.csv'); 
%	inputFile = ('widthScore_depthScore.csv'); 
%	inputFile = ('widthScore_depthScore_aspectRatioScore.csv'); 
%	inputFile = ('widthScore_depthScore_aspectRatioScore_relativeIntensityScore.csv'); 
%	inputFile = ('widthScore_depthScore_contrastScore.csv'); 
%	inputFile = ('widthScore_depthScore_contrastScore_aspectRatioScore.csv'); 
%	inputFile = ('widthScore_depthScore_contrastScore_relativeIntensityScore.csv'); 
%	inputFile = ('widthScore_depthScore_relativeIntensityScore.csv'); 
%	inputFile = ('widthScore_relativeIntensityScore.csv'); 
%	inputFile = ('output.csv'); 
	inputFile = ('avgOutput.csv'); 
	
	

	inputDirectory = ('data/openni_data/output/');
	fileID = fopen(strcat(inputDirectory, inputFile));
	C = textscan(fileID, '%s %d %d %d %d %f','delimiter', ',', 'EmptyValue', -Inf);
	fclose(fileID);

	detectedImgs = char(C{1});
	detectionX = int32(C{2});
	detectionY = int32(C{3});
	detectionW = int32(C{4});
	detectionH = int32(C{5});
	detectionScore = single(C{6});

	
	%//=======================================================================
	%// Open ground truth data
	%//=======================================================================
	
	gtFile = ('groundTruth_noExt.csv');	
	gtDirectory = ('data/openni_data/');

	fileID = fopen(strcat(gtDirectory, gtFile));
	C = textscan(fileID, '%s %d %d %d %d','delimiter', ',', 'EmptyValue', -Inf);
	fclose(fileID);

	gtImgs = char(C{1});
	gtX = int32(C{2});
	gtY = int32(C{3});
	gtW = int32(C{4});
	gtH = int32(C{5});


	%//=======================================================================
	%// Evaluate
	%//=======================================================================		
	truePositive = 0;	
	falsePositive = 0;
	
	listOfImgs={};
	count=1;
	for i = 1:length(detectionX)
		dImg = strtrim(detectedImgs(i,:));
		dRegion = [ detectionX(i) detectionY(i) detectionW(i) detectionH(i) ];
		dArea = detectionW(i) * detectionH(i);
		
		%-- if detection score passes the threshold
		if detectionScore(i) > detectionThreshold 
		
			for j = 1:length(gtX)
				gtImg = strtrim(gtImgs(j,:));
				gtRegion = [ gtX(j) gtY(j) gtW(j) gtH(j) ];
				gtArea = gtW(j) * gtW(j);			
				

				if strcmp(dImg, gtImg) 			
					largerArea = max(dArea, gtArea);
					intersection = rectint(dRegion, gtRegion);				
					
					if intersection > (0.5*largerArea)
						%if there is no entry for this img					
						if length(find(strcmp(dImg, listOfImgs)==1)) == 0
							%add img to list
							listOfImgs{count,1} = dImg;
							count = count +1;
							
							%add true positive
							truePositive = truePositive + 1;	
						end
					else
						falsePositive = falsePositive + 1;
					end			
				end
				
			end
		end				
	end	

	falseNegatives = length(gtX) - truePositive;
	precision =  truePositive/(truePositive+falsePositive);%-- Precision = TP/(TP + FP) 
	recall =  truePositive/length(gtX);%-- Recall = TP/nP,

	
	%//=======================================================================
	%// Output
	%//=======================================================================		
	M ={};
	M{1, 1} = recall;
	M{1, 2} = precision;

	dlmcell(strcat('P-R_', inputFile), M, ',', '-a');

	%recall 
	%precision 
	%truePositive
	%falseNegatives
	%falsePositive

	clear all;

end

