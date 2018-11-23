rosshutdown
clc
clear 
close all

rosinit('192.168.80.129'); % type your robot's IP

robot = rospublisher('/husky_velocity_controller/cmd_vel');
velmsg = rosmessage(robot);

odom = rossubscriber('/husky_velocity_controller/odom');
odomdata = receive(odom); % wait up to 3 seconds, returning error if got timeout
pose = odomdata.Pose.Pose;
Ax = pose.Position.X;
Ay = pose.Position.Y;
quat = pose.Orientation;
angles = quat2eul([quat.W quat.X quat.Y quat.Z]); % transformation from quaternion to euler angles
theta = angles(1); %robot's heading angle
    
%% System Parameters
K1=0.5;
K2=0.5; %gain


xt=3;
yt=2; %xt= target.x, yt = target.y
rho=sqrt((xt-Ax)^2+(yt-Ay)^2);

while 1
if rho >=0.02
    rho=sqrt((xt-Ax)^2+(yt-Ay)^2);
    psi=atan2(yt-Ay,xt-Ax);
    phi=theta-psi;

    if phi > pi
        phi = phi - 2*pi;
    end
    if phi < -pi
        phi = phi + 2*pi;
    end % for robot angle range

disp([theta*180/pi psi*180/pi phi*180/pi]);

    velmsg.Linear.X = K1*rho*cos(phi);
    velmsg.Angular.Z = -K1*sin(phi)*cos(phi)-K2*phi;

    if velmsg.Linear.X >= 1
        velmsg.Linear.X=1;
    end
    if velmsg.Linear.X <= -1
        velmsg.Linear.X=-1;
    end
    if velmsg.Angular.Z >= 2
        velmsg.Linear.Z=2;
    end
    if velmsg.Angular.Z <= -2
        velmsg.Angular.Z=-2;
    end % saturation for robot velocity maximum range
    
    send(robot,velmsg); %sending input into real robot via ROS
    
    odomdata = receive(odom);
    pose = odomdata.Pose.Pose;
    Ax = pose.Position.X;
    Ay = pose.Position.Y;
    quat = pose.Orientation;
    angles = quat2eul([quat.W quat.X quat.Y quat.Z]);
    theta = angles(1);  %update robot's position information
else
    velmsg.Linear.X=0;
    velmsg.Angular.Z=0;
    send(robot,velmsg);
    break;
end
end
