use <../battery_holder.scad>;
use <../battery_lib.scad>

zFite = $preview ? 0.1 : 0; // z-fighting avoidance for preview

// Battery cell parameters
batt_dia = BatteryLib_TotalDiameter("18650"); // batt_dia of a 18650 cell
echo("batt_dia: ", batt_dia);

// Parameters for the battery holder
holder_height = 6; // holder_height of holder
wall_thick = 2;

retainer_thick = 1.4; // retainer_thick holder_height
retainer_rad = 2;     // retainer_radius radius

conn_depth = 3; // depth of the connector

tol = 0.2; // Tolerance to help fit

retaining_tabs = true;  // Retaining retainer for the battery
cable_tie_slots = true; // Cable tie slots for the battery holder

render_top_holder = true; // Show battery model and top holder

// Layout parameters
xCells = 2; // Number of cells in the x direction
yCells = 3; // Number of cells in the y direction

batteryHolderConfig(cells_x = xCells, cells_y = yCells, width = batt_dia + wall_thick + conn_depth, tolerance = tol)
    translate([ 0, 0, -tol ])
{
    battery_holder(diameter = batt_dia, height = holder_height, wall_thickness = wall_thick,
                   connector_depth = conn_depth, retainer_radius = retainer_rad, retainer_thickness = retainer_thick,
                   cell_tolerance = tol, connector_tolerance = tol, retainer = retaining_tabs,
                   tie_slot = cable_tie_slots);

    color("DodgerBlue") BatteryLib_GenerateBatteryModel("18650");

    translate([ 0, 0, BatteryLib_TotalHeight("18650") ]) rotate([ 0, 180, 0 ]) battery_holder(
        diameter = batt_dia, height = holder_height, wall_thickness = wall_thick, connector_depth = conn_depth,
        retainer_radius = retainer_rad, retainer_thickness = retainer_thick, cell_tolerance = tol,
        connector_tolerance = tol, retainer = retaining_tabs, tie_slot = cable_tie_slots);
}