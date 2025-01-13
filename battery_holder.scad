/**
 * @file battery_holder.scad
 * @brief A script to generate a battery holder for arrays of cylindrical battery cells
 * @author Cameron K. Brooks
 * @copyright 2025
 *
 * This is inspired by "Parametric 18650 battery grid" written by delboy711: https://www.thingiverse.com/thing:3026658
 * This script is a more modular and overall vastly improved version of the 18650 battery holder script
 *
 */

// uses the shape_trapezium.scad module from dotSCAD
use <dotSCAD/src/shape_trapezium.scad> // from dotSCAD: https://github.com/JustinSDK/dotSCAD

// ---------------------------------
// Global Parameters
// ---------------------------------
$fn = $preview ? 32 : 128;  // number of fragments for circles, affects render time
zFite = $preview ? 0.1 : 0; // z-fighting avoidance for preview

/**
 * @brief Generate a single cell for a battery holder
 * @param cell_diameter Diameter of the battery cell
 * @param height Height of the cell
 * @param thickness Thickness of the cell
 * @param connector_depth Depth of the connector
 * @param tab_radius Radius of the tab
 * @param tab_height Height of the tab
 * @param cell_tolerance Tolerance for the cell
 * @param conn_tolerance Tolerance for the connector
 * @param tabs Whether to include tabs for the battery
 * @param tie_slot Whether to include a slot for a cable tie
 */
module battery_holder(cell_diameter, height, thickness, connector_depth, tab_radius, tab_height, cell_tolerance,
                      conn_tolerance, tabs = true, tie_slot = true)
{
    // base_width = cell_diameter + thickness * 2;
    base_width = cell_diameter + thickness;
    trap_width = base_width * 2 / 3; // Width of the trapezoid
    trapezium_major = cell_diameter - thickness;
    conn_shift = (base_width + connector_depth) / 2;
    tab_radius = is_undef(tab_radius) ? thickness * 2 : tab_radius; // tab_radius radius
    tab_height = is_undef(tab_height) ? thickness / 2 : tab_height; // tab_height holder_height

    difference()
    {
        union()
        {
            // difference()
            {
                union()
                {
                    // main body
                    translate([ 0, 0, height / 2 ]) cube([ base_width, base_width, height ], center = true);

                    // tabs to hold the battery
                    if (tabs)
                        for (rotation = [45:90:325])
                            rotate([ 0, 0, rotation ]) translate([ 0, cell_diameter / 2, 0 ])
                            {
                                translate([ 1, 0, height ]) cylinder(r = tab_radius, h = tab_height, $fn = 16);
                            }
                }
                for (i = [0:1:3])
                    translate([ 0, 0, height / 2 ]) cube([ base_width, base_width, height ], center = true);
            }

            // Connectors
            // Generate the connectors between cells

            translate([ 0, conn_shift, 0 ]) conns(base = base_width, width = trapezium_major, depth = connector_depth,
                                                  height = height, type = "male");

            rotate([ 0, 0, -90 ]) translate([ 0, conn_shift, 0 ]) conns(
                base = base_width, width = trapezium_major, depth = connector_depth, height = height, type = "male");

            rotate([ 0, 0, 90 ]) translate([ 0, conn_shift, 0 ])
                conns(base = base_width, width = trapezium_major, depth = connector_depth, height = height,
                      tolerance = conn_tolerance, type = "female");

            rotate([ 0, 0, 180 ]) translate([ 0, conn_shift, 0 ])
                conns(base = base_width, width = trapezium_major, depth = connector_depth, height = height,
                      tolerance = conn_tolerance, type = "female", tie_slot = tie_slot);
        }
        // Main body hole for the battery cell
        translate([ 0, 0, -zFite / 2 ])
            cylinder(r = cell_diameter / 2 + cell_tolerance / 2, h = height + zFite, $fn = 64);
    }
}

/**
 * @brief Generate a connector for a battery holder
 * @param base Base width of the connector
 * @param width Width of the connector
 * @param depth Depth of the connector
 * @param height Height of the connector
 * @param tolerance Tolerance for the connector
 * @param type
 * @param tie_slot Whether to keep a slot for a cable tie
 */

module conns(base, width, depth, height, tolerance = 0, type = "male", tie_slot = true)
{
    cover = tie_slot ? 0 : depth;
    if (type == "female")
    {

        difference()
        {
            translate([ cover / 2, 0, height / 2 ]) cube([ base + cover, depth, height ], center = true);
            translate([ 0, 0, -zFite / 2 ]) linear_extrude(height + zFite) polygon(
                shape_trapezium([ width + tolerance, width - depth + tolerance ], h = depth + zFite, corner_r = 0));
        }
    }
    else
    {
        linear_extrude(height)
            polygon(shape_trapezium([ width - depth - tolerance, width - tolerance ], h = depth + zFite, corner_r = 0));
    }
}

/**
 * @brief Generate a battery holder configuration by applying the proper transformations to the children
 * @param cells_x Number of cells in the x direction
 * @param cells_y Number of cells in the y direction
 * @param width Width of the cell
 * @param tolerance Tolerance for the cell
 */
module batteryHolderConfig(cells_x, cells_y, width, tolerance = 0)
{
    for (i = [0:cells_x - 1])
        for (j = [0:cells_y - 1])
            // Generate the grid of cells and connectors
            translate([ (width + tolerance / 2) * i, (width + tolerance / 2) * j, 0 ]) children();
}