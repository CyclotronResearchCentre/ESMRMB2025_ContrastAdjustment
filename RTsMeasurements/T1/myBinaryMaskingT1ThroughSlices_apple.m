clear all;
close all;
clc;

myTI = [40 100 300 600 1000 1500 3000 5000];
mySliceNumber = [6 7 8 9 21 22 23 24];

fileName = ones(size(myTI,2),size(mySliceNumber,2));
fileName = string(fileName);

myMean = zeros(size(myTI,2),size(mySliceNumber,2));
myStd = zeros(size(myTI,2),size(mySliceNumber,2));
mySNR = zeros(size(myTI,2),size(mySliceNumber,2));

xPos = 20:30;
yPos = 42:50;

myBinaryMask = myBinaryMaskGenerator(yPos,xPos,64,48);
myBinaryMask = im2double(myBinaryMask);

myBinaryMaskSouthwest = myBinaryMaskGenerator(55:64,1:10,64,48);
myBinaryMaskNorthwest = myBinaryMaskGenerator(1:10,1:10,64,48);
myBinaryMaskNortheast = myBinaryMaskGenerator(1:10,39:48,64,48);
myBinaryMaskSoutheast = myBinaryMaskGenerator(55:64,39:48,64,48);
myCornerBinaryMask = myBinaryMaskSouthwest + myBinaryMaskNorthwest ...
    + myBinaryMaskNortheast + myBinaryMaskSoutheast;
myCornerBinaryMask = im2double(myCornerBinaryMask);

for j = 1:size(mySliceNumber,2)

    for i=1:size(myTI,2)

       filename = sprintf('C:\\Users\\Administrator\\OneDrive - Universite de Liege\\Work\\Programming\\Matlab\\KneeImaging\\data\\phantom\\RTsMeasurement\\T1meas\\se_TI%d\\Slice%d_TI%d.png',myTI(i),mySliceNumber(j),myTI(i));

       myImage = imread(filename);
       myImage = im2double(myImage);

       myImageMasked = myBinaryMask .* myImage;
       myImageMasked = im2uint16(myImageMasked);

       myImageMaskedValues = myImageMasked(yPos,xPos);

       myMean(i,j) = mean(myImageMaskedValues,"all");

       myNoiseImage = myCornerBinaryMask.* myImage;
       myNoiseImage = im2uint16(myNoiseImage);

       myNoiseImageNorthwest = myNoiseImage(1:10,1:10);
       myNoiseImageNortheast = myNoiseImage(1:10,39:48);
       myNoiseImageSouthwest = myNoiseImage(55:64,1:10);
       myNoiseImageSoutheast = myNoiseImage(55:64,39:48);

       myNoiseImageValues = [myNoiseImageNorthwest myNoiseImageNortheast myNoiseImageSouthwest ...
           myNoiseImageSoutheast];
       myNoiseImageValues = single(myNoiseImageValues);
       myStd(i,j) = std( myNoiseImageValues(:));
       mySNR(i,j) = myMean(i,j)/myStd(i,j);

    end
    
end

TI = [40 100 300 600 1000 1500 3000 5000];

myMeanThroughSlices = mean(myMean,2);
myStdThroughSlices = mean(myStd,2);
mySNRThroughSlices = mean(mySNR,2);

myTotalStd = mean(myStd,"all");
myTotalMean = mean(myMean,"all");

myStdNorm = (myTotalStd / myTotalMean);

figure;
plot(TI, myMeanThroughSlices, 'r*');

