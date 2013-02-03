function im = cv2007image(typ, n)
%CV2007IMAGE reads an image for the 2007 computer vision assignment
%   IM = CV2007IMAGE(TYPE, N) returns a grey-level image IM. TYPE is the
%   string 'cat' or 'car' and N is a small integer specifying the image to
%   read. TYPE can also be 0 or 1, specifying car or cat.
%
% Superseded by TEACHIMAGE

warning('CV2007IMAGE:obsolete', 'cv2007image is now superseded by teachimage');

if typ == 0
    typ = 'car';
elseif typ == 1
    typ = 'cat';
end
if ~(isequal(typ, 'cat') || isequal(typ, 'car'))
    error('Incorrect type of image requested');
end
im = teachimage(fullfile('carscats', [typ num2str(n, '%03d') '.jpg']));
