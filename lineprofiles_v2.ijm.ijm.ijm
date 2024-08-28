//runs plot profile and outputs a .csv for each line roi
//does not work on multi channel images
//saves rois as zip file in same directory

imageId = getImageID();
imageName = getTitle();
dir = getDirectory("Choose a Directory");
ch = getNumber("which channel?", 1);
	//Stack.setChannel(ch);
n = roiManager("count");

//for each roi, save line profile results
for(i=0;i<n;i++) {
	selectImage(imageId);
	roiManager("select", i);
	run("Plot Profile");
	Plot.getValues(x, y);
	for (j=0; j<x.length; j++){
		setResult("Distance", j, x[j]);
		setResult("GrayValue", j, y[j]);
	}
	saveAs("Results", dir+imageName+"_Ch"+ch+"_"+(i+1)+".csv");
	run("Clear Results");
	//print(i);
}

//save roi
roiManager("save", dir+imageName+"_Ch"+ch+".zip");
//close all other windows
selectImage(imageId);
close("\\Others");

//print("done");
//selectImage(imageId);
