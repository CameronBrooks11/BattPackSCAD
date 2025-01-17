use <../battery_holder.scad>;
use <../battery_lib.scad>

// Battery cell type
battery_type = "26650"; // Battery type

// Battery holder parameters
body_height = 8;          // height of the holder
wall_thickness = 2.4;     // thickness of the holder
retainer_thickness = 1.2; // thickness of the retainer

battery_diameter = BatteryLib_TotalDiameter(battery_type);
echo("Battery diameter: ", battery_diameter);

render_battery = false; // Show battery model and top holder

// Generate the battery holder
battery_holder(diameter = battery_diameter, height = body_height, wall_thickness = wall_thickness,
               retainer_thickness = retainer_thickness);

if (render_battery)
{
    // Generate the battery cell
    translate([ 0, 0, -BatteryLib_CathodeHeight(battery_type) ]) color("MediumSpringGreen")
        BatteryLib_GenerateBatteryModel("26650");

    // Generate the top holder
    translate([ 0, 0, BatteryLib_BodyHeight(battery_type) - body_height + retainer_thickness ])
        battery_holder(diameter = battery_diameter, height = body_height, wall_thickness = wall_thickness,
                       retainer_thickness = retainer_thickness);
}