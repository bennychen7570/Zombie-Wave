class Projectile {
  Player p;
  color projectileFill;
  PVector location, trajectory, mouseLoc; 
  float speed; 
  int size;
  boolean active;
  
  
  Projectile(Player p, color projectileFill, PVector location, PVector mouseLoc) {
    this.p = p;
    this.location = location; 
    this.mouseLoc = mouseLoc; 
    active = true;
    speed = 12; 
    size = 7;
    this.projectileFill = projectileFill;
    trajectory = PVector.sub(mouseLoc, location); 
    trajectory.normalize(); 
    trajectory.mult(speed);
  } 

  void update() {
    if (active) {
      location.add(trajectory); 
      stroke(projectileFill); 
      fill(projectileFill); 
      ellipse(location.x, location.y, size, size);
    }
  }
  
  }
