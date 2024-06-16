
import processing.sound.*;
Sound globalSound;

//kratos arrays
PImage[] kratosIdle = new PImage[6];
PImage[] kratosRunning = new PImage[9];
PImage[] kratosAttack = new PImage[24];
PImage[] kratosJump = new PImage[8];
PImage kratosBlocking;

//skeleton arrays
PImage[] skeletonIdle = new PImage[5];
PImage[] skeletonFight = new PImage[4];
PImage[] skeletonDead = new PImage[7];
PImage[] skeletonWalking = new PImage[9];

//argos arrays
PImage[] argosFight = new PImage[6];
PImage[] argosDead = new PImage[4];
PImage[] argosWalking = new PImage[7];

IntList groundX = new IntList();
IntList groundY  = new IntList();
IntList groundZ = new IntList();

IntList wallX = new IntList();
IntList wallY  = new IntList();
IntList wallZ = new IntList();

Kratos player = new Kratos();

//maps
PImage[] maps = new PImage[3];

//menu Video
//PImage[] video = new PImage[1067];
PImage[] video = new PImage[1];

SoundFile page, titleMusic;
PImage title, back, vol, UI;
PFont font;

int[] kratosHitBox = {player.x, player.y, 65, 100};


Skeleton[] skeletons = new Skeleton[1];
Argos[] argos = new Argos[1];


void setup() {

  for (int i = 0; i < skeletons.length; i++) {
    skeletons[i] = new Skeleton(i * 100 + 1000, 400, 470, 1680);
  }

  for (int i = 0; i < argos.length; i++) {
    argos[i] = new Argos(i * 100 + 1000, 400, 470, 1680);
  }

  size(1280, 800);
  vol = loadImage("vol.png");
  UI = loadImage("UI.png");


  //loading image
  font = createFont("GODOFWAR.TTF", 40);
  background(0);
  fill(255);
  textFont(font);
  textAlign(CENTER);
  text("Loading...", width/2, height/2);

  titleMusic = new SoundFile(this, "titleMusic.mp3");
  page = new SoundFile(this, "flip.mp3");
  back = loadImage("back.png");
  title = loadImage("a.png");

  handleGround();
  handleWalls();

  for (int i = 0; i < argosFight.length; i++) {
    argosFight[i] = loadImage("argos_attacking" + (i+7) +".png");
  }

  for (int i = 0; i < argosWalking.length; i++) {
    argosWalking[i] = loadImage("argos_walking" + (i+1) +".png");
  }

  for (int i = 0; i < argosDead.length; i++) {
    argosDead[i] = loadImage("argos_dead" + (i+1) +".png");
  }

  for (int i = 0; i <= kratosIdle.length - 1; i++) {
    kratosIdle[i] = loadImage("Kratos_Idle" + (i + 1) + ".png");
  }

  for (int i = 0; i <= kratosAttack.length - 1; i++) {
    kratosAttack[i] = loadImage("Kratos_Attack" + (i + 1) + ".png");
  }

  for (int i = 0; i <= kratosRunning.length - 1; i++) {
    kratosRunning[i] = loadImage("Kratos_Running" + (i + 1) + ".png");
  }

  for (int i = 0; i <= kratosJump.length - 1; i++) {
    kratosJump[i] = loadImage("Kratos_Jump" + (i + 1) + ".png");
  }

  for (int i = 0; i < skeletonIdle.length; i++) {
    skeletonIdle[i] = loadImage("skeleteon_idle" + (i + 1) + ".png");
  }

  for (int i = 0; i < skeletonWalking.length; i++) {
    skeletonWalking[i] = loadImage("skeleteon_walking" + (i+1) + ".png");
  }

  for (int i = 0; i < skeletonFight.length; i++) {
    skeletonFight[i] = loadImage("skeleteon_fight" + (i+1) +".png");
  }

  for (int i = 0; i < skeletonDead.length; i++) {
    skeletonDead[i] = loadImage("skeleteon_dead" + (i+1) + ".png");
  }

  kratosBlocking = loadImage("Kratos_Block.png");


  for (int i = 0; i < video.length; i++) {
    if (i >= 0 && i  < 9) {
      video[i] = loadImage("title0000" + (i + 1) + ".png");
    } else if (i >= 9 && i  < 99) {
      video[i] = loadImage("title000" + (i + 1) + ".png");
    } else if (i >= 99 && i  < 999) {
      video[i] = loadImage("title00" + (i + 1) + ".png");
    } else if (i >= 999 && i < 9999) {
      video[i] = loadImage("title0" + (i + 1) + ".png");
    }
  }

  for (int i = 0; i < maps.length; i++) {
    maps[i] = loadImage("map" + (i + 1) + ".png");
  }

  //titleMusic.loop();
}



void draw() {


  if (gameMode == 1) {
    handleScene();
  }
  //handleMenu();
  if (gameMode == 1) {
    handleUI();
    handleJumpMovement();
    handlePlayer();

    //showHitBoxes();
    handleEnemies();
  }

  if (!player.alive) {
    handleDeathScreen();
  }
}

int map = 0;
int dir = 1;
int imageCenter;
float act = 0;
int gravity = 0;
boolean grounded = false;


int skeletonDir = -1;

