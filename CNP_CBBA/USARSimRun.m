function USARSimRun()

% Clear environment
close all; clear all;
addpath(genpath(cd));

% Add java class
javaaddpath('USARSim\USARSimJava');

for UAVID=1:5,

    FileName = strcat('agents\agent',int2str(UAVID));

    FileUAV = load(FileName);

    UAV = FileUAV.UAV;
    Path = UAV.path;
    SizePath = size(Path);
    LenPath = SizePath(1);

    RobotType = UAV.type;
    RobotName = strcat('UAV',int2str(UAVID));
    switch RobotType
        case 1
            RobotClass = 'AirRobot';
            TargetClass = 'AirTarget';
            color = 'b';
        case 2
            RobotClass = 'AirRobot2';
            TargetClass = 'AirTarget2';
            color = 'g';
        otherwise
            RobotClass = 'AirRobot';
            TargetClass = 'AirTarget';
            color = 'b';
    end

    Robot = initializeRobot(RobotName, RobotClass, [UAV.y, UAV.x, UAV.z], [0,0,0]);
    pause(UAV.time);
    truth(1)= getGroundTruth(Robot);

    for i=1:LenPath,
        TargetName = strcat('T',num2str(Path(i,5)));
        Target = initializeRobot(TargetName, TargetClass, [Path(i,2), Path(i,1), Path(i,3)+2], [0,0,0]);
        if i==1,
            Start = [UAV.x, UAV.y-1, UAV.z,];
            MissionGoTo(Robot, Start, [UAV.x, UAV.y, UAV.z], Path(i,1:4));
            truth(i+1) = getGroundTruth(Robot);
        elseif i == 2
            MissionGoTo(Robot, [UAV.x, UAV.y, UAV.z], Path(i-1,1:3), Path(i,1:4));
            truth(i+1) = getGroundTruth(Robot);
        else
            MissionGoTo(Robot, Path(i-2,1:3), Path(i-1,1:3), Path(i,1:4));
            truth(i+1) = getGroundTruth(Robot);
        end
        shutdownRobot(Target);
    end

    shutdownRobot(Robot);
    
    for i=1:LenPath,
        if i == 1,
            X1 = [UAV.x, Path(i,1)];
            Y1 = [UAV.y, Path(i,2)];
        else
            X1 = [Path(i-1,1), Path(i,1)];
            Y1 = [Path(i-1,2), Path(i,2)];
        end
        S1 = ['-','o','r'];
        X2 = [truth(i).Position(2), truth(i+1).Position(2)];
        Y2 = [truth(i).Position(1), truth(i+1).Position(1)];
        S2 = ['-','o',color];
        plot(X2,Y2,S2), grid on
        plot(X1,Y1,S1), grid on
        title('Robot Paths Simulation')
        xlabel('X')
        ylabel('Y')
        hold on
        %text(Path(i,1)-0.2,Path(i,2)-0.2, ['P' num2str(i)]);
        text(truth(i+1).Position(2)+0.05,truth(i+1).Position(1)+0.05, ['T' num2str(Path(i,5))]);
    end
    %text(UAV.x-0.2,UAV.y-0.2, ['P0']);
    text(UAV.x+0.05,UAV.y+0.05, ['A' num2str(UAVID)]);
end

shutdownUSAR();
