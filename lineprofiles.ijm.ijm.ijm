imageId = getImageID();
imageName = getTitle();
dir = getDirectory("Choose a Directory");
ch = getNumber("which channel?", 1);
n = roiManager("count");

for(i=0;i<n;i++) {
	roiManager("select", i);
	selectImage(imageId);
	Stack.setChannel(ch);
	run("Plot Profile");
	Plot.getValues(x, y);
	for (j=0; j<x.length; j++){
		setResult("Distance", j, x[j]);
		setResult("GrayValue", j, y[j]);
	}
	saveAs("Results", dir+imageName+"_Ch"+ch+"_"+(i+1)+".csv");
	close("Results");
	//print(i);
}
roiManager("save", dir+imageName+"_Ch"+ch+".zip");
selectImage(imageId);
Stack.setChannel(3);
close("\\Others");

//print("done");
//selectImage(imageId);
//Stack.setChannel(3);
