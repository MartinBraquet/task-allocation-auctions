%% Function getMissionState
% This function gets the array of mission states from the robot spawned by 
% robot
% state - matlab struct with members Name, TimeStamp, Link, Value, Torque;
% robot - java class object for the desired robot (use
% initializeRobot(robot_Name) to get robot)
% Each usarMissionState object has the following public properties:
%	Name- name of package as described in USARMisPkg.ini
%	TimeStamp- double valued timestamp
%	Link- integer array denoting link numbers
%	Value- double-precision array with angle values corresponding to Link
%	Torque- double array with torque values coresponding to Link
function state = getMissionState(robot)
state = robot.getMissionState();
end