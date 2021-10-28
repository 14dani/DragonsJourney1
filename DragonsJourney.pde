import ddf.minim.*;

Minim minim;
AudioPlayer playI;
AudioPlayer playJ;
AudioPlayer playE;
AudioSample playPauseB;
//--------------------------------variables

int intervaloDisparo;
long instanteDisparo;

int intervaloDificultad;
long instanteDificultad;

float velocidadEnemigo;
int level;

int escenario;

Escenario escPortada;
Escenario escIntro;
Escenario escSeleccion;
Escenario escGameOver;
Escenario escJuego1;
long instant;
int interval;
int sel;

//--------------------------Balas 
ArrayList<Escenario> estrellas;
ArrayList<Fuego> FuegoDragon;
ArrayList<Nube> nubesEsc3;


//__________________________Heroe
Heroe heroe;
float angulo;
char heroeSeleccionado;
Fuego FuegoDragonD;


//___________________________Villano
int tipoVillano;
Villano vlln;

//___________________________Ataques
ArrayList<Ataque> ataques;
long instanteAtaque;
int intervaloAtaque;


Nube[] clouds = new Nube[5];




void setup() {
  
  //size(1920,1080);
  fullScreen();
  
  minim = new Minim(this);
  
  playI = minim.loadFile("Arab Ambient (Full).mp3");
  playJ = minim.loadFile("Oriental Arabian Oud.mp3");
  playE = minim.loadFile("Dark Arabic Oriental (Full).mp3");
  escenario = 1;
  interval = 25000;
  
  
  //______________________________________________________________________pantalla
 
  escPortada = new Escenario(loadImage("Screenshot (386).png"));
  escIntro = new Escenario(loadImage("Screenshot (382).png"));
  escJuego1 = new Escenario(sel);

  
  
  //Fondo de nubes escenario 3____________
  
  for (int index=0; index < clouds.length; index++) {
    println(index);
    clouds[index] = new Nube();
    clouds[index].Nube = loadImage("Nube.png");
  }
  //___________________________________
  
  escSeleccion = new Escenario(loadImage("Escenario-3.png"));
  
  escGameOver = new Escenario(loadImage("Screenshot (385).png"));
  
  
  
  //___________________________________Heroe
  heroe = new Heroe();
  heroe.selDragon(1);
  heroeSeleccionado = 'S';
  
  
  //___________________________________Villano
  tipoVillano = 2;
  
  vlln = new Villano(tipoVillano, random(-1, 2), random(-5,0));
  
  ataques = new ArrayList<Ataque>();
  
  FuegoDragon = new ArrayList<Fuego>();
  
  
}




void escPortada (){
  escPortada.display();
  playE.pause();
  playJ.pause();
  
  playI.play();
  playI.loop();
}


void escIntro (){
  //botones de seguir
}


void escSeleccion (){
  // investigar lo de la selección de personaje 
  sel = 0;
}


void escGameOver (){
  escGameOver.display();
  playJ.pause();
  playI.pause();
  playE.play();
  if (millis () - instant > interval) {
    playE.pause();
    escenario = 1;
    
  }
}

