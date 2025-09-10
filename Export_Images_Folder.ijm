/*
 * ImageJ MAcro
 * By Andrea Quezada  andrea.quezada@pm.me 
 * Extracts all series inside all multi-file files with given extension in new folders
* Last edit: 06.06.2021
 */

////////////////////// SET PARAMETERS //////////////////////
 ////////////////////////////////////////////////////////////

// Set the extension
extension = "lif";  //eg "lif", "vsi", etc...

// Set to true if you want different channels of the image to be saved individually
// if set to false, it will save each series as a composite.
is_save_individual_channels = true; // set to either true or false

 //////////////////// END SET PARAMETERS ////////////////////
 ////////////////////////////////////////////////////////////

dir = getDirectory("Select a directory containing one or several ."+extension+" files.");

files = getFileList(dir);

setBatchMode(true);
k=0;
n=0;

run("Bio-Formats Macro Extensions");
for(f=0; f<files.length; f++) {
        if(endsWith(files[f], "."+extension)) {
                k++;
                id = dir+files[f];
                Ext.setId(id);
                Ext.getSeriesCount(seriesCount);
                print(seriesCount+" series in "+id);
                n+=seriesCount;
                for (i=0; i<seriesCount; i++) {
                        run("Bio-Formats Importer", "open=["+id+"] color_mode=Default view=Hyperstack stack_order=XYCZT series_"+(i+1));
                        fullName        = getTitle();
                        dirName         = substring(fullName, 0,lastIndexOf(fullName, "."+extension));
                        fileName        = substring(fullName, lastIndexOf(fullName, " - ")+3, lengthOf(fullName));
                        File.makeDirectory(dir+File.separator+dirName+File.separator);

                        print("Saving "+fileName+" under "+dir+File.separator+dirName);

                        getDimensions(x,y,c,z,t); //  width, height, channels, slices, frames

                        if(c > 1) {
                                if(is_save_individual_channels) {
                                        run("Split Channels");
                                        selectWindow("C1-" + fullName);
                                        saveAs("tiff", dir+File.separator+dirName+File.separator+fullName+" - "+"C=1"+".tif");
                                        selectWindow("C2-" + fullName);
                                        saveAs("tiff", dir+File.separator+dirName+File.separator+fullName+" - "+"C=0"+".tif");
                                } else {
                                       saveAs("tiff", dir+File.separator+dirName+File.separator+fullName+" - "+".tif");
                        }
                        run("Close All");
                }
        }
}
}
Ext.close();
setBatchMode(false);
showMessage("Done with "+k+" files and "+n+" series!");
