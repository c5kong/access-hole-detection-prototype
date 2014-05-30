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
%	inputFile = ('avgOutput.csv'); 

inputFile = ('meanDetectionScore_9SP_wMax_d51_ar2_illum1.csv'); 
inputDirectory = ('data/openni_data/output/');

tic;
evaluate(0, inputFile, inputDirectory);
evaluate(0.05, inputFile, inputDirectory);
evaluate(0.1, inputFile, inputDirectory);
evaluate(0.15, inputFile, inputDirectory);
evaluate(0.2, inputFile, inputDirectory);
evaluate(0.25, inputFile, inputDirectory);
evaluate(0.3, inputFile, inputDirectory);
evaluate(0.35, inputFile, inputDirectory);
evaluate(0.4, inputFile, inputDirectory);
evaluate(0.45, inputFile, inputDirectory);
evaluate(0.5, inputFile, inputDirectory);
evaluate(0.55, inputFile, inputDirectory);
evaluate(0.6, inputFile, inputDirectory);
evaluate(0.65, inputFile, inputDirectory);
evaluate(0.7, inputFile, inputDirectory);
evaluate(0.75, inputFile, inputDirectory);
evaluate(0.8, inputFile, inputDirectory);
evaluate(0.85, inputFile, inputDirectory);
evaluate(0.9, inputFile, inputDirectory);
toc;