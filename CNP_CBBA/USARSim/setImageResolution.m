% outRes = setImageResolution(robot,res)
% This function sets the resolution of the image that is sent from the
% robot
% outRes - new resolution
% robot - java class object for the desired robot (use
% This is mostly here for a future implementation.  It currently acts as a
% scaling element.  A factor of 1 is the same as input resolution.  0.5
% would be 1/2 scale, etc.
function outRes = setImageResolution(robot,res)
    robot.setResolution(res);
    outRes=res;