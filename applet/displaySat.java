import processing.core.*; 
import processing.xml.*; 

import java.awt.event.*; 
import processing.opengl.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class displaySat extends PApplet {

//import fullscreen.*;

//import processing.pdf.*;


//FullScreen fs; 

String simulationPath = "/Users/davidcarley/Dropbox/research/project/implementation/molecularSimulation/data/testCNF";
String localTSVData = "http://www.cs.rit.edu/~dnc6813/project/applet/sweepDatapoints.tsv";

boolean savePDF = false;

int tableColor      = 0xffffffff; //color(91, 103, 112, 127);  //#5B6770;
int backgroundColor = 0xffffffff;
int pointColor      = 0xffE8A41C;
int pointTextColor  = 0xff000000;

int axisColor         = 0xffffffff;
int axisHoverColor    = 0xff00ff00;
int selectedAxisColor = 0xffFFBC00;
int axisTextColor     = 0xff000000;

int titleColor      = 0xff000000;

int liptonColor     = color(255, 20, 20, 100); //= #ff0000;
int ogiRayColor     = color(20, 255, 20, 100); //= #0000ff;
int distriColor     = color(20, 20, 255, 100); //= #00ff00;


/// Store coordinates of plot
int plotX1, plotX2;
int plotY1, plotY2;

/// Set boarderMargin
int borderMargin = 50;

/// Store data boundries
float xMin, xMax;
float yMin, yMax;

/// Array to store testdata
datapoint[] testData;
int numDatapoint;


float dataXmin = 0.0f;
float dataXmax = 15.0f;

float dataYmin = 0.0f;
float dataYmax = 5000.0f;

///
element[] metricList;

///
PFont selectFont;
PFont mainFont;
PFont axisFont;

/// 
String currentSelected;
String [] metricNameList = {
    "Mix", "Extract", "Append", "Split", "Splice", "Purify", "Time", "Memory"
};

String [] metricAxisList = {

    "Number of Mixes", 
    "Number of Extracts", 
    "Number of Appends", 
    "Number of Splits", 
    "Number of Splices", 
    "Number of Purifies", 
    "Elapsed execution time in seconds", 
    "Solution space memory footprint in Bytes"
};


///
///
///
public void setup() { 

    size(1000, 720, OPENGL);
    frameRate(32);        // 5 fps
    // Create the fullscreen object

    //  fs = new FullScreen(this); 
    // enter fullscreen mode
    //fs.enter();

    axisFont   = loadFont("SansSerif-17.vlw");
    selectFont = loadFont("Helvetica-17.vlw");
    textFont(selectFont, 17);
    //    mainFont   = loadFont("Baskerville-23.vlw");
    mainFont   = loadFont("Garamond-48.vlw");

    currentSelected = "";
    currentMetricDescription = "";

    metricList = new element[metricNameList.length];
    for (int i = 0; i < metricList.length; i++) {
        metricList[i] = new element();
    }    
    for (int i = 0; i < metricList.length; i++) {
        metricList[i].description = metricNameList[i];
    }

    metricList[0].setBegin(300, borderMargin, textWidth(metricList[0].description));
    for (int i = 1; i < metricList.length; i++) {
        metricList[i].setBegin(metricList[i-1].positionX+metricList[i-1].width, metricList[i-1].positionY, textWidth(metricList[i].description));
    }

    int maxDatapoints = 1000;
    numDatapoint = 0;
    testData = new datapoint[maxDatapoints];
    for (int i = 0; i < testData.length; i++) {
        testData[i] = new datapoint();
    }

    //    processDirectory(simulationPath);
    // saveDatapointsTSV(); 
    processTSV(localTSVData);




    println("number of datapoints " + numDatapoint);

    plotX1 = 3*borderMargin;
    plotX2 = width - borderMargin;
    plotY1 = borderMargin;
    plotY2 = height - 2*borderMargin;


    addMouseWheelListener(new java.awt.event.MouseWheelListener() { 
        public void mouseWheelMoved(java.awt.event.MouseWheelEvent evt) { 
            mouseWheel(evt.getWheelRotation());
        }
    }
    );
} 



///
///
///
public void draw() {

    /// Start *.pdf
    if (savePDF == true) {
        beginRecord(PDF, currentSelected + ".pdf");
    }

    //////////////////////////////////////
    background(backgroundColor);

    displayPlot();
    displayPoints();

    fill(titleColor);
    textFont(mainFont, 48);
    text(currentSelected, plotX2 - textWidth(currentSelected) - 10, plotY1+50);

    textAlign(CENTER);
    fill(axisTextColor);
    textFont(axisFont, 17);
    text("Clause-variable ratio", width/2, height - 0.75f*borderMargin);
    drawHorizonalAxis();

    textAlign(CENTER);
    fill(axisTextColor);
    textFont(axisFont, 17);


    drawVerticalAxis();
    //////////////////////////////////////

    /// close *.pdf file

    if (savePDF == true) {
        endRecord();
        savePDF = false;
    }


    /// Display interaction for user
    for (int i = 0; i < metricList.length; i++) {
        metricList[i].display();
    }

    saveOutput();
}


int horizonalHover;
int verticalHover;
String currentMetricDescription;


public void drawHorizonalAxis() {
    float volumeInterval = 120;

    volumeInterval = dataXmax/12;

    if (horizonalHover == 1) {
        fill(selectedAxisColor);
    }
    else {
        fill(axisTextColor);
    }
    textFont(axisFont, 17);
    textAlign(RIGHT);

    for (float v = 0.1f; v < dataXmax; v += volumeInterval) {
        float x = map(v, dataXmin, dataXmax, plotX1, plotX2);
        text(nf(v, 1, 1), x, plotY2+30);
    }
}

public void updateHorizonalAxis() {

    horizonalHover = 0;
    if (mouseX > plotX1 && mouseX < plotX2) {
        if (mouseY > plotY2 && mouseY < plotY2+100) {
            horizonalHover = 1;
        }
    }
}


public void drawVerticalAxis() {
    float volumeInterval = 100;



    pushMatrix();
    translate(borderMargin, height/2);

    rotate(radians(270));
    text(currentMetricDescription, 0, 0);
    popMatrix();



    volumeInterval = dataYmax/17;


    if (verticalHover == 1) {

        //    fill(axisHoverColor);
        //     rect(plotX1-100, plotY1, 200, plotY2- plotY1);

        fill(selectedAxisColor);
    }
    else {
        fill(axisTextColor);
    }
    textFont(axisFont, 17);
    textAlign(RIGHT);

    for (float v = 0; v < dataYmax; v += volumeInterval) {
        float y = map(v, dataYmin, dataYmax, plotY2, plotY1);
        text(floor(v), plotX1-10, y);
    }
}

public void updateVerticalAxis() {

    verticalHover = 0;
    if (mouseX > plotX1 -100 && mouseX < plotX1) {
        if (mouseY > plotY1 && mouseY < plotY2) {
            verticalHover = 1;
        }
    }




    if ( currentSelected.equals("Mix")) {
        currentMetricDescription = metricAxisList[0];
    }
    else if (currentSelected.equals("Extract")) {
        currentMetricDescription = metricAxisList[1];
    }
    else if (currentSelected.equals("Append")) {
        currentMetricDescription = metricAxisList[2];
    }
    else if (currentSelected.equals("Split")) {
        currentMetricDescription = metricAxisList[3];
    }
    else if (currentSelected.equals("Splice")) {
        currentMetricDescription = metricAxisList[4];
    }
    else if (currentSelected.equals("Purify")) {
        currentMetricDescription = metricAxisList[5];
    }
    else if (currentSelected.equals("Time")) {
        currentMetricDescription = metricAxisList[6];
    }
    else if (currentSelected.equals("Memory")) {
        currentMetricDescription = metricAxisList[7];
    }
    else {
        currentMetricDescription = "";
    }
}




public int maxElement() {

    int maxValue;
    int sampleMetric = 0;


    maxValue = 0;

    for (datapoint testPoint: testData) {

        if ( currentSelected.equals("Mix")) {
            sampleMetric = testPoint.mixCount;
        }
        else if (currentSelected.equals("Extract")) {
            sampleMetric = testPoint.extractCount;
        }
        else if (currentSelected.equals("Append")) {
            sampleMetric = testPoint.appendCount;
        }
        else if (currentSelected.equals("Split")) {
            sampleMetric = testPoint.splitCount;
        }
        else if (currentSelected.equals("Splice")) {
            sampleMetric = testPoint.spliceCount;
        }
        else if (currentSelected.equals("Purify")) {
            sampleMetric = testPoint.purifyCount;
        }
        else if (currentSelected.equals("Time")) {
            sampleMetric = testPoint.executionTime;
        }
        else if (currentSelected.equals("Memory")) {
            sampleMetric = testPoint.memory;
        }
        else {
            sampleMetric = 0;
        }
        if (sampleMetric > maxValue) maxValue = sampleMetric;
    }
    return maxValue;
}


public int minElement() {

    int minValue = 999999;
    int sampleMetric = 0;

    for (datapoint testPoint: testData) {

        if ( currentSelected.equals("Mix")) {
            sampleMetric = testPoint.mixCount;
        }
        else if (currentSelected.equals("Extract")) {
            sampleMetric = testPoint.extractCount;
        }
        else if (currentSelected.equals("Append")) {
            sampleMetric = testPoint.appendCount;
        }
        else if (currentSelected.equals("Split")) {
            sampleMetric = testPoint.splitCount;
        }
        else if (currentSelected.equals("Splice")) {
            sampleMetric = testPoint.spliceCount;
        }
        else if (currentSelected.equals("Purify")) {
            sampleMetric = testPoint.purifyCount;
        }
        else if (currentSelected.equals("Time")) {
            sampleMetric = testPoint.executionTime;
        }
        else if (currentSelected.equals("Memory")) {
            sampleMetric = testPoint.memory;
        }
        else {
            sampleMetric = 0;
        }
        if (sampleMetric < minValue) minValue = sampleMetric;
    }
    return minValue;
}



class element {

    int selectedBackgroundColor;
    int unselectedBackgroundColor;
    int selectedFontColor;
    int unselectedFontColor;

    int   isSelected;        ///< 0 not selected, 1 selected
    float positionX;
    float positionY;
    float textX;
    float textY;
    float width;
    float height;
    float textMargin;

    String description;

    element() {

        selectedBackgroundColor = 0xffCBD4D8;
        unselectedBackgroundColor = 0xffABB5BD;
        selectedFontColor = 0xff000000;
        unselectedFontColor = 0xffffffff;
        description = "NULL";
        textMargin = 20;
    }

    public void display() {

        int backgroundColor;
        int fontColor;

        if (isSelected == 1) {
            dataYmin = minElement();
            dataYmax = 1.2f*maxElement();
            backgroundColor = selectedBackgroundColor;
            fontColor = selectedFontColor;
        }
        else {
            backgroundColor = unselectedBackgroundColor;
            fontColor = unselectedFontColor;
        }  

        textFont(selectFont, 17);
        rectMode(CORNER);
        fill(backgroundColor);
        rect(positionX, positionY, width, height);

        fill(fontColor);
        textAlign(LEFT);
        text(description, positionX, positionY+30);
    }

    ///
    /// Set the array element at position 0 to desired location.
    ///
    public void setBegin(float x, float y, float xWidth) {

        positionX = x;
        positionY = y;
        textX = positionX;
        textY = positionY + 30;
        textFont(selectFont, 17);
        width = xWidth;
        height = 50;
    }

    ///
    /// 0 no hover, 1 mouse hover
    ///
    public int isHover() {


        if (mouseX > positionX && mouseX < positionX+width) {
            if (mouseY > positionY && mouseY < positionY+height) {
                return 1;
            }
        }

        return 0;
    }
}


class datapoint {

    int m;
    int n;
    int executionTime;
    int memory;
    int isSat;            //< 0 UNSAT, 1 SAT, 2 UNKNOWN
    int algorithmType;    //< 0 Lipton, 1 Ogihara-Ray, 2 Distribution
    String filename;

    int mixCount;
    int extractCount;
    int appendCount;
    int splitCount;
    int spliceCount;
    int purifyCount;

    datapoint() {
        m = 0;
        n = 1;
        executionTime = 0;
        memory = 0;
        isSat = 2;

        filename = "undefined";

        mixCount     = 0;
        extractCount = 0;
        appendCount  = 0;
        splitCount   = 0;
        spliceCount  = 0;
        purifyCount  = 0;
    }

    public void drawExpandedPoint(int x, int y) {
    }
}


///
///
///
public void displayPlot() {

    pushMatrix();

    fill(tableColor);    
    rectMode(CORNERS);
    rect(plotX1, plotY1, plotX2, plotY2);

    popMatrix();
}


///
///
///
public void displayPoints() {

    float pointRadius = 40.0f;
    float sampleMetric = 0;

    pushMatrix();

    for (datapoint testPoint: testData) {
        //        println(testPoint.filename + " " + testPoint.mixCount);

        if (testPoint.filename.equals("undefined")) {
        }
        else {
            float ratio = (float)testPoint.m/testPoint.n;
            float x = map(ratio, dataXmin, dataXmax, plotX1, plotX2);

            if ( currentSelected.equals("Mix")) {
                sampleMetric = testPoint.mixCount;
            }
            else if (currentSelected.equals("Extract")) {
                sampleMetric = testPoint.extractCount;
            }
            else if (currentSelected.equals("Append")) {
                sampleMetric = testPoint.appendCount;
            }
            else if (currentSelected.equals("Split")) {
                sampleMetric = testPoint.splitCount;
            }
            else if (currentSelected.equals("Splice")) {
                sampleMetric = testPoint.spliceCount;
            }
            else if (currentSelected.equals("Purify")) {
                sampleMetric = testPoint.purifyCount;
            }
            else if (currentSelected.equals("Time")) {
                sampleMetric = testPoint.executionTime;
            }
            else if (currentSelected.equals("Memory")) {
                sampleMetric = testPoint.memory;
            }
            else {
                sampleMetric = 0;
            }

            //        float y = map(sampleMetric, dataYmin, dataYmax, plotY2, plotY1);
            float y = map(sampleMetric, dataYmin, dataYmax, plotY2, plotY1);

            //        noStroke();
            if (testPoint.algorithmType == 0) {
                fill(liptonColor);
            }
            else if (testPoint.algorithmType == 1) {
                fill(ogiRayColor);
            }
            else if (testPoint.algorithmType == 2) {
                fill(distriColor);
            }

            if (testPoint.isSat == 1) {
                pointRadius = 30.0f;
            }
            else if (testPoint.isSat == 0) {
                pointRadius = 10.0f;
            }
            else {
            }

            ellipse(x, y, pointRadius, pointRadius);

            ////////////////////

            fill(pointTextColor);
            textFont(selectFont, 17);
            text(testPoint.n, x-10, y);
        }
        stroke(0);
    }

    popMatrix();
}


// This function returns all the files in a directory as an array of File objects
// This is useful if you want more info about the file
public File[] listFiles(String dir) {
    File file = new File(dir);
    if (file.isDirectory()) {
        File[] files = file.listFiles();
        return files;
    } 
    else {
        // If it's not a directory
        return null;
    }
}



public void displayDirectory(String path) {

    File[] files = listFiles(path);
    for (int i = 0; i < files.length; i++) {
        File f = files[i];    
        println("Name: " + f.getName());
        println("Is directory: " + f.isDirectory());
        println("Size: " + f.length());
        String lastModified = new Date(f.lastModified()).toString();
        println("Last Modified: " + lastModified);
        println("-----------------------");
    }
}


public void processDirectory(String path) {

    File[] files = listFiles(path);
    datapoint tempPoint = new datapoint();

    for (int i = 0; i < files.length; i++) {
        File filename = files[i];    
        String[] lines;        
        lines = loadStrings(filename);


        if (filename.getName().endsWith(".out")) {

            testData[numDatapoint].filename = filename.getName();
            String[] nameSplit = split(filename.getName(), "_");

            for (int z = 0; z < nameSplit.length; z++) {

                if (nameSplit[z].startsWith("N")) {
                    testData[numDatapoint].n = parseInt(nameSplit[z].substring(1));
                }
                else if (nameSplit[z].startsWith("M")) {
                    testData[numDatapoint].m = parseInt(nameSplit[z].substring(1));
                }
            }

            for (int j = 0; j < lines.length; j++) {
                String[] pieces = split(lines[j], " "); // Load data into array

                if (pieces[0].equals("s")) {
                    if (pieces[1].equals("SATISFIABLE")) {
                        testData[numDatapoint].isSat = 1;
                    }
                    else if (pieces[1].equals("UNSATISFIABLE")) {
                        testData[numDatapoint].isSat = 0;
                    }
                }
                else if (pieces[0].equals("c")) {
                    
                    if (pieces[1].equals("mixCount:")) {
                        testData[numDatapoint].mixCount = parseInt(pieces[pieces.length-1]);
                    }
                    else if (pieces[1].equals("extractCount:")) {
                        testData[numDatapoint].extractCount = parseInt(pieces[pieces.length-1]);
                    }
                    else if (pieces[1].equals("appendCount:")) {
                        testData[numDatapoint].appendCount = parseInt(pieces[pieces.length-1]);
                    }
                    else if (pieces[1].equals("splitCount:")) {
                        testData[numDatapoint].splitCount = parseInt(pieces[pieces.length-1]);
                    }
                    else if (pieces[1].equals("spliceCount:")) {    
                        testData[numDatapoint].spliceCount = parseInt(pieces[pieces.length-1]);
                    }
                    else if (pieces[1].equals("purifyCount:")) {
                        testData[numDatapoint].purifyCount = parseInt(pieces[pieces.length-1]);
                    }
                    else if (pieces[1].equals("numVar:")) {
                        
                        testData[numDatapoint].n = parseInt(pieces[pieces.length-1]);
                    }
                    else if (pieces[1].equals("numClause:")) {
                        testData[numDatapoint].m = parseInt(pieces[pieces.length-1]);
                    }
                    else if (pieces[1].equals("Test:") || pieces[1].equals("algorithmType:")) {
                        if (pieces[pieces.length-1].equals("Lipton")) {
                            testData[numDatapoint].algorithmType = 0;
                        }
                        else if (pieces[pieces.length-1].equals("Ogihara-Ray")) {
                            testData[numDatapoint].algorithmType = 1;
                        }
                        else if (pieces[pieces.length-1].equals("Distribution")) {
                            testData[numDatapoint].algorithmType = 2;
                        }
                    }
                    else if (pieces[1].equals("solutionMemory:")) {

                        testData[numDatapoint].memory = parseInt(pieces[pieces.length-1]);
                    }
                    else if (pieces[1].equals("algorithmTime:")) {
                        testData[numDatapoint].executionTime = parseInt(pieces[pieces.length-1]);
                    }
                }
                else if (pieces[0].equals("v")) {
                }
            }
            numDatapoint++;
        }
    }
}



public void saveOutput() {

    /*


    if (savePDF == true) {
        fill(200, 0, 0);
    }
    else {
        fill(0, 200, 0);
    }

    rect(100, 100, 100, 100);

    if (mouseX > 100 && mouseX < 200) {
        if (mouseY > 100 && mouseY < 200) {
            savePDF = true;
        }
    }
    */
}


public void processTSV(String filename) {

    datapoint tempPoint = new datapoint();

    String[] lines;        
    lines = loadStrings(filename);

    if (filename.endsWith(".tsv")) {

        for (int j = 0; j < lines.length; j++) {

            String[] pieces = split(lines[j], "\t"); // Load data into array

            for (int k = 0; k < pieces.length; k++) {

                switch(k) {
                case 0:
                    testData[numDatapoint].filename = pieces[0];
                case 1: 
                    testData[numDatapoint].algorithmType = parseInt(pieces[1]);
                    break;
                case 2: 
                    testData[numDatapoint].m = parseInt(pieces[2]);
                    break;
                case 3:
                    testData[numDatapoint].n = parseInt(pieces[3]);
                    break;
                case 4:
                    testData[numDatapoint].executionTime = parseInt(pieces[4]);
                    break;
                case 5:
                    testData[numDatapoint].memory = parseInt(pieces[5]);
                    break;
                case 6:
                    testData[numDatapoint].isSat = parseInt(pieces[6]);
                    break;
                case 7:
                    testData[numDatapoint].mixCount = parseInt(pieces[7]);
                    break;
                case 8:
                    testData[numDatapoint].extractCount = parseInt(pieces[8]);
                    break;
                case 9:
                    testData[numDatapoint].appendCount = parseInt(pieces[9]);
                    break;
                case 10:
                    testData[numDatapoint].splitCount = parseInt(pieces[10]);
                    break;
                case 11:
                    testData[numDatapoint].spliceCount = parseInt(pieces[11]);
                    break;
                case 12:
                    testData[numDatapoint].purifyCount = parseInt(pieces[12]);
                    break;
                default:
                    break;
                }
            }

            numDatapoint++;
        }
    }
    else {
        println("input TSV file");
    }
}



PrintWriter output;


public void saveDatapointsTSV() {

    output = createWriter("sweepDatapoints.tsv");

    for (datapoint testPoint: testData) {

        if (!testPoint.filename.equals("undefined")) {
            output.print(testPoint.filename + "\t");
            output.print(testPoint.algorithmType + "\t");
            output.print(testPoint.m + "\t");        
            output.print(testPoint.n + "\t");                
            output.print(testPoint.executionTime + "\t");                
            output.print(testPoint.memory + "\t");                
            output.print(testPoint.isSat + "\t");
            output.print(testPoint.mixCount + "\t");
            output.print(testPoint.extractCount + "\t");
            output.print(testPoint.appendCount + "\t");
            output.print(testPoint.splitCount + "\t");
            output.print(testPoint.spliceCount + "\t");
            output.print(testPoint.purifyCount + "\n");
        }
    }
    output.flush(); // Write the remaining data
    output.close(); // Finish the file
}




public void mouseWheel(int delta) {

    if (horizonalHover == 1) {
        dataXmax += (float)delta/20; 
        if (dataXmax < 0) dataXmax = 0.2f;
    }
    else if (verticalHover == 1) {
        dataYmax += (float)delta*20; 
        if (dataYmax < 0) dataYmax = 0.2f;
    }
    else {
    }
}


public void mouseMoved() {

    for (int i = 0; i < metricList.length; i++) {
        if (metricList[i].isHover() == 1) {
            metricList[i].isSelected = 1; 
            //            println("inhover"+i); 
            currentSelected = metricList[i].description;
        }
        else {
            metricList[i].isSelected = 0;
        }
    }

    updateHorizonalAxis();
    updateVerticalAxis();
}



public void mousePressed() {
  
    dataYmin = minElement();
    dataYmax = 1.2f*maxElement();

//    savePDF = true;
    
}

public void mouseReleased() {

}

    static public void main(String args[]) {
        PApplet.main(new String[] { "--present", "--bgcolor=#666666", "--hide-stop", "displaySat" });
    }
}
