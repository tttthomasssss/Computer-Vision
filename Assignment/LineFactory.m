classdef LineFactory<handle
    %LINEFACTORY Summary of this class goes here
    %   Detailed explanation goes here
    
    methods (Access = public)
        function obj = LineFactory()
        end;
        
        function lines = retrieve_hough_lines(obj, edge_map, threshold)
            if (nargin < 3)
                threshold = 0.5;
            end;
            
            % Hough Transform
            [H theta rho] = hough(edge_map, 'RhoResolution', 2);
            
            [rows cols vals] = find(H > max(H(:)) * threshold);
            
            % Find Hough Peaks
            peaks = houghpeaks(H, length(rows), 'threshold', threshold);
            
            % Fit Hough Lines
            lines = houghlines(edge_map, theta, rho, peaks);
        end;
        
        function img = recreate_scene_from_houghlines(obj, lines, edge_map)
           
            % Try to interpolate edge map
            size_img = size(edge_map);

            img = zeros(size_img);

            tolerance = 1;

            for k = 1:length(lines)
    
                p1 = lines(k).point1;
                p2 = lines(k).point2;
    
                img(p1(1, 2), p1(1, 1)) = img(p1(1, 2), p1(1, 1)) + 1;
                img(p2(1, 2), p2(1, 1)) = img(p2(1, 2), p2(1, 1)) + 1;
    
                h_span = abs(p2(1, 1) - p1(1, 1));
                v_span = abs(p2(1, 2) - p1(1, 2));
    
                % Differentiate horizontal & vertical lines simply by determining
                % whether the horizontal or vertrical difference is larger
                if (h_span > v_span)
        
                    v_step = v_span ./ h_span;
        
                    if (p1(1, 1) < p2(1, 1))
                        x = p1(1, 1);
                        actual_y = p1(1, 2);
                        y_gradient = ternary_conditional(p1(1, 2) <= p2(1, 2), 1, -1);
                    else
                        x = p2(1, 1);
                        actual_y = p2(1, 2);
                        y_gradient = ternary_conditional(p2(1, 2) <= p1(1, 2), 1, -1);
                    end;
        
                    y = actual_y;
        
                    % Redraw Hough line
                    while x < max(p1(1, 1), p2(1, 1))
            
                        % Apply a 2 Pixel tolerance
                        found_pixel = 0;
                        i = max(x - tolerance, 1);
                        while i <= min(x + tolerance, size_img(1, 2)) && found_pixel == 0
                            j = max(y - tolerance, 1);
                            while j <= min(y + tolerance, size_img(1, 1)) && found_pixel == 0
                                found_pixel = img(j, i) > 0;
                                j = j + 1;
                            end;
                            i = i + 1;
                        end;
            
                        if (found_pixel ~= 0)
                            img(y, x) = img(y, x) + 1;
                        end;
            
                        % Without tolerance
                        %if (edge_map(y, x) > 0)
                        %    img(y, x) = img(y, x) + 1;
                        %end;
            
                        x = x + 1;
                        actual_y = actual_y + (v_step .* y_gradient);
                        y = round(actual_y);
                    end;
                else
        
                    h_step = h_span ./ v_span;
        
                    if (p1(1, 2) < p2(1, 2))
                        y = p1(1, 2);
                        actual_x = p1(1, 1);
                        x_gradient = ternary_conditional(p1(1, 1) < p2(1, 1), 1, -1);
                    else
                        y = p2(1, 2);
                        actual_x = p2(1, 1);
                        x_gradient = ternary_conditional(p2(1, 1) < p1(1, 1), 1, -1);
                    end;
        
                    x = actual_x;
        
                    % Redraw Hough Line
                    while y < max(p1(1, 2), p2(1, 2))
            
                        % Apply a 2 Pixel tolerance
                        found_pixel = 0;
                        i = max(x - tolerance, 1);
                        while i <= min(x + tolerance, size_img(1, 2)) && found_pixel == 0
                            j = max(y - tolerance, 1);
                            while j <= min(y + tolerance, size_img(1, 1)) && found_pixel == 0
                                found_pixel = img(j, i) > 0;
                                j = j + 1;
                            end;
                            i = i + 1;
                        end;
            
                        if (found_pixel ~= 0)
                            img(y, x) = img(y, x) + 1;
                        end;
            
                        % Without tolerance
                        %if (edge_map(y, x) > 0)
                        %    img(y, x) = img(y, x) + 1;
                        %end;
            
                        y = y + 1;
                        actual_x = actual_x + (h_step .* x_gradient);
                        x = round(actual_x);
                    end;
                end;
            end;
        end;
    end;
end

