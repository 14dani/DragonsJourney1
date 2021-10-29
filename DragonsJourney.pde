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
Escenario escJuego1, escJuego2, escJuego3, escJuego4;
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
Villano vlln1,vlln2,vlln3;

//___________________________Ataques
ArrayList<Ataque> ataques;
long instanteAtaque;
int intervaloAtaque;

//___________________________Explosiones
ArrayList<Explosion> explosiones;
ArrayList<FuegoAnimacion> fuegos;

boolean cambiodeNivel;

Nube[] clouds = new Nube[5];




void setup() {
  
  //size(1920,1080);
  fullScreen();
  frameRate(12);
  
  minim = new Minim(this);
  
  playI = minim.loadFile("Arab Ambient (Full).mp3");
  playJ = minim.loadFile("Oriental Arabian Oud.mp3");
  playE = minim.loadFile("Dark Arabic Oriental (Full).mp3");
  escenario = 1;
  interval = 25000;
  instant = millis();
  
  
  //______________________________________________________________________pantalla
  
  escJuego1 = new Escenario(sel);
  escJuego2 = new Escenario(sel);
  escJuego3 = new Escenario(sel);
  escJuego4 = new Escenario(sel);
  escPortada = new Escenario(loadImage("Screenshot (386).png"));
  escIntro = new Escenario(loadImage("Screenshot (382).png"));
  cambiodeNivel = false;

  
  
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
  tipoVillano = 1;
  
  vlln1 = new Villano(1, random(-10, -15), random(-15,10));
  
  vlln2 = new Villano(2, random(-1, -5), random(-5,0));
  
  vlln3 = new Villano(3, random(-1, -5), random(-5,0));
  
  
  
  ataques = new ArrayList<Ataque>();
  explosiones = new ArrayList<Explosion>();
  fuegos = new ArrayList<FuegoAnimacion>();
  FuegoDragon = new ArrayList<Fuego>();
  
  
}




