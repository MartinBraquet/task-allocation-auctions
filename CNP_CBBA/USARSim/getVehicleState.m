% state = getVehicleState(robot)
% This function gets the state from the robot spawned by rob
% state - matlab struct with members TimeStamp, FrontSteer, RearSteer,
% LightToggle, LightIntensity, BatteryLife;
% robot - java class object for the desired robot (use
% initializeRobot(robot_Name) to get robot)
function state = getVehicleState(robot)
    state = struct('TimeStamp', 0, 'FrontSteer', 0, 'RearSteer', 0, 'LightToggle', 0, 'LightIntensity', 0, 'BatteryLife', 0);
    state.TimeStamp = robot.getStateGroundVehilce().TimeStamp;
    state.FrontSteer = robot.getStateGroundVehilce().FrontSteer;
    state.RearSteer = robot.getStateGroundVehilce().RearSteer;
    state.LightToggle = robot.getStateGroundVehilce().LightToggle;
    state.LightIntensity = robot.getStateGroundVehilce().LightIntensity;
    state.BatteryLife = robot.getStateGroundVehilce().BatteryLife;