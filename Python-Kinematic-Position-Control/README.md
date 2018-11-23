# Controlling the real robot
+ Controlling the real robot via ROS into wanted position using kinematic error modeling's input velocities
+ Please attach github URL when you use my code!
+ 코드를 사용시 링크를 첨부해주세요!
+ Each folders and branches has its own README.md which is A to Z explanation in detail
+ 각각의 폴더와 브런치들에 자세한 README.md(설명)이 별도로 있습니다.
</br></br>

### Robot - Husky from Clearpath
+ [Husky](https://www.clearpathrobotics.com/husky-unmanned-ground-vehicle-robot/)

### referred to robot's modelling of paper : 
+ **A Stable Target-Tracking Control for Unicycle Mobile Robots**, Sung-On Lee, Young-Jo Cho, Myung Hwang-Bo, Bum-Jae You, Sang-Rok Oh, Proceedings of the 2000 IEEE/RSJ International Conference on Intelligent Robots and Systems 
  + **Modelling uses velocity input which is proved stable by Lyapunov stability**
</br></br>

## Code breaking down
+ Libraries
  ~~~python
  #!/usr/bin/env python
  import rospy
  from geometry_msgs.msg  import Twist
  from nav_msgs.msg import Odometry
  from math import pow,atan2,sqrt,sin,cos
  from tf.transformations import euler_from_quaternion
  import numpy as np 
  ~~~
  '#!/usr/bin/env python' teaches terminal what kind of script source we will run
  
  You should import [ROS message types](http://wiki.ros.org/ROS/Tutorials/UnderstandingTopics) as library
  
  </br></br>
+ ROS connection :

  ~~~python
  class husky():
    def __init__(self):
        #Creating our node,publisher and subscriber
        rospy.init_node('turtlebot_controller', anonymous=True)
        self.velocity_publisher = rospy.Publisher('/husky_velocity_controller/cmd_vel', Twist, queue_size=10)
        self.pose_subscriber = rospy.Subscriber('/husky_velocity_controller/odom', Odometry, self.callback)
        self.pose = Odometry()
        self.rate = rospy.Rate(10)

    #Callback function implementing the pose value received
    def callback(self, data):
        self.pose = data.pose.pose.position
        self.orient = data.pose.pose.orientation
        self.pose.x = round(self.pose.x, 4)
        self.pose.y = round(self.pose.y, 4)
  ~~~
  </br>
　This code block initializes ROS connection and make nodes subscribe and publishe the messages under topics </br>
　like graph followed when _**x = husky()**_ line inherit class _**callback**_ function is automatically implemented </br>
　whenever _**'Odometry'**_ data comes from _**'/odom'**_ topic  
  
  <p align="center">
  <img src="https://github.com/engcang/image-files/blob/master/husky/rqt_kinematic_py.gif" width="600"/>
  </p>

  </br></br>
+ Function :

  ~~~python
  def move2goal(self):
        K1=0.5
        K2=0.5
        goal_pose_ = Odometry()
        goal_pose = goal_pose_.pose.pose.position
        goal_pose.x = input("Set your x goal:")
        goal_pose.y = input("Set your y goal:")
        distance_tolerance = input("Set your tolerance:")
        vel_msg = Twist()
        r = sqrt(pow((goal_pose.x - self.pose.x), 2) + pow((goal_pose.y - self.pose.y), 2))
        while r >= distance_tolerance:

            r = sqrt(pow((goal_pose.x - self.pose.x), 2) + pow((goal_pose.y - self.pose.y), 2))
            psi = atan2(goal_pose.y - self.pose.y, goal_pose.x - self.pose.x)
            orientation_list = [self.orient.x, self.orient.y, self.orient.z, self.orient.w]
            (roll, pitch, yaw) = euler_from_quaternion (orientation_list)
            theta = yaw
            phi = theta - psi
            if phi > np.pi:
                phi = phi - 2*np.pi
            if phi < -np.pi:
                phi = phi + 2*np.pi

            vel_msg.linear.x = K1*r*cos(phi)
            vel_msg.angular.z = -K1*sin(phi)*cos(phi)-(K2*phi)

            #Publishing input
            self.velocity_publisher.publish(vel_msg)
            self.rate.sleep()
        #Stopping our robot after the movement is over
        vel_msg.linear.x = 0
        vel_msg.angular.z =0
        self.velocity_publisher.publish(vel_msg)
  ~~~
  Input Gains K1 and K2 can differ how fast the robot will move</br>
  goal_pose.x and y gets the wanted position of robot under Odometry.pose.pose.position message type from [ROS msg type](http://wiki.ros.org/msg) </br>
  1.Using the modelling of the paper above, calculated the input by rho(distance between robot and goal position) and phi (subtraction between robot direction and direction from origin to goal position under World coordinate)
  
  2.send input to robot via ROS untill get closed to goal position within tolerance (gets input from the user in meter unit)
  
  3.When get close enough, stop robot via sending '0' velocity

</br></br>

+ Main part :

  ~~~python
  if __name__ == '__main__':
   x = husky()
   while 1:
      try:
        x.move2goal()
      except:
        pass
  ~~~
  After inherit _**husky()**_ class, continuously moves robot to wanted position
  </br>
 
  
  </br>
## Result clip using Gazebo
</br>
  <p align="center">
  <img src="https://github.com/engcang/image-files/blob/master/husky/kinematic_py.gif" width="500"/>
  </p>
  </br>
  Robot moves to (3,2) position from origin untill close enough </br>
  Gazebo simulation can be implemented as above clip by
  
  ~~~shell
  $ roslaunch husky_gazebo husky_playpen.launch 
  ~~~
