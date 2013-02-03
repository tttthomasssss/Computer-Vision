%% Demo of Inverse Perspective Mapping
%
% David Young
%
%% Read in some of the traffic sequence and get one image from it
% This assumes that the Sussex vision library is in your Matlab path.

ims = teachimage('traffic', 151:350);
im = ims{1};
imshow(im);

%% Image coordinates
% Set up the coordinates of some points that lie on lines converging to the
% vanishing point. 

% Vanishing point coordinates - could use HT and line intersection to get
% this
yvp = 7;
xvp = 91;

xhsize = size(im, 2)/3;

y1 = size(im, 1);   % choose y coords for display region
x11 = xvp-xhsize;
x12 = xvp+xhsize;

y2 = 30;
x21 = xvp - xhsize*(y2-yvp)/(y1-yvp);
x22 = xvp + xhsize*(y2-yvp)/(y1-yvp);

pin = [x11 x12 x21 x22; y1 y1 y2 y2];    %

hold on; plot(pin(1,:), pin(2,:), 'g+'); hold off

%% Ground coordinates
% Set up the coordinates of some points on the ground. This is somewhat
% arbitrary, but we assume that the sides of the road are (almost)
% parallel. (Making them exactly parallel causes a numerical problem.)
%
% We can only compute ground coordinates up to a scale factor unless we
% have some additional information.

Y1 = 200;   % coordinate on ground corresponding to y1
X11 = 50;
X12 = 140;

Y2 = 0;     % coordinate on ground corresponding to y2
X21 = 70;
X22 = 120;

pout = [X11 X12 X21 X22; Y1 Y1 Y2 Y2];

figure; plot(pout(1,:), pout(2,:), 'g+'); axis equal

%% Compute homography    
% Find the transformation that maps from image coordinates to road
% coordinates, using the coordinates above

v = homography_solve(pin, pout);
tform = maketform('projective', v');

%% Display the test image

imt = imtransform(im(y2:y1, :), tform);
imshow(imt);

%% Animate the sequence

% Images of vehicles appear distorted, because they do not lie in the
% ground plane.

for i = 1:length(ims)
    imshow(imtransform(ims{i}(30:132, :), tform));
    drawnow;
end

%% Experimenting
% You can download this document and then extract the original M-file with
% Matlab's |grabcode| function. You can then edit it for experimentation.
% (Functions from the Sussex vision library are only available to Sussex
% students and staff.)
%
% Copyright University of Sussex, 2009.


