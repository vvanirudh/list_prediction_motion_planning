function [ in_collision, min_distance, grad ] = shapes_point_check( point, shape_array )
%SHAPES_POINT_CHECK Summary of this function goes here
%   Detailed explanation goes here

in_collision = 0;
min_distance = Inf;
grad = zeros(size(point));
for shape = shape_array
    switch shape.name
       case 'rectangle'
           poly_x = [shape.data(1) shape.data(1)+shape.data(3) shape.data(1)+shape.data(3) shape.data(1)];
           poly_y = [shape.data(2) shape.data(2) shape.data(2)+shape.data(4) shape.data(2)+shape.data(4)];
           [dis, x_poly,y_poly] = p_poly_dist(point(1), point(2), poly_x, poly_y);
           if (dis < min_distance)
               min_distance = dis;
               grad(1) = sign(dis)*(point(1) - x_poly)/max(eps, abs(dis));
               grad(2) = sign(dis)*(point(2) - y_poly)/max(eps, abs(dis));
           end
           if (dis < 0)
               in_collision = 1;
           end
       case 'circle'
           dis = sqrt((point(1) - shape.data(1))^2 + (point(2) - shape.data(2))^2) - shape.data(3);
           if (dis < min_distance)
               min_distance = dis;
               grad(1) = sign(dis)*(point(1) - shape.data(1))/max(eps, abs(dis));
               grad(2) = sign(dis)*(point(2) - shape.data(2))/max(eps, abs(dis));
           end
           if (dis < 0)
               in_collision = 1;
           end
       otherwise
        disp('invalid shape!!!');
    end
end


end

