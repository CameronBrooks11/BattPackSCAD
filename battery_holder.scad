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
 * @param cell_allowance Allowance for the cell
 * @param connector_allowance Allowance for the connector
 * @param retainer Whether to include a retainer
 * @param tie_slot Whether to include a slot for a cable tie
 */
module battery_holder(diameter, height, wall_thickness, retainer_thickness, retainer_radius = undef,
                      connector_depth = undef, wire_cut = undef, arc_cutout = true, cell_allowance = 0.2,
                      connector_allowance = 0.2, retainer = true, tie_slot = true)
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
                              height = total_height, allowance = connector_allowance, type = "female");

            rotate([ 0, 0, 180 ]) translate([ 0, conn_shift, 0 ]) dovetail_conn(
                base = base_width, width = trapezium_major, depth = connector_depth, height = total_height,
                allowance = connector_allowance, type = "female", tie_slot = tie_slot);
        }

        // Main body cavity for the battery cell to fit into
        translate([ 0, 0, retainer_thickness ])
            cylinder(r = diameter / 2 + cell_allowance / 2, h = height + zFite, $fn = 64);
        // Main body access hole to be able to connect the battery cell
        translate([ 0, 0, -zFite / 2 ])
            cylinder(r = diameter / 2 - retainer_radius, h = height + retainer_thickness + zFite, $fn = 64);

        // Wire track cutouts
        for (i = [0:1])
            rotate([ 0, 0, 90 * i ]) translate([ 0, 0, retainer_thickness / 2 ]) union()
            {
                translate([ 0, 0, -retainer_thickness / 2 ])
                    cube([ wire_cut, base_width * 2, retainer_thickness * 2 ], center = true);

                if (arc_cutout)
                {
                    translate([ 0, 0, retainer_thickness / 2 ]) rotate([ 90, 0, 0 ]) scale([ 1, 1 / 3, 1 ])

                        cylinder(r = wire_cut / 2, h = base_width * 2, center = true);
                }
            }
    }
}

/**
 * @brief Generate a male / female dovetail connector
 * @param base Base width of the connector
 * @param width Width of the connector
 * @param depth Depth of the connector
 * @param height Height of the connector
 * @param allowance Allowance for the connector
 * @param type
 * @param tie_slot Whether to keep a slot for a cable tie
 */

module dovetail_conn(base, width, depth, height, allowance = 0, type = "male", tie_slot = true)
{
    cover = tie_slot ? 0 : depth;
    if (type == "female")
    {

        difference()
        {
            translate([ cover / 2, 0, height / 2 ]) cube([ base + cover, depth, height ], center = true);
            translate([ 0, 0, -zFite / 2 ]) linear_extrude(height + zFite) polygon(
                shape_trapezium([ width + allowance, width - depth + allowance ], h = depth + zFite, corner_r = 0));
        }
    }
    else
    {
        linear_extrude(height)
            polygon(shape_trapezium([ width - depth - allowance, width - allowance ], h = depth + zFite, corner_r = 0));
    }
}

/**
 * @brief Generate a battery holder configuration by applying the proper transformations to the children
 * @param cells_x Number of cells in the x direction
 * @param cells_y Number of cells in the y direction
 * @param width Width of the cell
 * @param allowance Allowance of connectors
 */
module batteryHolderConfig(cells_x, cells_y, width, connector_allowance = 0.2)
{
    cx_shift = (width / 2 + connector_allowance / 2) * (cells_x - 1);
    cy_shift = (width / 2 + connector_allowance / 2) * (cells_y - 1);
    for (i = [0:cells_x - 1])
        for (j = [0:cells_y - 1])
            // Generate the grid of cells and connectors
            translate([
                (width + connector_allowance / 2) * i - cx_shift, (width + connector_allowance / 2) * j - cy_shift, 0
            ]) children();
}

/**
 * @brief Generate a battery holder box by removing the holder part from the floor to create an imprint
 * @param cells_x Number of cells in the x direction
 * @param cells_y Number of cells in the y direction
 * @param retainer_thickness Thickness of the retainer
 * @param connector_depth Depth of the connector
 * @param connector_allowance Allowance for the connector
 * @param box_wall_thickness Thickness of the box walls
 * @param box_floor_thickness Thickness of the box floor
 */
module battery_holder_box(battery_height, battery_diameter, cells_x, cells_y, wall_thickness, retainer_thickness,
                          connector_depth, connector_allowance, flange_width, mounting_hole_diameter,
                          box_wall_thickness, box_floor_thickness, box_allowance, cover = false)
{

    box_height = battery_height + retainer_thickness * 2 + box_floor_thickness + box_allowance; // height of the box

    holder_base_width =
        battery_diameter + wall_thickness + connector_depth; // width of the holder not including connectors
    holder_bounding_width =
        holder_base_width + connector_depth / 2 + connector_allowance / 2; // width of the holder including connectors

    flange_thickness = box_floor_thickness; // thickness of the flange

    cover_width_diff = cover ? box_wall_thickness * 2 + box_allowance : 0; // width difference for the cover

    // Main body of the box
    translate([ 0, 0, box_height / 2 ]) color("Grey") difference()
    {
        union()
        {

            // Base shape of the box
            cube(
                [
                    holder_bounding_width * cells_x + box_wall_thickness * 2 + cover_width_diff,
                    holder_bounding_width * cells_y + box_wall_thickness * 2 + cover_width_diff,
                    box_height
                ],
                center = true);

            // Flanges for mounting the box coming off the sides at z=0
            for (i = [0:1])
            {
                flange_offset = cover ? box_height - flange_thickness : 0;
                mirror([ i, 0, 0 ]) translate([
                    holder_bounding_width * cells_x / 2 + box_wall_thickness + flange_width / 2, 0,
                    -box_height / 2 + box_floor_thickness / 2 +
                    flange_offset
                ])

                    difference()
                {
                    // flange base shape
                    cube([ flange_width, holder_bounding_width * cells_y + box_wall_thickness * 2, flange_thickness ],
                         center = true);

                    // create one screw hole for each y cell
                    for (j = [0:cells_y - 1])
                    {
                        translate([ 0, holder_bounding_width * j - holder_bounding_width * (cells_y - 1) / 2, 0 ])
                            cylinder(r = mounting_hole_diameter / 2, h = flange_thickness + zFite, center = true);
                    }

                    // cut off the sharp edges of the flange
                    for (i = [0:1])
                        mirror([ 0, i, 0 ]) translate(
                            [ flange_width / 2, (holder_bounding_width * cells_y + box_wall_thickness * 2) / 2, 0 ])
                            rotate([ 0, 0, 45 ])
                                cube([ flange_width * sqrt(2), flange_width * sqrt(2), flange_thickness + zFite ],
                                     center = true);
                }
            }
        }

        // Cut out the middle cavity of the box
        translate([ 0, 0, box_floor_thickness ]) cube(
            [
                holder_bounding_width * cells_x + box_allowance + cover_width_diff,
                holder_bounding_width * cells_y + box_allowance + cover_width_diff, box_height +
                zFite
            ],
            center = true);
    }
}