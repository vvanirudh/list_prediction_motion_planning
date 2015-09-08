function [Xpoints, Ypoints] = createcircle(varargin)
% CREATECIRCLE Create a circle with the mouse
%   [X, Y] = createcircle(N) lets you create a circle with N points 
%   in the current figure. Use the mouse to indicate the center and
%   adjust the radius. Press ENTER to confirm the shape and output 
%   the X and Y values. The N parameter is optional. Default 20.
%   N = 3 can be used to draw triangles, N = 4 to draw squares etc.
%   
%   Example:
%   imshow('westconcordaerial.png');
%   [X,Y] = createcircle(4);
%
%   J.A. Disselhorst.
%   Loosely based on GETRECT and GETLINE (c) The MathWorks, Inc 



    global CCaxes CCfig CCline1 NOP CCline2
    
    if (nargin == 0)
        NOP = 20 + 1;                       % Default number of points
    elseif isnumeric(varargin{1})
        NOP = round(varargin{1}+1);     % User selected number of points
    elseif ischar(varargin{1})
        feval(varargin{:});             % Subfunctions
        return;
    end

    % -Save state of figure, and adjust----------------------
    CCaxes = gca;
    CCfig = ancestor(CCaxes, 'figure');
    old_db = get(CCfig, 'DoubleBuffer');
    state = uisuspend(CCfig);
    original_modes = get(CCaxes, {'XLimMode', 'YLimMode', 'ZLimMode'});
    set(CCfig, 'Pointer', 'crosshair', ...
        'WindowButtonDownFcn', 'createcircle(''ButtonDown'');','DoubleBuffer','on');
    set(CCaxes,'XLimMode','manual', ...
               'YLimMode','manual', ...
               'ZLimMode','manual');
    figure(CCfig);
    
    % Line 1: guideline, Line 2: circle ------------------
    CCline1 = line('Parent', CCaxes, ...
                  'XData', [0 0], ...
                  'YData', [0 0], ...
                  'Visible', 'off', ...
                  'Clipping', 'off', ...
                  'Color', 'g', ...
                  'LineStyle', ':', ...
                  'LineWidth', 1);
              
    CCline2 = line('Parent', CCaxes, ...
                  'XData', zeros(1,NOP), ...
                  'YData', zeros(1,NOP), ...
                  'Visible', 'off', ...
                  'Clipping', 'off', ...
                  'Color', 'g', ...
                  'LineStyle', ':', ...
                  'LineWidth', 1);
     
    errCatch = 0;    %Wait for the function to complete.
    try
        waitfor(CCline2, 'UserData', 'Completed');
    catch
        errCatch = 1;
    end
     
    if (errCatch == 1)          % error
        errStatus = 'trap';
    elseif (~ishandle(CCline2) || ...
                ~strcmp(get(CCline2, 'UserData'), 'Completed'))
        errStatus = 'unknown';
    else                        %succes.
        errStatus = 'ok';
        x = get(CCline2, 'XData');
        y = get(CCline2, 'YData');
    end

    % Delete the animation objects
    if (ishandle(CCline1))
        delete(CCline1);
    end
    if (ishandle(CCline2))
        delete(CCline2);
    end

    % Restore the figure state
    if (ishandle(CCfig))
       uirestore(state);
       set(CCfig, 'DoubleBuffer', old_db);

       if ishandle(CCaxes)
           set(CCaxes, {'XLimMode','YLimMode','ZLimMode'}, original_modes);
       end
    end
    %clear the globals
    clear CCaxes CCfig CCline1 NOP CCline2

    % Depending on the error status, return the answer or generate
    % an error message.
    switch errStatus
    case 'ok'
        % Return the answer
        Xpoints = x(1:end-1);
        Ypoints = y(1:end-1);

    case 'trap'
        % An error was trapped during the waitfor
        eid = 'Images:createcircle:interruptedMouseSelection';
        error(eid, '%s', 'Interruption during mouse selection.');

    case 'unknown'
        % User did something to cause the rectangle drag to
        % terminate abnormally.  For example, we would get here
        % if the user closed the figure in the drag.
        eid = 'Images:createcircle:interruptedMouseSelection';
        error(eid, '%s', 'Interruption during mouse selection.');
    end    

    
function ButtonDown             % the user clicked
    global CCaxes CCfig CCline1 CCline2
    
    point = get(CCaxes,'CurrentPoint');
    set(CCline1, 'XData', [point(1,1) point(1,1)], ...
                'YData', [point(1,2),point(1,2)], ...
                  'visible','on', ...
                  'Color', 'r', ...
                  'LineStyle', ':', ...
                  'LineWidth', 1);
              
    set(CCline2,'visible','on',...
                  'Color', 'r', ...
                  'LineStyle', ':', ...
                  'LineWidth', 1);          
     
    set(CCfig, 'WindowButtonMotionFcn', 'createcircle(''ButtonMotion'');', ...
                 'WindowButtonUpFcn', 'createcircle(''ButtonUp'');');
    
    
function ButtonUp                   % the drawing is complete
    global CCaxes CCfig CCline1 NOP CCline2
    xdata = get(CCline1, 'XData');
    ydata = get(CCline1, 'YData');
    point = get(CCaxes,'CurrentPoint');
    xdata(2) = point(1,1); ydata(2) = point(1,2);
    set(CCline1, 'XData', xdata, 'YData',ydata,'visible','off');
    set(CCfig, 'WindowButtonMotionFcn', '', ...
                 'WindowButtonUpFcn', '','KeyPressFcn','createcircle(''KeyPress'');');
    xdif = xdata(2)-xdata(1);
    ydif = ydata(2)-ydata(1);
    THETA=linspace(0+atan2(ydif,xdif),2*pi+atan2(ydif,xdif),NOP); % Create the circle
    RHO=ones(1,NOP)*sqrt(xdif^2+ydif^2);
    [X,Y] = pol2cart(THETA,RHO);
    X=X+xdata(1);
    Y=Y+ydata(1);
    set(CCline2, 'XData', X, 'YData',Y,'visible','on', ...
                  'Color', [1 .5 .2], ...
                  'LineStyle', '-', ...
                  'LineWidth', 2);
    
function ButtonMotion           % the user moves the mouse, after clicking
    global CCaxes CCline1 NOP CCline2
    point = get(CCaxes,'CurrentPoint');
    xdata = get(CCline1, 'XData');
    ydata = get(CCline1, 'YData');
    point = get(CCaxes,'CurrentPoint');
    xdata(2) = point(1,1); ydata(2) = point(1,2);
    set(CCline1, 'XData', xdata, 'YData',ydata);
    
    xdif = xdata(2)-xdata(1);
    ydif = ydata(2)-ydata(1);
    THETA=linspace(0+atan2(ydif,xdif),2*pi+atan2(ydif,xdif),NOP);
    RHO=ones(1,NOP)*sqrt(xdif^2+ydif^2);
    [X,Y] = pol2cart(THETA,RHO);
    X=X+xdata(1);
    Y=Y+ydata(1);
    set(CCline2, 'XData', X, 'YData',Y);

function KeyPress
    global CCfig CCline2
    key = get(CCfig, 'CurrentCharacter');
    if (key==char(13)) | (key==char(3))   % enter and return keys
        % return control to line after waitfor
        set(CCline2, 'UserData', 'Completed');  
    end
    