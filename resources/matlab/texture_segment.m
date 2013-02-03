function t = texture_segment(im, k, varargin)
%TEXTURE segments an image on the basis of Laws texture measures
%   S = TEXTURE_SEGMENT(IM, K) segments an image into K texture classes
%   using Laws' 5x5 texture masks and k-means clustering on the texture
%   energy vectors.
%
%   S = TEXTURE_SEGMENT(IM, K, MASKSTRING, INCLUDEMASK1, SMOOTHSIZE) allows
%   arguments to be passed to TEXTURE_VECTORS. See TEXTURE_VECTORS for
%   details of these parameters. Not all the parameters need be given, as
%   for TEXTURE_VECTORS.
%
%   See also TEXTURE_DEMO, TEXTURE_VECTORS

% David Young, School of Informatics, University of Sussex, 2009


v = texture_vectors(im, varargin{:});
v = (reshape(v, numel(im), size(v,3)))';  % Make it 2-D

% Use k-means clustering to group similar vectors together
t = k_means(v, k);
t = reshape(t, size(im));

end
