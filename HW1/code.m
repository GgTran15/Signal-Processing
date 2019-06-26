clear all; close all; clc;
load Testdata
L=15; % spatial domain
n=64; % Fourier modes
x2=linspace(-L,L,n+1); 
x=x2(1:n);
y=x; 
z=x;
k=(2*pi/(2*L))*[0:(n/2-1) -n/2:-1]; 
ks=fftshift(k);
[X,Y,Z]=meshgrid(x,y,z);
[Kx,Ky,Kz]=meshgrid(ks,ks,ks);

slice = 20;
Utave = zeros(n, n, n);
for j=1:20
    Un(:,:,:) = reshape(Undata(j,:),n,n,n); 
%    close all, isosurface(X,Y,Z,abs(Un),0.5)
%     axis([-20 20 -20 20 -20 20]), grid on, drawnow
%     pause(1)
    Unt(:,:,:) = fftn(Un);
%   Untp(:,:,:) = fftshift(abs(Unt)/max(abs(Unt(:))));
%     close all, isosurface(Kx, Ky, Kz, Untp, 0.5)
%     pause(1)
    Utave = Utave + Unt;
end
Utave = fftshift(Utave)/slice;
Utave_norm = abs(Utave)/max(abs(Utave(:)))
isosurface(Kx, Ky, Kz, Utave_norm,0.5);
title('Figure 1: Central Frequency after Denoising',...
    'Color', [255, 121, 77]/255)
xlabel('Kx', 'Color', [255, 121, 77]/255),
ylabel('Ky', 'Color', [255, 121, 77]/255), 
zlabel('Kz', 'Color', [255, 121, 77]/255)
grid on

[M, I] = max(Utave_norm(:));
[l, m, p] = ind2sub(size(Utave_norm), I); %get the index of max k
kx0 = Kx(l, m, p);
ky0 = Ky(l, m, p);
kz0 = Kz(l, m, p);
filter = exp(-0.2 *((Kx - kx0).^2 + (Ky - ky0).^2 + (Kz - kz0).^2));

for j=1:slice
    Un(:,:,:) = reshape(Undata(j,:),n,n,n); 
    Unt = fftn(Un);
    Unt = fftshift(Unt);
    Untf = Unt .* filter;
    Untf = ifftshift(Untf);
    Unf = ifftn(Untf); % go back to time domain

    [M, I] = max(Unf(:));
    [i1_max, i2_max, i3_max] = ind2sub(size(Unf), I);
    x_max(j) = X(i1_max, i2_max, i3_max);
    y_max(j) = Y(i1_max, i2_max, i3_max);
    z_max(j) = Z(i1_max, i2_max, i3_max);
end

plot3(x_max, y_max, z_max, 'Color', [255, 102, 102]/255,...
    'LineWidth', 3);
grid on
title('Figure 2: Trajectory of the marble inside the intestine',...
    'Color', [255, 121, 77]/255)
xlabel('x', 'Color', [255, 121, 77]/255), 
ylabel('y', 'Color', [255, 121, 77]/255),
zlabel('z', 'Color', [255, 121, 77]/255)
hold on
end_point = [x_max(end) y_max(end) z_max(end)];
plot3(end_point(1), end_point(2), end_point(3), '.', ...
    'Color', 'b', 'markersize', 30)
text(x_max(end), y_max(end), z_max(end),...
    ['   (' num2str(x_max(end)) ', ' num2str(y_max(end)) ', ' ...
    num2str(z_max(end)) ')'], 'color', [51, 204, 255]/255)









