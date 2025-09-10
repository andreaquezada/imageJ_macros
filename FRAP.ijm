 /*
 * ImageJ MAcro
 * By Andrea Quezada  andrea.quezada@pm.me 
 * This ImageJ macro performs FRAP (Fluorescence Recovery After Photobleaching) analysis on an image stack. It first subtracts background and applies rigid body registration to correct for motion. The user is prompted to select a reference ROI for normalization and a bleach ROI for recovery measurement. The macro then normalizes fluorescence intensities, analyzes the time series, and outputs a bleach-corrected stack while closing all intermediate windows.

* Last edit: 26.08.2019
 */
 
macro "FRAP" {
rename("source");
run("Subtract Background...", "rolling=100 stack");
run("MultiStackReg ", "first=source second=source transformation=[Rigid Body]");
waitForUser("Draw ROI around reference aggregate");
run("Measure")
run("Set Slice...", "slice="+1);
run("Set Measurements...", "  mean redirect=None decimal=9");
run("Select None");
setBatchMode(true);
for(l=0; l<nSlices+1; l++) {
        run("Restore Selection");
        run("Clear Results");
        run("Measure");
        picsum=getResult("Mean",0);
        if(l==0){picsum1=picsum;}
        int_ratio=picsum1/picsum;
                        //print(int_ratio+'  '+picsum1+'  '+picsum);
        run("Select None");
        run("Multiply...", "slice value="+int_ratio);
        run("Next Slice [>]");
}
setBatchMode(false);
selectWindow("source");
rename("BleachCorrected");
run("Clear Results");
setSlice(1);
setLocation(0,100);
waitForUser("Draw Bleach ROI");
run("Time Series Analyzer V2 0");
selectWindow("Time Series V3_2");
setLocation(1060,100);
selectWindow("BleachCorrected");
setSlice(1);
selectWindow("ROI Manager");
run("Close" );
     }
if (isOpen("Log")) {
         selectWindow("Log");
         run("Close");
    }
if (isOpen("Plot Values")) {
         selectWindow("Plot Values");
         run("Close");
    }
    while (nImages()>0) {
          selectImage(nImages());
          run("Close");
    }
}
