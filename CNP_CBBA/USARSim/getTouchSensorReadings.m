% touch = getTouchSensorReadings(robot)
% This function gets the touch sensor readings from the robot spawned by rob
% touch - matlab struct with members Name and ContactState
% robot - java class object for the desired robot (use
% initializeRobot(robot_Name) to get robot)
function touch = getTouchSensorReadings(robot)
    touch = struct('Name', [], 'TimeStamp', 0, 'ContactState', []);
	a = robot.getSensorTouch();
    touch.Name = a.Name;
    touch.ContactState = a.State;
	touch.TimeStamp = a.TimeStamp;