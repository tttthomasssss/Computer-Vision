function im = teachimage(name, varargin)
%TEACHIMAGE Read an image from the local vision collection
%   There is a collection of miscellaneous individual images used for
%   demonstrations and exercises, and also some sets of images for specific
%   purposes.
%
%   LIST = TEACHIMAGE returns a list (a cell array of strings) of the names
%   of the miscellaneous images available.
%
%   IMAGE = TEACHIMAGE(FILENAME) reads an image from the vision teaching
%   directory and converts it to a grey-level image in the range 0 to 1.
%   FILENAME must be one of the names returned when TEACHIMAGE is called
%   with no arguments, including the extension.
%
%   LIST = TEACHIMAGE('classes') returns a list (a cell array of strings)
%   of the names of the classes of image available.
%
%   N = TEACHIMAGE(CLASSNAME) returns the number of images in the class
%   given. CLASSNAME must be one of the names returned by
%   TEACHIMAGE('classes').
%
%   IMAGE = TEACHIMAGE(CLASSNAME, K) returns one or more images of the
%   class specified by CLASSNAME, which must be one of the names returned
%   by TEACHIMAGE('classes'). If K is a scalar, the K'th image is returned.
%   If K is a vector, each of the images specified by the elements of K is
%   returned in a cell array. In this case IMAGE{J} is the K(J)'th image in
%   the class. Images returned have grey-levels in the range 0 to 1. 
%
%   Image classes
%
%   'car', 'cat', 'person', 'building' are from the LabelMe database, at
%   http://labelme.csail.mit.edu/ The car and cat images are very small and
%   vary in size; the person and building images are larger and all the
%   same size.
%
%   'mrhead' has slices from an arbitrarily chosen MR brain scan from the
%   Oasis database, at http://www.oasis-brains.org/
%
%   'mrchest' has an arbitrarily chosen MR chest scan sequence from the
%   IOWA MRRF database at https://mri.radiology.uiowa.edu/trio_cardiac.html
%
%   'traffic' has images from a static camera over the A27 in
%   Shoreham-by-Sea. The frame rate is about 5 frames/second. The images
%   are quite small and grey-level quantisation is coarse.
%
%   DIR = TEACHIMAGE([]) returns the path of the images folder.
%
%   Assumes that images are in a folder called "images" which is in the
%   same folder as the vision library which contains this m-file.

classes = {'car' 'cat' 'person' 'building' 'mrhead' 'mrchest' 'traffic'};

fname = mfilename('fullpath');
path = fileparts(fileparts(fname));
d = fullfile(path, 'images');
if ~exist(d)
    error('Data directory not found on this machine');
end

if nargin < 1
% return list of images    
    im = dir(d);
    im = {im.name}';
    ok = false(size(im));
    for i = 1:length(im)
        name = im{i};
        ok(i) = ~ismember(name, {'.' '..' 'Thumbs.db'}) && ismember('.', name);
    end
    im = im(ok);
    
elseif isempty(name)  % directory requested    
    im = d;
    
elseif isequal(name, 'classes')
    im = classes';
    
elseif ismember(name, classes)
    switch name
        case {'building', 'person'}
            im = classims(d, 'peoplebuildings', name, varargin{:});
            
        case {'car', 'cat'}
            im = classims(d, 'carscats', name, varargin{:});
            
        case 'mrhead'
            im = mrhead(d, varargin{:});
            
        case 'mrchest'
            im = mrchest(d, varargin{:});
            
        case 'traffic'
            im = traffic(d, varargin{:});
    end
    
else % return image requested
    im = readimage(fullfile(d, name));
    
end
end

function im = readimage(filename)
[k,map] = imread(filename);
if isempty(map) && ndims(k) == 3
    im = rgb2gray(k);
else
    im = ind2gray(k,map);
end
% Should really check class of result to scale properly, but 8 bits is
% right for all the images in the collection at the time of writing
im = double(im)/256;
end

function im = classims(d, classdir, typ, n)
dirname = fullfile(d, classdir);
if nargin < 4
    im = countfiles(dirname, ['^' typ '\d{3}\.jpg$']);
elseif isscalar(n)
    filename = fullfile(dirname, [typ num2str(n, '%03d') '.jpg']);
    im = readimage(filename);
else
    im = cell(size(n));
    k = 0;
    for i = n
        filename = fullfile(dirname, [typ num2str(i, '%03d') '.jpg']);
        k = k+1;
        im{k} = readimage(filename);
    end
end
end

function n = countfiles(d, pattern)
% Counts the number of files in directory d whose names match the pattern
files = dir(d);
files = {files.name};
n = 0;
for i = 1:length(files)
    if ~isempty(regexpi(files{i}, pattern))
        n = n + 1;
    end
end
end

function im = mrhead(d, n)
%MRHEAD reads an MR scan image

persistent allims;

if isempty(allims)
    mrfile = fullfile(d, 'mrscans', ...
        'OAS1_0001_MR1_11_24_2009_6_23_57', ...
        'OAS1_0001_MR1', ...
        'RAW', ...
        'OAS1_0001_MR1_mpr-1_anon');
    info = analyze75info(mrfile);
    allims = analyze75read(info);
    allims = double(flipdim(allims, 1))/double(info.GlobalMax);
end

if nargin < 2
    im = size(allims,3);
elseif isscalar(n)
    im = allims(:,:,n);
else
    im = cell(size(n));
    k = 0;
    for i = n
        k = k + 1;
        im{k} = allims(:,:,i);
    end       
end

end

function im = mrchest(d, n)

persistent allims;

if isempty(allims)
    mrfile = fullfile(d, 'mrscans', ...
        'Iowa_MRRF', ...
        'tf2d14_retro_iPAT_2CH.gif');
    allims = double(imread(mrfile, 'Frames', 'all'))/256;
end

if nargin < 2
    im = size(allims,4);
elseif isscalar(n)
    im = allims(:,:,1,n);
else
    im = cell(size(n));
    k = 0;
    for i = n
        k = k + 1;
        im{k} = allims(:,:,1,i);
    end       
end

end

function y = traffic(d, n)

d = fullfile(d, 'trafficdata', 'shoreham_bmp');

xsize = 6:177;   % for cropping to remove black border
ysize = 6:137;

if nargin < 2
    y = countfiles(d, '^sh\d{3}\.bmp$');
else
    if ~isscalar(n)
        y = cell(size(n));
    end
    j = 0;
    for i = n
        [im, map] = imread(fullfile(d, ['sh' num2str(i, '%03i') '.bmp']));
        im = ind2gray(im, map);   % Convert from indices to grey levels
        im = double(im(ysize, xsize))/256;   % Crop and scale
        if isscalar(n)
            y = im;
        else
            j = j + 1;
            y{j} = im;
        end
    end
end

end
