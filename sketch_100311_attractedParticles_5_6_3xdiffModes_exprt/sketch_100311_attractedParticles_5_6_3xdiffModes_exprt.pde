



/*
100311
 
 making a particle attraction system,
 to test the idea of trying to make things
 that both attract and repulse one another 
 
 - each particle is slightly attracted by the others
 - attraction changes the velocity!
 - each particle also repulses particles from itsself
 
 */



//  lifesaver
int debug = 3;

//   another lifesaver
import processing.opengl.* ;


// ___________________________________________


boolean attraction_or_repulsion_trueFalse = true ;

int curr_part_mode_index = 0;
String[] possible_particle_mode = { 
  "attracting", "repulsed", "repulsing_others" };


// ___________________________________________

//   some particle bits

int num_particles = 25;
AttractedParticle[] attractedParticles;


// attraction
float attraction_force_multiplier = 5.1 ;

// repulsing others
float repulsing_others_force_multiplier = 6.0 ;


// attraction max distance
//  no attraction beyond this distance
float attraction_maxDistance = 150;
float attraction_minDistance = 50;

//  friction
float friction = 0.9;



// visual attributes
// ( guess I never quite got around to implement the things using
//    the static colourings... oops! )

float particle_radius = 15;

color particle_col_if_static_and_attracting = color( 255, 0, 0, 128);
color particle_col_if_moving_and_attracting = color( 255, 0, 0, 200);

color particle_col_if_static_and_repulsed = color( 0, 0, 255, 128);
color particle_col_if_moving_and_repulsed = color( 0, 0, 255, 200);

color particle_col_if_static_and_repulsingOthers = color( 0, 255, 0, 200);
color particle_col_if_moving_and_repulsingOthers = color( 0, 255, 0, 200);

color particle_attraction_force_ring_colour_if_attracting = color( 255, 0, 0, 64 );
color particle_attraction_force_ring_colour_if_repulsed = color( 0, 0, 255, 64 );
color particle_attraction_force_ring_colour_if_repulsingOthers = color(  0, 255, 0, 64 );

float particle_strokeWeight = 0.1;


// __ drawing the direction indication
boolean draw_vel_indication = true ;
float vel_indication_line_magnification = 15;


// ___ which particle are we using?
int curr_particle_i = 0 ;


// ___________________________________________________________________

void setup(){
  size( 800, 800, OPENGL );
  frameRate( 25 ); 

  // _ no filling
  noFill();

  // _____ strokeweight
  strokeWeight( particle_strokeWeight );


  // ___ set up particles!
  setupParticles();

}



// _________________________________________________



void draw(){

  background( 255 );

  // ___  update and draw
  for( int i = 0; i <  attractedParticles.length; i++ ){

    if( attractedParticles[i].active == true ){
      attractedParticles[i].update();
      attractedParticles[i].drawMe();        
    }
  }

}



// _______________________________________________



void setupParticles(){

  // ____ setup particles!
  attractedParticles = new AttractedParticle[ num_particles ];

  for( int i = 0; i < num_particles; i++ ){
    attractedParticles[i] = new AttractedParticle();
    attractedParticles[i].id = i;
  }

  // reset the current particle number
  curr_particle_i = 0;
}



// _____________________________________________




void increment_curr_particle_i(){

  curr_particle_i = (curr_particle_i+1) % num_particles ;

}



// ================== keyboard mouse interaction ==========================

/*

 set up a new particle
 
 */


void mouseReleased(){

  // __ set up 

  println(" looking at particle i = "+curr_particle_i );

  attractedParticles[ curr_particle_i ].active = true;
  attractedParticles[ curr_particle_i ].curr_x = mouseX;
  attractedParticles[ curr_particle_i ].curr_y = mouseY;
  attractedParticles[ curr_particle_i ].vel_x = 0;
  attractedParticles[ curr_particle_i ].vel_y = 0;      
  //   and finally, is it an attracting or repulsing particle?
  // __ attracting or repulsing particle?
  attractedParticles[ curr_particle_i ].modeNumber_OfThisParticle =  curr_part_mode_index;


  // for the next setup
  increment_curr_particle_i();     
}



/*

 keycommands
 
 */


void keyPressed(){


  println(" attraction_force_multiplier = "+attraction_force_multiplier );  

  if( key == CODED ){

    if( keyCode == SHIFT ){
      //      attraction_or_repulsion_trueFalse = !attraction_or_repulsion_trueFalse ;
      //      println(" attraction_or_repulsion_trueFalse = "+attraction_or_repulsion_trueFalse );
      curr_part_mode_index = (curr_part_mode_index + 1) % possible_particle_mode.length ;
      println(" curr_part_mode_index = "+curr_part_mode_index+" ... ie. "+possible_particle_mode[curr_part_mode_index] );
    }

  }


  // _____  reset particles
  if( key == 'q' || key == 'Q' ){
    setupParticles();
  }


  // _____  reverse the attraction / repulsion on them all 
  if( key == 'x' || key == 'X' ){

    for( int i = 0; i < attractedParticles.length ; i++ ){
      attractedParticles[ i ].modeNumber_OfThisParticle = (attractedParticles[ i ].modeNumber_OfThisParticle + 1 )%possible_particle_mode.length ;
    }
  }


  //   set the attraction repulsion speed
  else{
    String buff = "" ;
    char k = key ;
    buff += k ;
    float buff_as_float = float( buff );
    if( buff_as_float >= 0 || buff_as_float <= 9 ){
      attraction_force_multiplier = buff_as_float ;
      println(" attraction_force_multiplier = "+attraction_force_multiplier );
    }    
  }


}
















