function shape = get_rectangle_shape(x,y,w,h)

shape = get_blank_shape();
shape.name = 'rectangle';
shape.data = [x y w h];

end

