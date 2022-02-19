class Player {
  PVector location; 
  int movementSpeed;
  float angle;
  color fill, stroke, projectileFill;
  int health, maxHealth, lastProjectileTime, projectileCD, ammo;
  boolean hitCooldown = false;

  Player() {
    movementSpeed = 5; 
    angle = 0; 
    stroke = color(#FFFFFF);
    fill = color(0);
    health = 6;
    maxHealth = health;
    projectileCD = 250;
    projectileFill = color(255);
  }

  void update() {
    // Handles Movement and constrains player to the screen
    if (upPressed && location.y - movementSpeed > 0) {
      location.y -= movementSpeed;
    } 
    if (leftPressed && location.x - movementSpeed > 0) { 
      location.x -= movementSpeed;
    } 
    if (downPressed && location.y + movementSpeed < height) {
      location.y += movementSpeed;
    } 
    if (rightPressed && location.x + movementSpeed < width) {
      location.x += movementSpeed;
    }

    // Provides a hit cooldown so player cannot die instantaneously
    if (hitCooldown) {
      playerCharacter.stroke = color(255, 0, 0);
      if (millis() - hitTime > hitTimeCD) {
        hitCooldown = false;
        playerCharacter.stroke = color(255);
      }
    }

    // If the player loses all their health, game over
    if (health <= 0) {
      gameActive = false;
      win = false;
      state = 2  ;
    }
if (mousePressed) {
      if (millis() - lastProjectileTime > projectileCD) {
        PVector mouseLoc = new PVector(mouseX, mouseY);
        PVector initialLoc = new PVector(location.x, location.y);
        projectiles.add(new Projectile(playerCharacter, projectileFill, initialLoc, mouseLoc));
        totalShots++;
        if (ammo > 0) {
          ammo--;
          if (ammo == 0) {
            projectileCD = 250;
            projectileFill = color(255);
          }
        }
        lastProjectileTime = millis();
      }
    }
  }
  void setHealth(int x){
      health = x;
  }
}
