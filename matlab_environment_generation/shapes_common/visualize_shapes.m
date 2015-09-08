function visualize_shapes( shape_array )
%VISUALIZE_SHAPES Summary of this function goes here
%   Detailed explanation goes here

hold on;
for shape = shape_array
    switch shape.name
        case 'rectangle'
            rectangle('Position',shape.data,'FaceColor','r');
        case 'circle'
            rectangle('Position', [shape.data(1:2) shape.data(3) shape.data(3)] ,'FaceColor','r', 'Curvature',[1,1]);
        otherwise
            disp('invalid shape!!!');
    end
end

end

