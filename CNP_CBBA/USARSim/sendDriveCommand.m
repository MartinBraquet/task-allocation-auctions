% out = sendDriveCommand(robot,command,command_Type)
% This function sends the commands to drive the robot
% robot - java class object for the desired robot (use
% initialize_robot(robot_ip) to get robot)
% command - 1x2 array [lmotor, rmotor] where -100<=lmotor,rmotor<=100
% command_Type - 'differential' or 'ackerman' or 'aerial', default is 'differential'
% For aeriall robot, the commands are as follows:
%	1- Vertical velocity, 2- forward velocity, 3- lateral velocity, and 
%	4- rotational velocity

function sendDriveCommand(robot, command, command_Type)
    if nargin > 3
        error('Too many input arguments');
    elseif nargin == 3
        if  strcmp(command_Type, 'differential')
            % In USAR sending 0 and 0 to left and right motors makes the
            % robot coast to a stop.  The following will allow the robot to
            % actually stop when a [0 0] command is issued.
            if sum(command) == 0
                robot.skidSteerDrive(0.1, 0.1, 1, 0, 0);
            end
            robot.skidSteerDrive(command(1), command(2), 1, 0, 0);
        elseif  strcmp(command_Type, 'aerial')  
            robot.aerialDrive(command(1), command(2),command(3),command(4), 1);
        else
            robot.ackermanDrive(comand(1), command(2), 1, 0, 0);
        end
    elseif nargin == 2
        % In USAR sending 0 and 0 to left and right motors makes the
        % robot coast to a stop.  The following will allow the robot to
        % actually stop when a [0 0] command is issued.
        if sum(command) == 0
            robot.skidSteerDrive(0.1, 0.1, 1, 0, 0);
        end        
        robot.skidSteerDrive(command(1), command(2), 1, 0, 0);
    elseif nargin < 2
        error('Too few input arguments: no motor commands given.');
    end
