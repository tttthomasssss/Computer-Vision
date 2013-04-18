classdef QuadtreeFactory<handle
    %QUADTREEFACTORY Summary of this class goes here
    %   Detailed explanation goes here
    
    methods (Access = public)
        function obj = QuadtreeFactory()
        end;
    
        function quadtree_data_list = init_quadtrees(obj, bb_matrix, img)
            
            quadtree_data_list = cell(length(bb_matrix), 1);
            size_img = size(img);
            
            % Make sure boxes are sized as a power of 2
            for i = 1:length(bb_matrix)
                temp = get_next_power_of_2(bb_matrix(i, 3));
                bb_matrix(i, 3) = ternary_conditional(bb_matrix(i, 1) + temp > size_img(1, 2), temp / 2, temp);
                temp  = get_next_power_of_2(bb_matrix(i, 4));
                bb_matrix(i, 4) = ternary_conditional(bb_matrix(i, 2) + temp > size_img(1, 1), temp / 2, temp);
            end;
            
            for i = 1:length(bb_matrix)
                slice = img(bb_matrix(i, 2):bb_matrix(i, 2) + bb_matrix(i, 4) - 1, bb_matrix(i, 1):bb_matrix(i, 1) + bb_matrix(i, 3) - 1);
                qt = qtdecomp(slice, 0.27);
    
                blocks = repmat(uint8(0), size(qt));

                for dim = [1024 512 256 128 64 32 16 8 4 2 1];
                    numblocks = length(find(qt==dim));
    
                    if (numblocks > 0)
                        values = repmat(uint8(1), [dim dim numblocks]);
                        values(2:dim, 2:dim, :) = 0;
                        blocks = qtsetblk(blocks, qt, dim, values);
                    end;
                end;

                blocks(end, 1:end) = 1;
                blocks(1:end, end) = 1;
                
                data = QuadCorrData(blocks, bb_matrix(i, :));
                
                quadtree_data_list{i, 1} = data;
            end;
        end;
    end;    
end

