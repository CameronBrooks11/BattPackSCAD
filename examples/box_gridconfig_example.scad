use <../battery_holder.scad>;
use <../battery_lib.scad>

zFite = $preview ? 0.1 : 0; // z-fighting avoidance for preview

// Battery cell parameters
batt_dia = BatteryLib_TotalDiameter("18650");      // batt_dia of a 18650 cell
batt_body_height = BatteryLib_BodyHeight("18650"); // batt_height of a 18650 cell
echo("batt_dia: ", batt_dia);
echo("batt_body_height: ", batt_body_height);

// Parameters for the battery holder
holder_height = 6; // holder_height of holder
wall_thick = 2;    // wall thickness
conn_depth = 3;    // depth of the connector
conn_allow = 0.2;  // Allowance between the connectors

retainer_thick = 1.4; // retainer_thick holder_height

// Layout parameters
xCells = 2; // Number of cells in the x direction
yCells = 2; // Number of cells in the y direction

// Box parameters
mounting_hole_diameter = 4; // Diameter of the mounting holes
flange_width = 10;          // Width of the flange
box_wall_thickness = 2;     // Thickness of the box walls
box_floor_thickness = 3;    // Thickness of the box floor
box_allowance = 0.3;        // Allowance for the box

render_export_box = false;     // Export the model
render_export_holder = true; // Export the holder

render_xsec = true; // Render the cross-section

if (!render_export_box && !render_export_holder)
{
    batteryHolderConfig(cells_x = xCells, cells_y = yCells, width = batt_dia + wall_thick + conn_depth)
    {
        // Generate first battery holder model
        battery_holder(diameter = batt_dia, height = holder_height, wall_thickness = wall_thick,
                       connector_depth = conn_depth, retainer_thickness = retainer_thick);

        // Generate battery model
        color("DodgerBlue") BatteryLib_GenerateBatteryModel("18650");

        // Generate second battery holder model
        translate([ 0, 0, BatteryLib_TotalHeight("18650") ]) rotate([ 0, 180, 0 ]) battery_holder(
            diameter = batt_dia, height = holder_height, wall_thickness = wall_thick, connector_depth = conn_depth,
            retainer_thickness = retainer_thick, connector_allowance = conn_allow);
    }

    // Generate the box
    render_battery_box();
}
else if (render_export_box)
{
    // Export the model
    render_battery_box();
}
else if (render_export_holder)
{
    // Generate first battery holder model
    battery_holder(diameter = batt_dia, height = holder_height, wall_thickness = wall_thick,
                   connector_depth = conn_depth, retainer_thickness = retainer_thick);
}
else
{
    echo("Invalid configuration");
}

module render_battery_box()
{
    // Generate the box
    if (render_xsec)
        difference()
        {
            battery_holder_box(battery_height = batt_body_height, battery_diameter = batt_dia, cells_x = xCells,
                               cells_y = yCells, wall_thickness = wall_thick, retainer_thickness = retainer_thick,
                               connector_depth = conn_depth, connector_allowance = conn_allow,
                               flange_width = flange_width, mounting_hole_diameter = mounting_hole_diameter,
                               box_wall_thickness = box_wall_thickness, box_floor_thickness = box_floor_thickness,
                               box_allowance = box_allowance);
            translate([ 0, -500, 0 ]) cube([ 1000, 1000, 1000 ], center = true);
        }
    else
    {
        battery_holder_box(battery_height = batt_body_height, battery_diameter = batt_dia, cells_x = xCells,
                           cells_y = yCells, wall_thickness = wall_thick, retainer_thickness = retainer_thick,
                           connector_depth = conn_depth, connector_allowance = conn_allow, flange_width = flange_width,
                           mounting_hole_diameter = mounting_hole_diameter, box_wall_thickness = box_wall_thickness,
                           box_floor_thickness = box_floor_thickness, box_allowance = box_allowance);
    }
}