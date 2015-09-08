function write_grid_to_file( filename, D, Dx, Dy )
%WRITE_GRID_TO_FILE Summary of this function goes here
%   Detailed explanation goes here
fid = fopen(filename, 'w');
fprintf(fid, 'Dim: %f\n', 2);
fprintf(fid, 'Value:\n');
for x=1:size(D, 1)
    for y = 1: size(D,2)
        fprintf(fid, '%f ',D(x,y));
    end
    fprintf(fid, '\n ');
end
fprintf(fid, 'Gradient X:\n');
for x=1:size(Dx, 1)
    for y = 1: size(Dx, 2)
        fprintf(fid, '%f ',Dx(x, y));
    end
    fprintf(fid, '\n ');
end
fprintf(fid, 'Gradient Y:\n');
for x=1:size(Dy, 1)
    for y = 1: size(Dy, 2)
        fprintf(fid, '%f ',Dy(x, y));
    end
    fprintf(fid, '\n ');
end

end

