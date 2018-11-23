# Controlling the real robot
+ Controlling the real robot via ROS into wanted position using kinematic error modeling's input velocities
+ Please attach github URL when you use my code! 
+ 코드를 사용시 링크를 첨부해주세요!
+ Each folders and branches has its own README.md which is A to Z explanation in detail
+ 각각의 폴더와 브런치들에 자세한 README.md(설명)이 별도로 있습니다.

</br></br>
### Robot - Turtlebot3 from ROBOTIS
+ [Turtlebot3](http://emanual.robotis.com/docs/en/platform/turtlebot3/overview/)

### Referred to robot's modelling of paper : 
+ **A Stable Target-Tracking Control for Unicycle Mobile Robots**, Sung-On Lee, Young-Jo Cho, Myung Hwang-Bo, Bum-Jae You, Sang-Rok Oh, Proceedings of the 2000 IEEE/RSJ International Conference on Intelligent Robots and Systems 
  + **Modelling uses velocity input which is proved stable by Lyapunov stability**


### Nessecary :
+ [< Robotics System Toolbox >](https://kr.mathworks.com/help/robotics/classeslist.html)
+ [< Support Package for Turtlebot-Based Robots >](https://kr.mathworks.com/help/supportpkg/turtlebotrobot/index.html)
+ Should start robot before running the MATLAB code by
  ~~~
  $ roslaunch turtlebot3_bringup turtlebot3_robot.launch
  ~~~
  on the board connected with turtlebot3

</br></br>
## Code breaking down

+ ROS connection :

  ~~~MATLAB
  rosinit('192.168.0.10'); % type your robot's IP
  tbot = turtlebot;
  resetOdometry(tbot); % Reset robot's Odometry

  robot = rospublisher('/cmd_vel'); % topic name is different with other robots
  velmsg = rosmessage(robot);

  odom = rossubscriber('/odom');
  ~~~
  </br>
  This block initialize ROS connection and make nodes subscribes and publishes the messages under topics
  <p align="center">
  <img src="https://github.com/engcang/image-files/blob/master/turtlebot3/kinematic_rqt_MAT.png" width="500"/>
  </p>

  </br></br>
+ System Parameters :

  ~~~MATLAB
  K1=2;
  K2=2; %gain

  xt=1;
  yt=1; %xt= target.x, yt = target.y
  rho=sqrt((xt-Ax)^2+(yt-Ay)^2);
  ~~~
  Input Gains K1 and K2 can differ how fast the robot will move </br>
  xt and yt is Goal position in X-Y 2D axes system

</br></br>

+ Calculating input :

  ~~~MATLAB
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

    velmsg.Linear.X = K1*rho*cos(phi);
    velmsg.Angular.Z = -K1*sin(phi)*cos(phi)-K2*phi;

    if velmsg.Linear.X >= 0.22
        velmsg.Linear.X=0.22;
    end
    if velmsg.Linear.X <= -0.22
        velmsg.Linear.X=-0.22;
    end
    if velmsg.Angular.Z >= 2
        velmsg.Linear.Z=2;
    end
    if velmsg.Angular.Z <= -2
        velmsg.Angular.Z=-2;
    end % saturation for robot velocity maximum range
    
    send(robot,velmsg); %sending input into real robot via ROS
    
    odomdata = receive(odom,3);
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
  ~~~
  </br>
  1.Using the modelling of the paper above, calculated the input by rho(distance between robot and goal position) and phi (subtraction between robot direction and direction from origin to goal position under World coordinate)
  
  2.and then saturate the input into bound which is the hardware specification of Turtlebot3
  
  3.send input to robot via ROS untill get closed to goal position within tolerance (0.02 meter in this code)
  
  </br>
## Result clip using Gazebo
</br>
  <p align="center">
  <img src="https://github.com/engcang/image-files/blob/master/turtlebot3/kinematic_MATLAB.gif" width="500"/>
  </p>
  </br>
  Robot moves to (1,1) position from origin untill close enough</br>
  Gazebo simulation can be implemented as above clip by
  
  ~~~shell
  $ roslaunch turtlebot3_gazebo turtlebot3_empty_world.launch 
  ~~~
