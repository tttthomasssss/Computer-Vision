function depth_display(im, m)
%DEPTH_DISPLAY displays stereo matches as a depth map
%   DEPTH_DISPLAY(IM, CORRESPS) takes an image, IM, and a set of stereo
%   correspondences. CORRESPS is expected to be a matrix with one
%   column per match, the column containing the match coordinates in the
%   original images in the order [left row; left col; right row; right
%   col]. IM should be the left image of the stereo pair.
%   
%   The display is generated assuming an arbitrary baseline and focal
%   length, and shows projections of the point cloud from three directions,
%   together with the points superimposed on the images. Colours are varied
%   by depth to make it clearer which parts of the image correspond to
%   which parts of the 3-D scene.

% Assume the following parameters
base_line = 1;      % camera separation in world coords
focal_length = 500; % focal length in pixels
[nr,nc] = size(im);
xc = nc/2;          % optic axis at centre
yc = nr/2;

% Convert row, column into x,y image coords
x1 = m(2,:) - xc;
y1 = yc - m(1,:);
x2 = m(4,:) - xc;
y2 = yc - m(3,:);

% Use Euclidean separation as horizontal disparity
% disps = sqrt((x1-x2).^2 + (y1-y2).^2);
% Use horizontal disparity
disps = (x1-x2);

% Compute x,y,z coordinates of points in m
% - assume parallel cameras
Z = focal_length * base_line ./ disps;
X = 0.5*(x1+x2) .* Z / focal_length;
Y = 0.5*(y1+y2) .* Z / focal_length;  % - to make increase upwards

% Sort by depth to facilitate comparisons
[Z, index] = sort(Z);
X = X(index);
Y = Y(index);
r1 = m(1, index);
c1 = m(2, index);

% Plot the points
getwin;
subplot(2,2,1);
plot1view(X,Z,Y,[0,-1,0],'Along camera axis');
subplot(2,2,2);
plot1view(X,Z,Y,[0,0,1],'From above');
subplot(2,2,3);
plot1view(X,Z,Y,[1,0,0],'From side');
subplot(2,2,4);
imshow(im, []);
different_points2(c1, r1);
end

%---------------------------------------------------------------------
function getwin
% Get a window for display, or set it up
h = findobj(allchild(0), 'tag', 'Depth Display');

if ~isempty(h)
    figure(h(1));
else
    h = figure( ...
        'Name','Depth Display', ...
        'tag', 'Depth Display', ...
        'NumberTitle', 'off', ...
        'Position', [200 100 800 600]); %#ok<NASGU>
end
clf;            % Clear the figure
end

%---------------------------------------------------------------------

function plot1view(X,Y,Z,viewpoint,titletext)
different_points3(X,Y,Z);
title(titletext);
xlabel('X');
ylabel('Z');
zlabel('Y');
view(viewpoint);
axis equal;
end

%-----------------------------------------------------------------------

function different_points3(x, y, z)
% Display a lot of points in different colour/symbol combinations
% Symbol changes rapidly, colour more slowly

% Vectors for colour/symbol combinations to distinguish matches
colours = ['y';'r';'c';'m';'g';'b'];
%syms = ['o';'x';'s';'+';'d';'*';'v';'p'];
lc = length(colours);
%ls = length(syms);
ls = ceil(length(x)/lc);

hold on;
for i=1:length(x)
    %colsym = [colours(mod(floor(i/ls),lc)+1), syms(mod(i-1,ls)+1)];
    colsym = [colours(mod(floor(i/ls),lc)+1), '+'];
    plot3(x(i), y(i), z(i), colsym);
end
hold off;
end

%-----------------------------------------------------------------------

function different_points2(x, y)
% Display a lot of points in different colours

% Vectors for colour/symbol combinations to distinguish matches
colours = ['y';'r';'c';'m';'g';'b'];
%syms = ['o';'x';'s';'+';'d';'*';'v';'p'];  % just do colours
lc = length(colours);
%ls = length(syms);
ls = ceil(length(x)/lc);

hold on;
for i=1:length(x)
    %colsym = [colours(mod(floor(i/ls),lc)+1), syms(mod(i-1,ls)+1)];
    colsym = [colours(mod(floor(i/ls),lc)+1), '+'];
    plot(x(i), y(i), colsym);
end
hold off;
end
