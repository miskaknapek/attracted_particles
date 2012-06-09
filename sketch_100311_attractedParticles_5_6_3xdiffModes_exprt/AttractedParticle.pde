

class AttractedParticle{


  boolean active = false;
  // what kind of particle are we?
//  boolean attracting_or_repulsing_particle_trueFalse = true ; 
  int modeNumber_OfThisParticle = 0;
  /*
  0 = attracting
  1 = repulsed
  2 = repulsing others
  */
  

  int id ;

  float curr_x ;
  float curr_y ;

  float vel_x ;
  float vel_y ;

  // 
  float acc_x ;
  float acc_y ;

  // 
  float friction_x ;
  float friction_y ;


  // current particle colour - depending on whether
  // it's moving or not


  // ________________________________


  // constructor
  AttractedParticle(){

    println(" \n ___ ooh! looks like we've got a particle! ");

  }


  // =============================================
  // class methods

  // -- attraction

    // -- move?

  // -- draw

  void update(){

    // - do we zero the velocity?
    // - accelleration?
    //// println(" do we zero the accelleration?????????????????????????????????");

    // ________ set the accelleration according to the 
    //             attraction by others

    // check for every other particle
    for( int i = 0 ; i < attractedParticles.length; i++ ){

      if( i == id ){
        continue ;  
      }


      // __ find the distance to the other
      float dx = attractedParticles[i].curr_x - curr_x ;
      float dy = attractedParticles[i].curr_y - curr_y ;

      // _ pythagoreus time
      float dist_to_other = sqrt( dx*dx + dy*dy );


      // __ if we're close enough, calculate and add velocity ... and don't do anything if we're close enough together
      //     moving the balls *together*
      if( dist_to_other < attraction_maxDistance /* && dist_to_other > attraction_minDistance */ ){

        // __ linear fall-off? 

        // __ distance effect
        //  this has a larger effect the closer things are
        float distance_speed_multiplier = ( 1.0 / dist_to_other ) * attraction_force_multiplier ;

        // normalise vector
        float normalised_vector_multiplier = 1.0 / dist_to_other;
        float normalised_dx = dx * normalised_vector_multiplier ;
        float normalised_dy = dy * normalised_vector_multiplier ;

        // _ relev attraction vector
        float relev_vector_to_other_x = distance_speed_multiplier * normalised_dx ;
        float relev_vector_to_other_y = distance_speed_multiplier * normalised_dy ;        


        // ___ add the vector to the accelleration 

        // if we're attracting something...
        if( modeNumber_OfThisParticle == 0 ){
          acc_x += relev_vector_to_other_x ;
          acc_y += relev_vector_to_other_y ;
        }
        //  and if we're being repulsed
        else if( modeNumber_OfThisParticle == 1 ){
          acc_x += -relev_vector_to_other_x ;
          acc_y += -relev_vector_to_other_y ;
        }
        //  and if we're REPUsLING OTHERS
        else if( modeNumber_OfThisParticle == 2 ){
          attractedParticles[i].acc_x += relev_vector_to_other_x * repulsing_others_force_multiplier ;
          attractedParticles[i].acc_y += relev_vector_to_other_y * repulsing_others_force_multiplier ;          
        }
      }

    }  // end check others loop


    // ___ and finally

      // __  add the accelleration to the velocity
    vel_x += acc_x ;
    vel_y += acc_y ; 

    // zero the accelleration ( nice cleanup for the next loop ) ;
    acc_x = 0 ;
    acc_y = 0 ;

    // __  introduce friction to the velocity !
    vel_x *= friction ;
    vel_y *= friction ;      

    // __  add the velocity to the position 
    curr_x += vel_x ;
    curr_y += vel_y ;


    // _______ make sure things stay inside
    stay_inside_bounds();


  }  //  c'est tout?




  // ________________________________________________


  void stay_inside_bounds(){


    if( curr_x > width ){
      curr_x = width ;
    }
    else if( curr_x < 0){
      curr_x = 0;
    }

    if( curr_y > height ){
      curr_y = height;
    }
    else if( curr_y < 0 ){
      curr_y = 0;
    }

  }



  // ___________________________________________



  void drawMe(){


    // change the colour depending on 
    // whether the particle is moving or not
    if( acc_x != 0 || acc_y != 0 ){

      // colour depending on whether we're attracting or repulsing
      if( modeNumber_OfThisParticle == 0 ){
        stroke( particle_col_if_moving_and_attracting );
      }
      //  repulsing particle colour
      else if( modeNumber_OfThisParticle == 1 ){
        stroke(  particle_col_if_moving_and_repulsed );
      }
      else if( modeNumber_OfThisParticle == 2 ){
        stroke(  particle_col_if_moving_and_repulsingOthers );
      }

    }
    //  not moving!
    else{

      // colour depending on whether we're attracting or repulsing
      if( modeNumber_OfThisParticle == 0 ){
        stroke( particle_col_if_static_and_attracting );
      }
      //  repulsing particle colour
      else if( modeNumber_OfThisParticle == 1 ){
        stroke(  particle_col_if_static_and_repulsed );
      }
      else if( modeNumber_OfThisParticle == 2 ){
        stroke(  particle_col_if_static_and_repulsingOthers );
      }

    }

    //  draw the shape    
    ellipse( curr_x, curr_y, particle_radius, particle_radius );


    // ___ the attractor/repulsion ring 


      // colour depending on whether we're attracting or repulsing
      if( modeNumber_OfThisParticle == 0 ){
        stroke( particle_attraction_force_ring_colour_if_attracting );
      }
      //  repulsing particle colour
      else if( modeNumber_OfThisParticle == 1 ){
        stroke(  particle_attraction_force_ring_colour_if_repulsed );
      }
      else if( modeNumber_OfThisParticle == 2 ){
        stroke(  particle_attraction_force_ring_colour_if_repulsingOthers );
      }

/*
    //  set different colour deping on whether we're attracting or repulsing
    if( attracting_or_repulsing_particle_trueFalse ){
      stroke( particle_attraction_force_ring_colour_if_attracting );
    }
    // repulsing colour
    else{
      stroke( particle_attraction_force_ring_colour_if_repulsed );
    }
*/

    // draw the attraction area
    ellipse( curr_x, curr_y, attraction_maxDistance*2, attraction_maxDistance*2 );


    // __ draw the line indicating the velocity direction
    float vel_line_end_x = curr_x + ( vel_x * vel_indication_line_magnification );
    float vel_line_end_y = curr_y + ( vel_y * vel_indication_line_magnification );
    line( curr_x, curr_y, vel_line_end_x, vel_line_end_y );
  }



}












