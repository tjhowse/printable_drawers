/*
	Parametric 3D Printable Small Parts Drawers v1.0
	Copyright (C) 2014 Travis John Howse
	tjhowse at gmail.com

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

// Dimensions of one unit of the drawer matrix.
unit_x = 98;
unit_y = 65;
unit_z = 45;

// Adust this scalar until the posts fit snugly in the face slots
post_thickness_scalar = 0.72;

drawer_wall_thickness = 1;
frame_wall_thickness = 4;
zff = 0.01;
slide_clearance = 1;

post_thickness = 2.2;
post_fin_x = frame_wall_thickness*2;
post_extra = 1.5;
frame_width = frame_wall_thickness+post_thickness;

handle_y = 30;
handle_x = 15;
frame_face_z = 3;
frame_face_pegs = 5;
drawer_lip = 2;

module drawer(units_x, units_y, units_z)
{
	drawer_x = unit_x * units_x - frame_wall_thickness;
	drawer_y = unit_y * units_y - slide_clearance*2 - frame_width*2;
	drawer_z = unit_z * units_z - slide_clearance*2 - frame_width*2;
	
	difference()
	{
		cube([drawer_x,drawer_y,drawer_z]);
		translate([drawer_wall_thickness,drawer_wall_thickness,drawer_wall_thickness]) cube([drawer_x-drawer_wall_thickness*2,drawer_y-drawer_wall_thickness*2,drawer_z-drawer_wall_thickness]);
	}
	// Handle
	difference()
	{
		translate([drawer_x-handle_x/sqrt(2),drawer_y/2-handle_y/2,drawer_z/2]) rotate([0,45,0]) union()
		{
			difference()
			{
				cube([handle_x,handle_y,handle_x]);
				translate([0,drawer_wall_thickness,drawer_wall_thickness]) cube([handle_x-drawer_wall_thickness,handle_y-drawer_wall_thickness*2,handle_x-drawer_wall_thickness]);
			}
			translate([handle_x-drawer_wall_thickness*2,drawer_wall_thickness,handle_x-drawer_wall_thickness]) cube([drawer_wall_thickness,handle_y-drawer_wall_thickness*2,drawer_wall_thickness]);
		}
		cube([drawer_x,drawer_y,drawer_z]);
	}
	translate([drawer_x-drawer_wall_thickness,0,drawer_z]) cube([drawer_wall_thickness,drawer_y,drawer_lip]);
	translate([0,0,drawer_z]) cube([drawer_wall_thickness,drawer_y,drawer_lip]);
}

module post(units_x)
{
	post_x = unit_x * units_x;
	cube([post_x,post_fin_x*3+post_thickness*post_thickness_scalar*2+post_extra,post_thickness*post_thickness_scalar]);
	translate([0,post_fin_x,post_thickness*post_thickness_scalar]) cube([post_x,post_thickness*post_thickness_scalar,post_fin_x]);
	translate([0,post_fin_x*2+post_thickness*post_thickness_scalar+post_extra,post_thickness*post_thickness_scalar]) cube([post_x,post_thickness*post_thickness_scalar,post_fin_x]);
}

module edge_post(units_x)
{
	post_x = unit_x * units_x;
	cube([post_x,post_fin_x+post_thickness*post_thickness_scalar+frame_wall_thickness,post_thickness*post_thickness_scalar]);
	translate([0,post_fin_x,post_thickness*post_thickness_scalar]) cube([post_x,post_thickness*post_thickness_scalar,post_fin_x]);
	
}

module post_subtract()
{
	translate([0,0,0])union()
	{
		translate([-(post_fin_x*2+post_thickness)/2,-post_thickness/2,0]) cube([post_fin_x*2+post_thickness,post_thickness,50]);
		rotate([0,0,90]) translate([-(post_fin_x*2+post_thickness)/2,-post_thickness/2,0]) cube([post_fin_x*2+post_thickness,post_thickness,50]);
	}
}

module frame_face_single(units_z, units_y)
{
	frame_x = unit_z * units_z;
	frame_y = unit_y * units_y;
	frame_z = frame_face_z+frame_face_pegs;
	
	difference()
	{
		cube([frame_x,frame_y,frame_z]);
		translate([frame_width,frame_width,0]) cube([frame_x-frame_width*2,frame_y-frame_width*2,frame_z]);
		translate([frame_wall_thickness+post_thickness*1.5+frame_x-frame_width*2-zff,frame_wall_thickness+post_thickness/2+zff,frame_face_z]) post_subtract();
		translate([frame_wall_thickness+post_thickness/2+zff,frame_wall_thickness+post_thickness/2+zff,frame_face_z]) post_subtract();
		translate([frame_wall_thickness+post_thickness/2+zff,frame_wall_thickness+post_thickness*1.5+frame_y-frame_width*2-zff,frame_face_z]) post_subtract();
		translate([frame_wall_thickness+post_thickness*1.5+frame_x-frame_width*2-zff,frame_wall_thickness+post_thickness*1.5+frame_y-frame_width*2-zff,frame_face_z]) post_subtract();
		
		translate([frame_width+post_fin_x,0,frame_face_z]) cube([frame_x-frame_width*2-post_fin_x*2,frame_y,frame_z]);
		translate([0,frame_width+post_fin_x,frame_face_z]) cube([frame_x,frame_y-frame_width*2-post_fin_x*2,frame_z]);
	}
}

module frame_face(units_z, units_y)
{
	difference()
	{
		union()
		{
			for (j = [0 : units_z-1])
			{
				for (i = [0 : units_y-1])
				{
					translate([i*(unit_z),j*(unit_y),0]) frame_face_single(1,1);
				}
			}
		}
		translate([frame_width,frame_width,-zff]) cube([unit_z * units_y-frame_width*2,unit_y * units_z-frame_width*2,frame_face_z+frame_face_pegs+2*zff]);
	}
	
}

module set_unit_faces(x,y)
{
	for (j = [0 : y-1])
	{
		for (i = [0 : x-1])
		{
			translate([i*(unit_z+5),j*(unit_y+5),0]) frame_face(1,1);
		}
	}
}

module set_unit_posts(x,y)
{
	for (j = [0 : y-1])
	{
		for (i = [0 : x-1])
		{
			translate([i*(unit_x+1),j*((post_fin_x*3+post_thickness*post_thickness_scalar*2+post_extra)+5),0]) post(1);
		}
	}	
}

module set_unit_drawers(x,y)
{
	for (j = [0 : y-1])
	{
		for (i = [0 : x-1])
		{
			translate([i*(unit_x+10),j*(unit_y-10),0]) drawer(1,1,1);
		}
	}
}

module assembled_unit()
{
	rotate([0,-90,0]) frame_face(1,1);
	translate([-unit_x+5,frame_width+slide_clearance/2,frame_width+slide_clearance/2]) drawer(1,1,1);
	translate([-unit_x-frame_face_z,-(post_fin_x*3+post_thickness*post_thickness_scalar*2+post_extra)/2,frame_wall_thickness]) post(1);
	translate([-unit_x-frame_face_z,-(post_fin_x*3+post_thickness*post_thickness_scalar*2+post_extra)/2,unit_z-frame_wall_thickness-post_thickness]) post(1);
}

module assembled()
{
	// A very rough demo on how all the parts fit together. In a proper assembly there should be:
	// * A second set of frame_faces(int,int) parts on the back,
	// * The big 2x2 drawer should have four more posts around it,
	// * The posts on the right of the big drawer should be rotated 90 degrees along the x axis
	// * The right hand side should have five more posts on it,
	// * The side posts should be rotated 90 degrees along x so nothing pokes out the sides,
	// * The top posts should be rotated 180 degrees along x so nothing pokes out the top.
	
	assembled_unit();
	translate([0,unit_y,0]) assembled_unit();
	translate([0,2*unit_y,0]) assembled_unit();
	translate([0,3*unit_y,0]) assembled_unit();
	translate([0,0,unit_z]) assembled_unit();
	translate([0,0,2*unit_z]) assembled_unit();
	translate([0,0,3*unit_z]) assembled_unit();
	translate([0,3*unit_y,unit_z]) assembled_unit();
	translate([0,3*unit_y,2*unit_z]) assembled_unit();
	translate([0,3*unit_y,3*unit_z]) assembled_unit();	
	translate([0,unit_y,3*unit_z]) assembled_unit();
	translate([0,2*unit_y,3*unit_z]) assembled_unit();
	translate([0,unit_y,unit_z]) rotate([0,-90,0]) frame_face(2,2);
	translate([-unit_x+5,unit_y+frame_width+slide_clearance/2,unit_z+frame_width+slide_clearance/2]) drawer(1,2,2);	
}

// Use these for printing batches of parts
// set_unit_faces(4,2);
// set_unit_posts(2,6);
// set_unit_drawers(1,3);
// %cube([200,200,200]);

// frame_face(1,1);
// post(1);
// edge_post(1);
// drawer(1,1,1);

assembled();