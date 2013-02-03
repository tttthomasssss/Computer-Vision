function stereo_display(im1, im2, corresps)
%STEREO_DISPLAY  Display results from stereo matcher.
%    STEREO_DISPLAY(IM1, IM2, CORRESPS) produces a simple display in
%    figure 1 of the results of correspondence matching on the two
%    images IM1 and IM2. CORRESPS is expected to be a matrix with one
%    column per match, the column containing the match coordinates in the
%    original images in the order [left row; left col; right row; right
%    col]. IM1 is taken to be the left image.
%    The top two figures show the points that are supposed to correspond
%    using a variety of colours and symbols to allow the matches to be
%    seen.
%    The bottom two figures show the disparity vectors as lines. The
%    bottom left figure shows those that are 'good' according to a
%    rough-and-ready criterion that happens to correspond to the
%    geometry of the scene; the bottom right figure shows the others.
%    The criterion used is specific to the images for the mantelpiece images used
%    for the vision assignment, Autumn 2010.
%
%    In addition DISPLAY_DEPTH is called to give a display of the 3D layout
%    of the points.

getwin;

s = size(im1);
axset = [1 s(2) 1 s(1)];

g = good_corrs(corresps);

% Show the 'good' disparity vectors

% Plot first image and feature positions
subplot(2,2,1);
imshow(im1);
hold on;
different_points(corresps(2,g), corresps(1,g));
hold off;
% second image and feature locations
subplot(2,2,2);
imshow(im2);
hold on;
different_points(corresps(4,g), corresps(3,g));
hold off;
% vectors
subplot(2,2,3);
hold on;
axis(axset);
axis ij
disp_vecs(corresps(:, g));
hold off;

% Show the bad disparity vectors

% feature positions
subplot(2,2,1);
hold on;
different_points(corresps(2,~g), corresps(1,~g));
hold off;
subplot(2,2,2);
hold on;
different_points(corresps(4,~g), corresps(3,~g));
hold off;
% vectors
subplot(2,2,4);
hold on;
axis(axset);
axis ij
disp_vecs(corresps(:, ~g));
hold off;

% Show the depth dispaly in a separate window
depth_display(im1, corresps);

end

%-----------------------------------------------------------------------

function getwin
% Get a window for display, or set it up
h = findobj(allchild(0), 'tag', 'Stereo Display');

if ~isempty(h)
    figure(h(1));
else
    figure( ...
        'Name','Stereo Display', ...
        'tag', 'Stereo Display', ...
        'NumberTitle', 'off', ...
        'Position', [200 100 800 600]);
end
clf;            % Clear the figure
end

%-----------------------------------------------------------------------

function different_points(x, y)
% Display a lot of points in different colour/symbol combinations

% Vectors for colour/symbol combinations to distinguish matches
colours = ['y';'m';'c';'r';'g';'b'];
syms = ['o';'x';'s';'+';'d';'*';'v';'p'];
lc = length(colours);
ls = length(syms);

for i=1:length(x)
    colsym = [colours(mod(i-1,lc)+1), syms(mod(i-1,ls)+1)];
    plot(x(i), y(i), colsym);
end
end

%-----------------------------------------------------------------------

function disp_vecs(corrs)
% Display disparity vectors using a variety of colours

colours = ['y';'m';'c';'r';'g';'b'];
lc = length(colours);
[nr, nmatches] = size(corrs);

for i=1:nmatches
    colsym = [colours(mod(i-1,lc)+1), '-'];
    plot([corrs(2,i); corrs(4,i)], [corrs(1,i); corrs(3,i)], colsym);
end
end

%----------------------------------------------------------------------

function g = good_corrs(corrs)
% Select disparity vectors that are reasonable. (Rough and ready, and
% very arbitrary - specific to the mantelpiece images).
rowl = corrs(1,:);
coll = corrs(2,:);
rowr = corrs(3,:);
colr = corrs(4,:);
x = (coll+colr)/2;
y = (rowl+rowr)/2;
xdisp = (coll-colr);
ydisp = (rowl-rowr);

% This is for the maze images
% g = abs(ydisp) < 8 & xdisp >= y/7 & xdisp <= y/5+20;

% This is for the mantelpiece images
g = abs(ydisp) < 20 & abs(xdisp - 0.063*x - 15) < 20;
end