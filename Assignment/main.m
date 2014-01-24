%	The MIT License (MIT)
%
% 	Copyright (c) 2013-2014 Thomas Kober
%
clear; close all;

df = DataFactory();

c = correspondences(df.img_left_bw, df.img_right_bw);

stereo_display(df.img_left_bw, df.img_right_bw, c);
