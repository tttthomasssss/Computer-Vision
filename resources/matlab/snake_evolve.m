function [xs, ys] = snake_evolve(xs, ys, xf, yf, alpha, gamma, image, N)
%SNAKE_EVOLVE   Repeatedly adjust a snake and display results
%   [XS, YS] = SNAKE_EVOLVE(XS, YS, XF, YF, ALPHA, GAMMA, IMAGE, N)
%   repeatedly calls SNAKE_ADJUST and displays the snake after each
%   iteration. Arguments and results are as for SNAKE_ADJUST, with the
%   addition of IMAGE on top of which the snake is drawn, and N, the number
%   of iterations to perform.
%
%   See also SNAKE_DEMO

hold off;
imshow(image, []);
hold on;
snake_show(xs, ys);
for i=1:N;
    [xs, ys] = snake_adjust(xs, ys, xf, yf, alpha, gamma);
    snake_show(xs, ys);
end;
hold off;
end
