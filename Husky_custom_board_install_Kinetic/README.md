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
+ Make setup file and source it
  ~~~shell
  $ gedit /etc/ros/setup.bash 
  ~~~
  **Use** gedit or **vi** to make setup.bash file and then type below as **original page**
  ~~~shell
  # Mark location of self so that robot_upstart knows where to find the setup file.
  export ROBOT_SETUP=/etc/ros/setup.bash

  # Setup robot upstart jobs to use the IP from the network bridge.
  # export ROBOT_NETWORK=br0
  # Insert extra platform-level environment variables here. The six hashes below are a marker
  # for scripts to insert to this file.

  ######
  # Pass through to the main ROS workspace of the system.
  source /opt/ros/indigo/setup.bash
  ~~~
  Source this setup file into **.bashrc** file and source it
  ~~~shell
  $ echo "source /etc/ros/setup.bash" >> ~/.bashrc
  $ source ~/.bashrc
  ~~~
  </br>
+ Create a robot_upstart job to start husky_core when robot board is booted as **Original page**
  ~~~shell
  $ rosrun robot_upstart install husky_base/launch/base.launch --job husky_core --setup '/etc/ros/setup.bash'
  ~~~
  Reboot the Husky robot and then see the Green LED on status bar
  </br>

## Joystick install and setup
$ rosrun joy joy_node
$ sudo chmod a+rw /dev/input/jsX
## [Velodyne VLP16 install and setup](http://wiki.ros.org/velodyne/Tutorials/Getting%20Started%20with%20the%20Velodyne%20VLP16)
