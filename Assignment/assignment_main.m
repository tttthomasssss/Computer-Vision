% Assignment Trial Stuff

% Read Image from File & Carry out morphological operations and edge
% detection
img_left_bw = teachimage('assignment/img_left_gray.bmp');
img_left_col = teachimage('assignment/img_left_colour.tif');

edges_img_left_bw = edge(img_left_bw, 'canny');

%imhist(edges_img_left_bw);

dilation_img_left_bw = bwmorph(edges_img_left_bw, 'dilate');
[dil_img_left_bw_height dil_img_left_bw_width] = size(dilation_img_left_bw);

%dil_2_img_left_bw = bwmorph(dilation_img_left_bw, 'dilate');

%rem_img_left_bw = bwmorph(dilation_img_left_bw, 'remove');
%rem_2_img_left_bw = bwmorph(dil_2_img_left_bw, 'remove');

figure(1);
imshow(dilation_img_left_bw);
%figure(3);
%imshow(dil_2_img_left_bw);

%figure(4);
%imshow(rem_img_left_bw);
%figure(5)
%imshow(rem_2_img_left_bw);

% Perform Hough transform
figure(2);
[H, t, r] = hough(dilation_img_left_bw);
imshow(imadjust(mat2gray(H)), 'XData', t, 'YData', r, 'InitialMagnification', 'fit');
%imshow(H, 'XData', t, 'YData', r, 'InitialMagnification', 'fit');
axis on, axis normal;
xlabel('\theta'), ylabel('\rho')
hold on;

% Apply manual threshold to whole array, ind2sub is messing things up
max_val = max(H(:));
min_theta = min(t(:));
min_rho = min(r(:));
%[y x] = ind2sub(size(H), find(H <= (max_val .* 0.65)));
[rho_idx theta_idx] = find(H >= (max_val .* 0.65));
%[rho_idx theta_idx] = find(H == max_val);

% Normalise the values of theta 5 rho, returned indices are from 0 - 2x max
% so subtract min from returned index
rho_idx_norm = rho_idx - abs(min_rho);
theta_idx_norm = theta_idx - abs(min_theta);
plot(theta_idx_norm, rho_idx_norm, 'g*');

% Accumulate Hough Lines in this Array
hough_lines = zeros(dil_img_left_bw_height, dil_img_left_bw_width);

% Line equation: rho = x*cos(theta) + y*sin(theta)
figure(1);
hold on;
for i = [theta_idx'; rho_idx']
    %curr_theta = t(i(1) + abs(min_theta)) + 90;
    %curr_rho = r(i(2) + abs(min_rho));
    
    curr_theta = t(i(1)) + 90;% + abs(min_theta);
    curr_rho = r(i(2))%; + abs(min_rho);
    
    % http://undergraduate.csse.uwa.edu.au/units/CITS4240/Labs/Lab6/lab6.html
    
    % Discriminate purely vertical lines from other lines
    if cosd(curr_theta) == 0
        y1 = 0;
        y2 = dil_img_left_bw_height;
        x1 = curr_rho ./ sind(curr_theta);
        x2 = (curr_rho + y2 * cosd(curr_theta)) ./ sind(curr_theta);
    else
        x1 = 0;
        x2 = dil_img_left_bw_width;
        y1 = -curr_rho ./ cosd(curr_theta);
        y2 = (x2 .* sind(curr_theta) - curr_rho) ./ cosd(curr_theta);
    end;    
    
   
    
    fprintf('RHO:[%f]; THETA:[%f]\n', curr_rho, curr_theta);
    fprintf('X1:[%d]; X2:[%d]\n', x1, x2);
    fprintf('Y1:[%d]; Y2:[%d]\n', y1, y2);
    
    
    line('XData', [x1 x2], 'YData', [y1 y2], 'Clipping', 'off', 'Color', 'r');
    
    %curr_theta = t(i(1) + abs(min_theta));
    %curr_rho = r(i(2) + abs(min_rho));
    
    %y = curr_rho * sind(curr_theta);
    %x = curr_rho * cosd(curr_theta);
    
    %plot(x, y, 'g*');
    
    % Draw line
    %y1 = 0;
    %x2 = 0;
    
    %figure(1);
    %line([hx x2], [y1 hy], 'Clipping', 'off', 'Color', 'r');
    
    % TODO: Now draw line with current values of rho and theta!!!
    
    %fprintf('i1: %d; i2: %d\n', i(1), i(2));
    %fprintf('curr rho: %f\n', curr_rho);
    %fprintf('curr theta: %f\n', curr_theta);
end;

%fprintf('MAX HOUGH: %f\n', max_val);
%fprintf('MIN HOUGH: %f\n', min(H(:)));
%H_thresh = H > max_val * .75;
%figure(3);
%imshow(imadjust(mat2gray(H)), 'XData', t, 'YData', r, 'InitialMagnification', 'fit');

%theta_val = t(y);
%rho_val = r(x);

% Find peaks in Hough transform
[rows, cols, vals] = findpeaks(H);
%plot(cols, rows, 'g*');
threshold = 0.7 * max(vals);
bigpeakindex = vals > threshold;
bigpeakrows = rows(bigpeakindex);
bigpeakcols = cols(bigpeakindex);
%plot(bigpeakcols, bigpeakrows, 'g*');