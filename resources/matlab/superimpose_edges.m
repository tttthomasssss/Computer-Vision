function imout = superimpose_edges(im1, im2, varargin)
% Return a 3-valued image which superimposes the edges from im1 and im2
e1 = edge(im1, 'canny', varargin{:});
e2 = edge(im2, 'canny', varargin{:});
imout = min(2, e1 + 2*e2);
end
