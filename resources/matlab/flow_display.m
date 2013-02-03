function flow_display(im1, im2, corresps)
%FLOW_DISPLAY  Display results from feature matcher.
%    FLOW_DISPLAY(IM1, IM2, CORRESPS) produces a simple display in
%    figure 1 of the results of correspondence matching on the two
%    images IM1 and IM2. CORRESPS is expected to be a matrix with one
%    column per match, the column containing the match coordinates in the
%    original images in the order [left row; left col; right row; right
%    col]. IM1 is taken to be the left image.
%    The top two figures show the points that are supposed to correspond
%    using a variety of colours and symbols to allow the matches to be
%    seen.
%    The bottom figure shows the flow vectors as lines, with a circle at
%    the starting point of each.

getwin;

s = size(im1);
axset = [1 s(2) 1 s(1)];

% Plot first image and feature positions
subplot(2,2,1);
imshow(im1);
hold on;
different_points(corresps(2,:), corresps(1,:));
hold off;

% same for other image
subplot(2,2,2);
imshow(im2);
hold on;
different_points(corresps(4,:), corresps(3,:));
hold off;

% Now show the flow vectors
subplot(2,2,3);
hold on;
axis(axset);
axis ij
disp_vecs(corresps);
hold off;

%-----------------------------------------------------------------------

function getwin
% Get a window for display, or set it up
h = findobj(allchild(0), 'tag', 'Flow Display');

if ~isempty(h)
    figure(h(1));
else
    figure( ...
        'Name','Flow Display', ...
        'tag', 'Flow Display', ...
        'NumberTitle', 'off', ...
        'Position', [200 100 800 600]);
end
clf;            % Clear the figure

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

%-----------------------------------------------------------------------

function disp_vecs(corrs)
% Display disparity vectors using a variety of colours

colours = ['y';'m';'c';'r';'g';'b'];
lc = length(colours);
[nr, nmatches] = size(corrs); %#ok<ASGLU>

for i=1:nmatches
    col = colours(mod(i-1,lc)+1);
    plot(corrs(2,i), corrs(1,i), [col, 'o']);
    plot([corrs(2,i); corrs(4,i)], [corrs(1,i); corrs(3,i)], [col, '-']);
end

