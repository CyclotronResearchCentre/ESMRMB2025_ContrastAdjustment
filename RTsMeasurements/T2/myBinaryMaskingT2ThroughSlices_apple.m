clear all;
close all;
clc;

myTE = [6 8 12 15 30 45 65 95 120 150 180];
mySliceNumber = [11 12 13 14 25 26 27 28];

fileName = ones(size(myTE,2),size(mySliceNumber,2));
fileName = string(fileName);

myMean = zeros(size(myTE,2),size(mySliceNumber,2));

xPos = 72:100;
yPos = 126:150;

myBinaryMask = myBinaryMaskGenerator(yPos, xPos,192,168);
myBinaryMask = im2double(myBinaryMask);

for j = 1:size(mySliceNumber,2)

    for i=1:size(myTE,2)

       fileName = sprintf('C:\\Users\\Administrator\\OneDrive - Universite de Liege\\Work\\Programming\\Matlab\\KneeImaging\\data\\phantom\\RTsMeasurement\\T2meas\\se_TE%d\\Slice%d_TE%d.png',myTE(i),mySliceNumber(j),myTE(i));
       myImage = imread(fileName);
       myImage = im2double(myImage);

       myImageMasked = myBinaryMask .* myImage;
       myImageMasked = im2uint16(myImageMasked);

       myImageMaskedValues = myImageMasked(yPos,xPos);

       myMean(i,j) = mean(myImageMaskedValues,"all");

    end
    
end

myMeanThroughSlices = mean(myMean,2);


figure;
plot(myTE, myMeanThroughSlices, 'r*');

