% rob = initializeRobot(robot_Name, robot_Class, robot_Position, robot_Orientation)
% This function spawns a robot of type robot_Class with name robot_Name, at
% an initial position of robot_Position with orientation robot_Orientation
% rob - java class object
% robot_Name - string, default is 'robby'
% robot_Class - string, default is 'P2AT'
% robot_Position - 1x3 vector, default is [0 0.1 1.8] 
% robot_Orientation - 1x3 vector, default is [0 0 0]
function rob = initializeRobot(robot_Name, robot_Class, robot_Position, robot_Orientation)
    % Make sure our Java directory is on the dynamic javaclasspath
    % Note that [clear java] will force classes on the dynamic path 
    % to be reloaded.
    rob = USARSim;
    
    if nargin > 4
        error('Too many input arguments');
    elseif nargin == 4
        % Note: USAR bug - cannot initialize at robot_position(2) = 0
        if robot_Position(2) == 0
            robot_Position(2) = 0.1;
        end
        rob.spawnRobot(robot_Class, robot_Name, robot_Position, robot_Orientation);
    elseif nargin == 3
        % Note: USAR bug - cannot initialize at robot_position(2) = 0
        if robot_Position(2) == 0
            robot_Position(2) = 0.1;
        end
        rob.spawnRobot(robot_Class, robot_Name, robot_Position, [0 0 0]);
    elseif nargin == 2
        rob.spawnRobot(robot_Class, robot_Name, [0 0.1 1.8], [0 0 0]);
    elseif nargin == 1
        rob.spawnRobot('AirRobot', robot_Name, [0 0 0], [0 0 0]);
    elseif nargin < 1
        error('Too few input argments');
    end
    rob.start();
