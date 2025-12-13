# OpenSCAD Dividers Project

This project contains OpenSCAD files for generating drawer dividers.

## Dividers

### 130mm Drawer Divider
*   **File:** `divider/dividers_130mm.scad`
*   **Description:** A drawer divider modified to have a length of 130mm.
*   **Key Parameters:**
    *   `drawerDividerWallWidth = 130` (Length)
    *   `drawerDividerWallHeight = 63`
    *   `drawerDividerWallThickness = 6.8`

### Grid Drawer Divider
*   **File:** `divider/dividers_grid.scad`
*   **Description:** A 130mm divider with a grid of holes subtracted to save material while maintaining strength.
*   **Key Parameters:**
    *   `holeSize = 5` (Square hole dimension)
    *   `minEdgeWidth = 3` (Minimum solid border)
    *   `gridSpacing = 2` (Spacing between holes)

### Diamond Grid Drawer Divider
*   **File:** `divider/dividers_diamond_grid.scad`
*   **Description:** A 130mm divider with a staggered grid of diamond-shaped holes. This design maximizes hole density (saving material) and includes beveled internal recesses (50% webbing thickness with 45° slopes) to further reduce plastic usage and prevent overhangs for vertical 3D printing. The model is rendered with a 90-degree rotation around its length (Y-axis) for convenient print bed plating.
*   **Key Parameters:**
    *   `holeSize = 5` (Original square dimension)
    *   `minEdgeWidth = 3` (Minimum solid border)
    *   `gridSpacing = 2` (Spacing between hole corners)