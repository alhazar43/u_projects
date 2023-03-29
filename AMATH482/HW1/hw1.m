 % Load the data
 clear all; close all; clc;
 load Testdata
 
 L = 15; % spatial domain
 n = 64; % Fourier modes
 x2 = linspace(-L, L, n + 1); x = x2(1: n);  y = x;  z = x;
 k = (2 * pi / (2 * L)) * [0: (n / 2 - 1) -n / 2: -1];  ks = fftshift(k);
 
 [X, Y, Z] = meshgrid(x, y, z);
 [Kx, Ky, Kz] = meshgrid(ks, ks, ks);
 
 % Plot the Original data at 1st measurement
 figure(1)
 Un_init(:, :, :) = reshape(Undata(1, :), n, n, n);
 isosurface(X ,Y , Z, abs(Un_init), 0.4)
 axis([-20 20 -20 20 -20 20]), grid on
 drawnow
 xlabel('X'); ylabel('Y');zlabel('Z');
 
 % Unfiltered FFT
 Untave=0;
 for j = 1: 20
     Un(:, :, :) = reshape(Undata(j, :), n, n, n);
     Unt = fftn(Un);
     Untave = Untave + Unt;
 end
 Untave=fftshift(Untave)/20;
 Untave_max=max(abs(Untave(:)));
 Untp = abs(Untave) / Untave_max;
 
 % Find the coordinates for the frequency signature and plot it
 [cx, cy, cz] = ind2sub(size(Untave), find(abs(Untave) == Untave_max));
 figure(2)
 isosurface(Kx, Ky, Kz, Untp, 0.6)
 axis([-2*pi 2*pi  -2*pi 2*pi  -2*pi 2*pi]), grid on
 drawnow
 xlabel('Kx'); ylabel('Ky');zlabel('Kz');
 pause(1)
 
 % Create the Gaussian filter of the form exp(-0.2*(k - k0) .^ 2)
 K0 = [Kx(cx, cy, cz), Ky(cx, cy, cz), Kz(cx, cy, cz)];  % find corresponding k0 on each axis
 filter = exp(-0.2*((Kx - K0(1)) .^ 2 + (Ky - K0(2)) .^ 2 +  (Kz - K0(3)) .^ 2));
 
 % Apply FFT with the Gaussian filter
 figure(3)
 pos = zeros(20, 3);
 for j = 1:20
     Un(:, :, :) = reshape(Undata(j, :), n, n, n);
     Unt = fftn(Un);
     Untf = filter .* fftshift(Unt);
     Unf = ifftn(Untf);
     Unf_max = max(abs(Unf(:)));
     Unfp = abs(Unf)/ Unf_max;
 
     % Plot the marble for each measurement on isosurface
     subplot(1, 2, 1)
     isosurface(X, Y, Z,Unfp,0.8)
     axis([-20 20 -20 20 -20 20]), grid on
     drawnow
     xlabel('X'); ylabel('Y');zlabel('Z');
     pause(1)
 
     % Find the exact coordiantes of the marble of each measurement in the spatial domain
     [cx, cy, cz] = ind2sub(size(Unf), find(abs(Unf) == Unf_max));
     pos(j, :) = [X(cx, cy, cz), Y(cx, cy, cz), Z(cx, cy, cz)];
 end
 
 % Plot the trajectory of the marble
 subplot(1, 2, 2)
 plot3(pos(:, 1), pos(:, 2), pos(:, 3), 'x-')
 axis([-20 20 -20 20 -20 20]), grid on
 xlabel('X'); ylabel('Y');zlabel('Z');
 final_pos = pos(20, :);

