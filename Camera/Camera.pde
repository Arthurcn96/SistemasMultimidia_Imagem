/**
 *Camera
 *by Arthur Costa e Danielli Costa
 *
 *Usa da camera do celular para fazer manipulação e processamento 
 *dos dados contem filtros: Pontilismo, Preto&Branco e mosaico.
 */

import ketai.camera.*;

KetaiCamera cam;
int x=0;
int filtro;
int Nfiltro=3;
float aux;
float escala;
int w, h;
PImage menor;

void setup() {
  smooth(2);
  
  cam = new KetaiCamera(this, width, height, 30);
  fullScreen();
  aux=height*0.25;
  escala=10;
  
  filtro = constrain(filtro, 0, Nfiltro);
  orientation(LANDSCAPE);
  
  drawUI();
  drawMenu();

  cam.setSaveDirectory("");
  cam.setPhotoSize(width, height);
  
  w = (int)(width/escala);
  h = (int)(height/escala);
}

void onCameraPreviewEvent() {//Ve se existe um novo frame a ser carregado
  cam.read();
  cam.autoSettings();
}

void pretoBranco() {//Aplica um filtro(tint) de preto e branco
  image(cam, 0, 0, width, height);  
  filter(GRAY);
}

void pontilismo() {//Cria varios circulos preenchidas com as cores dos pixels correspondentes

  for (int i = 0; i<500; i++) {
    int x = int(random(cam.width));
    int y = int(random(cam.height));
    color pix = cam.get(x, y);//Pega a cor do pixel da imagem no X,Y aleatorio
    fill(pix, 128);
    ellipse(x, y, escala, escala);//Faz um circulo na imagem no X,Y
    noStroke();
  }
  
}


void quadrados() {//Aplica um filtro(tint) de preto e branco
  //image(cam, 0, 0, width, height);  
  //filter(GRAY);

 //for(int x = 0; x < w; x++){
    for (int y = 0; y < height; y++) {
      int i = x + (y * w);
      color c = menor.pixels[i];
      noStroke();
      image(cam, x*escala, y*escala, escala, escala);
      tint(c);
    }
  //}
  ++x;
  if(x > height) {
    x=0;
    noLoop();
  }
  
}


void mosaico() {//Cria varios pixels preenchidas com as mesma imagem aplicado o filtro(tint) correspondentes do pixel

  menor = createImage((int)(cam.width/escala), (int)(cam.height/escala), RGB);
  menor.copy(cam, 0, 0, cam.width, cam.height, 0, 0, w, h);
  menor.loadPixels();
  w = (int)(width/escala);
  h = (int)(height/escala);

  if (x < w) {
 //for(int x = 0; x < w; x++){
    for (int y = 0; y < h; y++) {
      int i = x + (y * w);
      color c = menor.pixels[i];
      noStroke();
      image(cam, x*escala, y*escala, escala, escala);
      tint(c);
    }
  //}
    
    ++x;
  } else {
    x=0;
    noLoop();
  }
  
}

void mousePressed() {

  loop();
  
  if (mouseX < width - aux*1.5) {//Tela acima do circulo
      x=0;
    if (mouseY >height/2) {//Lado Esquerdo
      filtro = constrain(filtro-1, 0, Nfiltro);
      
    } else { //Lado direito
      filtro = constrain(filtro+1, 0, Nfiltro);
    }
  } else {
    if (mouseX > width-aux*1.5 && mouseX < width-aux*0.5){//Na mesma altura do circulo
      if (mouseY > (height/2)-(aux/2) && mouseY < (height/2)+(aux/2)) {//clique no circulo
          println("INICIOU A CAMERA!!");
          if (cam.isStarted()) {
            cam.pause();
          } else {
  
            cam.start();
          }
      } else if (mouseY < (height/2)-(aux/2)) {//clique a Direita do circulo
          if (cam.getCameraID() == 0) {
            cam.setCameraID(1);
          } else {
            cam.setCameraID(0);
          }
      } else if (mouseY > (height/2)+(aux/2)) {//A Esquerda do circulo
        //cam.savePhoto("foto_teste.jpg");
         saveFrame("/storage/emulated/0/Pictures/FotoSalva##.jpg");
         println("SALVOU!!");
      }
    }else{//Retangulo abaixo do circulo
      x=0;
      escala=(mouseY/50)+5;
      println(escala);
     
      //BARRA DESLIZANTE PARA MANIPULAÇÃO DOS ESCALARES DOS FILTROS.
      //Caminho /storage/emulated/0/Pictures/foto_teste.jpg

    }
  }
}

void draw() {

  //println(frameRate);
  
  
  if (filtro==0) {
    noTint();
    image(cam, 0, 0, width, height);
  } else if (filtro==1) {
    pontilismo();
  } else if (filtro == 2) {
    noTint();
    quadrados();
  } else if (filtro ==3) {
    mosaico();
  }


  if (cam.isStarted()) drawUI();
}

void drawUI() {//Desenha o circulo

  pushStyle();
  
  strokeWeight(20);
  noFill();
  stroke(0);
  ellipse(width-aux, height/2, aux-5, aux-5);//Circulo interno preto

  strokeWeight(15);
  noFill();
  stroke(255);
  ellipse(width-aux, height/2, aux, aux);//Circulo exnterno preto
   
  
  popStyle();

  //pushStuyle()saves the current style settings and popStyle() restores the prior settings. 
  //these functions are always used together.
  //They allow you to change the style settings and later return to what you had.
}

void drawMenu() {

  pushStyle();

  textSize(height*0.067);
  fill(0);
  translate(width/2, height/2);
  rotate(3*PI/2);
  text("Filtro anterior \t Filtro seguinte", -width/4, 0);
  text("Salvar         ON/OFF        Selfie", -width/4, height-aux*1.3);
  

  popStyle();
}