//import fullscreen.*;
import java.awt.event.*;
import processing.pdf.*;
import processing.opengl.*;

//FullScreen fs; 


/// Global data
int FIRST_RUN = 0;      // 0 --- subsequent run, 1 --- first run(generate new datapoints)
                        // Select directory for datapoints
String simulationPath = "/Users/davidcarley/Dropbox/research/project/implementation/molecularSimulation/data/testCNF";
                        // Default TSV datapoints for subsequent runs
String localTSVData = "http://www.cs.rit.edu/~dnc6813/project/applet/sweepDatapoints.tsv";
//String localTSVData = "sweepDatapoints.tsv";

boolean savePDF = false;

color tableColor      = #ffffff; //color(91, 103, 112, 127);  //#5B6770;
color backgroundColor = #ffffff;
color pointColor      = #E8A41C;
color pointTextColor  = #000000;

color axisColor         = #ffffff;
color axisHoverColor    = #00ff00;
color selectedAxisColor = #FFBC00;
color axisTextColor     = #000000;

color titleColor      = #000000;

color liptonColor     = color(255, 20, 20, 100); //= #ff0000;
color ogiRayColor     = color(20, 255, 20, 100); //= #0000ff;
color distriColor     = color(20, 20, 255, 100); //= #00ff00;


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

float dataXmin = 0.0;
float dataXmax = 15.0;
float dataYmin = 0.0;
float dataYmax = 5000.0;

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
void setup() { 

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

    if (FIRST_RUN == 1) {
        processDirectory(simulationPath);
        saveDatapointsTSV();
    }
    else {
        processTSV(localTSVData);
    }
    //  println("number of datapoints " + numDatapoint);

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
void draw() {

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
    text("Clause-variable ratio", width/2, height - 0.75*borderMargin);
    drawHorizonalAxis();

    textAlign(CENTER);
    fill(axisTextColor);
    textFont(axisFont, 17);

    drawVerticalAxis();
    //////////////////////////////////////

    // Display key
    textAlign(LEFT);
    fill(axisTextColor);
    textFont(axisFont, 17);
    text("Lipton ", 75, height - 65); 

    fill(liptonColor);
    ellipse(60, height - 70, 20, 20);

    textAlign(LEFT);
    fill(axisTextColor);
    textFont(axisFont, 17);
    text("Ogihara-Ray ", 75, height - 45); 

    rectMode(CENTER);
    fill(ogiRayColor);
    rect(60, height - 50, 20, 20);

    textAlign(LEFT);
    fill(axisTextColor);
    textFont(axisFont, 17);
    text("Distribution ", 75, height - 25); 

    fill(distriColor);

    drawTriangle(60, height-30, 20);

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

