#!/usr/bin/env python
import rospy
from geometry_msgs.msg  import Twist
from nav_msgs.msg import Odometry
from math import pow,atan2,sqrt,sin,cos
from tf.transformations import euler_from_quaternion
import numpy as np 

class husky():
    def __init__(self):
        #Creating our node,publisher and subscriber
        rospy.init_node('husky_controller', anonymous=True)
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

    def move2goal(self):
        K1=0.4
        K2=0.4
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

if __name__ == '__main__':
   x = husky()
   while 1:
      try:
        x.move2goal()
      except:
        pass
