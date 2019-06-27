clear all; close all; clc

load('cam1_1.mat')
cam = 1;
a = size(vidFrames1_1);
for k = 1:a(4)
    mov(k).cdata = vidFrames1_1(:,:,:,k);
    mov(k).colormap = [];
end

xCut = a(2)/2;    %col
masking = zeros(a(1), xCut);
nonMask = ones(a(1), xCut);
maskMat = horzcat(masking, nonMask);

frames = a(4);
x = zeros(3, 300)';
y = zeros(3, 300)';
for k = 1:frames
    A = double(rgb2gray(vidFrames1_1(:,:,:,k)));
    A = A >= 255;
    %A = A .* maskMat;
  %  imshow(A)
    [row, col] = find(A == max(A(:)));
    x(k, 1) = mean(col);
    y(k, 1) = mean(row);   
end

% %CAM 2
load('cam2_1.mat')
cam = 2;
a = size(vidFrames2_1);
for k = 1:a(4)
    mov(k).cdata = vidFrames2_1(:,:,:,k);
    mov(k).colormap = [];
end

xCut = a(2)/2;    %col
% masking = zeros(a(1), xCut);
% nonMask = ones(a(1), xCut);
% maskMat = horzcat(masking, nonMask);

frames = a(4);

for k = 1:frames
%         X=frame2im(mov(k));
%     subplot(2,1, 1) ,imshow(X); drawnow
    A = double(rgb2gray(vidFrames2_1(:,:,:,k)));
    A = A >= 252;
%         subplot(2,1, 2) ,imshow(A); drawnow
%     A = A .* maskMat;
%     imshow(A); 
    [row, col] = find(A == max(A(:)));
    x(k, cam) = mean(col);
    y(k, cam) = mean(row);
end


%CAM 3:
load('cam3_1.mat')
cam = 3;
a = size(vidFrames3_1);
for k = 1:a(4)
    mov(k).cdata = vidFrames3_1(:,:,:,k);
    mov(k).colormap = [];
end

xCut = a(2)/2;    %col
masking = zeros(a(1), xCut-50);   
nonMask = ones(a(1), xCut + 50);
maskMat = horzcat(masking, nonMask);

frames = a(4);

for k = 1:a(4)
    mov(k).cdata = vidFrames3_1(:,:,:,k);
    mov(k).colormap = [];
end

for k = 1:frames
%     A=frame2im(mov(k));
%    subplot(2,1, 1) ,imshow(A); drawnow
   A = double(rgb2gray(vidFrames3_1(:,:,:,k)));
   A= A >= 250;
    A = A .* maskMat;
% subplot(2,1, 2)   
%     imshow(A)
    [row, col] = find(A == max(A(:)));
    x(k, cam) = mean(col);
    y(k, cam) = mean(row);
end

minSize = 226;
X = [x(:,1)'; y(:, 1)'; x(:,2)'; y(:, 2)'; x(:,3)'; y(:, 3)'];
X = X(:, 1:minSize);
[row, col] = size(X);
XSubtracted = zeros(row,col);
for rows = 1:row
    XSubtracted(rows) = X(rows) - mean(X(rows));
end

n = 3
%U:mm, V: nn, S:mn
[U, S, V] = svd(X/sqrt(n - 1));
Y = U'*X;
% for k = 1:6
%     subplot(3,2,k), plot(abs(Y(k,:)))
% end

sig = diag(S);
for k = 1:6
    energy(k) = (sig(k)/sum(sig));
end
plot(abs(Y(1,:)))
 title('Test 1: Highest principle component')
 xlabel('Time')
 ylabel('Displacement of the can')
%  subplot(1, 2, 2)
%  histogram(energy, length(energy))