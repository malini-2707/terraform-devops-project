resource "aws_instance" "web" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [var.sg_id]

 user_data = <<-EOF
#!/bin/bash
apt update -y
apt install docker.io -y
systemctl start docker
systemctl enable docker

docker run -d -p 80:3000 node:18-alpine sh -c "
echo 'const http=require(\"http\");
http.createServer((req,res)=>{
res.end(\"Hello from Terraform DevOps Project 🚀\");
}).listen(3000);' > app.js &&
node app.js"
EOF

  tags = {
    Name = "Terraform-Docker-Instance"
  }
}