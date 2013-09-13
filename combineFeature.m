%function [ X ] = combineFeature()
	clear all;
	clc;
	tic
	%//=======================================================================
	%// Open feature 1
	%//=======================================================================

	inputFile = ('widthScore_aspectRatioScore_relativeIntensityScore_depthScore');	
	inputDirectory = ('data/openni_data/output/');
	filename=strcat(inputDirectory, inputFile);
	fileID = fopen(strcat(filename, '.csv'));
	C = textscan(fileID, '%s %d %d %d %d %f','delimiter', ',', 'EmptyValue', -Inf);
	fclose(fileID);

	feature1Img = char(C{1});
	feature1X = int32(C{2});
	feature1Y = int32(C{3});
	feature1W = int32(C{4});
	feature1H = int32(C{5});
	feature1Score = single(C{6});

	
	%//=======================================================================
	%// Open feature 2
	%//=======================================================================
	
	inputFile2 = ('relativeIntensityScore');	
	inputDirectory = ('data/openni_data/output/');
	filename2=strcat(inputDirectory, inputFile2);
	fileID = fopen(strcat(filename2, '.csv'));	
	C = textscan(fileID, '%s %d %d %d %d %f','delimiter', ',', 'EmptyValue', -Inf);
	fclose(fileID);

	feature2Score = single(C{6});
	
		

	%//=======================================================================
	%// Output file
	%//=======================================================================
	
	outputFile = strcat(inputFile, '_');
	outputFile = strcat(outputFile, inputFile2);
	outputFile = strcat(outputFile, '.csv');
	
	
	%//=======================================================================
	%// combine scores
	%//=======================================================================		

	M ={};
	for i=1:length(feature1X)	
		dImg = strtrim(feature1Img(i,:));
		M{1, 1} = dImg;
		M{1, 2} = feature1X(i);
		M{1, 3} = feature1Y(i);
		M{1, 4} = feature1W(i);
		M{1, 5} = feature1H(i);
		M{1, 6} = feature1Score(i)*feature2Score(i);		
		dlmcell(outputFile, M, ',', '-a');
	end
	
	
toc;
%end