void escJuego(){
  escJuego1.display();
  playI.pause();
  playJ.play();
  //playJ.loop();
    
    
  //_______________________________________________________Estrellas
  //for (int i = 0; i < estrellas.size(); i++){
  //  Escenario tmp = estrellas.get(i);
  //  PVector aux = tmp.getPos();
  //  float d = dist(width/2, height/2, aux.x, aux.y);
  //  float maxDist = dist(0, 0, width/2, height/2);
  //  float tam = map(d,0, maxDist, 5, 40);
    
  //  tmp.dibujarEstrella(tam);
  //  tmp.moverEstrella();
    
  //}
  //_______________________________________________________
    
    
  
  
  
  //Ataques de mago a dragon
  //  for(int x=0; x<ataques.size(); x++){
  //    Ataque tmp = ataques.get(x);
  //    //tmp.dibujar();
  //    tmp.mover();
      
      
  //    if(dragon.getPos().dist(tmp.getPos()) <30 && tmp.isPlaying()){
  //      explosiones.add(new Explosion(tmp.getPos())));
  //      tmp.quitar();
  //      personaje.quitarVida();
  //    }
      
  //    //revisa si los asteroides salieron de la pantalla
  //    if (!tmp.isPlaying()){
  //    asteroides.remove(x);
  //  }
  //}
  
  
  //------------------- funciones que se relacionana con mago x dragon
  //If vida de mago es == 0 
  //float ganarHechizo() 
  //-------------------------- función para restar vida si el poder del mago le pega al dragon
  //if (aux.getPosBalaMago().dist(heroe.getPosDragon()) <= 20) {
  //      if (aux.getValidaMago()) {
  //        heroe.restarVida();
  //        aux.quitarBala();
  //      //  playerDeath.trigger();
  //      }
  //    } 
  
   //Sección de niveles
    
    
    //
    
    //Ataques de mago a dragon
    for (int x=0; x < ataques.size(); x++){
    Ataque tmp = ataques.get(x);
    tmp.mover();
  }
    
    if (millis() - instanteAtaque > intervaloAtaque) {
    PVector aux = vlln.getPos();
    Ataque nuevo = new Ataque(tipoVillano, aux.x, aux.y);
    ataques.add(nuevo);
    instanteAtaque = millis();
  }
  
  //____________________________________________________Villano
  vlln.mover();
  
  //Obtener la posicion del heroe para lanzar fuego
  for (int x=0; x < FuegoDragon.size(); x++){
    Fuego tmp = FuegoDragon.get(x);
    tmp.dibujar();
    tmp.mover();
  }
  
  //____________________________________________________Heroe
  heroe.moverYdibujo(mouseY, mouseX);
  heroe.getPosDragon();
  

}




void draw() {
  
  if(escenario == 1){
    escPortada();
  }
  else if(escenario == 2){
    escIntro.display();
  }
  else if(escenario == 3){
    escSeleccion.display();
  }
  else if(escenario == 4){
    escJuego();
  }
  else if(escenario == 5){
    escGameOver();
  }
}

void keyPressed(){
  if (escenario == 3) {
    if (key == 's' || key == 'S') {
      
      //Nivel 1
      heroeSeleccionado = 's';
      heroe.selDragon(1);
      escJuego1.selEsc(1);
      escenario = 4;
      instanteAtaque = millis();
      intervaloAtaque = 5000;
    }
    
    if (key == 'E' || key == 'e'){
      heroeSeleccionado = 'e';
      escJuego1.selEsc(2);
      heroe.selDragon(2);
      escenario = 4;
      instanteAtaque = millis();
      intervaloAtaque = 5000;
      
    }
    if (key == 'V' || key == 'v'){
      
      heroeSeleccionado = 'v';
      heroe.selDragon(3);
      escJuego1.selEsc(3);
      escenario = 4;
      instanteAtaque = millis();
      intervaloAtaque = 5000;
     }
  }
  
  
  if (key == ' ')  {
    if (escenario == 4) {
      //heroe.disparar();
      PVector aux = heroe.getPosDragon();
      Fuego nuevo = new Fuego(heroeSeleccionado,aux.x, aux.y);
      FuegoDragon.add(nuevo);
    } 
  }
  
  
  if(key == '1'){
    escenario = 1;
  }
  else if(key == '2'){
    escenario = 2;
  }
  else if(key == '3'){
    escenario = 3;
  }
   else if(key == '4'){
    escenario = 4;
    //instanteAtaque = millis();
    //intervaloAtaque = 5000;
  }
  else if(key == '5'){
    escenario = 5;
    instant = millis();
  }
  
  
  if(key == CODED){
    if(keyCode == LEFT){
      angulo += 4;
    }
    else if(keyCode == RIGHT){
      angulo -= 4;
    
    }
  }
  

}
