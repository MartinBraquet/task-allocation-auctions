% ins = getINSReadings(robot)
% This function gets the inertial sensor readings from the robot spawned by rob
% ins - matlab struct with members Name, Position, and Orientation
% robot - java class object for the desired robot (use
% initializeRobot(robot_Name) to get robot)
function ins = getINSReadings(robot)
    ins = struct('Name', [], 'TimeStamp', 0, 'Position', [0 0 0], 'Orientation', [0 0 0]);
    a = robot.getSensorINS();
	ins.Names = a.Name;
    ins.Position = a.Position;
    ins.Orientation = a.Orientation;
	ins.TimeStamp = a.TimeStamp;