void handleDeathScreen() {
  opacity = true;
  tint(255, tint);
  fill(0, tint);
  rect(0, 0, width, height);
  textMode(CENTER);
  fill(255, 0, 0);
  text("YOU ARE DEAD", width/2, height/2);

  text("QUIT", width/2, height/2 + 200);
  if (mouseIn(560, 570, 160, 40)) {
    if (mousePressed && mouseButton == LEFT) {

      exit();
    }
  }
}
int argosDir = 1;

void handleEnemies() {

  //argos
  for (int i = 0; i < argos.length; i++) {
    enemiesDead = true;
    if (argos[i].alive) {
      enemiesDead = false;
      break;
    }
  }

  for (int i = 0; i < argos.length; i++) {

    if (argos[i].action != "dying") {
      argos[i].x += argos[i].knockBack;
      if (argos[i].knockBack > 0) {
        argos[i].knockBack--;
      } else if (argos[i].knockBack <0) {
        argos[i].knockBack++;
      }

      if (argos[i].x - globalX <= argos[i].rangeX1 - globalX) {
        argos[i].x = argos[i].rangeX1;
      } else if (argos[i].x - globalX >= argos[i].rangeX2 - globalX) {
        argos[i].x = argos[i].rangeX2;
      }
    }

    if (argos[i].alive) {
      if (argos[i].action != "dying") {
        if (argosDir == 1) {
          argos[i].hitBox[0] = argos[i].x - globalX - 30;
          argos[i].hitBox[1] = argos[i].y + globalY;
        } else if (argosDir == -1) {
          argos[i].hitBox[0] = argos[i].x - globalX - 30;
          argos[i].hitBox[1] = argos[i].y + globalY;
        }
        //handle healthbars

        strokeWeight(1);
        fill(0, 100);
        rect(argos[i].x - globalX - 50, argos[i].y + globalY - 60, 120, 10);

        fill(#49F900, 100);
        rect(argos[i].x - globalX - 50, argos[i].y + globalY - 60, float(argos[i].health)/float(argos[i].maxHealth) * 120, 10);



        //handle walking

        if (hitBox(kratosHitBox, argos[i].hitBox) && player.x > argos[i].x) {
          if (argos[i].action != "fight") {
            argos[i].action = "fight";
            argos[i].act = 0;
            argosDir = 1;
          }
        } else if (hitBox(kratosHitBox, argos[i].hitBox) && player.x < argos[i].x) {
          if (argos[i].action != "fight") {
            argos[i].action = "fight";
            argos[i].act = 0;
            argosDir = -1;
          }
        } else if (argos[i].action == "walking") {


          if (argos[i].x - globalX < player.x) {

            if (argos[i].x - globalX <= argos[i].rangeX2 - globalX) {
              argos[i].x += argos[i].speed;
            } else {
              argos[i].x = argos[i].rangeX2;
            }

            argos[i].hitBox[0] = argos[i].x - globalX - 20;
            argos[i].hitBox[1] = argos[i].y + globalY;
            switch(argos[i].action) {
            case "walking":
              if (argos[i].act > argosWalking.length -1 ) {
                argos[i].act = 0;
              }
              image(argosWalking[int(argos[i].act)], argos[i].x - globalX -30, argos[i].y + globalY - 20, argosWalking[0].width * 1.5, argosWalking[0].height * 1.5);

              argos[i].act += 0.4;

              if (argos[i].x - globalX >= argos[i].rangeX2 - globalX) {
                argos[i].act = 4;
              }
              break;
            }
          } else if (argos[i].x - globalX > player.x) {

            if (argos[i].x - globalX >= argos[i].rangeX1 - globalX) {
              argos[i].x -= argos[i].speed;
            } else {
              argos[i].x = argos[i].rangeX1;
            }



            switch(argos[i].action) {
            case "walking":
              if (argos[i].act > argosWalking.length -1 ) {
                argos[i].act = 0;
              }
              pushMatrix();
              scale(-1, 1);
              image(argosWalking[int(argos[i].act)], (argos[i].x - globalX) * -1 - argosWalking[0].width, argos[i].y + globalY - 20, argosWalking[0].width * 1.5, argosWalking[0].height * 1.5);
              popMatrix();



              if (argos[i].x - globalX <= argos[i].rangeX1 - globalX) {
                argos[i].act = 4;
              }
              argos[i].act += 0.4;


              break;
            }
          }
        }



        if (argos[i].action == "fight") {

          if (argos[i].act > argosFight.length - 1) {
            argos[i].action = "walking";

            if (hitBox(kratosHitBox, argos[i].hitBox)) {
               
              
              if(argos[i].x - globalX > player.x){
                argosDir = -1;
              } else {
                argosDir = 1;
              }
              
              argos[i].attack(argos[i].damage);
            }
          }

          if (player.x >= argos[i].x - globalX) {
            image(argosFight[int(argos[i].act)], argos[i].x - globalX - 30, argos[i].y + globalY - argosFight[int(argos[i].act)].height + 60, argosFight[int(argos[i].act)].width * 1.4, argosFight[int(argos[i].act)].height * 1.6);
          } else {
            pushMatrix();
            scale(-1, 1);
            image(argosFight[int(argos[i].act)], (argos[i].x - globalX) * -1 - argosWalking[0].width, argos[i].y + globalY - argosFight[int(argos[i].act)].height + 60, argosFight[int(argos[i].act)].width * 1.6, argosFight[int(argos[i].act)].height * 1.6);
            popMatrix();
          }


          argos[i].act += 0.6;
        }
      } else {

        if (argos[i].act > argosDead.length - 1) {
          argos[i].alive = false;
        }

        pushMatrix();
        scale(argosDir, 1);
        image(argosDead[int(argos[i].act)], (argos[i].x - globalX) * argosDir - argosWalking[0].width, argos[i].y + globalY - argosDead[int(argos[i].act)].height + 80, argosDead[int(argos[i].act)].width * 1.4, argosDead[int(argos[i].act)].height * 1.4);
        popMatrix();

        argos[i].act += 0.4;
      }
    }
  }

  //skeletons
  for (int i = 0; i < skeletons.length; i++) {
    enemiesDead = true;
    if (skeletons[i].alive) {
      enemiesDead = false;
      break;
    }
  }

  for (int i = 0; i < skeletons.length; i++) {

    if (skeletons[i].action != "dying") {
      skeletons[i].x += skeletons[i].knockBack;
      if (skeletons[i].knockBack > 0) {
        skeletons[i].knockBack--;
      } else if (skeletons[i].knockBack <0) {
        skeletons[i].knockBack++;
      }
      
        if (skeletons[i].x - globalX <= skeletons[i].rangeX1 - globalX) {
        skeletons[i].x = skeletons[i].rangeX1;
      } else if (skeletons[i].x - globalX >= skeletons[i].rangeX2 - globalX) {
        skeletons[i].x = skeletons[i].rangeX2;
      }
    }

    if (skeletons[i].alive) {
      if (skeletons[i].action != "dying") {
        if (skeletonDir == 1) {
          skeletons[i].hitBox[0] = skeletons[i].x - globalX - 30;
          skeletons[i].hitBox[1] = skeletons[i].y + globalY;
        } else if (skeletonDir == -1) {
          skeletons[i].hitBox[0] = skeletons[i].x - globalX - 30;
          skeletons[i].hitBox[1] = skeletons[i].y + globalY;
        }
        //handle healthbars

        strokeWeight(1);
        fill(0, 100);
        rect(skeletons[i].x - globalX - 50, skeletons[i].y + globalY - 35, 120, 10);

        fill(#49F900, 100);
        rect(skeletons[i].x - globalX - 50, skeletons[i].y + globalY - 35, float(skeletons[i].health)/float(skeletons[i].maxHealth) * 120, 10);



        //handle walking

        if (hitBox(kratosHitBox, skeletons[i].hitBox) && player.x > skeletons[i].x) {
          if (skeletons[i].action != "fight") {
            skeletons[i].action = "fight";
            skeletons[i].act = 0;
            skeletonDir = 1;
          }
        } else if (hitBox(kratosHitBox, skeletons[i].hitBox) && player.x < skeletons[i].x) {
          if (skeletons[i].action != "fight") {
            skeletons[i].action = "fight";
            skeletons[i].act = 0;
            skeletonDir = -1;
          }
        } else if (skeletons[i].action == "walking") {

          if (skeletons[i].x - globalX < player.x) {
            if (skeletons[i].x - globalX <= skeletons[i].rangeX2 - globalX) {
              skeletons[i].x += skeletons[i].speed;
            }

            skeletons[i].hitBox[0] = skeletons[i].x - globalX - 20;
            skeletons[i].hitBox[1] = skeletons[i].y + globalY;
            switch(skeletons[i].action) {
            case "walking":
              if (skeletons[i].act > skeletonWalking.length -1 ) {
                skeletons[i].act = 0;
              }
              image(skeletonWalking[int(skeletons[i].act)], skeletons[i].x - globalX -30, skeletons[i].y + globalY, skeletonIdle[0].width * 1.5, skeletonIdle[0].height * 1.5);

              skeletons[i].act += 0.4;
              if (skeletons[i].x - globalX >= skeletons[i].rangeX2 - globalX) {
                skeletons[i].act = 0;
              }

              break;
            }
          } else {

            if (skeletons[i].x - globalX >= skeletons[i].rangeX1 - globalX) {
              skeletons[i].x -= skeletons[i].speed;
            }

            switch(skeletons[i].action) {
            case "walking":
              if (skeletons[i].act > skeletonWalking.length -1 ) {
                skeletons[i].act = 0;
              }
              pushMatrix();
              scale(-1, 1);
              image(skeletonWalking[int(skeletons[i].act)], (skeletons[i].x - globalX) * -1 - skeletonIdle[0].width, skeletons[i].y + globalY, skeletonIdle[0].width * 1.5, skeletonIdle[0].height * 1.5);
              popMatrix();


              skeletons[i].act += 0.4;
              if (skeletons[i].x - globalX <= skeletons[i].rangeX1 - globalX) {

                skeletons[i].act = 0;
              }


              break;
            }
          }
        }



        if (skeletons[i].action == "fight") {

          if (skeletons[i].act > skeletonFight.length - 1) {
            skeletons[i].action = "walking";

            if (hitBox(kratosHitBox, skeletons[i].hitBox)) {

              if(skeletons[i].x - globalX > player.x){
                skeletonDir = -1;
              } else {
                skeletonDir = 1;
              }
              skeletons[i].attack(skeletons[i].damage);
            }
          }

          if (player.x >= skeletons[i].x - globalX) {
            image(skeletonFight[int(skeletons[i].act)], skeletons[i].x - globalX - 30, skeletons[i].y + globalY - skeletonFight[int(skeletons[i].act)].height+ 70, skeletonFight[int(skeletons[i].act)].width * 1.4, skeletonFight[int(skeletons[i].act)].height * 1.4);
          } else {
            pushMatrix();
            scale(-1, 1);
            image(skeletonFight[int(skeletons[i].act)], (skeletons[i].x - globalX) * -1 - skeletonIdle[0].width, skeletons[i].y + globalY - skeletonFight[int(skeletons[i].act)].height + 70, skeletonFight[int(skeletons[i].act)].width * 1.4, skeletonFight[int(skeletons[i].act)].height * 1.4);
            popMatrix();
          }


          skeletons[i].act += 0.6;
        }
      } else {

        if (skeletons[i].act > skeletonDead.length - 1) {
          skeletons[i].alive = false;
        }

        pushMatrix();
        scale(skeletonDir, 1);
        image(skeletonDead[int(skeletons[i].act)], (skeletons[i].x - globalX) * skeletonDir - skeletonIdle[0].width, skeletons[i].y + globalY - skeletonDead[int(skeletons[i].act)].height + 100, skeletonDead[int(skeletons[i].act)].width * 1.4, skeletonDead[int(skeletons[i].act)].height * 1.4);
        popMatrix();

        skeletons[i].act += 0.4;
      }
    }
  }
}


void showHitBoxes() {

  noFill();
  stroke(255, 0, 0);
  strokeWeight(3);
  strokeCap(SQUARE);
  rect(kratosHitBox[0], kratosHitBox[1], kratosHitBox[2], kratosHitBox[3]);

  for (int i = 0; i < skeletons.length; i++) {
    rect(skeletons[i].hitBox[0], skeletons[i].hitBox[1], skeletons[i].hitBox[2], skeletons[i].hitBox[3]);
  }

  for (int i = 0; i < groundX.size(); i++) {

    stroke(255);
    strokeWeight(3);
    line(groundX.get(i) - globalX, groundY.get(i) + globalY + 50, groundZ.get(i) - globalX, groundY.get(i) + globalY + 50);
  }

  for (int i = 0; i < wallX.size(); i++) {

    stroke(#FFED1F);
    strokeWeight(3);
    line(wallX.get(i) - globalX, wallY.get(i) + globalY + 50, wallX.get(i) - globalX, wallZ.get(i) + globalY + 50);
  }
}

void handleGround() {

  if (map == 0) {
    makePlatform(465, 450, 1740);
    makePlatform(0, 480, 200);
    makePlatform(1740, 395, 2100);
    makePlatform(2100, 520, 2590);
    makePlatform(2590, 560, 2900);
  } else if (map == 1) {
  } else if (map == 2) {
    makePlatform(0, 450, 3000);
  }
}

void clearCollisions() {
  wallX.clear();
  wallY.clear();
  wallZ.clear();
  groundX.clear();
  groundY.clear();
  groundZ.clear();
}

void handleWalls() {

  if (map == 0) {
    makeWall(1740, 450, 395);
    makeWall(2100, 520, 395);
    makeWall(2100, 520, 395);
    makeWall(2590, 560, 510);

    //door
    makeWall(2900, 560, 200);

    makeWall(0, 520, 200);
  } else if (map == 1) {
  } else if (map == 2) {
  }
}

void handleJumpMovement() {


  if (player.action.equals("jumping")) {
    if (gravity > 0) {
      grounded = false;
    }
    if (gravity > -30) {
      gravity-= 2;
    }
  }
}

boolean enemiesDead = false;
void handlePlayer() {


  player.alive = player.health >= 0 && player.y < 1000;

  if (player.knockBack > 0) {
    player.knockBack--;
  } else if (player.knockBack < 0) {
    player.knockBack++;
  }



  if (globalX > 0 && player.x == 450) {
    globalX += player.knockBack;
  } else {
    player.x += player.knockBack;
  }

  if (moveLeft) {
    if (!player.action.equals("jumping") && !player.action.equals("running")) {
      player.action = "running";
    }
    if (globalX > 0 && player.x == 450) {
      globalX -= player.speed;
    } else {
      player.x -= player.speed;
    }
    kratosHitBox[0] = player.x;
    kratosHitBox[1] = player.y;
  }

  if (moveRight) {
    if (!player.action.equals("jumping") && !player.action.equals("running")) {
      player.action = "running";
    }
    if (player.x == 450 && globalX < lastX) {
      globalX += player.speed;
    } else {
      player.x += player.speed;
    }
    kratosHitBox[0] = player.x;
    kratosHitBox[1] = player.y;
  }


  for (int i = 0; i < wallX.size(); i++) {
    if (collision(i, 50)) {
      if (i == 4 && enemiesDead) {
        map = 2;
        clearCollisions();
        handleWalls();
        handleGround();
        globalX = 0;
        globalY = 2000;

        player.x = 450;
        player.y = 400;

        break;
      }
      if (dir == 1) {

        if (player.x == 450) {
          globalX = wallX.get(i) - (player.x + 65);
        } else {
          player.x = wallX.get(i) - (globalX + 65);
        }
      } else {

        if (player.x == 450) {
          globalX = wallX.get(i) - (player.x);
        } else {
          player.x = wallX.get(i) - (globalX);
        }
      }
      break;
    }
  }




  if (player.x > 450 && globalX < lastX) {
    player.x = 450;
  } else if (player.x < 450 && globalX == lastX) {
    player.x = 450;
  }
  if (moveRight) {
    dir = 1;
    imageCenter = 0;
  } else if (moveLeft) {
    dir = -1;
    imageCenter = kratosIdle[0].width;
  }


  switch(player.action) {
  case "idle":
    if (act > kratosIdle.length - 1) {
      act = 0;
    }
    pushMatrix();
    scale(dir, 1);
    image(kratosIdle[int(act)], player.x * dir - imageCenter, player.y + 50 - kratosIdle[int(act)].height, 2 * kratosIdle[int(act)].width, 2 * kratosIdle[int(act)].height);
    popMatrix();
    act += 0.25;

    break;
  case "running":
    if (act > kratosRunning.length - 1) {
      act = 0;
    }
    pushMatrix();
    scale(dir, 1);
    image(kratosRunning[int(act)], player.x * dir - imageCenter, player.y + 50 - kratosRunning[int(act)].height, 2 * kratosRunning[int(act)].width, 2 * kratosRunning[int(act)].height);
    popMatrix();
    act += 0.5;



    break;
  case "blocking":
    pushMatrix();
    scale(dir, 1);
    image(kratosBlocking, player.x * dir - imageCenter, player.y + 50 - kratosBlocking.height, 2 * kratosBlocking.width + 5, 2 * kratosBlocking.height -10);
    popMatrix();
    break;
  case "jumping":
    if (act > kratosJump.length - 1) {
      act = kratosJump.length - 1;
    }
    pushMatrix();
    scale(dir, 1);
    image(kratosJump[int(act)], player.x * dir - imageCenter, player.y + 50 - kratosJump[int(act)].height, 2 * kratosJump[int(act)].width, 2 * kratosJump[int(act)].height);
    popMatrix();
    act += 0.5;
    break;

  case "attack":

    switch(player.whichAttack) {

    case 1:

      if (act > 3) {
        act = 0;
        player.action = "idle";
        player.attack();
      }
      pushMatrix();
      scale(dir, 1);
      image(kratosAttack[int(act)], player.x * dir - imageCenter, player.y + 50 - kratosAttack[int(act)].height, 2 * kratosAttack[int(act)].width, 2 * kratosAttack[int(act)].height);
      popMatrix();
      act+= 0.6;

      break;

    case 2:

      if (act > 8) {
        act = 0;
        player.action = "idle";
        player.attack();
      }
      pushMatrix();
      scale(dir, 1);
      image(kratosAttack[int(act)], player.x * dir - imageCenter, player.y + 50 - kratosAttack[int(act)].height, 2 * kratosAttack[int(act)].width, 2 * kratosAttack[int(act)].height);
      popMatrix();
      act+= 0.6;

      break;

    case 3:

      if (act > 15) {
        act = 0;
        player.action = "idle";
        player.attack();
      }
      pushMatrix();
      scale(dir, 1);
      image(kratosAttack[int(act)], player.x * dir - imageCenter, player.y + 50 - kratosAttack[int(act)].height - (kratosAttack[int(act)].height - kratosAttack[0].height), 2 * kratosAttack[int(act)].width, 2 * kratosAttack[int(act)].height);
      popMatrix();
      act+= 0.6;


      break;

    case 4:

      if (act > 23) {
        act = 0;
        player.action = "idle";
        player.whichAttack = 0;
        player.attack();
      }
      pushMatrix();
      scale(dir, 1);
      image(kratosAttack[int(act)], player.x * dir - imageCenter, player.y + 50 - kratosAttack[int(act)].height - (kratosAttack[int(act)].height - kratosAttack[0].height), 2 * kratosAttack[int(act)].width, 2 * kratosAttack[int(act)].height);
      act+= 0.6;
      popMatrix();

      break;
    }


    break;
  }




  if (gravity <= 0) {

    int counter = 0;

    for (int i = 0; i < groundX.size(); i++) {
      if (isOnGround(i, 50)) {
        counter++;
        if (!grounded) {
          player.action = "idle";
          grounded = true;
        }
        globalY = (groundY.get(i) - 450) * -1;
        gravity = 0;
      }
    }


    if (counter == 0) {
      grounded = false;
      if (gravity > -30) {
        gravity -= 2;
      }
      if (player.action != "jumping") {
        act = 4;
        player.action = "jumping";
      }
    }
  }

  if (globalY > -580) {
    globalY += gravity;
  } else {
    player.y -= gravity;
  }
}

int globalX = 200;
int globalY = 0;
int lastX = 1680;

void handleScene() {
  if (globalX < 0) {
    globalX = 0;
  } else if (globalX > lastX) {
    globalX = lastX;
  }
  if (globalY < - 580) {
    globalY = -580;
  }
  if (map == 0) {
    image(maps[map], globalX * -1, globalY - 860, 3500, 2250);
  } else if (map == 1) {
  } else if (map == 2) {
    image(maps[map], globalX * -1, globalY - 550, 3500, 2250);
  }
}
int difficulty = 2;
float frame = 0;
int a = 200;
int b = 170;
int c = 75;
int d = 200;
int e = 200;
int menu = 0;
int gameMode = 1;
boolean opacity= false;
boolean flip = false;
int tint = 256;
int soundEffectsVol = 150;
int musicVol = 150;

void handleMenu() {

  if (menu != 1) {
    tint(255, 256);
  }
  //display menu video
  if (gameMode != 1) {
    image(video[int(frame)], 0, 0, 1280, 800);
    frame+= 1.5;
    if (frame > video.length - 1) {
      frame = 0;
    }
  }
  tint(255, tint);
  if (gameMode == 0) {
    image(title, 20, 20);
  }

  textFont(font);
  textAlign(CENTER);
  fill(0);

  if (gameMode == 2 || gameMode == 3) {
    if (mouseIn(e, 20, 200 + (200 - e)*2, 60)) {
      if (mousePressed && mouseButton == LEFT) {
        menu = 0;
        opacity = true;
      }

      if (e > 125) {
        e-=25;
      } else {
        e = 125;
      }
    } else {
      if (e < 200) {
        e+=25;
      } else {
        e = 200;
      }
    }
  }

  if (gameMode == 0) {
    if (mouseIn(a, 310, 200 + (200 - a)*2, 60)) {
      if (mousePressed && mouseButton == LEFT) {
        menu = 1;
        opacity = true;
      }

      if (a > 125) {
        a-=25;
      } else {
        a = 125;
      }
    } else {
      if (a < 200) {
        a+=25;
      } else {
        a = 200;
      }
    }

    if (mouseIn(b, 410, 200 + (200 - b)*2, 60)) {
      if (mousePressed && mouseButton == LEFT) {
        menu = 2;
        opacity = true;
      }
      if (b > 95) {
        b-=25;
      } else {
        b = 95;
      }
    } else {
      if (b < 170) {
        b+=25;
      } else {
        b = 170;
      }
    }

    if (mouseIn(c, 510, 200 + (200 - c)*2, 60)) {
      if (mousePressed && mouseButton == LEFT) {
        menu = 3;
        opacity = true;
      }
      if (c > 25) {
        c-=25;
      } else {
        c = 20;
      }
    } else {
      if (c < 75) {
        c+=25;
      } else {
        c = 75;
      }
    }

    if (mouseIn(d, 610, 200 + (200 - d)*2, 60)) {
      if (mousePressed && mouseButton == LEFT) {
        exit();
      }
      if (d > 125) {
        d-=25;
      } else {
        d = 125;
      }
    } else {
      if (d < 200) {
        d+=25;
      } else {
        d = 200;
      }
    }
  }

  if (opacity) {
    if (!flip) {
      if (tint > 0) {
        tint -=20;
      } else {
        if (menu == 0 || menu == 2 || menu == 3) {
          page.play();
        } else {
          titleMusic.stop();
        }
        tint = 0;
        flip = true;
        gameMode = menu;
      }
    } else {
      if (tint < 256) {
        tint += 20;
      } else {
        flip = false;
        opacity = false;
        tint = 256;
      }
    }
  }

  tint(255, tint);
  fill(0, tint);
  if (gameMode == 0) {
    image(back, a, 310, 200 + (200 - a)*2, 60);
    image(back, b, 410, 200 + (200 - b)*2, 60);
    image(back, c, 510, 200 + (200 - c)*2, 60);
    image(back, d, 610, 200 + (200 - d)*2, 60);
  }

  if (gameMode == 2 || gameMode == 3) {
    image(back, e, 20, 200 + (200 - e)*2, 60);
  }

  if (menu != 1) {
    fill(230, 120);
    textSize(18);
    text("by Yaksh Butani and Ali Chehab", 1110, 790);
    textSize(40);
    fill(0);
  }
  fill(0, tint);

  if (gameMode == 3) {
    image(back, 80, 120, 100, 60);
    image(back, 80, 190, 100, 60);
    image(back, 80, 260, 100, 60);
    image(back, 80, 330, 100, 60);
    image(back, 80, 400, 220, 60);
    image(back, 80, 470, 360, 60);
    image(back, 170, 120, 340, 60);
    image(back, 170, 190, 380, 60);
    image(back, 170, 260, 240, 60);
    image(back, 170, 330, 330, 60);
    image(back, 310, 400, 220, 60);
    image(back, 440, 470, 270, 60);
    image(back, -50, 540, 1200, 250);
  }

  if (gameMode == 0) {
    text("PLAY", 300, 350);
    text("OPTIONS", 300, 450);
    text("INSTRUCTIONS", 300, 550);
    text("EXIT", 300, 650);
  }

  if (gameMode == 3) {
    text("A", 130, 160);
    text("D", 130, 230);
    text("F", 130, 300);
    text("E", 130, 370);
    text("SPACE", 190, 440);
    text("LEFT MOUSE", 260, 510);
    textAlign(LEFT);
    text("MOVE LEFT", 220, 160);
    text("MOVE RIGHT", 220, 230);
    text("BLOCK", 220, 300);
    text("INTERACT", 220, 370);
    text("JUMP", 350, 440);
    text("ATTACK", 480, 510);
    text("Upgrade your character and defeat all \n the enemies on each map. Reach the end \n and fight the final boss Zeus. Make sure \n you do not lose all your health, dodging \n and blocking attacks from enemies.", 100, 600);
    textAlign(CENTER);
  }

  if (gameMode == 2 || gameMode == 3) {
    text("BACK", 300, 60);
  }
  if (gameMode == 2) {
    image(vol, 150, 500, 100, 100);
    image(back, 200, 150, 20, 320);

    image(back, 350, 150, 280, 80);
    image(back, 300, 250, 380, 80);
    image(back, 350, 350, 280, 80);
    image(back, 330, 450, 320, 80);

    textAlign(CENTER);
    text("Beginner", 490, 200);
    text("Intermediate", 490, 300);
    text("No Mercy", 490, 400);
    text("Titan Mode", 490, 500);

    textSize(20);
    textAlign(LEFT);

    if (difficulty == 1) {
      image(back, 300, 570, 500, 120);
      text("Designed for players who want \n to focus on the story and narrative \n of the game. Enemies are relatively \n easy to defeat, and the game \n is more forgiving.", 350, 600);
    } else if (difficulty == 2) {
      image(back, 300, 570, 500, 120);
      text("This difficulty setting offers \n a balanced experience for players \n who want a challenge but still want \n to enjoy the story and gameplay. \n Enemies are moderately difficult to defeat.", 350, 600);
    } else if (difficulty == 3) {
      image(back, 300, 570, 500, 100);
      text("For players who want a more \n challenging experience. Enemies are \n tougher and require more strategy and \n skill to defeat.", 350, 600);
    } else if (difficulty == 4) {
      image(back, 300, 570, 500, 120);
      text("Designed for experienced players \n who want the ultimate challenge. \n Enemies are extremely tough, and the \n game requires god-like reflexes \n and strategy to defeat.", 350, 600);
    }

    if (mousePressed) {
      if (mouseIn(350, 150, 280, 80)) {
        difficulty = 1;
      } else if (mouseIn(300, 250, 380, 80)) {
        difficulty = 2;
      } else if  (mouseIn(350, 350, 280, 80)) {
        difficulty = 3;
      } else if  (mouseIn(330, 450, 320, 80)) {
        difficulty = 4;
      }
    }

    if (difficulty == 1) {
      stroke(0, tint);
      strokeWeight(3);
      noFill();
      rect(350, 150, 280, 80);
    } else if (difficulty == 2) {
      strokeWeight(3);
      stroke(0, tint);
      noFill();
      rect(300, 250, 380, 80);
    } else if (difficulty == 3) {
      stroke(0, tint);
      strokeWeight(3);
      noFill();
      rect(350, 350, 280, 80);
    } else if (difficulty == 4) {
      stroke(0, tint);
      strokeWeight(3);
      noFill();
      rect(330, 450, 320, 80);
    }


    fill(40, tint);
    ellipse(210, soundEffectsVol, 30, 30);
    if (mouseIn(180, 130, 60, 370)) {
      if (mousePressed && mouseButton == LEFT) {
        soundEffectsVol= mouseY;
        if (mouseY < 150) {
          soundEffectsVol = 150;
        } else if (mouseY > 470) {
          soundEffectsVol = 470;
        }
        globalSound.volume(((470 - float(soundEffectsVol))/320));
      }
    }
  }
}

int xp = 0;
void handleUI() {
  rectMode(CORNER);
  strokeWeight(1);
  stroke(0);
  image(UI, -30, -20, 500, 250);
  fill(0, 85);
  rect(200, 85, player.maxHealth, 10);
  rect(200, 100, player.maxRage, 10);
  fill(#49F900, 85);
  rect(200, 85, float(player.health)/float(player.maxHealth) * player.maxHealth, 10);
  fill(#0296FF, 85);
  rect(200, 100, float(player.rage)/float(player.maxRage) * player.maxRage, 10);
  fill(#9D2527, 120);
  textAlign(CENTER);
  text(xp, 250, 170);
  strokeWeight(0);
}

boolean mouseIn(int left, int top, int w, int h) {
  return (mouseX > left && mouseX < left+w && mouseY > top && mouseY < top+h);
}


class Kratos {

  boolean alive = true;

  int health = 150;
  int maxHealth = 150;
  int rage = 100;
  int maxRage = 100;

  int damage = 25;
  int whichAttack = 0;
  int speed = 10;
  int jumpHeight = 30;

  String action = "idle";

  int x = 450;
  int y = 400;

  int knockBack = 0;

  void attack() {

    int[] attackHitBox = {0, 0, 0, 0};
    if (dir == 1) {
      attackHitBox[0] = player.x + 65;
      attackHitBox[1] = player.y;
      attackHitBox[2] = 150;
      attackHitBox[3] = 100;
    } else if (dir == -1) {
      attackHitBox[0] = player.x - 150;
      attackHitBox[1] = player.y;
      attackHitBox[2] = 150;
      attackHitBox[3] = 100;
    }



    for (int i = 0; i < skeletons.length; i++) {
      if (hitBox(attackHitBox, skeletons[i].hitBox)) {
        skeletons[i].health -= player.damage;
        if (player.x > skeletons[i].x - globalX) {
          skeletons[i].knockBack = -15;
        } else {
          skeletons[i].knockBack = 15;
        }
        if (skeletons[i].health <= 0) {
          if (skeletons[i].alive && skeletons[i].action != "dying") {
            skeletons[i].act = 0;
            skeletons[i].action = "dying";
          }
        }
      }
    }

    for (int i = 0; i < argos.length; i++) {
      if (hitBox(attackHitBox, argos[i].hitBox)) {
        argos[i].health -= player.damage;
        if (player.x > argos[i].x - globalX) {
          argos[i].knockBack = -10;
        } else {
          argos[i].knockBack = 10;
        }
        if (argos[i].health <= 0) {
          if (argos[i].alive && argos[i].action != "dying") {
            argos[i].act = 0;
            argos[i].action = "dying";
          }
        }
      }
    }
  }
}

class Skeleton {

  int health;
  int maxHealth;

  int damage;
  int speed;

  boolean isIdle;
  boolean alive;

  int x;
  int y;

  int rangeX1;
  int rangeX2;

  float act;
  String action = "walking";

  int[] hitBox = {0, 0, 50, 100};
  int knockBack = 0;

  public Skeleton(int x, int y, int rangeX1, int rangeX2) {

    this.health = 50 * difficulty;
    this.maxHealth = 50 * difficulty;

    this.damage = 5 * difficulty;
    this.speed = 4;

    this.isIdle = true;
    this.alive = true;

    this.x = x;
    this.y = y;

    this.rangeX1 = rangeX1;
    this.rangeX2 = rangeX2;

    this.act = 0;
    this.action = "walking";
  }

  void attack(int damage) {
    println(skeletonDir);
    player.knockBack = 10 * skeletonDir;
    if (player.action != "blocking") {
      player.health -= damage;
    }
  }
}

class Argos {

  int health;
  int maxHealth;

  int damage;
  int speed;

  boolean isIdle;
  boolean alive;

  int x;
  int y;

  int rangeX1;
  int rangeX2;

  float act;
  String action = "walking";

  int[] hitBox = {0, 0, 100, 150};
  int knockBack = 0;

  public Argos(int x, int y, int rangeX1, int rangeX2) {

    this.health = 150 * difficulty;
    this.maxHealth = 150 * difficulty;

    this.damage = 15 * difficulty;
    this.speed = 3;

    this.isIdle = true;
    this.alive = true;

    this.x = x;
    this.y = y;

    this.rangeX1 = rangeX1;
    this.rangeX2 = rangeX2;

    this.act = 0;
    this.action = "walking";
  }

  void attack(int damage) {
    player.knockBack = 20 * argosDir;
    if (player.action != "blocking") {
      player.health -= damage;
    }
  }
}


boolean moveLeft;
boolean moveRight;

void keyPressed() {
  if (key == 'a' || key == 'A' && key != 'd' && key != 'D' && player.action != "attack") {
    moveLeft = true;
    moveRight = false;
  }

  if (key == 'd' || key == 'D' && key != 'a' && key != 'A' && player.action != "attack") {
    moveRight = true;
    moveLeft = false;
  }

  if ((key == 'f' || key == 'F') && (!player.action.equals("jumping") && grounded)) {

    player.action = "blocking";
  }

  if (key == ' ' && !player.action.equals("jumping")) {
    player.action = "jumping";
    gravity = player.jumpHeight;
    grounded = false;
    act = 0;
  }
}

void keyReleased() {
  if (key == 'a' || key == 'A') {
    moveLeft = false;
    if (!player.action.equals("jumping")) {
      player.action = "idle";
    }
  }

  if (key == 'd' || key == 'D') {
    moveRight = false;
    if (!player.action.equals("jumping")) {
      player.action = "idle";
    }
  }

  if ((key == 'f' || key == 'F') && (!player.action.equals("jumping") && grounded)) {
    if (!player.action.equals("jumping") && grounded) {
      player.action = "idle";
    }
  }
}

void makePlatform(int x, int y, int x2) {

  groundX.append(x);
  groundY.append(y);
  groundZ.append(x2);
}

void makeWall(int x, int y, int y2) {
  wallX.append(x);
  wallY.append(y);
  wallZ.append(y2);
}

boolean isOnGround(int i, float playerHeight) {

  return player.x + playerHeight + 20 >= groundX.get(i) - globalX &&
    player.x <= groundZ.get(i) - globalX &&
    player.y + playerHeight <= groundY.get(i) + globalY &&
    player.y + playerHeight - gravity >= groundY.get(i) + globalY;
}

boolean collision(int i, float playerHeight) {
  return player.x + playerHeight + 20 >= wallX.get(i) - globalX &&
    player.x <= wallX.get(i) - globalX &&
    player.y + playerHeight <= wallY.get(i) + globalY &&
    player.y >= wallZ.get(i) + globalY;
}

boolean hitBox(int[] r1, int[] r2) {
  //  *******************************************************general formula*************************************
  //  if(rectOneRight > rectTwoLeft &&
  //rectOneLeft < rectTwoRight &&
  //rectOneBottom > rectTwoTop &&
  //rectOneTop < rectTwoBottom)

  int r1Bot, r1Right;
  int r2Bot, r2Right;
  r1Right=r1[0]+r1[2];//the "right" side of the first rectangle
  r1Bot=r1[1]+r1[3];//the "bottom" of the first rectangle

  r2Right=r2[0]+r2[2];//the "right" side of the second rectangle
  r2Bot=r2[1]+r2[3];//the "bottom" of the second rectangle

  return (r1Right > r2[0] && r1[0] < r2Right && r1Bot > r2[1] && r1[1] < r2Bot);
}//end hitBox

void mousePressed() {
  if (!player.action.equals("attack") && !player.action.equals("jumping") && !player.action.equals("blocking") ) {
    player.whichAttack += 1;
    if (player.whichAttack == 5) {
      player.whichAttack = 4;
    }
    player.action  = "attack";

    switch(player.whichAttack) {

    case 1:
      act = 0;
      break;

    case 2:
      act = 4;
      break;

    case 3:
      act = 9;
      break;

    case 4:
      act = 16;
      break;
    }
  }
}
