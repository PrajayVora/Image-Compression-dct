clear;
clc;
%% start
n = 16;
I = imread('pepper.png');
I = rgb2gray(I);
I = flip(I, 2);
I = im2double(I);
%% 2d dct of 16x16 blocks
D = dctmtx(size(I,1));
dct1 = D*I*D';
figure
imshow(dct1);       %dct of entire img
title('dct of image');
T = dctmtx(n);
dct = @(block_struct) T*block_struct.data*T';
B = blockproc(I,[n n],dct);
figure
imshow(B);           %dct of blocks
title('dct of blocks');

%% criteria
absB = abs(B);
maskedB = absB(1:n,1:n);
sizeB = [size(B,1)/n size(B,2)/n];
BEnergy = sum(abs(B(1:n,1:n)),'all');
d = zeros(n);  

for i=1:n
    for j=1:n
        if sum(maskedB(1:i,1:j),'all') >= 95/100*BEnergy
            d(i,j) = 1;
        end
    end
end
d = flip(d,1);
d = flip(d,2);
%% masking

mask = d;
B2 = blockproc(B,[n n],@(block_struct) mask .* block_struct.data);
figure
imshow(B2);              %dct of blocks after mask
title('dct of blocks after masking');
%% invrdct

invdct = @(block_struct) T' * block_struct.data * T;
I2 = blockproc(B2,[n n],invdct);
figure
imshow(I)
title('original');
figure
imshow(I2)
title('compressed');
