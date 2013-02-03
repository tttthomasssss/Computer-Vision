function [newxs, newys] = snake_adjust(xs, ys, xf, yf, alpha, beta, gamma)
%SNAKE_ADJUST  Make one set of adjustments to snake's control points
%   [NEWXS, NEWYS] = SNAKE_ADJUST(XS, YS, XF, YF, ALPHA, BETA, GAMMA)
%   takes vectors of x- and y-coords, XS and YS, and returns updated
%   vectors having made adjustments based on internal elastic forces and
%   image forces. 
%
%   The elastic force moves each point towards the mid-point of its
%   neighbours; the distance moved is ALPHA times the distance to
%   the mid-point.
%
%   The smoothing force moves each point towards a curve through its
%   neighbours; the distance moved is determined by BETA. If BETA is
%   omitted it is assumed to be zero.
%
%   The external force moves a point at (XI, YI) a distance along the
%   x-axis of GAMMA*XF(XI,YI) and along the y-axis of GAMMA*YF(XI,YI).
%   XF and YF are 2-D structures holding (typically) the x- and
%   y-gradients of the image. If no external force is required, xf and
%   yf should be empty matrices, or gamma can be 0
%
%   See also SNAKE_DEMO

if nargin < 7; gamma = beta; beta = 0; end
newxs = xs + adjst(xs, xs, ys, xf, alpha, beta, gamma);   % do x-coords
newys = ys + adjst(ys, xs, ys, yf, alpha, beta, gamma);   % and y-coords
end


function adj = adjst(as, xs, ys, af, alpha, beta, gamma)
% Function to do either the x or the y adjustments.

% Shifted vectors
ad = [as(end); as(1:end-1)];            % shifted one place down
au = [as(2:end); as(1)];                % shifted one place up
if beta ~= 0
    add = [ad(end); ad(1:end-1)];            % shifted two places down
    auu = [au(2:end); au(1)];                % shifted two places up
end

% The elastic adjustment is calculated using the shifted vectors to
% compute a function of each coord and its nearest neighbours.
am = (ad + au)/2;
adj = alpha * (am - as);

% Smoothing adjustment
if beta ~= 0
    adj = adj + beta * ((4/3)*am - as - (1/6)*(add+auu));
end

if ~isempty(af) && gamma ~= 0
    % Next line converts the snake coords to linear indices into the
    % image force array.
    indices = sub2ind(size(af), round(ys), round(xs));
    
    % The image force adjustment is applied simply
    adj = adj + gamma * af(indices);
end
end
