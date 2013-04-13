close all;

df = DataFactory();

img_slice_1 = df.img_left_bw(1:512, 1:512);
img_slice_2 = df.img_left_bw(1:512, 513:end);
img_slice_3 = df.img_left_bw(end - 512 + 1:end, 1:512);
img_slice_4 = df.img_left_bw(end - 512 + 1:end, 513:end);

figure; imshow(img_slice_1);
figure; imshow(img_slice_2);
figure; imshow(img_slice_3);
figure; imshow(img_slice_4);

qt = qtdecomp(img_slice_1, 0.27);

blocks = repmat(uint8(0), size(qt));

for dim = [512 256 128 64 32 16 8 4 2 1];
    numblocks = length(find(qt==dim));
    
    if (numblocks > 0)
        values = repmat(uint8(1), [dim dim numblocks]);
        values(2:dim, 2:dim, :) = 0;
        blocks = qtsetblk(blocks, qt, dim, values);
    end;
end;

blocks(end, 1:end) = 1;
blocks(1:end, end) = 1;

figure; imshow(blocks, []);