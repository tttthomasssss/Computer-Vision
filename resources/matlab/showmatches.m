function [f1, f2, f3] = showmatches(im1, im2, corresps, f1, f2, f3)
%SHOWMATCHES  Display results from matcher.
%    SHOWMATCHES(IM1, IM2, CORRESPS) produces a display of the results of
%    correspondence matching on the two images IM1 and IM2. CORRESPS is
%    expected to be a matrix with one column per match, the column
%    containing the match coordinates in the original images in the order
%    [left row; left col; right row; right col]. IM1 is taken to be the
%    left image.
%
%    Three figures are produced. Two of them display the original images
%    with feature positions superimposed, with corresponding points given
%    corresponding symbols of different shapes and colours. The third shows
%    the match vectors as lines.
%
%    SHOWMATCHES(IM1, IM2, CORRESPS, F1, F2, F3) uses the figures whose
%    handles are given in the final three arguments.
%
%    [F1, F2, F3] = SHOWMATCHES(...) returns the handles of the figures
%    used.

if nargin < 4
    f1 = figure;
    f2 = figure;
    f3 = figure;
else
    f1 = figure(f1);
    f2 = figure(f2);
    f3 = figure(f3);
end

s = size(im1);
axset = [1 s(2) 1 s(1)];

% Plot first image and feature positions
figure(f1);
imshow(im1); title('Image 1');
hold on;
different_points(corresps(2,:), corresps(1,:));
hold off;
% second image and feature locations
figure(f2);
imshow(im2); title('Image 2');
hold on;
different_points(corresps(4,:), corresps(3,:));
hold off;
% vectors
figure(f3);
hold on;
axis(axset);
disp_vecs(corresps); title('Match offset vectors');
axis ij
axis equal
hold off;

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


