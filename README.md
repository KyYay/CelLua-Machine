# CelLua-Machine
A fanmade version of Sam Hogan's Cell Machine, based heavily off the Mystic Mod, that adds a bunch of new cells.
## Running
1. Download a release, preferably the latest one (should be a .love file)
2. Download and install LOVE at https://love2d.org
3. Double-click the .love file (might not work on all OS, for more info see https://love2d.org/wiki/Getting_Started#Running_Games)
## Distributing your own version
1. Create a zip file of the whole game directory (make sure the zip contains the files and *not* the folder OF the files)
2. Rename the .zip to .love
For more info see https://love2d.org/wiki/Game_Distribution#Create_a_.love-file
## New Cells
Trash Cell - Deletes any cells that get pushed into it. Taken from the Mystic Mod. <br>
![image](https://user-images.githubusercontent.com/71151507/126050831-631a3a5e-856f-418b-a6a5-0d82c4834672.png)

One/Two/Three Directional - Can only be pushed towards the marked directions. <br>
![image](https://user-images.githubusercontent.com/71151507/126050754-adf65e40-b0f1-46d7-838a-be619b70080b.png) ![image](https://user-images.githubusercontent.com/71151507/126050761-58bd68c4-b6e1-45ed-a641-2215cd5e7efc.png) ![image](https://user-images.githubusercontent.com/71151507/126050767-433d2200-dd3a-496a-bf16-98f90d3abcb0.png)

180° Rotator Cell - Rotates cells 180 degrees. <br>
![image](https://user-images.githubusercontent.com/71151507/126050775-03e39b96-f705-44a9-bc3f-14cfa01945c1.png)

Mirror Cell - Swaps the cells that it's arrows point to. <br>
![image](https://user-images.githubusercontent.com/71151507/126050777-9a8072e9-88d6-453c-84f5-43e31b175d9a.png)

Puller Cell - Pulls cells. Does not push cells. <br>
![image](https://user-images.githubusercontent.com/71151507/126050778-88e20293-cea0-4c5c-a925-e1a74ae26202.png)

Diverger Cell - Any forces that come into the sides which the arrows point to get rotated 90° and teleported to the end of the diverger. Quite buggy, dont be too surprised if a crash can happen. If an infinite loop slips by but is detected as it happens, it will stop the loop and create a trash cell, for debugging purposes. <br>
![image](https://user-images.githubusercontent.com/71151507/126050780-6e618371-dfce-4482-b580-87d5b6cac04b.png)

Redirector Cell - Replaces the rotation of the 4 cells it touches with it's own rotation. <br>
![image](https://user-images.githubusercontent.com/71151507/126050783-5fd81eeb-c7f5-433a-b894-36390eb88dfe.png)

Gear Cell - Grabs the 8 cells nearby and rotates them 45 degrees around itself. Cells going from diagonally adjacent to orthogonally adjacent will have their rotation adjusted. <br>
![image](https://user-images.githubusercontent.com/71151507/126050785-8d82bd19-1859-4a33-a3c8-a15a94a1a761.png)
![image](https://user-images.githubusercontent.com/71151507/126050787-560bc47e-8b21-4807-aea1-ecbb3170ace8.png)

Mold Cell - Upon being generated by a generator, the generated cell will disappear (but the forces from being cloned will still apply.) <br>
![image](https://user-images.githubusercontent.com/71151507/126050788-3ec06ebc-e78f-4282-af07-ea3c509ea1c9.png)

Repulse Cell - Applies a pushing force in all 4 directions. <br>
![image](https://user-images.githubusercontent.com/71151507/126050790-9477f303-fe36-4255-9d6d-d5b628b0fd34.png)

Weight Cell - This cell will effectively remove the force from one mover that is trying to push it. They will stack with each other. <br>
![image](https://user-images.githubusercontent.com/71151507/126050791-9d8e1397-cad7-4137-97a1-e8d5bb40f2cf.png)