void escPortada (){
  escPortada.display();
  playE.pause();
  playJ.pause();
  
  playI.play();
  playI.loop();
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

void escJuegoNIV1(){
  escJuego1.display();
  textSize(15);
  fill(255);
  textAlign(CENTER);
  text("Nivel 1", width/2,20);
  playI.pause();
  playJ.play();
  //playJ.loop();
  
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
  

//Ataques de mago a dragon
  for (int x=0; x < ataques.size(); x++){
    Ataque tmp = ataques.get(x);
    tmp.dibujar();
    tmp.mover();
    
    if (heroe.getPosDragon().dist(tmp.getPos()) < 150 && tmp.isPlaying()){
      explosiones.add(new Explosion(tipoVillano, tmp.getPos()));
      tmp.quitar();
      
      heroe.restarVida();
      if(heroe.getVida()==0){

      escenario = 5;
      //  instant = millis();
        //escGameOver();
      //}

        escenario = 5;
        escGameOver();
      }

    }
    
    if(!tmp.isPlaying()){
      ataques.remove(x);
    }
  
  }
  
  for (int x=0; x<explosiones.size(); x++) {
        Explosion tmp = explosiones.get(x);
        if (tmp.isActive()) {
          tmp.dibujar();
        }
        else
        explosiones.remove(x);
      }
    
    if (millis() - instanteAtaque > intervaloAtaque) {
    PVector aux = vlln1.getPos();
    Ataque nuevo = new Ataque(1, aux.x, aux.y);
    ataques.add(nuevo);
    instanteAtaque = millis();
  }
  
  
  //____________________________________________________Villano
  vlln1.dibujar();
  vlln1.mover();
  
  
  
 // Obtener la posicion del heroe para lanzar fuego
  for (int x=0; x < FuegoDragon.size(); x++){
    Fuego tmp = FuegoDragon.get(x);
    tmp.dibujar();
    tmp.mover();
    
    if (tmp.getPosFuego().dist(vlln1.getPos()) < 120 && tmp.isPlaying()){
      fuegos.add(new FuegoAnimacion(heroeSeleccionado, tmp.getPosFuego()));
      tmp.quitar();
      

      vlln1.restarVida();
        if(vlln1.getVida() == 0){
          escenario = 5;
        }
      }

      //heroe.quitarVida();

    
    
    if(!tmp.isPlaying()){
      FuegoDragon.remove(x);
    }
  
  }
  
  for (int x=0; x<fuegos.size(); x++) {
        FuegoAnimacion tmp = fuegos.get(x);
        if (tmp.isActive()) {
          tmp.dibujar();
        }
        else
        fuegos.remove(x);
      }
    
  
  
  //____________________________________________________Heroe
  heroe.moverYdibujo(mouseY, mouseX);
  heroe.getPosDragon();
  

  
  
  
  
  
  //if (vlln.getVida() == 0 ) {
  //  if (cambioNivel == false) {
  //    nivel++;
  //    cambioNivel = true;
  //    intervaloEnemigo -= 400;
  //  }
  //}
  
  
  
  
  //if (nivel < 4) {
  //  for (int x=0; x < ataques.size(); x++){
  //    Ataque tmp = ataques.get(x);
  //    tmp.dibujar();
  //    tmp.mover();
    
  //    if (heroe.getPosDragon().dist(tmp.getPos()) < 150 && tmp.isPlaying()){
  //      explosiones.add(new Explosion(tipoVillano, tmp.getPos()));
  //      tmp.quitar();
        
  //      heroe.restarVida();
  //    //if(heroe.getVida()==0){
  //    //  escenario = 5;
  //    //  instant = millis();
  //      //escGameOver();
  //    //}
  //  }
    
  //  if(!tmp.isPlaying()){
  //    ataques.remove(x);
  //  }
  
  //}
  
  
  ////Explosiones
  //for (int x=0; x<explosiones.size(); x++) {
  //      Explosion tmp = explosiones.get(x);
  //      if (tmp.isActive()) {
  //        tmp.dibujar();
  //      }
  //      else
  //      explosiones.remove(x);
  //    }
      
      
  //    for (int x=0; x < FuegoDragon.size(); x++){
  //  Fuego tmp = FuegoDragon.get(x);
  //  tmp.dibujar();
  //  tmp.mover();
    
  //  if (tmp.getPosFuego().dist(vlln.getPos()) < 120 && tmp.isPlaying()){
  //    fuegos.add(new FuegoAnimacion(heroeSeleccionado, tmp.getPosFuego()));
  //    tmp.quitar();
      
  //    vlln.restarVida();
  //  }
    
  //  if(!tmp.isPlaying()){
  //    FuegoDragon.remove(x);
  //  }
  
  //}
  
  
  ////AnimacionFuego
  //for (int x=0; x<fuegos.size(); x++) {
  //      FuegoAnimacion tmp = fuegos.get(x);
  //      if (tmp.isActive()) {
  //        tmp.dibujar();
  //      }
  //      else
  //      fuegos.remove(x);
  //    }
    
      
      
      
      
    
    
  //    if (nivel == 1) {
  //      if (ataques.size() < 3) {
  //        tipoVillano = 1;
  //        PVector aux = vlln.getPos();
  //        Ataque nuevo = new Ataque(tipoVillano, aux.x, aux.y);
  //        ataques.add(nuevo);
          
  //      }
  //    }
  //    else if (nivel == 2) {
  //      if (ataques.size() < 5) {
  //        tipoVillano = 2;
  //        PVector aux = vlln.getPos();
  //        Ataque nuevo = new Ataque(tipoVillano, aux.x, aux.y);
  //        ataques.add(nuevo);
          
  //      }
  //    }
  //    else if (nivel == 3) {
  //      if (ataques.size() < 6) {
  //        tipoVillano = 3;
  //        PVector aux = vlln.getPos();
  //        Ataque nuevo = new Ataque(tipoVillano, aux.x, aux.y);
  //        ataques.add(nuevo);
          
  //      }
  //    }
      
  //    //instanteAtaque = millis();
  //  }
  
  
  
  
  
}

void escJuegoNIV2(){
  escJuego2.display();
  textSize(15);
  fill(255);
  textAlign(CENTER);
  text("Nivel 2", width/2,20);
  playI.pause();
  playJ.play();
  //playJ.loop();
  
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
  

//Ataques de mago a dragon
  for (int x=0; x < ataques.size(); x++){
    Ataque tmp = ataques.get(x);
    tmp.dibujar();
    tmp.mover();
    
    if (heroe.getPosDragon().dist(tmp.getPos()) < 150 && tmp.isPlaying()){
      explosiones.add(new Explosion(tipoVillano, tmp.getPos()));
      tmp.quitar();
      
      heroe.restarVida();
      if(heroe.getVida()==0){

      escenario = 8;
      //  instant = millis();
        //escGameOver();
      //}

        escenario = 8;
        escGameOver();
      }

    }
    
    if(!tmp.isPlaying()){
      ataques.remove(x);
    }
  
  }
  
  for (int x=0; x<explosiones.size(); x++) {
        Explosion tmp = explosiones.get(x);
        if (tmp.isActive()) {
          tmp.dibujar();
        }
        else
        explosiones.remove(x);
      }
    
    if (millis() - instanteAtaque > intervaloAtaque) {
    PVector aux = vlln2.getPos();
    Ataque nuevo = new Ataque(2, aux.x, aux.y);
    ataques.add(nuevo);
    instanteAtaque = millis();
  }
  
  
  //____________________________________________________Villano
  vlln2.dibujar();
  vlln2.mover();
  
  
  
 // Obtener la posicion del heroe para lanzar fuego
  for (int x=0; x < FuegoDragon.size(); x++){
    Fuego tmp = FuegoDragon.get(x);
    tmp.dibujar();
    tmp.mover();
    
    if (tmp.getPosFuego().dist(vlln2.getPos()) < 120 && tmp.isPlaying()){
      fuegos.add(new FuegoAnimacion(heroeSeleccionado, tmp.getPosFuego()));
      tmp.quitar();
      

      vlln2.restarVida();
        if(vlln2.getVida() == 0){
          escenario = 6;
        }
      }

      //heroe.quitarVida();

    }
    
    //if(!tmp.isPlaying()){
    //  FuegoDragon.remove(x);
    //}
  
  
  
  for (int x=0; x<fuegos.size(); x++) {
        FuegoAnimacion tmp = fuegos.get(x);
        if (tmp.isActive()) {
          tmp.dibujar();
        }
        else
        fuegos.remove(x);
      }
    
  
  
  //____________________________________________________Heroe
  heroe.moverYdibujo(mouseY, mouseX);
  heroe.getPosDragon();
  

  
  
  
  
  
  //if (vlln.getVida() == 0 ) {
  //  if (cambioNivel == false) {
  //    nivel++;
  //    cambioNivel = true;
  //    intervaloEnemigo -= 400;
  //  }
  //}
  
  
  
  
  //if (nivel < 4) {
  //  for (int x=0; x < ataques.size(); x++){
  //    Ataque tmp = ataques.get(x);
  //    tmp.dibujar();
  //    tmp.mover();
    
  //    if (heroe.getPosDragon().dist(tmp.getPos()) < 150 && tmp.isPlaying()){
  //      explosiones.add(new Explosion(tipoVillano, tmp.getPos()));
  //      tmp.quitar();
        
  //      heroe.restarVida();
  //    //if(heroe.getVida()==0){
  //    //  escenario = 5;
  //    //  instant = millis();
  //      //escGameOver();
  //    //}
  //  }
    
  //  if(!tmp.isPlaying()){
  //    ataques.remove(x);
  //  }
  
  //}
  
  
  ////Explosiones
  //for (int x=0; x<explosiones.size(); x++) {
  //      Explosion tmp = explosiones.get(x);
  //      if (tmp.isActive()) {
  //        tmp.dibujar();
  //      }
  //      else
  //      explosiones.remove(x);
  //    }
      
      
  //    for (int x=0; x < FuegoDragon.size(); x++){
  //  Fuego tmp = FuegoDragon.get(x);
  //  tmp.dibujar();
  //  tmp.mover();
    
  //  if (tmp.getPosFuego().dist(vlln.getPos()) < 120 && tmp.isPlaying()){
  //    fuegos.add(new FuegoAnimacion(heroeSeleccionado, tmp.getPosFuego()));
  //    tmp.quitar();
      
  //    vlln.restarVida();
  //  }
    
  //  if(!tmp.isPlaying()){
  //    FuegoDragon.remove(x);
  //  }
  
  //}
  
  
  ////AnimacionFuego
  //for (int x=0; x<fuegos.size(); x++) {
  //      FuegoAnimacion tmp = fuegos.get(x);
  //      if (tmp.isActive()) {
  //        tmp.dibujar();
  //      }
  //      else
  //      fuegos.remove(x);
  //    }
    
      
      
      
      
    
    
  //    if (nivel == 1) {
  //      if (ataques.size() < 3) {
  //        tipoVillano = 1;
  //        PVector aux = vlln.getPos();
  //        Ataque nuevo = new Ataque(tipoVillano, aux.x, aux.y);
  //        ataques.add(nuevo);
          
  //      }
  //    }
  //    else if (nivel == 2) {
  //      if (ataques.size() < 5) {
  //        tipoVillano = 2;
  //        PVector aux = vlln.getPos();
  //        Ataque nuevo = new Ataque(tipoVillano, aux.x, aux.y);
  //        ataques.add(nuevo);
          
  //      }
  //    }
  //    else if (nivel == 3) {
  //      if (ataques.size() < 6) {
  //        tipoVillano = 3;
  //        PVector aux = vlln.getPos();
  //        Ataque nuevo = new Ataque(tipoVillano, aux.x, aux.y);
  //        ataques.add(nuevo);
          
  //      }
  //    }
      
  //    //instanteAtaque = millis();
  //  }
  
  
  
  
  
  
  
  



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
    escJuegoNIV1();
    }
    //
  else if(escenario == 5){
      escJuegoNIV2();
    }
  else if(escenario == 6){
      //escJuegoNIV3();
  }
  else if(escenario == 8){
    escGameOver();
  }
}

