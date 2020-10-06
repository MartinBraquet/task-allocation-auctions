% rob = shutdownRobot(robot)
% This function closes the connection to USARSim and removes the robot from
% UT2004 
% robot - java class object for the desired robot (use
% initializeRobot(robot_Name) to set robot)
function shutdownRobot(robot)
    robot.stop();
    robot.shutdown();
