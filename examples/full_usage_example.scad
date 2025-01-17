use <../battery_holder.scad>;
use <../battery_lib.scad>

zFite = $preview ? 0.1 : 0; // z-fighting avoidance for preview

// Battery cell parameters
batt_dia = BatteryLib_TotalDiameter("18650"); // batt_dia of a 18650 cell
echo("batt_dia: ", batt_dia);

// Parameters for the battery holder
holder_height = 5; // holder_height of holder
wall_thick = 3;
conn_depth = 3; // depth of the connector

retainer_thick = 1.2;   // retainer_thick holder_height
retainer_rad = 1.5;     // retainer_radius radius

wire_cut_width = 6 + 2; // Width of the wire, my nickel strips are 6mm wide, add 2mm for clearance

conn_tol = 0.2; // Tolerance between the connectors
cell_tol = 0.2; // Tolerance between the cell and holder

retaining_tabs = true;  // Retaining retainer for the battery
cable_tie_slots = true; // Cable tie slots for the battery holder

battery_holder(diameter = batt_dia, height = holder_height, wall_thickness = wall_thick,
               retainer_thickness = retainer_thick, retainer_radius = retainer_rad, connector_depth = conn_depth,
               wire_cut = wire_cut_width, cell_tolerance = cell_tol, connector_tolerance = conn_tol, retainer = true,
               tie_slot = true);