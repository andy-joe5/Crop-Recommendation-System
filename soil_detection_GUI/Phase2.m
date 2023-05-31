clc
clear all
close all

[filename,pathname] = uigetfile({'*.*';'*.bmp';'*.tif';'*.gif';'*.png'},'Pick an Image File');
I = imread([pathname,filename]);
I1 = rgb2gray(I);
figure, imshow(I); title('HAND GESTURE IMAGES');
I = imresize(I,[200,200]);

subplot(2, 2, 1);
imshow(I)
title('original image')
impixelinfo;


%Add salt and pepper noise and display it.
J = imnoise(I1,'salt & pepper',0.1);
subplot(2, 2, 2);
imshow(J)
title('Noise added image')


%Use a median filter to filter out the noise and display the filtered image
K = medfilt2(J);
subplot(2, 2, 3);
imshow(K)
title('Filtered image')


%MSE and PSNR measurement
[row, col] = size(I);
mse = sum(sum((I(1,1) - K(1,1)).^2)) / (row * col);
psnr = 10 * log10(255 * 255 / mse);

disp('<--------------- Median  filter  ---------------------------->');
disp('Mean Square Error ');
disp(mse);
disp('Peak Signal to Noise Ratio');
disp(psnr);
disp('<--------------------------------------------------------->');


% % 
% R = I(:,:,1);
% G = I(:,:,2);
% B = I(:,:,3);
% % 
% % 


% %%%%TO ENHANCE THE CONTRAST OF THE RESIZED IMAGE%%%%
% I = imadjust(I,stretchlim(I));
% figure, imshow(I);title('CONTRAST ENHANCED IMAGE');
% 
% %           %%%%%%%SEGMENTATION%%%%%%
% 
% 
% 
% 
%  % Extract Features
% 
% % %%%%PERFORM RGB TO HSV COLOUR TRANSFORMATION%%%%% 
HSV=rgb2hsv(I);
figure,imshow(HSV),title('HSV COLOUR TRANSFORM IMAGE');
% %%SEPARATE THREE CHANNELS%%%
H=HSV(:,:,1);
S=HSV(:,:,2);
V=HSV(:,:,3);

figure,imshow(H),title('H-CHANNEL IMAGE');
figure,imshow(S),title('S-CHANNEL IMAGE');
figure,imshow(V),title('V-CHANNEL IMAGE');

figure,
subplot(1,3,1),imshow(H),title('H-CHANNEL');
subplot(1,3,2),imshow(S),title('S-CHANNEL');
subplot(1,3,3),imshow(V),title('V-CHANNEL');

% %% PERFORM RGB TO GRAY CONVERSION ON THE V-CHANNEL IMAGE%%%%
[m n o]=size(V);
if o==3
    gray=rgb2gray(V);
else
    gray=V;
end
figure,imshow(gray);title('V- CHANNEL GRAY IMAGE');
% 
% % % % % % % % % % % ad = fcnBPDFHE(gray); 
% 
% 
% %%%%%%ADJUST THE CONTRAST OF THE GRAY CHANNEL IMAGE%%%%
ad=imadjust(gray);
figure,imshow(ad);title('ADJUSTED GRAY IMAGE');
% 
% %%%%TO PERFORM BINARY CONVERSION ON THE ADJUSTED GRAY IMAGE%%%%%
bw=im2bw(gray,0.5);
figure,imshow(bw);title('BLACK AND WHITE IMAGE');
% 
% % %%%%TAKE COMPLEMENT TO THE BLACK AND WHITE IMAGE %%%%
bw=imcomplement(bw);
figure,imshow(bw);title('COMPLEMENT IMAGE');
% 
% %%%%TO PERFORM MORPHOLOGICAL OPERATIONS IN THE BW IMAGE%%%%
 %%FILL HOLES%%
bw=imfill(bw,'holes');
figure,imshow(bw),title('EDGE BASED SEGMENTATION');
%  %%DILATE OPERATION%%%
SE=strel('square',3);
bw=imdilate(bw,SE);
figure,imshow(bw),title('DILATED IMAGE');
% % 
% %  %%AGAIN FILL HOLES%%
% bw=imfill(bw,'holes');
% %   %%TO REMOVE THE SMALL OBJECTS TO PERFORM IMOPEN OPERATIONS%%%
% SE=strel('disk',10);
% bw=imopen(bw,SE);
% figure,imshow(bw),title('SMALL OBJECTS REMOVED IMAGE');
% %   %%TO CLEAR THE UNWANTED BORDERS%%%
% bw=imclearborder(bw);
% figure,imshow(bw),title('BORDER CORRECTED IMAGE');
% bw11=im2double


%  (bw);


%% Masking
% seg = bw11.*r;
% seg2 = bw11.*g;
% seg3 = bw11.*b;
% seg1=cat(3,seg,seg2,seg3);
% figure,imshow(seg1);
% title('Segmentation output');

%% segmentation
L = kmean(K);
%  Initialization and Load Data
%  Here we initialize some parameters 
imageDim = 28;         % image dimension
filterDim = 8;          % filter dimension
numFilters = 100;         % number of feature maps
numImages = 60000;      % maximum number of images 
poolDim = 3;          % dimension of pooling region

% load MNIST training images
addpath(genpath('../Dataset'));
images = loadMNISTImages('../Dataset/MNIST/train-images-idx3-ubyte');
images = reshape(images,imageDim,imageDim,1,numImages);

W = randn(filterDim,filterDim,1,numFilters);
b = rand(numFilters);

convImages = images(:, :, 1,1:8); 

