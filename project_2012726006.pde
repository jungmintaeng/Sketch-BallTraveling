import java.util.HashMap;
import processing.sound.*;
/*
 * global variables
 */
static final int BALL_SIZE = 50;
static final float DECREMENT = 0.7;
Stage stage;
PImage bg_stage1, bg_stage2, ballImage;
Ball ball;
int current_stage = 1;
HashMap<String, SoundFile> soundMap = new HashMap();

void setup(){
  // TODO : frame setting
  System.out.println(dataPath("F.wav"));
  size(1080, 720);
  smooth();
  stage = new Stage();
  ball = new Ball();
  ball.move(110, 25);
  bg_stage1 = loadImage("data\\stage1.jpg");
  bg_stage2 = loadImage("data\\stage2.jpg");
  ballImage = loadImage("data\\ball.png");
  String[] keySet = {"ball", "Crash", "HiHat", "HiTom", "LowTom", "Kick", "Ride", "Snare"};
  for(String oneKey : keySet)
    soundMap.put(oneKey, new SoundFile(this, dataPath("sounds/"+oneKey+".mp3")));
  soundMap.put("Guitar", new SoundFile(this, dataPath("sounds/F.wav")));
  soundMap.put("Piano", new SoundFile(this, dataPath("sounds/majA.wav")));
}

void draw(){
  // TODO : Draw Map
  //stage.draw_stage1();
  stage.draw_stage(current_stage);
  ball.draw();
}

void mouseMoved() {
  System.out.println(mouseX + " " + mouseY);
}

class Stage{
  public Stage(){
    
  }
  
  public void draw_stage(int stage){
    if(stage == 1){
      background(bg_stage1);
      fill(123,123,123);
      pushMatrix();
      translate(400, 310);
      rotate(radians(18));
      rect(-200, -105, 600, 15, 10);
      popMatrix();
      pushMatrix();
      translate(680, 630);
      rotate(radians(-10));
      rect(-200, -105, 350, 15, 10);
      popMatrix();
    }else if(stage == 2){
      background(bg_stage2);
    }
  }
}

void reStart(){
  current_stage = 1;
  ball = new Ball();
  ball.move(110, 25);
}

class Ball{
  PVector location;
  PVector velocity;
  boolean changed = false;
  int rotateDirection = 1;
  
  Ball(){
    location = new PVector(0, 0);
    velocity = new PVector(1.5, 0.1);
  }
  
  public void draw(){
    pushMatrix();
    translate(location.x, location.y);
    rotate(rotateDirection * radians(frameCount % 360) * 5);
    image(ballImage, (-1) * (BALL_SIZE/2), (-1) * (BALL_SIZE/2));
    popMatrix();
    collision();
    location.add(velocity);
    velocity.add(new PVector(0, 0.1));
  }
  
  public void move(float x, float y){
    location.add(new PVector(x,y));
  }
  
  public void collision(){
    if(current_stage == 1){
      if(location.x < 245 && 90/80*(location.x-120) + 50 - (location.y + BALL_SIZE/2) < 0){
        velocity.y = velocity.y * DECREMENT * -1;
        soundMap.get("ball").play();
      }else if(!changed && location.x >= 245 && location.x <= 800 && (location.x-245)*(335-150)-((location.y + BALL_SIZE/2)-150)*(810-245) < 0){
        velocity.y = velocity.y * DECREMENT * -1;
        soundMap.get("ball").play();
      }else if(!changed && location.x >= 851 && (location.x-880)*(450-510)-((location.y+BALL_SIZE/2)-510)*(920-880) < 0){
        velocity.y = velocity.y * (DECREMENT - 0.1) * -1;
        velocity.x *= -1;
        rotateDirection = -1;
        changed = true;
        soundMap.get("ball").play();
        soundMap.get("Guitar").play();
      }else if(changed && location.x >= 467 && location.x <= 810 && (location.x-467)*(500-562)-((location.y+BALL_SIZE/2)-562)*(810-467) < 0){
        velocity.y = velocity.y * DECREMENT * -1;
        soundMap.get("ball").play();
      }else if(location.y > height){
        soundMap.get("Piano").play();
        current_stage = 2;
        location.x = 270;
        location.y = 0;
      }
    }else if(current_stage == 2){
      if(location.x <= 270 && (location.x - 110)*(120-70) - ((location.y + BALL_SIZE / 2) - 70)*(240 - 110) < 0){
        velocity.y = velocity.y * (DECREMENT - 0.1) * -1;
        velocity.x *= -1;
        rotateDirection *= -1;
        soundMap.get("ball").play();
        soundMap.get("Crash").play();
      }else if( location.x >= 300 && location.x <= 520 && (location.x - 300)*(350-350) - ((location.y + BALL_SIZE / 2) - 350)*(522 - 300) < 0){
        velocity.y = velocity.y * DECREMENT * -1;
        soundMap.get("ball").play();
        soundMap.get("HiTom").play();
      }else if( location.x >= 550 && location.x <= 750 && (location.x - 300)*(350-350) - ((location.y + BALL_SIZE / 2) - 350)*(522 - 300) < 0){
        velocity.y = velocity.y * -1;
        soundMap.get("ball").play();
        soundMap.get("LowTom").play();
      }else if(location.x >= 751 && location.x < width && (location.x - 825)*(466-385) - ((location.y + BALL_SIZE / 2) - 385)*(944 - 825) < 0){
        velocity.y = velocity.y * DECREMENT * -1;
        soundMap.get("ball").play();
        soundMap.get("Ride").play();
      }else if(location.x >= width){
        reStart();
      }
    }
  }
}