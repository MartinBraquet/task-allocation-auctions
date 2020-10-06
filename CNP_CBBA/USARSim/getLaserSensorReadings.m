% laser = getLaserSensorReadings(robot)
% This function gets the laser range finder readings from the robot spawned
% by rob
% laser - matlab struct with members Name, Resolution (in radians), FOV
% (field of view), and Scans
% robot - java class object for the desired robot (use
% initializeRobot(robot_Name) to get robot)
function laser = getLaserSensorReadings(robot)
    laser = struct('Name', [], 'TimeStamp', 0, 'Resolution', 0, 'FOV', 0, 'Scans', zeros(360,1));
    a = robot.getSensorLaser();
	laser.Name = a.Name;
    laser.Resolution = a.Resolution;
    laser.FOV = a.FieldOfView;
    laser.Scans = a.Scans;
	laser.TimeStamp = a.TimeStamp;