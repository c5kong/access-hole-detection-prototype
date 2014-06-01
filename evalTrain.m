
inputFile = ('train_filter.csv'); 
inputDirectory = ('data/openni_data/output/');

tic;
evalTrainingSet(0, inputFile, inputDirectory);
evalTrainingSet(0.05, inputFile, inputDirectory);
evalTrainingSet(0.1, inputFile, inputDirectory);
evalTrainingSet(0.15, inputFile, inputDirectory);
evalTrainingSet(0.2, inputFile, inputDirectory);
evalTrainingSet(0.25, inputFile, inputDirectory);
evalTrainingSet(0.3, inputFile, inputDirectory);
evalTrainingSet(0.35, inputFile, inputDirectory);
evalTrainingSet(0.4, inputFile, inputDirectory);
evalTrainingSet(0.45, inputFile, inputDirectory);
evalTrainingSet(0.5, inputFile, inputDirectory);
evalTrainingSet(0.55, inputFile, inputDirectory);
evalTrainingSet(0.6, inputFile, inputDirectory);
evalTrainingSet(0.65, inputFile, inputDirectory);
evalTrainingSet(0.7, inputFile, inputDirectory);
evalTrainingSet(0.75, inputFile, inputDirectory);
evalTrainingSet(0.8, inputFile, inputDirectory);
evalTrainingSet(0.85, inputFile, inputDirectory);
evalTrainingSet(0.9, inputFile, inputDirectory);
toc;