//Adding Inernet Gateway & NAT Gateway(with EIP) 

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}


resource "aws_eip" "myeip" {
  //instance = aws_instance.web.id
  vpc = true
}

resource "aws_nat_gateway" "NAT_GW" {
  allocation_id = aws_eip.myeip.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "NAT_GW"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.IGW]
}

//Adding Customize Route Table & Association 

resource "aws_route_table" "custom_rtb" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name = "MyRoute"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.custom_rtb.id
  count          = 2
}

//Adding NAT Gateway into the default main route table

resource "aws_default_route_table" "default_rtb" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NAT_GW.id

  }

  tags = {
    Name = "default_rtb"
  }
}



#Adding Load Balancer 

resource "aws_lb" "application_LB" {
  name               = "PROD-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_tls.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]

  enable_deletion_protection = false

  tags = {
    Environment = "PROD"
  }
}

//Load Balancer - Target Group

resource "aws_lb_target_group" "application_LB_TG" {
  name        = "PROD-lb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.main.id

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 10
    path                = "/"
    port                = 80
  }
}

resource "aws_lb_target_group_attachment" "front_end" {
  target_group_arn = aws_lb_target_group.application_LB_TG.arn
  target_id        = aws_instance.web[count.index].id
  port             = 80
  count            = 2
}

//Load Balancer - Listener

resource "aws_lb_listener" "application_LB_LT" {
  load_balancer_arn = aws_lb.application_LB.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.application_LB_TG.arn
  }
}