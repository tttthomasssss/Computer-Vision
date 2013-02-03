function snake_show(xs, ys)
%SNAKE_SHOW  Display a snake
%   SNAKE_SHOW(XS,YS) plots the snake as green circles joined by a line.

hold on;
plot([xs; xs(1)], [ys; ys(1)], 'go-');
hold off;

end
