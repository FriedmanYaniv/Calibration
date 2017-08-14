%% read raw and rotate

% make sure to be in the right directory, and name the raw file as 'Data'
fileID = fopen(['','Data' ,'.raw']);
raw_data=fread(fileID,'uint16');
fclose(fileID);
I = reshape(raw_data ,  640, 480)';
clear raw_data;
gray = mat2gray(I) ;  
BW = im2bw(gray, 0.3);

properties = 'Centroid'	;
stats = regionprops(BW,properties) ; 
stats.Centroid;
centroids = cat(1, stats.Centroid);

topX = 366.5 ;  topY = 455 ; 
rightX = 488.5 ; rightY = 358 ; 

theta = atan2(-(topY - rightY), (-(topX-rightX))) ;

% lineLength = 100;
% lineX = topX + lineLength*cos(theta) ; 
% lineY = topY + lineLength*sin(theta) ;
% hold on
% plot([topX lineX],[topY lineY])


rotMat = [cos(theta) -sin(theta) ; sin(theta) cos(theta)] ; 
rotatedCentroids = (centroids*rotMat) ;

centX = mean(centroids(:,1)) ;  centY = mean(centroids(:,2));
rotCentX = mean(rotatedCentroids(:,1)) ;  rotcentY = mean(rotatedCentroids(:,2));

diffX = centX - rotCentX ; 
diffY = centY - rotcentY ; 
plot(rotatedCentroids(:,1)+diffX, rotatedCentroids(:,2)+diffY,'g.')

%% play with correlation q convolution filters
clear; clc;
I = imread('coins.png');
imshow(I)

noise = uint8(rand(size(I))*40 - 20) ; 
im = I + noise ; 
imshow(im)

filt = ones(5,5) ;
filt = filt/length(filt(:)) ; 
C = uint8(convn(im,filt,'same')) ; 
imshow(C)

%% build "Gauss" filter

weights = [1 2 3 2 1] ; 
[X,Y] = meshgrid(weights, weights) ; 
gFilter = (X+Y)/2;
gFilter = gFilter / sum(gFilter(:)) ;
G = uint8(filter2(gFilter,im,'same')) ; 
imshow(G)

filteredIm = imfilter(I,gFilter,'corr','same');

%% Regions
bwI = mat2gray(I);
bwI = im2bw(I,0.3);

[L, num] = bwlabel(I,4);
%%
f = (bwI);
[L, num] = bwlabel(f);
borders = bwperim(f);
B = bwboundaries(f);
g = bound2im(B(45),size(f,1),size(f,2));
