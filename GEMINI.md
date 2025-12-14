# Project: OpenSCAD Generator & Vision Verifier


## Project Overview
This project automates the creation and verification of custom 3D printed .dividersrts We utilize SCAD files to programmatically generate STLs/PNGs

The process may include multiple incremental modifications, and it's important that each modification is identified as being correct.

## Core Resources
* **Engine:** [OpenSCAD](https://openscad.org/) (Headless/CLI mode).
* **AI Tool:** gemini-cli (Multimodal Vision).

## Workflow Architecture

### 0. Set up of project

You should start with a project directory including at least one SCAD file.  

* put directory under local git source control and add all files

* add a `README.md` file to each model directory which includes a description of the desired project output and parameters for that model.

* **Verification:** Run `./tests/test_preview.sh` to confirm that OpenSCAD and the headless rendering environment (xvfb) are correctly configured.

### 1. Modification (SCAD)
We modify the OpenSCAD parameters to change divider dimensions or couplers.

* Identify Key Parameters -- these are typically variables in the scad file

* Set key parameters first, these are usually variables set at the beginning of the file and include things like basic dimensions

* Make requested modifications to the SCAD logic itself if required.  Ideally wrap modifications into a module class that uses existing modules rather than modifing modules which existed prior to this project.

* **Print Optimization:** Consider 3D printing constraints.
    *   Use 45° angles (chamfers/bevels) to avoid overhangs if printing vertically.
    *   Rotate models (e.g., `rotate([0, 90, 0])`) within the SCAD file to orient them correctly for the print bed (plating).
    *   Subtract material (grids/honeycombs) to save plastic, using `hull()` for clean beveled cuts.

* Whenever you want to modify a scad file which has been previously unmodified, copy the file and rename it with an indication of intent: eg "egg_holder.scad" would change to "egg_holder_scaled_ostrich.scad" if we wanted to scale a chicken egg holder into an ostrich egg holder.

### 2. Rendering (CLI)
We use OpenSCAD's command line interface to export a visual preview (PNG) rather than just an STL. This is faster for AI verification.

**Preview Script:**
Use the `preview.sh` script located in the project root for simplified preview generation. It automatically handles headless rendering (via `xvfb-run`) if required.

**Command Syntax Example (using preview.sh):**
```bash
./preview.sh -o divider/preview/my_divider_150mm.png -s 1024,768 divider/my_divider.scad
```

**Manual Command Syntax Example (for reference):**
```bash
openscad -o preview.png \
  --imgsize=1024,768 \
  --camera=0,0,0,60,0,25,500 \
  --projection=o \
  -D "length=150" \
  -D "text_string=\"SPOONS\"" \
  divider.scad
```

* Whenever you modify key parameters, use the dimensions as part of the resulting image name along with a timestamp, and cache these in a "preview" directory.

* If you have a syntax error or other error coming out of the openscad executable, try to diagnose and debug.

* Do not remove old preview images, and if a particular modification takes multiple attempts add "try_#" to the filename eg 'egg_holder_duck.jpg' 'egg_holder_duck_try_2.jpg' 'egg_holder_duck_try_3.jpg'

### 3. Export (STL)
To generate a 3D printable STL file, use the `generatestl.sh` script.

**Command Syntax Example:**
```bash
./generatestl.sh divider/my_divider.scad
```
This will create `stl/my_divider.stl`.

### 4. Presentation to user

When the modification is evaluated to match the intended description and the scad file is correct, execute the following steps:

* Restate the description provided by the user
* Copy the most recent preview file which was evaluated as correct into the same directory as the scad file, with the name "preview"
* Indicate to the user the preview file which is considered to be accurate
* Update the README.md file with the description and definition of any key parameters
* commit the changes to git with a comment describing the change
