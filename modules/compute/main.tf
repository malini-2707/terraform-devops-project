resource "aws_instance" "web" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [var.sg_id]

  user_data = <<-EOF
              #!/bin/bash
              # Wait for cloud-init to finish apt tasks
              while fuser /var/lib/dpkg/lock >/dev/null 2>&1 ; do sleep 1; done
              
              apt-get update -y
              apt-get install -y apt-transport-https ca-certificates curl software-properties-common docker.io
              
              systemctl start docker
              systemctl enable docker
              
              # Add current user to docker group (optional but helpful)
              usermod -aG docker ubuntu
              
              # Run a test container
              docker run -d --name hello-world -p 80:3000 node:18-alpine sh -c "
              echo 'const http=require(\"http\");
              http.createServer((req,res)=>{
              res.writeHead(200, {\"Content-Type\": \"text/html\"});
              res.end(\"<h1>Hello from Terraform DevOps Project 🚀</h1><p>Provisioned by Jenkins</p>\");
              }).listen(3000);' > app.js &&
              node app.js"
              EOF

  tags = {
    Name = "Terraform-Docker-Instance"
  }
}