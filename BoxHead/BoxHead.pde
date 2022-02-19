ArrayList<Enemy> enemies;
boolean gameActive, win, waveComplete, menuDisplay;
int menuTextTime, menuTextCD;
int level, currentWave, currentEnemies, remainingEnemies;
int totalKills, totalShots, score, state, startTime;
int hitTime, hitTimeCD;
ArrayList<Projectile> projectiles;
final int displayTime = 1000;
Player playerCharacter;
XML xml;
XML[] waves;
boolean upPressed, leftPressed, downPressed, rightPressed;

void setup() {
  size(1280, 960);
  xml = loadXML("waves.xml");
  waves = xml.getChildren("wave");
  gameActive = false;
  state = 0;
  menuTextCD = 1000;
  hitTimeCD = 800;
  upPressed = leftPressed = downPressed = rightPressed = false;
}

void draw() {
  background(0);
  if (state == 0) {
    drawMenu();
  } 
    if (state == 1) {
    drawGame();
  } else if (state == 2) {
    gameOver();
  }
}

// Draws Menu screen
void drawMenu() {
  textAlign(CENTER);
  rectMode(CENTER);

  if (millis() - menuTextTime > menuTextCD) {
    menuDisplay = !menuDisplay;
    menuTextTime = millis();
  }
  if (menuDisplay == true) {
    textSize(40);
    text("-- Click anywhere on the screen --", width/2, height/2 - 50);
    text("-- Then press ENTER to Start --", width/2, height/2 );
  } 

  textSize(90);
  fill(#FF0000);
  text("Boxhead", width/2, height/2 - 100);
  fill(255);
  textSize(20);
  text("Controls: ", width/2, height/2 + 200);
  stroke(255);  
  strokeWeight(3);
  line(width/2 + 130 , height/2 + 210, width/2 - 130, height/2 + 210);
  textSize(20);
  text("W A S D / Arrow Keys: Move", width/2, height/2 + 250);
  text("Mouse: Aim and Shoot", width/2, height/2 + 300);
  stroke(255);
  strokeWeight(3); 
}
// Draws game over screen
void gameOver() {
  textSize(50);
  if (win) {
    fill(#00F00D);
    text("Congratulations! You Win!", width/2, height/2 - 100);
  } else {
    fill(#FF0000);
    text("Game Over", width/2, height/2 - 100);
  }
  fill(255);
  textSize(40);
  text("Survived until Wave " + currentWave, width/2, height/2 - 50);
  text("-- Press ENTER to Restart --", width/2, height/2);
  textSize(30);
  text("Total  Kills: " + totalKills, width/2, height/2 + 100);
  text("Shots Fired: " + totalShots, width/2, height/2 + 150);
  text("Hit Accuracy: " + round(((float)totalKills / (float) totalShots)*100) + "%", width/2, height/2 + 200);
  textSize(38);
  text("Final Score: " + score, width/2, height/2 + 300);
}

// Draws all game components
void drawGame() {
  if (!gameActive) {
    initializeGame();
  }
  playerCharacter.update();
  updateProjectiles();
  pushMatrix();
  drawPlayer();
  popMatrix();
  updateEnemies();
  collisionProjectiles();
  drawText();
}

// Initializes all global variables for a new wave
void initializeGame() {
  enemies = new ArrayList<Enemy>();
  projectiles = new ArrayList<Projectile>();
  currentWave = waves[level].getInt("id");
  currentEnemies = waves[level].getInt("enemies");
  remainingEnemies = currentEnemies;
  gameActive = true;
}

void drawPlayer() {
  fill(playerCharacter.fill);
  stroke(playerCharacter.stroke);
  playerCharacter.angle = atan2(playerCharacter.location.x - mouseX, playerCharacter.location.y - mouseY);
  translate(playerCharacter.location.x, playerCharacter.location.y);
  strokeWeight(4);
  rect(0, 0, 40, 40);
}

// Draws game text 
void drawText() {
  textSize(30);
  fill(255);
  textAlign(CENTER);

  //TOP TEXT
  text("Health", width*.25, 30);
  stroke(255, 0, 0);
  fill(255, 0, 0, 90);
  for (int i = 0; i < playerCharacter.health; i++) {
    rect(width*.22 + (40 * i), 50, 30, 30);
  }
  fill(255);
  text("Score", width/2, 30); 
  text(score, width/2, 70);
  text("Remaining  Enemies:", width*.75, 30); 
  text(remainingEnemies, width*.75, 70);

  //BOTTOM TEXT
  text("Wave", width/2, height - 70); 
  text(currentWave, width/2, height - 30);

  if (waveComplete) {
    fill(#ffffff); 
    textSize(60);
    text("Wave Complete", width/2, height/2);

    if (millis() - startTime > displayTime)
    { 
       if (playerCharacter.health == 5){
          playerCharacter.setHealth(6);
      }  
    else if (playerCharacter.health == 4){
          playerCharacter.setHealth(5);
      } 
     else   if (playerCharacter.health == 3){
          playerCharacter.setHealth(4);
      } 
    else   if (playerCharacter.health == 3){
          playerCharacter.setHealth(2);
      } 
     else if (playerCharacter.health == 1){
          playerCharacter.setHealth(2);
      } 
      playerCharacter.projectileCD -= 25; //change this number to make game easier :) 
      waveComplete = false;
    }
  }
}

void keyPressed() {
    if (state == 0 && (key == RETURN || key == ENTER)) {
      state = 1;
      playerCharacter = new Player();
      playerCharacter.location = new PVector(width/2, height/2);
      totalKills = 0;
      level = 0;
      score = 0;
      totalShots = 0;
    }
  if (state == 1) {
    switch(key) {
      case('w') : 
      case('W') :
      upPressed = true;
      break; 
      case('a') : 
      case('A') : 
      leftPressed = true;      
      break; 
      case('s') : 
      case('S') :
      downPressed = true;      
      break; 
      case('d') : 
      case('D') : 
      rightPressed = true;      
      break;
    }
    if (keyCode == UP) {
      upPressed = true;
    } else if (keyCode == LEFT) {
      leftPressed = true;
    } else if (keyCode == DOWN) {
      downPressed = true;
    } else if (keyCode == RIGHT) {
      rightPressed = true;
    }
  } else if (state == 2 && (key == RETURN || key == ENTER)) {
    state = 0;
  }
}

void keyReleased() {
  switch(key) {
    case('w') : 
    case('W') :
    upPressed = false;
    break; 
    case('a') : 
    case('A') : 
    leftPressed = false;      
    break; 
    case('s') : 
    case('S') :
    downPressed = false;      
    break; 
    case('d') : 
    case('D') : 
    rightPressed = false;      
    break;
  }
  if (keyCode == UP) {
    upPressed = false;
  } else if (keyCode == LEFT) {
    leftPressed = false;
  } else if (keyCode == DOWN) {
    downPressed = false;
  } else if (keyCode == RIGHT) {
    rightPressed = false;
  }
}
  void updateProjectiles() {
  for (int i = 0; i < projectiles.size (); i++) {
    Projectile p = projectiles.get(i);
    p.update();

    if (p.location.x < 0 || p.location.x > width || p.location.y < 0 || p.location.y > height || p.active == false) {
      projectiles.remove(i);
    }
  }
  }  
  void updateEnemies() {
  int m = millis();
  if (m % 10 == 0 && currentEnemies > 0) {
    spawnEnemy();
  }
  for (int i = 0; i < enemies.size (); i++) {
    Enemy e = enemies.get(i);
    e.update();
  }
  if (remainingEnemies == 0 && level < waves.length - 1) {
    level++;
    startTime = millis();
    gameActive = false;
    waveComplete = true;
  } else if (remainingEnemies == 0 && level == waves.length - 1) {     // All levels beaten
    gameActive = false;
    win = true;
    state = 2;
  }
}

// Spawns a new enemy in one of 4 sections off screen
void spawnEnemy() {
  int r = (int) random(0, 4);
  color c = color(0, 255, 0);
  if (r == 0) {
    enemies.add(new Enemy(new PVector(random(-200, 0), random(-200, height)), playerCharacter, c));
  } else if (r == 1) {
    enemies.add(new Enemy(new PVector(random(width, width ), random(-200, height)), playerCharacter, c));
  } else if (r == 2) {
    enemies.add(new Enemy(new PVector(random(width , width ), random(height, 200)), playerCharacter, c));
  } else {
    enemies.add(new Enemy(new PVector(random(width , width ), random(-200, 0)), playerCharacter, c));
  }
  currentEnemies--;
}

// Helper function for simplifying collision detection
boolean checkCollision(float x, float y, float x2, float y2, float r) {
  if (dist(x, y, x2, y2) < r) {
    return true;
  } else {
    return false;
  }
}

void collisionProjectiles() {
  for (int i = projectiles.size () - 1; i >= 0; i--) {
    for (int j = enemies.size () - 1; j >= 0; j--) {
      Projectile p = projectiles.get(i);
      Enemy e = enemies.get(j);
      if (p.active && e.active && checkCollision(p.location.x, p.location.y, e.location.x, e.location.y, 20)) {
        totalKills++;
        score += 100;
        remainingEnemies--;
        p.active = false;
        e.active = false;
      }
    }
  }
}
