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
 * @param diameter Diameter of the battery cell
 * @param height Height of the battery cell
 * @param wall_thickness Thickness of the battery holder
 * @param retainer_thickness Thickness of the retainer
 * @param retainer_radius Radius of the retainer
 * @param connector_depth Depth of the connector
 * @param wire_cut Width of the wire cutout
 * @param cell_tolerance Tolerance for the cell
 * @param connector_tolerance Tolerance for the connector
 * @param retainer Whether to include a retainer
 * @param tie_slot Whether to include a slot for a cable tie
 */
module battery_holder(diameter, height, wall_thickness, retainer_thickness, retainer_radius = undef,
                      connector_depth = undef, wire_cut = undef, cell_tolerance = 0.2, connector_tolerance = 0.2,
                      retainer = true, tie_slot = true)
{

    retainer_radius = is_undef(retainer_radius) ? diameter * 0.1 : retainer_radius; // retainer_radius radius
    retainer_thickness =
        is_undef(retainer_thickness) ? wall_thickness / 2 : retainer_thickness; // retainer_thickness holder_height
    wire_cut = is_undef(wire_cut) ? (diameter - retainer_radius * 2) / 2 : wire_cut;
    connector_depth = is_undef(connector_depth) ? wall_thickness : connector_depth;

    // base_width = diameter + wall_thickness * 2;
    base_width = diameter + wall_thickness;
    trap_width = base_width * 2 / 3; // Width of the trapezoid
    trapezium_major = diameter - wall_thickness;
    conn_shift = (base_width + connector_depth) / 2;
    total_height = height + retainer_thickness;

    translate([ 0, 0, -retainer_thickness ]) difference()
    {
        union()
        {

            // main body
            translate([ 0, 0, total_height / 2 ])
                cube([ base_width, base_width, height + retainer_thickness ], center = true);

            // Cut out the connectors between cells
            translate([ 0, conn_shift, 0 ])
                dovetail_conn(base = base_width, width = trapezium_major, depth = connector_depth,
                              height = total_height, type = "male");

            rotate([ 0, 0, -90 ]) translate([ 0, conn_shift, 0 ])
                dovetail_conn(base = base_width, width = trapezium_major, depth = connector_depth,
                              height = total_height, type = "male");

            rotate([ 0, 0, 90 ]) translate([ 0, conn_shift, 0 ])
                dovetail_conn(base = base_width, width = trapezium_major, depth = connector_depth,
                              height = total_height, tolerance = connector_tolerance, type = "female");

            rotate([ 0, 0, 180 ]) translate([ 0, conn_shift, 0 ]) dovetail_conn(
                base = base_width, width = trapezium_major, depth = connector_depth, height = total_height,
                tolerance = connector_tolerance, type = "female", tie_slot = tie_slot);
        }
        // Main body cavity for the battery cell to fit into
        translate([ 0, 0, retainer_thickness ])
            cylinder(r = diameter / 2 + cell_tolerance / 2, h = height + zFite, $fn = 64);
        // Main body access hole to be able to connect the battery cell
        translate([ 0, 0, -zFite / 2 ])
            cylinder(r = diameter / 2 - retainer_radius, h = height + retainer_thickness + zFite, $fn = 64);

        // Wire track cutouts
        rotate([ 0, 0, 0 ]) translate([ 0, 0, retainer_thickness / 2 ])
            cube([ wire_cut, base_width * 2, retainer_thickness + zFite ], center = true);
        rotate([ 0, 0, 90 ]) translate([ 0, 0, retainer_thickness / 2 ])
            cube([ wire_cut, base_width * 2, retainer_thickness + zFite ], center = true);
    }
}

/**
 * @brief Generate a male / female dovetail connector
 * @param base Base width of the connector
 * @param width Width of the connector
 * @param depth Depth of the connector
 * @param height Height of the connector
 * @param tolerance Tolerance for the connector
 * @param type
 * @param tie_slot Whether to keep a slot for a cable tie
 */

module dovetail_conn(base, width, depth, height, tolerance = 0, type = "male", tie_slot = true)
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
 * @param tolerance Tolerance of connectors
 */
module batteryHolderConfig(cells_x, cells_y, width, connector_tolerance = 0.2)
{
    cx_shift = (width / 2 + connector_tolerance / 2) * (cells_x - 1);
    cy_shift = (width / 2 + connector_tolerance / 2) * (cells_y - 1);
    for (i = [0:cells_x - 1])
        for (j = [0:cells_y - 1])
            // Generate the grid of cells and connectors
            translate([
                (width + connector_tolerance / 2) * i - cx_shift, (width + connector_tolerance / 2) * j - cy_shift, 0
            ]) children();
}