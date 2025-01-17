# BattPackSCAD

**BattPackSCAD** is an OpenSCAD library for designing customizable battery packs using parametrically generated, 3D printable holders for a variety of standard battery cell types.

## Features

- **Parametric Design**: Fully adjustable dimensions for cell diameter, holder thickness, connector depth, and more.
- **Extensibility**: Modular structure allows easy integration with other OpenSCAD projects.
- **Examples**: Includes example scripts to demonstrate usage and customization.

## Dependancies

- [dotSCAD](https://github.com/JustinSDK/dotSCAD)

## Examples

To get started simply import the libraries and start customizing:

```javascript
use <BattPackSCAD/battery_holder.scad>;
use <BattPackSCAD/battery_lib.scad>;

battery_type = "18650";

battery_holder(diameter=BatteryLib_TotalDiameter(battery_type), height=8, wall_thickness=3, retainer_thickness=2);
```

<img src="images/example_simple.PNG" alt="design_top_view" width="30%">

### 2x3 Grid Example

See `examples/gridconfig_2x3_example.scad`.

<img src="images/example_2x3.PNG" alt="example_2x3" width="40%">

### Simple Example

See `examples/simple_example.scad`.

<img src="images/example_single.PNG" alt="example_simple" width="40%">

## Acknowledgements

This library is a continuation of the work [kartchnb/battery_lib](https://github.com/kartchnb/battery_lib) and [thingiverse/delboy711/Parametric-18650-battery-grid](https://www.thingiverse.com/thing:3026658).
