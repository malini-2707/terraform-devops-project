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
                <title>Wild Animals Portfolio</title>
                <style>
                  * { margin: 0; padding: 0; box-sizing: border-box; }
                  body { font-family: 'Georgia', serif; background: #0d1f0f; color: #e8f5e9; }

                  header {
                    background: linear-gradient(135deg, #1b5e20, #2e7d32);
                    text-align: center;
                    padding: 60px 20px 40px;
                    border-bottom: 4px solid #66bb6a;
                  }
                  header h1 { font-size: 3.5em; color: #a5d6a7; letter-spacing: 4px; text-shadow: 2px 2px 8px rgba(0,0,0,0.5); }
                  header p { font-size: 1.2em; color: #81c784; margin-top: 12px; font-style: italic; }

                  nav {
                    background: #0a1a0b;
                    display: flex;
                    justify-content: center;
                    gap: 40px;
                    padding: 18px;
                    position: sticky;
                    top: 0;
                    z-index: 100;
                    border-bottom: 2px solid #2e7d32;
                  }
                  nav a {
                    color: #81c784;
                    text-decoration: none;
                    font-size: 1em;
                    letter-spacing: 2px;
                    text-transform: uppercase;
                    transition: color 0.3s;
                  }
                  nav a:hover { color: #a5d6a7; }

                  .hero {
                    background: url('https://images.unsplash.com/photo-1474511320723-9a56873867b5?w=1400') center/cover no-repeat;
                    height: 500px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                  }
                  .hero-text {
                    background: rgba(0,0,0,0.65);
                    color: white;
                    padding: 40px 60px;
                    border-radius: 12px;
                    text-align: center;
                    border: 1px solid #66bb6a;
                  }
                  .hero-text h2 { font-size: 2.5em; color: #a5d6a7; }
                  .hero-text p { font-size: 1.2em; margin-top: 12px; color: #c8e6c9; }

                  .section-title {
                    text-align: center;
                    font-size: 2.2em;
                    color: #66bb6a;
                    margin: 60px 0 10px;
                    letter-spacing: 2px;
                  }
                  .section-subtitle {
                    text-align: center;
                    color: #81c784;
                    margin-bottom: 40px;
                    font-style: italic;
                  }

                  .animals-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                    gap: 30px;
                    max-width: 1200px;
                    margin: 0 auto 80px;
                    padding: 0 20px;
                  }
                  .animal-card {
                    background: #1a2e1b;
                    border-radius: 15px;
                    overflow: hidden;
                    border: 1px solid #2e7d32;
                    transition: transform 0.3s, box-shadow 0.3s;
                  }
                  .animal-card:hover {
                    transform: translateY(-8px);
                    box-shadow: 0 15px 35px rgba(102,187,106,0.2);
                  }
                  .animal-img {
                    width: 100%;
                    height: 220px;
                    object-fit: cover;
                  }
                  .animal-body { padding: 25px; }
                  .animal-body h3 { font-size: 1.5em; color: #a5d6a7; margin-bottom: 5px; }
                  .animal-body .scientific { font-style: italic; color: #66bb6a; font-size: 0.9em; margin-bottom: 12px; }
                  .animal-body p { color: #c8e6c9; font-size: 0.95em; line-height: 1.7; margin-bottom: 15px; }
                  .tags { display: flex; gap: 8px; flex-wrap: wrap; }
                  .tag {
                    background: #1b5e20;
                    color: #a5d6a7;
                    padding: 4px 12px;
                    border-radius: 20px;
                    font-size: 0.8em;
                    border: 1px solid #2e7d32;
                  }
                  .status-tag {
                    padding: 4px 12px;
                    border-radius: 20px;
                    font-size: 0.8em;
                    font-weight: bold;
                  }
                  .endangered { background: #b71c1c; color: #ffcdd2; }
                  .vulnerable { background: #e65100; color: #ffe0b2; }
                  .stable { background: #1b5e20; color: #c8e6c9; }

                  .stats {
                    background: #0a1a0b;
                    padding: 60px 20px;
                    text-align: center;
                    border-top: 2px solid #2e7d32;
                    border-bottom: 2px solid #2e7d32;
                  }
                  .stats h2 { font-size: 2em; color: #66bb6a; margin-bottom: 40px; }
                  .stats-grid {
                    display: flex;
                    justify-content: center;
                    gap: 40px;
                    flex-wrap: wrap;
                  }
                  .stat-item { min-width: 150px; }
                  .stat-item .number { font-size: 3em; color: #a5d6a7; font-weight: bold; }
                  .stat-item .label { color: #81c784; font-size: 0.95em; margin-top: 5px; }

                  .facts {
                    max-width: 1000px;
                    margin: 60px auto;
                    padding: 0 20px;
                  }
                  .fact-item {
                    background: #1a2e1b;
                    border-left: 5px solid #66bb6a;
                    padding: 20px 25px;
                    margin-bottom: 20px;
                    border-radius: 8px;
                  }
                  .fact-item h4 { color: #a5d6a7; font-size: 1.1em; margin-bottom: 8px; }
                  .fact-item p { color: #c8e6c9; line-height: 1.7; }

                  footer {
                    background: #0a1a0b;
                    color: #66bb6a;
                    text-align: center;
                    padding: 35px;
                    border-top: 3px solid #2e7d32;
                  }
                  footer p { margin: 6px 0; opacity: 0.8; }
                </style>
              </head>
              <body>

                <header>
                  <h1>🌿 Wild Animals Portfolio</h1>
                  <p>Exploring the Magnificent Creatures of the Wild</p>
                </header>

                <nav>
                  <a href="#">Home</a>
                  <a href="#">Animals</a>
                  <a href="#">Facts</a>
                  <a href="#">Conservation</a>
                  <a href="#">Contact</a>
                </nav>

                <div class="hero">
                  <div class="hero-text">
                    <h2>Discover the Wild</h2>
                    <p>A journey through nature's most extraordinary creatures</p>
                  </div>
                </div>

                <h2 class="section-title">🐾 Featured Animals</h2>
                <p class="section-subtitle">Learn about the world's most fascinating wild animals</p>

                <div class="animals-grid">

                  <div class="animal-card">
                    <img class="animal-img" src="https://images.unsplash.com/photo-1557050543-4d5f4e07ef46?w=600" alt="Lion"/>
                    <div class="animal-body">
                      <h3>🦁 Lion</h3>
                      <div class="scientific">Panthera leo</div>
                      <p>Known as the King of the Jungle, lions are social big cats living in groups called prides. They are found primarily in sub-Saharan Africa and are apex predators.</p>
                      <div class="tags">
                        <span class="tag">🌍 Africa</span>
                        <span class="tag">Carnivore</span>
                        <span class="tag">180–250 kg</span>
                        <span class="status-tag vulnerable">Vulnerable</span>
                      </div>
                    </div>
                  </div>

                  <div class="animal-card">
                    <img class="animal-img" src="https://images.unsplash.com/photo-1551969014-7d2c4cddf0b6?w=600" alt="Tiger"/>
                    <div class="animal-body">
                      <h3>🐯 Tiger</h3>
                      <div class="scientific">Panthera tigris</div>
                      <p>The largest wild cat species, tigers are solitary hunters with distinctive orange coats and black stripes. They are native to Asia and excellent swimmers.</p>
                      <div class="tags">
                        <span class="tag">🌏 Asia</span>
                        <span class="tag">Carnivore</span>
                        <span class="tag">90–310 kg</span>
                        <span class="status-tag endangered">Endangered</span>
                      </div>
                    </div>
                  </div>

                  <div class="animal-card">
                    <img class="animal-img" src="https://images.unsplash.com/photo-1564760055775-d63b17a55c44?w=600" alt="Elephant"/>
                    <div class="animal-body">
                      <h3>🐘 Elephant</h3>
                      <div class="scientific">Loxodonta africana</div>
                      <p>The largest land animals on Earth, elephants are highly intelligent and live in matriarchal herds. They use their trunks for communication, feeding, and drinking.</p>
                      <div class="tags">
                        <span class="tag">🌍 Africa</span>
                        <span class="tag">Herbivore</span>
                        <span class="tag">4000–7000 kg</span>
                        <span class="status-tag vulnerable">Vulnerable</span>
                      </div>
                    </div>
                  </div>

                  <div class="animal-card">
                    <img class="animal-img" src="https://images.unsplash.com/photo-1547036967-23d11aacaee0?w=600" alt="Wolf"/>
                    <div class="animal-body">
                      <h3>🐺 Wolf</h3>
                      <div class="scientific">Canis lupus</div>
                      <p>Wolves are highly social animals that live and hunt in packs. They are known for their howling communication and play a vital role in maintaining ecosystem balance.</p>
                      <div class="tags">
                        <span class="tag">🌎 Americas</span>
                        <span class="tag">Carnivore</span>
                        <span class="tag">30–80 kg</span>
                        <span class="status-tag stable">Least Concern</span>
                      </div>
                    </div>
                  </div>

                  <div class="animal-card">
                    <img class="animal-img" src="https://images.unsplash.com/photo-1503066211613-c17ebc9daef0?w=600" alt="Cheetah"/>
                    <div class="animal-body">
                      <h3>🐆 Cheetah</h3>
                      <div class="scientific">Acinonyx jubatus</div>
                      <p>The fastest land animal on Earth, cheetahs can reach speeds of up to 112 km/h in short bursts. Unlike other big cats, they cannot roar but can purr.</p>
                      <div class="tags">
                        <span class="tag">🌍 Africa</span>
                        <span class="tag">Carnivore</span>
                        <span class="tag">21–72 kg</span>
                        <span class="status-tag vulnerable">Vulnerable</span>
                      </div>
                    </div>
                  </div>

                  <div class="animal-card">
                    <img class="animal-img" src="https://images.unsplash.com/photo-1607462109225-6b64ae2dd3cb?w=600" alt="Gorilla"/>
                    <div class="animal-body">
                      <h3>🦍 Gorilla</h3>
                      <div class="scientific">Gorilla beringei</div>
                      <p>Gorillas are the largest living primates and share 98.3% of their DNA with humans. They live in family groups led by a dominant silverback male.</p>
                      <div class="tags">
                        <span class="tag">🌍 Africa</span>
                        <span class="tag">Herbivore</span>
                        <span class="tag">70–200 kg</span>
                        <span class="status-tag endangered">Endangered</span>
                      </div>
                    </div>
                  </div>

                </div>

                <div class="stats">
                  <h2>🌍 Wildlife By Numbers</h2>
                  <div class="stats-grid">
                    <div class="stat-item">
                      <div class="number">8.7M</div>
                      <div class="label">Species on Earth</div>
                    </div>
                    <div class="stat-item">
                      <div class="number">41,415</div>
                      <div class="label">Species Assessed by IUCN</div>
                    </div>
                    <div class="stat-item">
                      <div class="number">16,306</div>
                      <div class="label">Threatened Species</div>
                    </div>
                    <div class="stat-item">
                      <div class="number">785</div>
                      <div class="label">Species Already Extinct</div>
                    </div>
                  </div>
                </div>

                <h2 class="section-title">📖 Interesting Facts</h2>
                <p class="section-subtitle">Amazing things about wild animals you may not know</p>

                <div class="facts">
                  <div class="fact-item">
                    <h4>🦁 Lions sleep up to 20 hours a day</h4>
                    <p>Lions conserve their energy for hunting and are most active during dawn and dusk. A pride of lions can consume up to 30 kg of meat in a single meal.</p>
                  </div>
                  <div class="fact-item">
                    <h4>🐘 Elephants never forget</h4>
                    <p>Elephants have exceptional memory and can remember individuals and locations for decades. They are one of the few animals known to show empathy and mourn their dead.</p>
                  </div>
                  <div class="fact-item">
                    <h4>🐯 No two tigers have the same stripes</h4>
                    <p>Just like human fingerprints, every tiger has a unique stripe pattern. Tigers are also the only big cats that actively seek out water and are strong swimmers.</p>
                  </div>
                  <div class="fact-item">
                    <h4>🐆 Cheetahs use their tail as a rudder</h4>
                    <p>While running at high speeds, cheetahs use their long tail for balance and to make sharp turns. They need only 3 stri