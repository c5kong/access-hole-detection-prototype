function [ X ] = evaluate(detectionScore)

	clc;
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	outputFile = ('output_perfectData.csv');
	gtFile = ('groundTruth_perfectdata.csv');
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	
	outputDirectory = ('data/SSRR2013/output/');
	gtDirectory = ('data/SSRR2013/output/groundTruth/');


	fileID = fopen(strcat(outputDirectory, outputFile));
	C = textscan(fileID, '%s %d %d %d %d %f','delimiter', ',', 'EmptyValue', -Inf);
	fclose(fileID);

	detectedImgs = char(C{1});
	detectedRegionsX = int32(C{2});
	detectedRegionsY = int32(C{3});
	detectedRegionsW = int32(C{4});
	detectedRegionsH = int32(C{5});
	detectedRegionScore = single(C{6});

	fileID = fopen(strcat(gtDirectory, gtFile));
	C = textscan(fileID, '%s %d %d %d %d','delimiter', ',', 'EmptyValue', -Inf);
	fclose(fileID);

	groundTruthPosImgs = char(C{1});
	groundTruthPosRegionsX = int32(C{2});
	groundTruthPosRegionsY = int32(C{3});
	groundTruthPosRegionsW = int32(C{4});
	groundTruthPosRegionsH = int32(C{5});

	truePositive = 0;
	falsePositive = 0;
	for i = 1:length(detectedRegionsX)
		dImg = strtrim(detectedImgs(i,:));
		dRegion(1, 1) = detectedRegionsX(i);
		dRegion(1, 2) = detectedRegionsY(i);
		dRegion(1, 3) = detectedRegionsW(i);
		dRegion(1, 4) = detectedRegionsH(i);	
		
		detectedArea = detectedRegionsW(i) * detectedRegionsH(i);
		
		if detectedRegionScore(i) > detectionScore

				for j = 1:length(groundTruthPosRegionsX)
				gtImg = strtrim(groundTruthPosImgs(j,:));
				gtRegion(1, 1) = groundTruthPosRegionsX(j);
				gtRegion(1, 2) = groundTruthPosRegionsY(j);
				gtRegion(1, 3) = groundTruthPosRegionsW(j);
				gtRegion(1, 4) = groundTruthPosRegionsW(j);
				
				gtArea = groundTruthPosRegionsW(j) * groundTruthPosRegionsW(j);

				if strcmp(dImg, gtImg) 			
					largerArea = max(detectedArea, gtArea);
					
					if rectint(dRegion, gtRegion) > (0.5*largerArea)
						truePositive = truePositive + 1;	
					else
						falsePositive = falsePositive + 1;
					end			
				end
			end


		end
		
		
	end	

	falseNegatives = length(groundTruthPosRegionsX) - truePositive;
	precision =  truePositive/(truePositive+falsePositive);%-- Precision = TP/(TP + FP) 
	recall =  truePositive/length(groundTruthPosRegionsX);%-- Recall = TP/nP,

	M ={};
	M{1, 1} = detectionScore;
	M{2, 1} = ('Precision');
	M{2, 2} = precision;
	M{3, 1} = ('Recall');
	M{3, 2} = recall;
	M{4, 1} = ('True Positives');
	M{4, 2} = truePositive;
	M{5, 1} = ('False Positives');
	M{5, 2} = falsePositive;
	M{6, 1} = ('False Negatives');
	M{6, 2} = falseNegatives;

	M{7, 1} = ('  ');
	dlmcell('P-R.csv', M, ',', '-a');

	%recall 
	%precision 
	%truePositive
	%falseNegatives
	%falsePositive

end

