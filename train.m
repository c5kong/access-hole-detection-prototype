function X = train()
tic
directory = 'data/openni_data/';

%--training dataset--%
segmentation('11_000240', directory);
segmentation('11_000300', directory);
segmentation('11_000660', directory);
segmentation('11_000720', directory);
segmentation('12_000240', directory);
segmentation('12_000300', directory);
segmentation('12_000660', directory);
segmentation('12_000720', directory);
segmentation('13_000600', directory);
segmentation('13_000660', directory);
segmentation('14_000180', directory);
segmentation('14_000240', directory);
segmentation('15_000000', directory);
segmentation('15_000060', directory);
segmentation('15_000480', directory);
segmentation('16_000000', directory);
segmentation('16_000060', directory);
segmentation('16_000120', directory);
segmentation('16_000480', directory);
segmentation('16_000540', directory);
segmentation('17_000060', directory);
segmentation('17_000120', directory);
segmentation('18_000120', directory);
segmentation('18_000180', directory);
segmentation('18_000660', directory);
segmentation('18_000720', directory);
segmentation('21_000060', directory);
segmentation('21_000120', directory);
segmentation('2_000120', directory);
segmentation('2_000180', directory);
segmentation('3_000180', directory);
segmentation('3_000240', directory);
segmentation('3_000540', directory);
segmentation('3_000600', directory);
segmentation('3_000960', directory);
segmentation('3_001020', directory);
segmentation('4_000240', directory);
segmentation('4_000300', directory);
segmentation('5_000000', directory);
segmentation('5_000060', directory);
segmentation('5_000360', directory);
segmentation('5_000420', directory);
segmentation('5_000720', directory);
segmentation('6_000000', directory);
segmentation('6_000360', directory);
segmentation('6_000420', directory);
segmentation('7_000180', directory);
segmentation('7_000360', directory);
segmentation('7_000660', directory);
segmentation('7_000720', directory);
segmentation('8_000180', directory);
segmentation('8_000240', directory);



'Training Dataset Runtime'
toc
end