resource "aws_instance" "web" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [var.sg_id]

  user_data = <<-EOF
              #!/bin/bash
              while fuser /var/lib/dpkg/lock >/dev/null 2>&1 ; do sleep 1; done
              
              apt-get update -y
              apt-get install -y docker.io
              
              systemctl start docker
              systemctl enable docker
              usermod -aG docker ubuntu

              cat > /home/ubuntu/app.js << 'APPEOF'
              const http = require("http");
              const html = `<!DOCTYPE html>
              <html lang="en">
              <head>
                <meta charset="UTF-8"/>
                <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
                <title>Golden Crust Bake House</title>
                <style>
                  * { margin: 0; padding: 0; box-sizing: border-box; }
                  body { font-family: 'Georgia', serif; background: #fdf6ec; color: #3b2a1a; }

                  header {
                    background: linear-gradient(135deg, #7b3f00, #c8860a);
                    color: white;
                    text-align: center;
                    padding: 50px 20px 30px;
                  }
                  header h1 { font-size: 3em; letter-spacing: 3px; text-shadow: 2px 2px 4px rgba(0,0,0,0.3); }
                  header p { font-size: 1.2em; margin-top: 10px; font-style: italic; opacity: 0.9; }

                  nav {
                    background: #3b2a1a;
                    display: flex;
                    justify-content: center;
                    gap: 30px;
                    padding: 15px;
                  }
                  nav a {
                    color: #f5d98b;
                    text-decoration: none;
                    font-size: 1em;
                    letter-spacing: 1px;
                    text-transform: uppercase;
                    transition: color 0.3s;
                  }
                  nav a:hover { color: #fff; }

                  .hero {
                    background: url('https://images.unsplash.com/photo-1509440159596-0249088772ff?w=1200') center/cover no-repeat;
                    height: 400px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                  }
                  .hero-text {
                    background: rgba(59,42,26,0.75);
                    color: white;
                    padding: 30px 50px;
                    border-radius: 10px;
                    text-align: center;
                  }
                  .hero-text h2 { font-size: 2em; }
                  .hero-text p { margin-top: 10px; font-size: 1.1em; }
                  .hero-text a {
                    display: inline-block;
                    margin-top: 20px;
                    padding: 12px 30px;
                    background: #c8860a;
                    color: white;
                    border-radius: 25px;
                    text-decoration: none;
                    font-size: 1em;
                    transition: background 0.3s;
                  }
                  .hero-text a:hover { background: #e09b1a; }

                  .section-title {
                    text-align: center;
                    font-size: 2em;
                    color: #7b3f00;
                    margin: 50px 0 10px;
                  }
                  .section-subtitle {
                    text-align: center;
                    color: #9e7a5a;
                    margin-bottom: 40px;
                    font-style: italic;
                  }

                  .menu {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                    gap: 25px;
                    max-width: 1100px;
                    margin: 0 auto 60px;
                    padding: 0 20px;
                  }
                  .card {
                    background: white;
                    border-radius: 12px;
                    box-shadow: 0 4px 15px rgba(0,0,0,0.1);
                    overflow: hidden;
                    transition: transform 0.3s;
                  }
                  .card:hover { transform: translateY(-5px); }
                  .card-emoji { font-size: 3em; text-align: center; padding: 25px 0 10px; background: #fff8ee; }
                  .card-body { padding: 20px; }
                  .card-body h3 { font-size: 1.3em; color: #7b3f00; }
                  .card-body p { font-size: 0.95em; color: #6b5040; margin: 8px 0; }
                  .card-body .price { font-size: 1.1em; font-weight: bold; color: #c8860a; }

                  .specials {
                    background: #7b3f00;
                    color: white;
                    text-align: center;
                    padding: 50px 20px;
                  }
                  .specials h2 { font-size: 2em; margin-bottom: 10px; }
                  .specials p { font-size: 1.1em; opacity: 0.9; max-width: 600px; margin: 0 auto 20px; }
                  .specials-grid {
                    display: flex;
                    justify-content: center;
                    gap: 20px;
                    flex-wrap: wrap;
                    margin-top: 30px;
                  }
                  .special-item {
                    background: rgba(255,255,255,0.1);
                    border-radius: 10px;
                    padding: 20px 30px;
                    min-width: 160px;
                  }
                  .special-item .day { font-size: 0.9em; opacity: 0.8; text-transform: uppercase; }
                  .special-item .item { font-size: 1.2em; font-weight: bold; margin-top: 5px; }

                  .info {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
                    gap: 30px;
                    max-width: 900px;
                    margin: 60px auto;
                    padding: 0 20px;
                  }
                  .info-card {
                    background: white;
                    border-left: 5px solid #c8860a;
                    padding: 25px;
                    border-radius: 8px;
                    box-shadow: 0 2px 10px rgba(0,0,0,0.07);
                  }
                  .info-card h3 { color: #7b3f00; font-size: 1.2em; margin-bottom: 12px; }
                  .info-card p { color: #6b5040; line-height: 1.8; }

                  footer {
                    background: #3b2a1a;
                    color: #f5d98b;
                    text-align: center;
                    padding: 30px;
                    font-size: 0.95em;
                  }
                  footer p { margin: 5px 0; opacity: 0.8; }
                </style>
              </head>
              <body>

                <header>
                  <h1>🍞 Golden Crust Bake House 1</h1>
                  <p>Baked Fresh Every Morning — Made with Love Since 2010</p>
                </header>

                <nav>
                  <a href="#">Home</a>
                  <a href="#">Menu</a>
                  <a href="#">Specials</a>
                  <a href="#">About</a>
                  <a href="#">Contact</a>
                </nav>

                <div class="hero">
                  <div class="hero-text">
                    <h2>Freshness You Can Taste</h2>
                    <p>Artisan breads, pastries & cakes crafted daily from scratch</p>
                    <a href="#">Order Now</a>
                  </div>
                </div>

                <h2 class="section-title">Our Menu</h2>
                <p class="section-subtitle">Everything baked fresh from scratch every morning</p>

                <div class="menu">
                  <div class="card">
                    <div class="card-emoji">🍞</div>
                    <div class="card-body">
                      <h3>Sourdough Bread</h3>
                      <p>Classic tangy sourdough with a crispy golden crust</p>
                      <p class="price">₹ 120</p>
                    </div>
                  </div>
                  <div class="card">
                    <div class="card-emoji">🥐</div>
                    <div class="card-body">
                      <h3>Butter Croissant</h3>
                      <p>Flaky, buttery layers — perfect with coffee</p>
                      <p class="price">₹ 80</p>
                    </div>
                  </div>
                  <div class="card">
                    <div class="card-emoji">🎂</div>
                    <div class="card-body">
                      <h3>Custom Cakes</h3>
                      <p>Personalized cakes for every occasion</p>
                      <p class="price">From ₹ 850</p>
                    </div>
                  </div>
                  <div class="card">
                    <div class="card-emoji">🧁</div>
                    <div class="card-body">
                      <h3>Cupcakes</h3>
                      <p>Moist vanilla & chocolate cupcakes with frosting</p>
                      <p class="price">₹ 60 each</p>
                    </div>
                  </div>
                  <div class="card">
                    <div class="card-emoji">🥖</div>
                    <div class="card-body">
                      <h3>Multigrain Loaf</h3>
                      <p>Healthy blend of oats, flax & whole wheat</p>
                      <p class="price">₹ 150</p>
                    </div>
                  </div>
                  <div class="card">
                    <div class="card-emoji">🍩</div>
                    <div class="card-body">
                      <h3>Donuts</h3>
                      <p>Glazed, chocolate & jam-filled varieties</p>
                      <p class="price">₹ 50 each</p>
                    </div>
                  </div>
                </div>

                <div class="specials">
                  <h2>🌟 Weekly Specials</h2>
                  <p>Come in on special days for exclusive freshly baked treats!</p>
                  <div class="specials-grid">
                    <div class="special-item"><div class="day">Monday</div><div class="item">Cinnamon Rolls</div></div>
                    <div class="special-item"><div class="day">Wednesday</div><div class="item">Cheese Focaccia</div></div>
                    <div class="special-item"><div class="day">Friday</div><div class="item">Fruit Tarts</div></div>
                    <div class="special-item"><div class="day">Sunday</div><div class="item">Brioche French Toast</div></div>
                  </div>
                </div>

                <div class="info">
                  <div class="info-card">
                    <h3>📍 Find Us</h3>
                    <p>12, Baker Street<br/>Anna Nagar, Chennai<br/>Tamil Nadu - 600040</p>
                  </div>
                  <div class="info-card">
                    <h3>🕐 Opening Hours</h3>
                    <p>Monday – Saturday: 7:00 AM – 9:00 PM<br/>Sunday: 8:00 AM – 6:00 PM</p>
                  </div>
                  <div class="info-card">
                    <h3>📞 Contact Us</h3>
                    <p>Phone: +91 98765 43210<br/>Email: hello@goldencrust.in</p>
                  </div>
                </div>

                <footer>
                  <p>🍞 Golden Crust Bake House — Chennai, Tamil Nadu</p>
                  <p>Provisioned by Jenkins & Terraform on AWS ☁️</p>
                </footer>

              </body>
              </html>`;
              http.createServer((req, res) => {
                res.writeHead(200, { "Content-Type": "text/html" });
                res.end(html);
              }).listen(3000);
              APPEOF

              docker run -d --name bakehouse -p 80:3000 \
                -v /home/ubuntu/app.js:/app/app.js \
                node:18-alpine node /app/app.js
              EOF

  tags = {
    Name = "Terraform-Docker-Instance"
  }
}