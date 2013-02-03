function im = mr_chest(varargin)
%MR_CHEST reads an MR chest scan image from a sequence
%   IM = MR_CHEST(N) returns image N from a particular (arbitrarily chosen)
%   sequence from the IOWA MRRF database at
%   https://mri.radiology.uiowa.edu/trio_cardiac.html
%   The result is a 2-D grey-level array.
%
%   N = MR_CHEST returns the number of slices available.
%
% superseded

warning('MR_CHEST:obsolete', 'mr_chest has been superseded by teachimage');
im = teachimage('mrchest', varargin{:});

end
