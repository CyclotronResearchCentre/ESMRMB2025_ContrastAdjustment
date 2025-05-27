function myNoiseBinaryMask = myNoiseBinaryMaskGenerator(p,q,m,n)

myNoiseBinaryMask = zeros(m,n);

myNoiseBinaryMask(1:p, 1:q) = 1;
myNoiseBinaryMask(1:p, n-q+1:n) = 1;
myNoiseBinaryMask(m-p+1:m, n-q+1:n) = 1;
myNoiseBinaryMask(m-p+1:m, 1:q) = 1;

