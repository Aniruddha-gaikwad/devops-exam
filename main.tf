resource "aws_subnet" "private_subnet" {
  vpc_id                  = data.aws_vpc.vpc.id
  cidr_block              = "10.0.214.0/24"  
  availability_zone       = "ap-south-1a"   
  map_public_ip_on_launch = false
  tags = {
    Name = "PrivateSubnet"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = data.aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = data.aws_nat_gateway.nat.id
  }

  tags = {
    Name = "PrivateRouteTable"
  }
}

resource "aws_route_table_association" "private_route_table_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_security_group" "lambda_sg" {
  vpc_id = data.aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  
    cidr_blocks = ["0.0.0.0/0"]
  }
    tags = {
    Name = "LambdaSG"
  }
}

resource "aws_lambda_function" "my_lambda" {
  function_name = "MyLambdaFunction_${formatdate("YYYYMMDDhhmmss", timestamp())}" 
  filename =  "./lambda_function.zip"
  handler       = "lambda_function.lambda_handler"  
  runtime       = "python3.8"  

  role = data.aws_iam_role.lambda.arn

  vpc_config {
    subnet_ids         = [aws_subnet.private_subnet.id]
    security_group_ids = [aws_security_group.lambda_sg.id]

    
  }

  source_code_hash = filebase64sha256("lambda_function.zip")  
    lifecycle {
    create_before_destroy = true
  }
}

#done





