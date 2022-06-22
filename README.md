<br />

# ELICIT - Evolutionary Computation Visualization

<br />

ELICIT is a data visualization program for evolutionary algorithm data, developed using Processing. ELICIT is able to load and represent multiple evolutionary algorithm runs through heatmaps, showing how the fitness is distributed (from black to blue) across populations (each column) over each generation (from left to right), depicting the genetic operators and connections between ancestors and descendants.

<br />

![ELICIT's interface](https://cdv.dei.uc.pt/wp-content/uploads/2020/05/ELICIT-interface.png)

While ELICIT was developed with visualizations directed at specific datasets, its main views can be used by any generic evolutionary algorithm run. It was developed in the scope of my MSc thesis and there are no current plans to develop it further, so the code may be unoptimized.

Below are instructions on how to use ELICIT, and a description of all its functionalities is available here: https://cdv.dei.uc.pt/elicit/


### Reference
A. Cruz, P. Machado, F. Assunção, and A. Leitão, “ELICIT: Evolutionary Computation Visualization,” in Genetic and Evolutionary Computation Conference, GECCO 2015, Madrid, Spain, July 11-15, 2015, Companion Material Proceedings, 2015, pp. 949-956. 


-----------------------------------------------------------------------------------------------------------


## Prerequisites

- Requires Processing (4.0) to run: https://processing.org/download


## Initialization:

- Place folder of runs in the data folder (file structure is depicted below, and examples are included in the project);
- Each run must be in a folder named "run#", where # is the number of run (ex: run1, run2, run3, ...);
- If the program doesn't run due to compatibility issues, try removing ",P3D" in this line of the code:
ELICIT/setup(): size(1200, 650, P3D) -> size(1200, 650)

Variables:
- Set "filen" to name of directory of run(s) (ex: data/dataset1/);
- Set "ifile" to number of first run folder (ex: 1 if first folder is named run1);
- Set "sfile" to the number of runs for the program to read (ex: 30 if reading from run1 to run30);
- fitmap can be switched if color mapping isn't ideal, or manipulated directly in Indiv.fitColor().


### Mouse / Keyboard

LEFT MOUSE - Select individuals and populations
RIGHT MOUSE - Drag to pan visualization
LEFT ARROW - Close visualization on mouse position
RIGHT ARROW - Open visualization on mouse position

-----------------------------------------------------------------------------------------------------------

## File Structure for generic data:

For each line, separated by spaces:
 - Population_ID
 - Individual_ID
 - Genetic_Operator (-1: first population // 0: Copy // 1: Mutation // 2: Crossover // 3: Elitism Copy // 4: Crossover+Mutation)
 - ID of Parent 1 (if Parent 1 doesn't exist: -1)
 - ID of Parent 2 (if Parent 2 doesn't exist: -1)
 - Fitness (Program will automatically detect if fitness is ascending or descending)




## File Structure for LISP trees that describe formulas:

First two lines describe the target:
- Line 1 lists all the X coordinates of the graph that describes the target curve
- Line 2 lists all the Y coordinates of the graph that describes the target curve

For each line, separated by spaces:
 - Population_ID
 - Individual_ID
 - Genetic_Operator (-1: first population // 0: Copy // 1: Mutation // 2: Crossover // 3: Elitism Copy // 4: Crossover+Mutation)
 - Parent1_ID (if Parent1 doesn't exist -1)
 - Parent2_ID (if Parent2 doesn't exist -1)
 - Fitness (Program with automatically detect if fitness is ascending or descending)
//(seperate Fitness from Tree with 2 spaces)
 - Tree (ex:   (* (- x1 x1) (* (+ x1 x1) (negexp x1)))  )
 - Line_Graph_Y_Coordinates (seperated by commas without spaces, a list of floats the describe the curve on a graph)


### Extra

- There is some additional code for handling datasets with two chromossomes, where each invididual has two genetic operators and two genotypes. Dataset requires each individual to have an additional Genetic_Operator and LISP tree, then change variable "locktyp" to false in the code.
