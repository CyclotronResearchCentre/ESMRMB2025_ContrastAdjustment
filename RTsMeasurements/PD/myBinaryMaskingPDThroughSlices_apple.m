clear all;
close all;
clc;

mySliceNumber = 13:26;

fileName = ones(size(mySliceNumber,2),1);
fileName = string(fileName);

myMean = zeros(size(mySliceNumber,2),1);
myStd = zeros(size(mySliceNumber,2),1);
mySNR = zeros(size(mySliceNumber,2),1);

xPos = 72:85;
yPos = 112:125;

myBinaryMask = myBinaryMaskGenerator(yPos,xPos,192,168);
myBinaryMask = im2double(myBinaryMask);

myBinaryMaskSouthwest = myBinaryMaskGenerator(183:192,1:10,192,168);
myBinaryMaskNorthwest = myBinaryMaskGenerator(1:10,1:10,192,168);
myBinaryMaskNortheast = myBinaryMaskGenerator(1:10,159:168,192,168);
myBinaryMaskSoutheast = myBinaryMaskGenerator(183:192,159:168,192,168);
myCornerBinaryMask = myBinaryMaskSouthwest + myBinaryMaskNorthwest ...
    + myBinaryMaskNortheast + myBinaryMaskSoutheast;
myCornerBinaryMask = im2double(myCornerBinaryMask);

for i = 1:size(mySliceNumber,2)

       filename = sprintf('C:\\Users\\Administrator\\OneDrive - Universite de Liege\\Work\\Programming\\Matlab\\KneeImaging\\data\\phantom\\RTsMeasurement\\PDmeas\\se_TR15s_TE6ms\\Slice%d.png',mySliceNumber(i));

       myImage = imread(filename);
       myImage = im2double(myImage);

       myImageMasked = myBinaryMask .* myImage;
       myImageMasked = im2uint16(myImageMasked);

       myImageMaskedValues = myImageMasked(yPos,xPos);

       myMean(i,1) = mean(myImageMaskedValues,"all");

       myNoiseImage = myCornerBinaryMask.* myImage;
       myNoiseImage = im2uint16(myNoiseImage);

       myNoiseImageNorthwest = myNoiseImage(1:10,1:10);
       myNoiseImageNortheast = myNoiseImage(1:10,159:168);
       myNoiseImageSouthwest = myNoiseImage(183:192,1:10);
       myNoiseImageSoutheast = myNoiseImage(183:192,159:168);

       myNoiseImageValues = [myNoiseImageNorthwest myNoiseImageNortheast myNoiseImageSouthwest ...
           myNoiseImageSoutheast];
       myNoiseImageValues = single(myNoiseImageValues);
       myStd(i,1) = std( myNoiseImageValues(:));
       mySNR(i,1) = myMean(i,1)/myStd(i,1);
    
end

myTotalStd = mean(myStd,"all");
myTotalMean = mean(myMean,"all");

myPD = (myTotalMean / myTotalStd);
save myPDapple.dat myPD -ascii;