void keyPressed(){
  if (escenario == 3 ) {
    if (key == 's' || key == 'S') {
      
      //Nivel 1
      heroeSeleccionado = 's';
      heroe.selDragon(1);
      escJuego1.selEsc(1);
      escJuego2.selEsc(1);
      escJuego3.selEsc(1);
      escenario = 4;
      
      instanteAtaque = millis();
      intervaloAtaque = 5000;
     
      
      
      
    }
    
    if (key == 'E' || key == 'e'){
      heroeSeleccionado = 'e';
      escJuego1.selEsc(2);
      escJuego2.selEsc(2);
      escJuego3.selEsc(2);
      heroe.selDragon(2);
      escenario = 4;
      instanteAtaque = millis();
      intervaloAtaque = 5000;
      
      
      
      
    }
    if (key == 'V' || key == 'v'){
      
      heroeSeleccionado = 'v';
      heroe.selDragon(3);
      escJuego1.selEsc(3);
      escJuego2.selEsc(3);
      escJuego3.selEsc(3);
      escenario = 4;
      instanteAtaque = millis();
      intervaloAtaque = 5000;
      
      
      
      
     }
  }
  
  
  if (key == ' ')  {
    if (escenario == 4 || escenario ==5 || escenario ==6) {
      //heroe.disparar();
      PVector aux = heroe.getPosDragon();
      Fuego nuevo = new Fuego(heroeSeleccionado,aux.x, aux.y);
      FuegoDragon.add(nuevo);
      println(FuegoDragon.size());
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
    
  }
  
  
  
  

}
