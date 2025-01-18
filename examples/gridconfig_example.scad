use <../battery_holder.scad>;
use <../battery_lib.scad>

zFite = $preview ? 0.1 : 0; // z-fighting avoidance for preview

// Battery cell parameters
batt_dia = BatteryLib_TotalDiameter("18650"); // batt_dia of a 18650 cell
echo("batt_dia: ", batt_dia);

// Parameters for the battery holder
holder_height = 6; // holder_height of holder
wall_thick = 2;    // wall thickness
conn_depth = 3;    // depth of the connector

retainer_thick = 1.4; // retainer_thick holder_height

// Layout parameters
xCells = 2; // Number of cells in the x direction
yCells = 3; // Number of cells in the y direction

render_export = false; // Export the model

if (!render_export)
{
    batteryHolderConfig(cells_x = xCells, cells_y = yCells, width = batt_dia + wall_thick + conn_depth)
    {
        // Generate first battery holder model
        battery_holder(diameter = batt_dia, height = holder_height, wall_thickness = wall_thick,
                       connector_depth = conn_depth, retainer_thickness = retainer_thick);

        // Generate battery model
        color("DodgerBlue") BatteryLib_GenerateBatteryModel("18650");

        // Generate second battery holder model
        translate([ 0, 0, BatteryLib_TotalHeight("18650") ]) rotate([ 0, 180, 0 ])
            battery_holder(diameter = batt_dia, height = holder_height, wall_thickness = wall_thick,
                           connector_depth = conn_depth, retainer_thickness = retainer_thick);
    }
}
else
{
    // Single instance for export
    battery_holder(diameter = batt_dia, height = holder_height, wall_thickness = wall_thick,
                   connector_depth = conn_depth, retainer_thickness = retainer_thick);
}