% Implement cnnConvolve in cnnConvolve.m first!
convolvedFeatures = cnnConvolve(convImages, W, b);

%  Checking convolution
% For 1000 random points
for i = 1:1000   
    filterNum = randi([1, numFilters]);
    imageNum = randi([1, 8]);
    imageRow = randi([1, imageDim - filterDim + 1]);
    imageCol = randi([1, imageDim - filterDim + 1]);    
   
    patch = convImages(imageRow:imageRow + filterDim - 1, imageCol:imageCol + filterDim - 1,1, imageNum);
    feature = sum(sum(patch.*W(:,:,1,filterNum)))+b(filterNum);
    feature = 1./(1+exp(-feature));    
    if abs(feature - convolvedFeatures(imageRow, imageCol,filterNum, imageNum)) > 1e-9
        fprintf('Convolved feature does not match test feature\n');
        fprintf('Filter Number    : %d\n', filterNum);
        fprintf('Image Number      : %d\n', imageNum);
        fprintf('Image Row         : %d\n', imageRow);
        fprintf('Image Column      : %d\n', imageCol);
        fprintf('Convolved feature : %0.5f\n', convolvedFeatures(imageRow, imageCol, filterNum, imageNum));
        fprintf('Test feature : %0.5f\n', feature);       
        error('Convolved feature does not match test feature');
    end 
end
disp('Segmentation using fuzzy was done.');

%%


cform = makecform('srgb2lab'); 
% Apply the colorform
lab_he = applycform(I,cform);

% Classify the colors in a*b* colorspace using K means clustering.
% Since the image has 3 colors create 3 clusters.
% Measure the distance using Euclidean Distance Metric.
ab = double(lab_he(:,:,2:3));
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);
nColors = 1;
[cluster_idx cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean', ...
                                      'Replicates',1);
%[cluster_idx cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean','Replicates',3);
% Label every pixel in tha image using results from K means
pixel_labels = reshape(cluster_idx,nrows,ncols);
%figure,imshow(pixel_labels,[]), title('Image Labeled by Cluster Index');

% Create a blank cell array to store the results of clustering
segmented_images = cell(1,3);
% Create RGB label using pixel_labels
rgb_label = repmat(pixel_labels,[1,1,3]);

for k = 1:nColors
    colors = I;
    colors(rgb_label ~= k) = 0;
    segmented_images{k} = colors;
end

seg_img = im2bw(segmented_images{1});
figure, imshow(seg_img);title('Segmented disease');



%%
signal1 = feature_ext(I);
[cA1,cH1,cV1,cD1] = dwt2(signal1,'db4');
[cA2,cH2,cV2,cD2] = dwt2(cA1,'db4');
[cA3,cH3,cV3,cD3] = dwt2(cA2,'db4');

DWT_feat = [cA3,cH3,cV3,cD3];
G = pca(DWT_feat);

g = graycomatrix(G);
stats = graycoprops(g,'Contrast Correlation Energy Homogeneity');
Contrast = stats.Contrast;
Correlation = stats.Correlation;
Energy = stats.Energy;
Homogeneity = stats.Homogeneity;
Mean = mean2(G);
Standard_Deviation = std2(G);
Entropy = entropy(G);
RMS = mean2(rms(G));
%Skewness = skewness(img)
Variance = mean2(var(double(G)));
a = sum(double(G(:)));
Smoothness = 1-(1/(1+a));
Kurtosis = kurtosis(double(G(:)));
Skewness = skewness(double(G(:)));
% Inverse Difference Movement
% m = size(G,1);
% n = size(G,2);
% in_diff = 0;
% for i = 1:m
%     for j = 1:n
%         temp = G(i,j)./(1+(i-j).^2);
%         in_diff = in_diff+temp;
%     end
% end
% IDM = double(in_diff);
    
feat = [Contrast,Correlation,Energy,Homogeneity, Mean, Standard_Deviation, Entropy, RMS, Variance, Smoothness, Kurtosis, Skewness];
disp('-----------------------------------------------------------------');
disp('Contrast = ');
disp(Contrast);
disp('Correlation = ');
disp(Correlation);
disp('Energy = ');
disp(Energy);
disp('Mean = ');
disp(Mean);
disp('Standard_Deviation = ');
disp(Standard_Deviation);
disp('Entropy = ');
disp('RMS = ');
disp(Entropy);
disp(RMS);
disp('Variance = ');
disp(Variance);
disp('Kurtosis = ');
disp(Kurtosis);
disp('Skewness = ');
disp(Skewness);
%%
load Trainset.mat
 xdata = meas;
 group = label;

 
result = svmDetect(feat,meas,label);
helpdlg(result);
X = meas(:,1:2);
[n,p] = size(X);

plot(X(:,1),X(:,2),'.','MarkerSize',15);
title('Hand gesture Data Set');
xlabel('Sepal length (cm)');
ylabel('Sepal width (cm)');
rng(3);
k = 3; % Number of GMM components
options = statset('MaxIter',1000);
Sigma = {'diagonal','full'}; % Options for covariance matrix type
nSigma = numel(Sigma);

SharedCovariance = {true,false}; % Indicator for identical or nonidentical covariance matrices
SCtext = {'true','false'};
nSC = numel(SharedCovariance);
d = 500; % Grid length
x1 = linspace(min(X(:,1))-2, max(X(:,1))+2, d);
x2 = linspace(min(X(:,2))-2, max(X(:,2))+2, d);
[x1grid,x2grid] = meshgrid(x1,x2);
X0 = [x1grid(:) x2grid(:)];
threshold = sqrt(chi2inv(0.99,2));
count = 1;
