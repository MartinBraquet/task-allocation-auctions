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
function sendMisPkgCommand(rob,name,joints,angles,types)
if(nargin < 5)
	types = zeros(1,length(joints));
end
rob.send_MisPkgCommand(name,joints,angles,types)
end