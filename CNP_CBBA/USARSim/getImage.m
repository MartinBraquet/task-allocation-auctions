% img = getImage(robot)
% This function returns an image from the SRV1s camera
% img - image from the robot in RGB
% robot - java class object for the desired robot (use
% initialize_robot(robot_ip) to set robot)
% See set_resolution(robot,res), set_imageCaption(robot,flag)
function img = getImage(robot)
    %robot.get_image();
    img = imread('C:\Images\usar.jpg');
    resolution = robot.getResolution();
    quality = robot.getQuality();
    img = imresize(img, resolution);