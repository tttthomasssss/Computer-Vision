%generate a simple image and hough transform
f=zeros(101,101);
f(80,80)=1;
f(70,70)=1;
f(100,100)=1;
f(10,10)=1;
f(50,50)=1;
%f(40:60,30)=1;
figure(1)
imshow(f);
figure(2)
[H,t,r]=hough(f);
%imshow(t, r,H,[])
imshow(imadjust(mat2gray(H)), 'XData', t, 'YData', r, 'InitialMagnification', 'fit');
axis on, axis normal
xlabel('\theta'), ylabel('\rho')

[height length] = size(f);

% Get the peak in the accumulator array
max_val = max(H(:));
[x, y] = ind2sub(size(H), find(H==max_val));
theta_val = t(y);
rho_val = r(x);

fprintf('X: %d\n', x);
fprintf('Y: %d\n', y);
fprintf('THETA: %f\n', t(y));
fprintf('RHO: %f\n', r(x));

theta_rad = deg2rad(theta_val);

h = norm([length; height])

rotated_theta_val = theta_val + 90;

x1 = 0;
x2 = h.*cos(deg2rad(rotated_theta_val));
y1 = 0;
y2 = h.*sin(deg2rad(rotated_theta_val));

[f t] = pol2cart(theta_val, rho_val);

fprintf('x2: %f\n', x2);
fprintf('y2: %f\n', y2);

%if abs(theta_rad) > pi/4
%    x1 = 0;
%    y1 = 0;
%    x2 = 2*length;
%    y2 = (-cos(theta_rad) * x2+rho_val) / sin(theta_rad);
%else
%    x1 = 0;
%    y1 = 0;
%    y2 = 2*height;
%    y2 = (-sin(theta_rad)*y2+rho_val) / cos(theta_rad);
%end;
figure(1);
line([x1 x2], [y1 y2], 'Clipping', 'off', 'Color', 'r');

