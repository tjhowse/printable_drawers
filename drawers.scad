unit_x = 100;
unit_y = 60;
unit_z = 40;
// unit_x = 50;
// unit_y = 50;
// unit_z = 40;

drawer_wall_thickness = 2;
frame_wall_thickness = 3;
zff = 0.01;
slide_clearance = 0.5;
base_rim = 5;

post_width = 10;
stack_groove_z = 5;

handle_y = 30;
handle_x = 15;

module drawer(units_x, units_y, units_z)
{
	drawer_x = unit_x * units_x - drawer_wall_thickness;
	drawer_y = unit_y * units_y - slide_clearance*2 - drawer_wall_thickness*2;
	drawer_z = unit_z * units_z - slide_clearance - drawer_wall_thickness;
	difference()
	{
		cube([drawer_x,drawer_y,drawer_z]);
		translate([drawer_wall_thickness,drawer_wall_thickness,drawer_wall_thickness]) cube([drawer_x-drawer_wall_thickness*2,drawer_y-drawer_wall_thickness*2,drawer_z-drawer_wall_thickness]);
	}
	// Handle
	
	difference()
	{
		translate([drawer_x-handle_x/sqrt(2),drawer_y/2-handle_y/2,drawer_z/2]) rotate([0,45,0]) union()
		// translate([drawer_x-handle_x/sqrt(2),drawer_y/2-handle_y/2,drawer_z/2]) rotate([0,0,0]) union()
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

}

module frame(units_x, units_y, units_z)
{
	frame_x = unit_x * units_x;
	frame_y = unit_y * units_y;
	frame_z = unit_z * units_z;
	
	difference()
	{
		union()
		{
			difference()
			{
				cube([frame_x,frame_y,frame_wall_thickness]);
				translate([base_rim,base_rim,0]) cube([frame_x-2*base_rim,frame_y-2*base_rim,frame_wall_thickness]);
			}
			
			// Slide guides
			translate([0,0,frame_wall_thickness]) cube([frame_x,frame_wall_thickness,frame_wall_thickness]);
			translate([0,frame_y-frame_wall_thickness,frame_wall_thickness]) cube([frame_x,frame_wall_thickness,frame_wall_thickness]);
		}
		post_subtraction();
		translate([frame_wall_thickness,0,0]) rotate([0,0,90]) post_subtraction();
		
		translate([0,frame_y-frame_wall_thickness,0]) post_subtraction();
		translate([0,frame_y-post_width,]) translate([frame_wall_thickness,0,0]) rotate([0,0,90]) post_subtraction();
		translate([frame_x-post_width,0,0]) post_subtraction();
		translate([frame_x-post_width,frame_y-frame_wall_thickness,0]) post_subtraction();
	}
	
	// Posts
	post(frame_z);
	translate([frame_wall_thickness,0,0]) rotate([0,0,90]) post(frame_z);
	
	translate([0,frame_y-frame_wall_thickness,0]) post(frame_z);
	translate([0,frame_y-post_width,]) translate([frame_wall_thickness,0,0]) rotate([0,0,90]) post(frame_z);
	
	translate([frame_x-post_width,0,0]) post(frame_z);
	translate([frame_x-post_width,frame_y-frame_wall_thickness,0]) post(frame_z);
}

module post(frame_z)
{
	difference()
	{
		union()
		{
			translate([0,0,frame_wall_thickness]) cube([post_width,frame_wall_thickness,frame_z - frame_wall_thickness]);
			translate([0,0,frame_wall_thickness+frame_z - frame_wall_thickness]) rotate([0,45,0]) cube([post_width/sqrt(2),frame_wall_thickness,post_width/sqrt(2)]);
		}
		post_subtraction();
	}
}
module post_subtraction()
{
	intersection()
	{
		rotate([0,45,0]) cube([post_width/sqrt(2),frame_wall_thickness,post_width/sqrt(2)]);
		cube([100,100,100]);
	}
}

frame(1,1,1);
// translate([drawer_wall_thickness,drawer_wall_thickness+slide_clearance,drawer_wall_thickness+slide_clearance]) drawer(1,1,1);

// drawer(1,1,1);