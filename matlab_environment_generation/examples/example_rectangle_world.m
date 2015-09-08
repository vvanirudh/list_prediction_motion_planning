%% This is to create an analytic set of piolygons (NOT MAP)

clc;
clear;
close all;

% %% Create analytic world
bbox = [0 1 0 1];
figure;
axis(bbox);
axis equal;
grid on;
count = 1;
while(1)
    title('Drag rect');
    final_rect = getrect(gca);
    rectangle('Position',final_rect,'FaceColor','r');
    shapes_array(count) = get_rectangle_shape(final_rect(1), final_rect(2), final_rect(3), final_rect(4));
    count = count + 1;
    title('Left click to continue, right click to stop');
    [~,~,button] = ginput(1);
    if (button == 3)
        break;
    end
end
