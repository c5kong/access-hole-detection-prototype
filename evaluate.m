function [ X ] = evaluate(detectionThreshold)

	clc;
	%detectionThreshold = 0.5;
	
	%//=======================================================================
	%// Open detection output
	%//=======================================================================

	inputFile = ('aspectRatioScore.csv');	
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
	M{1, 1} = detectionThreshold;
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

	clear all;
end

