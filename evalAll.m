
%	inputFile = ('avgOutput.csv'); 

inputFile = ('baseline.csv'); 
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