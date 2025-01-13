















use <cyl_batt_holder.scad>;

// Battery cell parameters
diameter = 19; // Diameter of a 18650 cell

// Parameters for the battery holder
height = 6; // Height of holder
thickness = 2;

tab_height = 1.4; // tab_height height
tab_radius = 2;   // tab_radius radius

conn_depth = 3; // depth of the connector

tol = 0.2; // Tolerance to help fit

retaining_tabs = true;   // Retaining tabs for the battery
cable_tie_slots = false; // Cable tie slots for the battery holder

tweak = 0; // Tweak for the battery holder

batteryHolderConfig(cells_x = 2, cells_y = 3, width = diameter + thickness + conn_depth+tweak, tolerance = tol)
    cell(cell_diameter = diameter, height = height, thickness = thickness, connector_depth = conn_depth,
         tab_radius = tab_radius, tab_height = tab_height, cell_tolerance = tol, conn_tolerance = tol,
         tabs = retaining_tabs, tie_slot = cable_tie_slots);