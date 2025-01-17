//use <BattPackSCAD/battery_holder.scad>;
//use <BattPackSCAD/battery_lib.scad>;

use <../battery_holder.scad>;
use <../battery_lib.scad>;

battery_type = "18650";

battery_holder(diameter=BatteryLib_TotalDiameter(battery_type), height=6, wall_thickness=3, retainer_thickness=2);