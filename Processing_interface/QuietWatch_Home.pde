//--------------------------Laboratorio Digital II-----------------------------
// Projeto: QuietWatch (T3BB5)
// Gabriel Pereira de Carvalho
// Otávio Felipe de Freitas
// Willian Abe Fukushima
//-----------------------------------------------------------------------------
// To interact with the interface, keyboard commands are used (PUBLISH)
// l = turn on input
// r = reset input
// m = mode input
// d = disarm input
//-----------------------------------------------------------------------------

//Java Libraries
import java.io.IOException;
import java.time.format.DateTimeFormatter;  
import java.time.LocalDateTime;
//Processing Libraries
import mqtt.*;
import ddf.minim.*;

//----------------------------- MQTT Connection ----------------------------------
String user   = "grupo1-bancadaB5";
String passwd = "L%40Bdygy1B5";      // keep %40
String broker = "3.141.193.238";     
String port   = "80";
MQTTClient client;
String clientID;
//-----------------------------------------------------------------------------

//-------------------------------- Variables ----------------------------------
int whichKey = -1;  // variable holds pressed key
Boolean estado_ligar = false;
Boolean estado_mode = false;
Boolean estado_reset = false;
Boolean estado_selmux0 = false;
Boolean estado_selmux1 = false;
Boolean estado_alerta = false;
Boolean estado_calibrando = false;
Boolean estado_desarmar = false;
Boolean estado_senha = false;
String senha = "";
PFont myFont;
int largura = 960;
int altura = 600;
PrintWriter QuietWatch_logger;
Minim minim;
AudioPlayer som_calibrando, som_alarme;
//-----------------------------------------------------------------------------

//------------------------- Setup: executed once --------------------------
void setup() {
  // Frame size
  size(960, 600);
  myFont = loadFont("myfont.vlw");
  smooth();
  //Setup PrintWriter
  QuietWatch_logger = createWriter("QuietWatch_logs_" + day() + "_" + month() + "_" + year() + "_horario_" + hour() + "_" + minute() + "_" + second() + ".txt");
  QuietWatch_logger.println("Setup Processing " + day() + "/" + month() + "/" + year() + " horario " + hour() + ":" + minute() + ":" + second());
  QuietWatch_logger.flush();
  // setup Minim
  minim = new Minim(this);
  som_calibrando = minim.loadFile("som_calibrando.mp3");
  som_alarme = minim.loadFile("som_alarme.mp3");
  // Connect with MQTT
  client = new MQTTClient(this);
  clientID = new String("labead-mqtt-processing-" + random(0,100));
  println("clientID=" + clientID);
  client.connect("mqtt://" + user + ":" + passwd + "@" + broker + ":" + port, clientID, false);
  // Ensure zero signals
  client.publish(user + "/E0home", "0");//reset
  client.publish(user + "/E1home", "0");//turn on
  client.publish(user + "/E2home", "0");//mode
  client.publish(user + "/E3home", "0");//disarm
}
//-----------------------------------------------------------------------------

