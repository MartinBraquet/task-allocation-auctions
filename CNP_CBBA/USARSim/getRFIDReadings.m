% rfid = getRFIDReadings(robot)
% This function gets the RFID sensor readings from the robot spawned by rob
% RFID - matlab struct with members Name, ID, and Mem data
% robot - java class object for the desired robot (use
% initializeRobot(robot_Name) to get robot)
function RFID = getRFIDReadings(robot)
    RFID = struct('Name',[], 'TimeStamp', 0,'ID', 0,'Mem', 0);
	a = robot.getRFID();
	RFID.Name = a.Name;
    RFID.ID = a.IDs;
    RFID.Mem = a.data;
	RFID.TimeStamp = a.TimeStamp;
end