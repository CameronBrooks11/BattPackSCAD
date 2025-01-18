use <../battery_holder.scad>;
use <../battery_lib.scad>

// ---------------------------------
// WORK-IN PROGRESS
// ---------------------------------
// The general idea is to use the the battery holder to create a battery box
// by removing the holder part from the floor to create an imprint

zFite = $preview ? 0.1 : 0; // z-fighting avoidance for preview

// Battery cell parameters
batt_dia = BatteryLib_TotalDiameter("18650"); // batt_dia of a 18650 cell
echo("batt_dia: ", batt_dia);
batt_height = BatteryLib_TotalHeight("18650"); // batt_height of a 18650 cell
echo("batt_height: ", batt_height);

// Parameters for the battery holder
holder_height = 5; // holder_height of holder
wall_thick = 3;
conn_depth = 3; // depth of the connector

retainer_thick = 1.2; // retainer_thick holder_height
retainer_rad = 1.5;   // retainer_radius radius

wire_cut_width = 6 + 2; // Width of the wire, my nickel strips are 6mm wide, add 2mm for clearance

conn_tol = 0.15; // Tolerance between the connectors
cell_tol = 0.15; // Tolerance between the cell and holder

retaining_tabs = true;  // Retaining retainer for the battery
cable_tie_slots = true; // Cable tie slots for the battery holder

cells_x = 2; // Number of cells in x direction
cells_y = 2; // Number of cells in y direction

unit_eff_width = batt_dia + wall_thick + conn_depth;
unit_total_width = unit_eff_width + conn_depth / 2 + conn_tol / 2;
unit_height = batt_height + retainer_thick;

box_wall_thick = 2;
box_floor_thick = 4;

imprint_depth = box_floor_thick / 2;

difference()
{
    translate([ 0, 0, unit_height / 2 - retainer_thick - box_floor_thick + imprint_depth ]) color("red") difference()
    {
        cube(
            [
                unit_total_width * cells_x + box_wall_thick * 2, unit_total_width * cells_y + box_wall_thick * 2,
                unit_height
            ],
            center = true);
        translate([ 0, 0, box_floor_thick ])
            cube([ unit_total_width * cells_x + conn_tol, unit_total_width * cells_y + conn_tol, unit_height + zFite ],
                 center = true);
    }

    batteryHolderConfig(cells_x = cells_x, cells_y = cells_y, width = unit_eff_width, connector_tolerance = conn_tol)
        battery_holder(diameter = batt_dia, height = holder_height, wall_thickness = wall_thick,
                       retainer_thickness = retainer_thick, retainer_radius = retainer_rad,
                       connector_depth = conn_depth, wire_cut = wire_cut_width, cell_tolerance = cell_tol,
                       connector_tolerance = -conn_tol, retainer = retaining_tabs, tie_slot = 0);
}