function X = automate()	
	tic
	directory = 'data/openni_data/';	
	
	%--debugging--%
	segmentation('12_000180', directory);
	%segmentation('11_000000', directory);
	%segmentation('11_000060', directory);
	%segmentation('6_000360', directory,149,237,122,119 );	

	'Total Dataset Runtime'
	toc
end