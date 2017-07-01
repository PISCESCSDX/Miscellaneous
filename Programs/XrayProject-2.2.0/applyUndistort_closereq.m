% -------------------------------------------------------------------------
% applyUndistort_closereq -- applyUndistort waitbar close button function. 
% 
% 
function applyUndistort_closereq(src,evnt)
hmsg = msgbox(['This window will be deleted when processing is finished.'...
    'Deleting this window now does not stop processing.'],...
    'Close','warn');
set(src,'CloseRequestFcn','closereq'); % restore default fcn
        return
end
