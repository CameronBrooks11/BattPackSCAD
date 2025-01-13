use <../battery_holder.scad>;
use <../battery_lib.scad>

zFite = $preview ? 0.1 : 0; // z-fighting avoidance for preview

// Battery cell parameters
batt_dia = BatteryLib_TotalDiameter("18650"); // batt_dia of a 18650 cell
echo("batt_dia: ", batt_dia);

// Parameters for the battery holder
holder_height = 6; // holder_height of holder
holder_thickness = 2;

tab_height = 1.4; // tab_height holder_height
tab_radius = 2;   // tab_radius radius

conn_depth = 3; // depth of the connector

tol = 0.2; // Tolerance to help fit

retaining_tabs = true;  // Retaining tabs for the battery
cable_tie_slots = true; // Cable tie slots for the battery holder

// Layout parameters
xCells = 2;                                                 // Number of cells in the x direction
yCells = 3;                                                 // Number of cells in the y direction
cell_separation = batt_dia + holder_thickness + conn_depth; // Separation between cells

translate([ -cell_separation / 2, 0, 0 ])

    batteryHolderConfig(cells_x = xCells, cells_y = yCells, width = batt_dia + holder_thickness + conn_depth,
                        tolerance = tol)
{
    color("DodgerBlue") BatteryLib_GenerateBatteryModel("18650");
    translate([ 0, 0, holder_height + zFite ]) rotate([ 0, 180, 0 ])
        battery_holder(cell_diameter = batt_dia, height = holder_height, thickness = holder_thickness,
             connector_depth = conn_depth, tab_radius = tab_radius, tab_height = tab_height, cell_tolerance = tol,
             conn_tolerance = tol, tabs = retaining_tabs, tie_slot = cable_tie_slots);
    translate([ 0, 0, BatteryLib_TotalHeight("18650") - holder_height - zFite ])
        battery_holder(cell_diameter = batt_dia, height = holder_height, thickness = holder_thickness,
             connector_depth = conn_depth, tab_radius = tab_radius, tab_height = tab_height, cell_tolerance = tol,
             conn_tolerance = tol, tabs = retaining_tabs, tie_slot = cable_tie_slots);
}