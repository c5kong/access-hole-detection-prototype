function X = automate(directory)
	
	%-- Debugging --%
	%segmentation('270', directory);  %-- False Pos
	segmentation('463', directory); %-- True Pos
	%segmentation('3270', directory); %-- False Neg (over %segmented)
	%segmentation('3220', directory); %-- False Neg (doesn't pass threshold)	

end