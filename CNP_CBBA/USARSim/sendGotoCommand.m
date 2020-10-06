%% Fuction sendMisPkgCommand sends a command to a mission package on the
%  given robot object.
%  name is the name of the mission package AS STATED IN USARBot.ini. If the
%   arm doesn't do anything when you send a command, you probably aren't
%   giving it the right name.
%  joints is a vector of joint numbers corresponding to the numbers given
%   in USARMisPkg.ini
%  angles is a vector of desired angles/speeds/torques corresponding the
%   joint numbers in joints
%  types is a vector of command orders corresponding to the joints
%   argument. Type 0 is angle control. Type 1 is speed control. Type 2 is
%   torque control. If this argument is ommitted, all types default to 0.
function sendGotoCommand(rob,pathnode)
    if nargin > 3
        error('Too many input arguments'); 
    elseif nargin == 2
        % In USAR sending 0 and 0 to left and right motors makes the
        % robot coast to a stop.  The following will allow the robot to
        % actually stop when a [0 0] command is issued.     
        rob.sendGoto(pathnode);
    elseif nargin < 2
        error('Too few input arguments: no motor commands given.');
    end