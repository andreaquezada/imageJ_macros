 /*
 * ImageJ MAcro
 * By Andrea Quezada  andrea.quezada@pm.me 
 * This macro allows the user to divide an image into an N×N grid of tiles, where N is specified at runtime. Each tile is duplicated from the original image, then cropped to the correct rectangular section, resized to a fixed output size (1000 × 916 pixels, bicubic interpolation) and saved as a TIFF file in a chosen directory, with filenames indicating their grid position (e.g., imagename0,0.tif).

* Last edit: 10.10.2021
 */


//Dialog.addNumber("How many divisions?", divisions);
//n = Dialog.getNumber();

//int(label="How many divisions (e.g., 2 means quarters)?") n;

dir = getDirectory("/Users/andrea/Desktop/images_Fede_03Oct21/");
n = 
id = getImageID(); 
title = getTitle(); 
getLocationAndSize(locX, locY, sizeW, sizeH); 
width = getWidth(); 
height = getHeight(); 
tileWidth = width / n; 
tileHeight = height / n; 
for (y = 0; y < n; y++) { 
offsetY = y * height / n; 
 for (x = 0; x < n; x++) { 
offsetX = x * width / n; 
selectImage(id); 
 call("ij.gui.ImageWindow.setNextLocation", locX + offsetX, locY + offsetY); 
tileTitle = title + x + "," + y; 
 run("Duplicate...", tileTitle); 
makeRectangle(offsetX, offsetY, tileWidth, tileHeight); 
run("Crop");
copy = getImageID();
selectImage(copy);
newtitle = getTitle();
run("Scale...", "x=- y=- width=1000 height=916 interpolation=Bicubic average create title=&newtitle");
saveAs("Tiff", dir + newtitle);
close();
} 
} 
selectImage(id); 
close(); 

// run("Scale...", "x=- y=- width=1000 height=916 interpolation=Bicubic average create title=37C_S13D_30_C0-2s.tif");
//saveAs("Tiff", "/Users/andrea/Desktop/images_Fede_03Oct21/37C_S13D_30_C0-2s.tif");
//close();
//close();

