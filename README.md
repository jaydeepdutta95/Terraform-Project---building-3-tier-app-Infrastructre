# Real time DevOps Project - Building 3 tier High Availability Application Architecture using Terraform  in AWS 
# Project Details: 

We are going to deploy a three-tier application architecture in AWS cloud platform using Infrastructure as Code tool - Terraform. 

**Why Terraform?** - We can deploy manually from the AWS console by creating every component one at a time, but what we do here, we will write code that will deploy the whole infrastructure in just a few clicks, and Terraform will help us in that. 

**What We will Deploy**? - We will deploy 

one VPC

two Public Subnets and One Private subnet

2 EC2 Instances in Public Subnets with two AV Zones with preinstalled Apache webserver.

1 EC2 instance in Private subnet as DB Instance.

Security Group for Ingress and Egress permissions

Load Balancer and LB Target and Listener

1 Customed Route Table, and modify the Default RTB

Internet Gateway and NAT Gateway

#--------------------------------------------------------------------#

# Project Diagram as follows 

![image](https://user-images.githubusercontent.com/117738727/220343886-d87860f9-523f-417c-ab25-5baa0bc2bc6b.png)



