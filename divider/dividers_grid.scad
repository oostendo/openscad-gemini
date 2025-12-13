
drawerDividerWallWidth = 130;
drawerDividerWallHeight = 63;
drawerDividerWallThickness = 6.8;
drawerDividerWallCornerRadius = 0.5;

// Grid Parameters
holeSize = 5;
minEdgeWidth = 3;
gridSpacing = 2; // Spacing between holes

hexDef = 50;

difference() {
    // Main Body
    CubeWithRoudedEdges(drawerDividerWallWidth, drawerDividerWallHeight, drawerDividerWallThickness, drawerDividerWallCornerRadius);

    // Grid of Holes
    GridHoles();
}

module GridHoles() {
    // Calculate X axis (Width)
    availableX = drawerDividerWallWidth - (2 * minEdgeWidth);
    numHolesX = floor((availableX + gridSpacing) / (holeSize + gridSpacing));
    actualSpanX = (numHolesX * holeSize) + ((numHolesX - 1) * gridSpacing);
    offsetX = (drawerDividerWallWidth - actualSpanX) / 2;

    // Calculate Y axis (Height)
    availableY = drawerDividerWallHeight - (2 * minEdgeWidth);
    numHolesY = floor((availableY + gridSpacing) / (holeSize + gridSpacing));
    actualSpanY = (numHolesY * holeSize) + ((numHolesY - 1) * gridSpacing);
    offsetY = (drawerDividerWallHeight - actualSpanY) / 2;
    
    // Generate Holes
    // Translating to Z-1 and thickness+2 to ensure clean cut through
    translate([offsetX, offsetY, -1]) {
        for (i = [0 : numHolesX - 1]) {
            for (j = [0 : numHolesY - 1]) {
                translate([i * (holeSize + gridSpacing), j * (holeSize + gridSpacing), 0])
                    cube([holeSize, holeSize, drawerDividerWallThickness + 2]);
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
