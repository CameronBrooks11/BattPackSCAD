use <../battery_holder.scad>;
use <../battery_lib.scad>

zFite = $preview ? 0.1 : 0; // z-fighting avoidance for preview
render_battery = false;      // Show battery model and top holder

// Battery cell type
battery_type = "26650"; // Battery type

// Battery holder parameters
holder_height = 6;    // holder_height of holder
holder_thickness = 2; // holder_thickness of holder
conn_depth = 3;       // depth of the connector
tab_radius = 3;       // tab_radius radius
tol = 0.2;            // Tolerance to help fit

// Generate the battery holder
rotate([ 0, 180, 0 ]) translate([ 0, 0, -(holder_height + zFite) ])
    battery_holder(cell_diameter = BatteryLib_TotalDiameter(battery_type), height = holder_height,
                   thickness = holder_thickness, connector_depth = conn_depth, cell_tolerance = tol,
                   conn_tolerance = tol, tab_radius = tab_radius);

// Generate the battery cell and top holder
if (render_battery)
{
    translate([ 0, 0, BatteryLib_BodyHeight(battery_type) - holder_height + zFite ]) battery_holder(
        cell_diameter = BatteryLib_TotalDiameter(battery_type), height = holder_height, thickness = holder_thickness,
        connector_depth = conn_depth, cell_tolerance = tol, conn_tolerance = tol);
    translate([ 0, 0, -BatteryLib_CathodeHeight(battery_type) ]) color("MediumSpringGreen")
        BatteryLib_GenerateBatteryModel("26650");
}