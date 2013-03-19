% Assignment Trial Stuff

% Read Image from File & Carry out morphological operations and edge
% detection
img_left_bw = teachimage('assignment/img_left_gray.bmp');

edges_img_left_bw = edge(img_left_bw, 'canny');

%imshow(img_left_bw);

dilation_img_left_bw = bwmorph(edges_img_left_bw, 'dilate');
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
[rho_idx theta_idx] = find(H >= (max_val .* 0.7));

% Normalise the values of theta 5 rho, returned indices are from 0 - 2x max
% so subtract min from returned index
rho_idx = rho_idx - abs(min_rho);
theta_idx = theta_idx - abs(min_theta);
plot(theta_idx, rho_idx, 'g*');

for i = [theta_idx'; rho_idx']
    curr_theta = deg2rad(t(i(1) + abs(min_theta)) + 90);
    curr_rho = r(i(2) + abs(min_rho));
    
    % TODO: Now draw line with current values of rho and theta!!!
    
    %fprintf('i1: %d; i2: %d\n', i(1), i(2));
    fprintf('curr rho: %f\n', curr_rho);
    fprintf('curr theta: %f\n', curr_theta);
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