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
    holeDiagonal = sqrt(2 * holeSize * holeSize);

    // Steps for the staggered grid
    // Horizontal step is the full width of diamond + spacing
    stepX = holeDiagonal + gridSpacing;
    // Vertical step is half the horizontal step (to nest in the gaps)
    stepY = stepX / 2;

    // Available area
    availableX = drawerDividerWallWidth - (2 * minEdgeWidth);
    availableY = drawerDividerWallHeight - (2 * minEdgeWidth);

    // Approximate max rows and cols to iterate over
    // We iterate a bit wider than calculated to catch staggered items on edges
    numRows = floor((availableY - holeDiagonal) / stepY) + 1;
    numCols = floor((availableX - holeDiagonal) / stepX) + 1;

    // Calculate the total span of the "even" grid to center it
    spanX = (numCols * stepX) - gridSpacing; // Span of N columns
    spanY = (numRows - 1) * stepY + holeDiagonal;

    // Base Offsets to center the grid block
    offsetX = (drawerDividerWallWidth - spanX) / 2;
    offsetY = (drawerDividerWallHeight - spanY) / 2;
    
    // Bounds for valid holes
    minX = minEdgeWidth;
    maxX = drawerDividerWallWidth - minEdgeWidth;
    minY = minEdgeWidth;
    maxY = drawerDividerWallHeight - minEdgeWidth;

    // Generate Holes
    // We iterate with a buffer (-1 to +1) to catch holes that might fit due to shifting
    translate([0,0, -1]) {
        for (j = [0 : numRows - 1]) {
            for (i = [-1 : numCols]) {
                // Determine Row properties
                rowY = offsetY + (holeDiagonal / 2) + (j * stepY);
                rowShift = (j % 2) * (stepX / 2);
                
                // Determine Hole Center
                // We use the same offsetX base, then add the grid position and the row's shift
                holeX = offsetX + (holeDiagonal / 2) + (i * stepX) + rowShift;
                
                // Check if this specific hole fits within the safe bounds
                // We check the bounding box of the diamond (which is width/height = holeDiagonal)
                if (holeX - (holeDiagonal/2) >= minX && 
                    holeX + (holeDiagonal/2) <= maxX &&
                    rowY - (holeDiagonal/2) >= minY && 
                    rowY + (holeDiagonal/2) <= maxY) {
                    
                    translate([holeX, rowY, 0])
                        rotate([0, 0, 45])
                        cube([holeSize, holeSize, drawerDividerWallThickness + 2], center=true);
                }
            }
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