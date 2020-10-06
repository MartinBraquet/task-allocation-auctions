% vehicleGeo = getVehicleGeometry(robot)
% This function gets the encoder readings from the robot spawned by rob
% vehicleGeo - matlab struct with members Name, Dimensions,
% CenterOfGravity, WheelRadius, WheelSeparation, WheelBase
% robot - java class object for the desired robot (use
% initializeRobot(robot_Name) to get robot)
function vehicleGeo = getVehicleGeometry(robot)
    vehicleGeo = struct('Name', [], 'Dimensions', [0 0 0], 'CenterOfGravity', [0 0 0], 'WheelRadius', 0, 'WheelSeparation', 0, 'WheelBase', 0);
    vehicleGeo.Name = robot.getGeometryGroundVehicle().Name;
    vehicleGeo.Ticks = robot.getSensorEncoders().Ticks;