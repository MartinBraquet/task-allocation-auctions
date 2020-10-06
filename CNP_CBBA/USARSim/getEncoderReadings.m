% encoders = getEncoderReadings(robot)
% This function gets the encoder readings from the robot spawned by rob
% encoders - matlab struct with members Name and Ticks
% robot - java class object for the desired robot (use
% initializeRobot(robot_Name) to get robot)
function encoders = getEncoderReadings(robot)
    encoders = struct('Names', [], 'TimeStamp', 0, 'Ticks', []);
	a = robot.getSensorEncoders();
    encoders.Names = a.Name;
    encoders.Ticks = double(a.Ticks);
	encoders.TimeStamp = a.TimeStamp;