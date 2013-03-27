%{
    Approach:
    Generate Histogram of Gray Scale Image and extract local peaks
    Use these local peaks as gray levels for thresholding
    Extract features based on that

    Result:
    Does not work very well at all :(
    
%}
close all;

min_peak_dist = 2;

df = DataFactory();

h = imhist(df.img_left_bw);

peaks = df.find_vector_peaks(h, min_peak_dist);

for i = 1:length(peaks)
    min_gray_level = (1 / length(h)) * (peaks(i) - min_peak_dist);
    max_gray_level = (1 / length(h)) * (peaks(i) + min_peak_dist);
    
    % Dilate before thresholding
    dil_img = df.dilate_grayscale_img(df.img_left_bw, 3, 'square', 2);
    
    thresh_img = thresholding(dil_img, min_gray_level, max_gray_level);
    figure(i);
    
    imshow(thresh_img);
    
end;