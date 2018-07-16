// Barry O'Riordan - 13144278    

#include "colors.inc"
#include "stones.inc"
  
  // Gamma settings to emphasise the shadows.
  global_settings 
  {
    assumed_gamma 2.2
  }

  // Creating location of the camera and where to point it.
  camera
  { 
    location <6, 2, -6> 
    look_at  <0, 2, 2>
    aperture .2 focal_point <1, 0, 0> blur_samples 200 variance 1 / 10000
  }
  
  // Location of the light source.
  light_source
  {
    <2, 4, 8>, 1 spotlight point_at 0 radius 10
  }
  
  // Default color sky box.
  sky_sphere 
  {
    pigment 
    {
      LightBlue
    }
  }

#default 
{
  finish 
  {
    diffuse .9
    reflection 
    {
      .1 metallic
    } 
    ambient .3
  }
  
  normal 
  {
    granite scale .2
  }
}  
 
  // Creating a hexagonal plane.        
  plane 
  { 
    y, -1   
    
    pigment 
      {
        hexagon color rgb .7 color rgb .75 color rgb .65
      }
         
    normal 
    {
      hexagon scale 5
    }
  }

  // Creating a sphere and cutting into it with another.
  difference 
  {
    sphere 
    {
      <0, 0, 0>, 1
    }

    sphere 
    {
      <1, 0, 0>, .55
    }

    texture 
    {
      T_Stone8
    }

    rotate    <0, 0, -clock * 360 + 40>
    translate <-pi, 0, 0>
    translate <2 * pi * clock, 0, 0>
  }