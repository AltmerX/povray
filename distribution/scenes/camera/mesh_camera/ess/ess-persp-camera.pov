// This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/ or send a
// letter to Creative Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041, USA.

// Persistence Of Vision Raytracer sample file.
// Demo for extreme super-sampling using the mesh_camera.
// See the README.txt file for more information.

/*********************************************************************************************
 * $File: //depot/povray/smp/distribution/scenes/camera/mesh_camera/ess/ess-persp-camera.pov $
 * $Revision: #1 $
 * $Change: 5407 $
 * $DateTime: 2011/02/21 15:33:00 $
 * $Author: jholsenback $
 ********************************************************************************************/
#version 3.7;

global_settings { assumed_gamma 1.0 }

#include "colors.inc"
#include "stones.inc"

#local near_plane = .1;
#local camera_width = 4;
#local camera_height = camera_width * image_height / image_width;
#local tmp = near_plane/3;
#local camera_width = camera_width*tmp;
#local camera_height = camera_height*tmp;
#local px_inc = camera_width / image_width; // Distance between vertices in the mesh
#local py_inc = camera_height / image_height;
#declare ca_mesh =
  mesh {
    #local row_count = 0;
    #while (row_count < image_height)
      #local col_count = 0;
      #local d_y = camera_height - 2*py_inc - row_count * py_inc;
      #while (col_count < image_width)
        #local d_x = col_count * px_inc;
		#local ex = d_x - camera_width / 2;
		#local ey = d_y - camera_height / 2;
		#local ez = near_plane;
		#local el = vlength(<ex, ey, ez>);
		#if((ex=0) & (ey=0))
			#local a = 0;
		#else
			#local a = atan2(ex, -ey);
		#end
		#local b = degrees(acos(ez / el));
		#local r = <cos(a), sin(a), 0>;
        triangle {
          <d_x, d_y, 0>
          <d_x, d_y, 0> + vaxis_rotate(<px_inc, py_inc, 0>, r, b)
          <d_x, d_y, 0> + vaxis_rotate(<px_inc, 0, 0>, r, b)
        }
        #local col_count = col_count + 1;
      #end
      #local row_count = row_count + 1;
    #end
  }

#declare sampleCount = 5;

// Our sample grid per pixel is sampleCount by sampleCount.
// In other words, sampleCount is the square root of the number of samples per pixel.
camera {
  mesh_camera {
    sampleCount * sampleCount
    0 // distribution #0 averages values from multiple meshes as described
    #local i = 0;
    #while(i < sampleCount)
      #local j = 0;
      #while(j < sampleCount)
        mesh {
          ca_mesh
          translate <(i / sampleCount - .5)*px_inc/tmp, (j / sampleCount - .5)*py_inc/tmp, 0>
          translate <-camera_width/2, -camera_height/2, -3 + near_plane>
        }
        #local j = j + 1;
      #end
      #local i = i + 1;
    #end
  }
}

light_source {
			 <2, 4, -3>
			 color White
}

sphere {
	   <0, 0, 0>, 1
	   texture {
	   		   T_Stone25
			   scale 4
	   }
}

#local i = 0;
#while(i < 10)
		 #local j = 0;
		 #while(j < 10)
		 		  sphere {
		 	   	  		 <1+i/10, j/10, 0>, .001
						 texture {
						 		 pigment {color White*2}
			   			 }
         		  }
		 		  #local j = j + 1;
		 #end
		 #local i = i + 1;
#end
