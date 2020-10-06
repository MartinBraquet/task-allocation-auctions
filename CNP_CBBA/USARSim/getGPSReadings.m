% gps = getGPSReadings(robot)
% This function gets the GPS readings from the robot spawned by rob
% gps - matlab struct with members Name, Latitude, Longitude, GotFix, and
% NumOfSatellites
% robot - java class object for the desired robot (use
% initializeRobot(robot_Name) to get robot)
function gps = getGPSReadings(robot)
    gps = struct('Name', [], 'TimeStamp', 0, 'Latitude', 0, 'Longitude', 0, 'GotFix', 0, 'NumOfSatellites', 0);
    a = robot.getSensorGPS();
	gps.Name = a.Name;
    gps.Latitude = a.Latitude;
    gps.Longitude = a.Longitude;
    gps.GotFix = a.GotFix;
    gps.NumOfSatellites = a.NumSatellites;
	gps.TimeStamp = a.TimeStamp;