//----------------------- Draw: executed continuously -----------------------
void draw() { 
    cursor(HAND);
    textFont(myFont);
    background(#B6BCB3);    
    // call functions to draw security system panel
    drawCabecalho();
    drawQuadro();
}
//-----------------------------------------------------------------------------

void drawCabecalho() {
    textAlign(CENTER);
    textSize(30);
    fill(0);
    text("Control Widgets with Keyboard", 10, 10, largura, altura);
    textAlign(CENTER);
    textSize(15);
    fill(0);
    text("r : E0 (reset)", 10, 40, largura, altura);
    textAlign(CENTER);
    textSize(15);
    fill(0);
    text("l: E1 (turn on)", 10, 55, largura, altura);
    textAlign(CENTER);
    textSize(15);
    fill(0);
    text("m: E2 (mode 0 'at home' or 1 'away from home')", 10, 70, largura, altura);
    textAlign(CENTER);
    textSize(15);
    fill(0);
    text("d: E3 (disarm)", 10, 85, largura, altura);
}
void drawQuadro(){
  stroke(#300A8B);
  fill(#868489);
  rect(250, 100, 500, 410);
//--------------------------- Widgets for Inputs ----------------------------
  if(estado_ligar){//l for turn on
    fill(#FF0303);
    ellipse(350, 150, 70, 70);
    textSize(12);
    fill(0);
    text("on", 350, 155);
  }else{
    fill(#B6BCB3);
    ellipse(350, 150, 70, 70);
    textSize(12);
    fill(0);
    text("off", 350, 155);
  }
  if(estado_mode){// m for mode
    fill(#FF0303);
    ellipse(350, 250, 70, 70);
    textSize(11);
    fill(0);
    text("Away from Home", 350, 255);
  }else{
    fill(#B6BCB3);
    ellipse(350, 250, 70, 70);
    textSize(12);
    fill(0);
    text("At Home", 350, 255);
  }
  if(estado_reset){// r for reset
    fill(#FF0303);
    ellipse(350, 350, 70, 70);
    textSize(12);
    fill(0);
    text("reset", 350, 355);
  }else{
    fill(#B6BCB3);
    ellipse(350, 350, 70, 70);
    textSize(12);
    fill(0);
    text("reset", 350, 355);
  }
  if(estado_disarm){// d for disarm(E3)
    fill(#FF0303);
    ellipse(350, 450, 70, 70);
    textSize(10);
    fill(0);
    text("Awaiting", 350, 455);//E3 = 1
  }else{
    fill(#B6BCB3);
    ellipse(350, 450, 70, 70);
    textSize(12);
    fill(0);
    text("Disarm", 350, 455);//E3 = 0
  }
  
  //---------------------------------------------------------------------------
  stroke(255,0,0);
  strokeWeight(5);
  line(500,100,500,510);
  //-------------------------- Widgets for Outputs ---------------------------
  if(estado_alerta){
    stroke(#300A8B);
    fill(#FF0303);
    ellipse(600, 150, 70, 70);
    textSize(12);
    fill(0);
    text("alert on", 600, 155);
  }else{
    stroke(#300A8B);
    fill(#00FF12);
    ellipse(600, 150, 70, 70);
    textSize(12);
    fill(0);
    text("alert off", 600, 155);
  }
  if(estado_calibrando){
    stroke(#300A8B);
    fill(#FF0303);
    ellipse(600, 250, 70, 70);
    textSize(12);
    fill(0);
    text("calibrating...", 600, 255);
  }else{
    //stroke(#300A8B);
    //if(estado_ligar){
    //  fill(#00FF12);
    //  ellipse(600, 250, 70, 70);
    //  textSize(12);
    //  fill(0);
    //  text("calibrated", 600, 255);
    //}
  }
  if(estado_senha){
    stroke(#300A8B);
    fill(#FF0303);
    ellipse(600, 370, 100, 100);
    textSize(12);
    fill(0);
    text("ENTER PASSWORD", 600, 375);
  }else{
    //stroke(#300A8B);
    //fill(#B6BCB3);
    //ellipse(600, 370, 100, 100);
    //textSize(12);
    //fill(0);
    //text("", 600, 155);
  }
  //-----------------------------------------------------------------------------
  String dispTime = "Time: " + hour() + ":" + minute() + ":" + second();
  fill(0);
  rect(605, 485, 85, 20);
  fill(#B6BCB3);
  text(dispTime, 650, 500);
}

//------------------- keyPressed: processes keyboard input ------------------
// keyPressed function - processes pressed key
void keyPressed() {
  whichKey = key;
  if(estado_senha){
    String key_char = str((char) whichKey);
    senha += key_char;
    if(senha.length() == 4){
      println("PASSWORD SENT " + senha);
      QuietWatch_logger.println("PASSWORD SENT  " + senha);
      QuietWatch_logger.flush();
      client.publish(user + "/RXhome", senha);
      senha = "";
    }
  }else{
    if(whichKey == 114){
      estado_reset = !estado_reset;
      if(estado_reset){
        client.publish(user + "/E0home", "1");
        QuietWatch_logger.println("Reset  " + hour() + ":" + minute() + ":" + second());
        QuietWatch_logger.flush();
      }else{
        client.publish(user + "/E0home", "0");
      }
    }
    if(whichKey == 108){
      estado_ligar = !estado_ligar;
      if(estado_ligar){
        client.publish(user + "/E1home", "1");
        QuietWatch_logger.println("Turn On  " + hour() + ":" + minute() + ":" + second());
        QuietWatch_logger.flush();
      }else{
        client.publish(user + "/E1home", "0");
      }
    }
    if(whichKey == 109){
      estado_mode = !estado_mode;
      if(estado_mode){
        client.publish(user + "/E2home", "1");
        QuietWatch_logger.println("Away from Home Mode  " + hour() + ":" + minute() + ":" + second());
        QuietWatch_logger.flush();
      }else{
        client.publish(user + "/E2home", "0");
        QuietWatch_logger.println("At Home Mode  " + hour() + ":" + minute() + ":" + second());
        QuietWatch_logger.flush();
      }
    }
    if(whichKey == 100){
      estado_disarm = !estado_disarm;
      if(estado_mode){
        client.publish(user + "/E3home", "1");
        QuietWatch_logger.println("Disarmed  " + hour() + ":" + minute() + ":" + second());
        QuietWatch_logger.flush();
      }else{
        client.publish(user + "/E3home", "0");
        QuietWatch_logger.println("Armed  " + hour() + ":" + minute() + ":" + second());
        QuietWatch_logger.flush();
      }
    }
  }
}
//-----------------------------------------------------------------------------

//----------------------------- MQTT Functions -----------------------------
void clientConnected() {
  println("client connected");
  client.subscribe(user + "/E0home");
  client.subscribe(user + "/E1home");
  client.subscribe(user + "/E2home");
  client.subscribe(user + "/E3home");
  client.subscribe(user + "/S0home");//motion alert
  client.subscribe(user + "/S1home");//calibrating
  client.subscribe(user + "/S2home");//password
}

void messageReceived(String topic, byte[] payload) {
  String dados = new String(payload);
  
  if(topic.endsWith("E0home")){
    if(Integer.parseInt(dados) == 1){
      QuietWatch_logger.println("Received Reset  " + hour() + ":" + minute() + ":" + second());
      QuietWatch_logger.flush();
      estado_reset = true;
    }else{
      estado_reset = false;
    }
  }
  
  if(topic.endsWith("E1home")){
    if(Integer.parseInt(dados) == 1){
      QuietWatch_logger.println("Received Turn On  " + hour() + ":" + minute() + ":" + second());
      QuietWatch_logger.flush();
      estado_ligar = true;
    }else{
      estado_ligar = false;
    }
  }
  
  if(topic.endsWith("E2home")){
    if(Integer.parseInt(dados) == 1){
      QuietWatch_logger.println("Received Away from Home Mode  " + hour() + ":" + minute() + ":" + second());
      QuietWatch_logger.flush();
      estado_mode = true;
    }else{
      QuietWatch_logger.println("Received At Home Mode  " + hour() + ":" + minute() + ":" + second());
      QuietWatch_logger.flush();
      estado_mode = false;
    }
  }
  if(topic.endsWith("E3home")){
    if(Integer.parseInt(dados) == 1){
      QuietWatch_logger.println("Received Disarmed  " + hour() + ":" + minute() + ":" + second());
      QuietWatch_logger.flush();
      estado_disarm = true;
    }else{
      QuietWatch_logger.println("Received Armed  " + hour() + ":" + minute() + ":" + second());
      QuietWatch_logger.flush();
      estado_disarm = false;
    }
  }
  
  if(topic.endsWith("S0home")){//message came from S0 (motion alert)
    if(Integer.parseInt(dados) == 1){//alert is activated
      DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss");  
      LocalDateTime now = LocalDateTime.now();
      if(estado_alerta == false){
        println("MOTION ALERT : " + dtf.format(now));
        QuietWatch_logger.println("MOTION ALERT  " + hour() + ":" + minute() + ":" + second());
        QuietWatch_logger.flush();
        if(estado_mode){
          som_alarme.play();
        }
        estado_alerta = true;
      }
    }else{
      estado_alerta = false;
      som_alarme.pause();
    }
  }
  
  if(topic.endsWith("S1home")){//message came from S1 (calibrating)
    if(Integer.parseInt(dados) == 1){//alert is activated
      DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss");  
      LocalDateTime now = LocalDateTime.now();
      if(estado_calibrando == false){
        println("Calibrating : " + dtf.format(now));
        QuietWatch_logger.println("Calibrating  " + hour() + ":" + minute() + ":" + second());
        QuietWatch_logger.flush();
        estado_calibrando = true;
      }
    }else{
      estado_calibrando = false;
    }
  }
    
  if(topic.endsWith("S2home")){//message came from S2
    if(Integer.parseInt(dados) == 1){
      DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss");  
      LocalDateTime now = LocalDateTime.now();
      if(estado_senha == false){
        println("Password : " + dtf.format(now));
        QuietWatch_logger.println("Enter Password  " + hour() + ":" + minute() + ":" + second());
        QuietWatch_logger.flush();
        estado_senha = true;
      }
    }else{
      estado_senha = false;
    }
  }
}
void connectionLost() {
  println("connection lost");
}
//---------------------------------------------------------------------------
