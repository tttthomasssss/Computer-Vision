function y = read_traffic_images(n)
%READ_TRAFFIC_IMAGES reads some images from the Shoreham traffic sequence
%     Y = READ_TRAFFIC_IMAGES(N) returns a cell array containing the images whose numbers are
%     specified by the matrix N. These images were obtained from a static camera over the A27 in
%     Shoreham-by-Sea. The frame rate is about 5 frames/second. Elements of N should be in the range
%     1 to 700. Each image is cropped to remove a digitisation artefact, and the grey levels lie
%     roughly in the range 0 to 1. The images are quite small, grey level only, and quantisation is fairly
%     coarse.
%
%     Assumes that images are in a folder called "images" which is in the
%     same folder as the vision library which contains this m-file.
%
% superseded

warning('READ_TRAFFIC_IMAGES:obsolete', 'read_traffic_images superseded by teachimage');
y = teachimage('traffic', n);

end
