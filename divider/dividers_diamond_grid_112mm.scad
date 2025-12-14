
drawerDividerWallWidth = 112;
drawerDividerWallHeight = 63;
drawerDividerWallThickness = 6.8;
drawerDividerWallCornerRadius = 0.5;

// Grid Parameters
holeSize = 5;
minEdgeWidth = 3;
gridSpacing = 2; // Spacing between hole corners

hexDef = 50;

rotate([0, 90, 0]) {
    difference() {
        // Main Body
        CubeWithRoudedEdges(drawerDividerWallWidth, drawerDividerWallHeight, drawerDividerWallThickness, drawerDividerWallCornerRadius);

        // Grid of Holes
        GridHoles();

        // Material Reduction Bevels (Thinner webbing with 45-degree slopes)
        BeveledRecesses();
    }
}

module BeveledRecesses() {
    recessDepth = drawerDividerWallThickness * 0.25;
    
    // Outer dimensions (Top of the cut, widest point)
    outerW = drawerDividerWallWidth - (2 * minEdgeWidth);
    outerH = drawerDividerWallHeight - (2 * minEdgeWidth);
    
    // Inner dimensions (Bottom of the cut, narrowest point)
    // For 45 degrees, the inset equals the depth
    innerW = outerW - (2 * recessDepth);
    innerH = outerH - (2 * recessDepth);

    // Center coordinates for the rectangles
    centerX = drawerDividerWallWidth / 2;
    centerY = drawerDividerWallHeight / 2;

    // Check validity
    if (innerW > 0 && innerH > 0) {
        
        // TOP RECESS
        // Hull between surface rectangle and depth rectangle
        hull() {
            // Surface Plate (Large) at Z = Thickness
            translate([centerX, centerY, drawerDividerWallThickness])
                cube([outerW, outerH, 0.01], center=true);
            
            // Bottom Plate (Small) at Z = Thickness - Depth
            translate([centerX, centerY, drawerDividerWallThickness - recessDepth])
                cube([innerW, innerH, 0.01], center=true);
        }

        // BOTTOM RECESS
        // Hull between surface rectangle and depth rectangle
        hull() {
            // Surface Plate (Large) at Z = 0
            translate([centerX, centerY, 0])
                cube([outerW, outerH, 0.01], center=true);
            
            // Bottom Plate (Small) at Z = Depth
            translate([centerX, centerY, recessDepth])
                cube([innerW, innerH, 0.01], center=true);
        }
    } else {
        echo("Warning: Recess too deep for part width, skipping bevel.");
    }
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
                
                translate([holeX, rowY, drawerDividerWallThickness / 2])
                    rotate([0, 0, 45])
                    cube([holeSize, holeSize, drawerDividerWallThickness + 2], center=true);
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
