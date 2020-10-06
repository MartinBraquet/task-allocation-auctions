% sonar = getSonarReadings(robot)
% This function gets the sonar readings from the robot spawned by rob
% sonar - matlab struct with members Name and Range
% robot - java class object for the desired robot (use
% initializeRobot(robot_Name) to get robot)
function sonar = getSonarReadings(robot)
    sonar = struct('Name', [], 'TimeStamp', 0, 'Range', []);
	a = robot.getSensorSonar();
    sonar.Name = a.Name;
    sonar.Range = a.Range;
	sonar.TimeStamp = a.TimeStamp;