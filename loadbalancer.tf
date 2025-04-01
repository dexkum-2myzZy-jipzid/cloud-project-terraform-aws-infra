resource "aws_lb" "api_nlb" {
  name               = "api-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.public_subnet.id]
  ip_address_type    = "ipv4"

  tags = {
    Name = "api-nlb"
  }
}

resource "aws_lb_target_group" "nlb_tg01" {
  name     = "nlb-tg01"
  port     = 8080
  protocol = "TCP"
  vpc_id   = aws_vpc.my_vpc.id

  health_check {
    protocol            = "HTTP"
    path                = "/v1/healthcheck"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 4
    interval            = 30
    matcher             = "200-399"
  }

  tags = {
    Name = "nlb-tg01"
  }
}

resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.api_nlb.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_tg01.arn
  }

  tags = {
    Name = "nlb-listener"
  }
}

resource "aws_lb_target_group_attachment" "webapp_attachment" {
  count            = 3
  target_group_arn = aws_lb_target_group.nlb_tg01.arn
  target_id        = aws_instance.web_app_instance[count.index].id
  port             = 8080
}