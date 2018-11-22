# Clearpath Husky robot
+ [Homepage](https://www.clearpathrobotics.com/husky-unmanned-ground-vehicle-robot/)
+ For installation of ROS, click [here](https://github.com/engcang/Ubuntu_ROS_Installation/)
</br></br>

## ROS Installation and setup
+ [Original page](http://wiki.ros.org/husky_bringup/Tutorials/Install%20Husky%20Software%20%28Advanced%29)
+ Install ROS package
  ~~~shell
  $ sudo apt-get update
  $ sudo apt-get install ros-kinetic-husky-robot
  $ sudo cp $(rospack find husky_bringup)/udev/*.rules /etc/udev/rules.d  
  ~~~
  Install Husky packages and udve rules
  </br>
+ Setup packages
  ~~~shell
  $ source /opt/ros/kinetic/setup.bash && source ~/catkin_ws/devel/setup.bash
  ~~~
  </br>
+ Start sensor ROS node
  ~~~shell
  $ roslaunch hls_lfcd_lds_driver hlds_laser.launch
  ~~~
  </br>

## Joystick install and setup
$ rosrun joy joy_node
$ sudo chmod a+rw /dev/input/jsX
## [Velodyne VLP16 install and setup](http://wiki.ros.org/velodyne/Tutorials/Getting%20Started%20with%20the%20Velodyne%20VLP16)
