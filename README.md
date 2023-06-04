
# How to Reduce the Costs of Running AWS EC2 Instances


# Introduction

It is painful to start and stop instances manually on a daily basis. 
It is also called the scheduler for AWS EC2 instance.
We create a Lambda function leavraging python boto3 with the CloudWatch rule and event which automatically starts or stops the instance based on the predefined time in the CloudWatch rule.

There are some Benefits on using scheduler on EC2:

Access the instance as per the working hours.
Reduce costs.
Stop instance from loading up on weekends.
The time limit for employees for working on the instance.

# Architecture

![](images/Auto-Start-Stop-Architecture.drawio.png)


# Implementation

AWS Lambda Functions, AWS EventBridge, Python boto3 . Using this method, You can schedule the start and stop of your EC2 instances by using tags on target instances.

The following are some advantages of utilizing scheduler on EC2:

Access the instance as per the working hours.
Reduce costs.
Stop instance from loading up on weekends.
The time limit for employees for working on the instance.


# Solution

AWS Lambda Functions, AWS EventBridge, Python boto3 . Using this method, You can schedule the start and stop of your EC2 instances by using the tag below on the target EC2 instances.

key = Auto-Start-Stop

value = true

# Logic of the Python Code

Returning All EC2 instances(InstanceID) tagged with the tag Auto-Start-Stop will be started each working day from Monday to Friday at 8:00 am UTC Which is 9:00 and will stopped each working day from Monday to Friday evening at 6:00 pm UTC


# Adjustment

Since the solution is deployed using Terraform, the schedule time adjustment should also be carried out using Terraform. However, you can also adjust the schedule time directly on the AWS console, however this is not really advised. To avoid any inconsistency or and duplicate resources, it is recommended that Terraform be used to apply the changes.


# Remediation

Simply remove the tag "Auto-Start-Stop" from the target EC2 instances manually.


# Deployment pre-requisites
Terraform CLI installed
IAM Role/IAM User with the enough permissions.
AWS CLI installed
Git Installed
10. Deployment Steps

git clone https://github.com/Assassin010/auto-start-stop-instances.git

git clone git@github.com:Assassin010/auto-start-stop-instances.git

Switch to the following directory => auto-start-stop
terraform init

terraform plan

terraform apply --auto-approve
To completely decommission the solution
terraform destroy --auto-approve 
11. Summary

So far, we've seen the utility of Event-Driven infrastructure, how services respond to events, and a use case in which a serverless compute service runs based on storage events and notifies a user via email. In addition, we used Infrastructure as a Code (IaaC) by using terragrunt + terraform to create and destroy all resources.

12. References

https://aws.amazon.com/ec2/
https://aws.amazon.com/lambda/
https://www.terraform.io
https://aws.amazon.com/cloudtrail/
https://aws.amazon.com/s3/
https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-what-is.html

Happy coding!
END - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

If you like my work and want to support me…
The BEST way is following me on dev.to here

Feel free to give likes/claps, or writing comments so I know how helpful this post was for you.

Gauthier Kwatatshey__
Connect with me on LinkdIn : https://www.linkedin.com/in/gauthier-kwatatshey-b9a66715b

Dev.to : https://dev.to/aws-builders/how-to-cut-down-the-costs-of-running-aws-servers-elastic-compute-3ch5

Medium : https://medium.com/@gauthier.kwatatshey/how-to-cut-down-the-costs-of-running-aws-servers-elastic-compute-1a87293eea57
