yum update -y
yum install docker -y
service docker start
usermod -a -G docker ec2-user
dnf install amazon-ecr-credential-helper -y
docker pull 642069671695.dkr.ecr.us-east-1.amazonaws.com/carmel/test:latest
docker run -p 3000:3000 642069671695.dkr.ecr.us-east-1.amazonaws.com/carmel/test:latest