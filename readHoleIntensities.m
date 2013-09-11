%function [ X ] = readHoleIntensities()

	
	inputFile = ('hole_intensities.csv');
	inputDirectory = ('data\training data\');
	file=strcat(inputDirectory, inputFile);

	fileID = fopen(strcat(inputDirectory, inputFile));
	C = textscan(fileID, '%s %d %d %d','delimiter', ',', 'EmptyValue', -Inf);
	fclose(fileID);

	Imgs = char(C{1});
	intAvg = int32(C{2});
	extAvg = int32(C{3});
	diff = int32(C{4});
	

%end

