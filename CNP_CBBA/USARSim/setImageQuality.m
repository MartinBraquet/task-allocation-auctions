% out = setImageQuality(robot,q)
% This function sets the JPEG quality between 1-8.  1-highest, 8-lowest
% out - quality set
% robot - java class object for the desired robot (use
% Currently unused.  Function is a place holder to test java code.
function out = setImageQuality(robot,q)
    robot.setQuality(q);
    out=q;