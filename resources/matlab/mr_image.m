function im = mr_image(varargin)
%MR_IMAGE reads an MR scan image
%   IM = MR_IMAGE(N) returns slice N from a particular (arbitrarily chosen)
%   scan from the Oasis database, at http://www.oasis-brains.org/
%   The result is a 2-D grey-level array.
%
%   N = MR_IMAGE returns the number of slices available.
%
% Superseded

warning('MR_IMAGE:obsolete', 'mr_image is superseded by teachimage');
im = teachimage('mrhead', varargin{:});

end
