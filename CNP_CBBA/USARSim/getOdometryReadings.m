% odometry = getOdometryReadings(robot)
% This function gets the odometry readings from the robot spawned by rob
% odometry - matlab struct with members Name and Pose
% robot - java class object for the desired robot (use
% initializeRobot(robot_Name) to get robot)
function odometry = getOdometryReadings(robot)
    odometry = struct('Name', [], 'TimeStamp', 0, 'Pose', [0 0 0]);
	a = robot.getSensorOdometry();
    odometry.Names = a.Name;
    odometry.Pose = a.Pose;
	odometry.TimeStamp = a.TimeStamp;