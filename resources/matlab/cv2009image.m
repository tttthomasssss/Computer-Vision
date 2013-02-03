function im = cv2009image(typ, n)
%CV2009IMAGE reads an image for the 2009 computer vision assignment
%   IM = CV2009IMAGE(TYPE, N) returns a grey-level image IM. TYPE is the
%   string 'person' or 'building' (or 'p' or 'b') and N is a small integer
%   specifying the image to read. TYPE can also be 0 or 1, specifying
%   person or building respectively.
%
% Superseded by TEACHIMAGE

warning('CV2009IMAGE:obsolete', 'cv2009image is now superseded by teachimage');

if isequal(typ, 'p') || isequal(typ, 0) 
    typ = 'person';
elseif isequal(typ, 'b') || isequal(typ, 1) 
    typ = 'building';
end
if ~(isequal(typ, 'building') || isequal(typ, 'person'))
    error('Incorrect type of image requested');
end
im = teachimage(typ, n);

end
