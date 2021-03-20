
$fn = 200;
nothing = 0.01;

// The model's base plate
module base(radius, height)
{
    cylinder(
        r=radius,
        h=height
        );
}

// The model's slices on top of the base plate
module slices(
                radius, height,
                count, gap,
                inner_radius
                )
{
    translate([0, 0, height/2])
    difference()
    {
        // Start with a cylinder
        cylinder(
            r=radius,
            h=height,
            center=true
            );
        // Cut out a cylinder in the middle
        cylinder(
            r=inner_radius + gap/2,
            h=height + nothing,
            center=true
            );
        // Cut trenches
        for (i = [1:1:count])
        {
            // Cut a trench
            rotate([0, 0, i*360/count])
            translate([0, radius/2, 0])
            cube(
                [gap, radius + nothing, height + nothing],
                center=true
                );
        }
    }

    // Restore inner socket
    cylinder(
        r=inner_radius - gap/2,
        h=height
        );
}

module pitball(
                radius,
                slice_radius,
                slice_height
                )
{
    sink = radius - sqrt(pow(radius,2) - pow(slice_radius,2));
    kill translate([0, 0, radius + slice_height - sink])
    sphere(r=radius);
}

module model()
{
    socket_radius = 20;
    socket_height = 3;
    base(socket_radius, socket_height);

    slice_radius = 16;
    slice_height = 8;
    slice_count = 8;
    slice_gap = 2;
    slice_inner_radius = 5;
    pit_radius = 25;
    translate([0, 0, socket_height - nothing])
    difference()
    {
        slices(
            slice_radius,
            slice_height,
            slice_count,
            slice_gap,
            slice_inner_radius
            );
        pitball(
            pit_radius,
            slice_radius,
            slice_height
            );
    }
}

model();
