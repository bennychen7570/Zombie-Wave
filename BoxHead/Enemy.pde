class Enemy {
  PVector location, direction; 
  Player p;
  int size, speed;
  boolean active;
  color fill;

  Enemy(PVector location, Player p, color fill) {
    this.location = location;
    this.p = p;
    size = 40;
    speed = (int) random(2, 4);
    active = true;
    direction = new PVector(0, 0);
    this.fill = fill;
  }

  void update() {
    if (active) {
      stroke(1, 82, 0); 
      fill(fill); 

      if (dist(p.location.x, p.location.y, location.x, location.y) > 50) {
        direction.x = p.location.x - location.x;
        direction.y = p.location.y - location.y;
        direction.normalize();
        location.x += direction.x * speed;
        location.y += direction.y * speed;
      } else {
        if (p.hitCooldown == false) {
           p.health--;
          hitTime = millis();
          p.hitCooldown = true;
        }
      }
      rect(location.x, location.y, size, size);
    }
  }

}
