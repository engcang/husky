# Clearpath Husky robot
+ [Homepage](https://www.clearpathrobotics.com/husky-unmanned-ground-vehicle-robot/)
+ For installation of ROS, click [here](https://github.com/engcang/Ubuntu_ROS_Installation/)
</br></br>

## ● Husky-ROS Installation and setup
+ [Original page](http://wiki.ros.org/husky_bringup/Tutorials/Install%20Husky%20Software%20%28Advanced%29)
+ Install ROS package
  ~~~shell
  $ sudo apt-get update
  $ sudo apt-get install ros-kinetic-husky-robot
  $ sudo cp $(rospack find husky_bringup)/udev/*.rules /etc/udev/rules.d  
  ~~~
  Install Husky packages and udev rules </br></br>
  
+ Make setup file and source it
  ~~~shell
  $ gedit /etc/ros/setup.bash 
  ~~~
  Use **gedit** or **vi** to make setup.bash file and then type below as **Original page** </br>
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
  <p align="center">
  <img src="https://github.com/engcang/image-files/blob/master/husky/green_LED.jpg" width="500"/>
  </p>
  </br>

## ● Joystick install and setup
+ Do bluetooth pairing
  after that give permission to access bluetooth controller
  ~~~shell
  $ rosrun joy joy_node
  $ sudo chmod a+rw /dev/input/js0
  ~~~
  </br>
+ When needed, Edit _**husky_control/launch/teleop.launch**_ file as [here](https://github.com/husky/husky/commit/862fd9c7df6bf3b57f9895f94e59003bcc460426) like below
  <p align="center">
  <img src="https://github.com/engcang/image-files/blob/master/husky/joystick.png" width="500"/>
  </p>
## ● [Velodyne VLP16 install and setup](http://wiki.ros.org/velodyne/Tutorials/Getting%20Started%20with%20the%20Velodyne%20VLP16)
