
drawerDividerWallWidth = 130;
drawerDividerWallHeight = 63;
drawerDividerWallThickness = 6.8;
drawerDividerWallCornerRadius = 0.5;

// Grid Parameters
holeSize = 5;
minEdgeWidth = 3;
gridSpacing = 2; // Spacing between hole corners

hexDef = 50;

difference() {
    // Main Body
    CubeWithRoudedEdges(drawerDividerWallWidth, drawerDividerWallHeight, drawerDividerWallThickness, drawerDividerWallCornerRadius);

    // Grid of Holes
    GridHoles();
}

module GridHoles() {
    // Calculate geometric properties of the rotated square (Diamond)
    // The width/height of the bounding box of a 45-degree rotated square is diagonal
    holeDiagonal = sqrt(2 * holeSize * holeSize);

    // Calculate X axis (Width)
    availableX = drawerDividerWallWidth - (2 * minEdgeWidth);
    // Determine how many diamonds fit, accounting for the diagonal width and spacing
    numHolesX = floor((availableX + gridSpacing) / (holeDiagonal + gridSpacing));
    // Calculate the total span of the grid
    actualSpanX = (numHolesX * holeDiagonal) + ((numHolesX - 1) * gridSpacing);
    // Calculate offset to center the grid
    offsetX = (drawerDividerWallWidth - actualSpanX) / 2;

    // Calculate Y axis (Height)
    availableY = drawerDividerWallHeight - (2 * minEdgeWidth);
    numHolesY = floor((availableY + gridSpacing) / (holeDiagonal + gridSpacing));
    actualSpanY = (numHolesY * holeDiagonal) + ((numHolesY - 1) * gridSpacing);
    offsetY = (drawerDividerWallHeight - actualSpanY) / 2;
    
    // Generate Holes
    // We iterate through the calculated number of holes
    for (i = [0 : numHolesX - 1]) {
        for (j = [0 : numHolesY - 1]) {
            // Calculate center position for each diamond
            // Start at offset
            // Add distance for previous holes (i * (size + space))
            // Add half-size to get to the center of the current hole (since we rotate around center)
            centerX = offsetX + (i * (holeDiagonal + gridSpacing)) + (holeDiagonal / 2);
            centerY = offsetY + (j * (holeDiagonal + gridSpacing)) + (holeDiagonal / 2);
            centerZ = drawerDividerWallThickness / 2;

            translate([centerX, centerY, centerZ])
                rotate([0, 0, 45])
                // Create cube centered in all axes, slightly thicker than wall to ensure cut
                cube([holeSize, holeSize, drawerDividerWallThickness + 2], center=true);
        }
    }
}

module CubeWithRoudedEdges(x,y,z,edgeRadius) {
    hull() {
        translate([0 + edgeRadius,0 + edgeRadius,0 + edgeRadius]) sphere(edgeRadius, $fn=hexDef);
        translate([x - edgeRadius,0 + edgeRadius,0 + edgeRadius]) sphere(edgeRadius, $fn=hexDef);
        translate([x - edgeRadius,y - edgeRadius,0 + edgeRadius]) sphere(edgeRadius, $fn=hexDef);
        translate([x - edgeRadius,y - edgeRadius,z - edgeRadius]) sphere(edgeRadius, $fn=hexDef);
        translate([0 + edgeRadius,y - edgeRadius,0 + edgeRadius]) sphere(edgeRadius, $fn=hexDef);
        translate([0 + edgeRadius,y - edgeRadius,z - edgeRadius]) sphere(edgeRadius, $fn=hexDef);
        translate([0 + edgeRadius,0 + edgeRadius,z - edgeRadius]) sphere(edgeRadius, $fn=hexDef);
        translate([x - edgeRadius,0 + edgeRadius,z - edgeRadius]) sphere(edgeRadius, $fn=hexDef);
    };
}
