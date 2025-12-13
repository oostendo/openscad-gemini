
drawerDividerWallWidth = 300;

// These "should" be staatic
drawerDividerWallHeight = 63;
drawerDividerWallThickness = 6.8;
drawerDividerWallCornerRadius = 0.5;



hexDef = 50;

CubeWithRoudedEdges(drawerDividerWallWidth,drawerDividerWallHeight,drawerDividerWallThickness,drawerDividerWallCornerRadius);


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