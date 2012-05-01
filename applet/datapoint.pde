
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

    void drawExpandedPoint(int x, int y) {
    }
}


///
///
///
void displayPlot() {

    pushMatrix();

    fill(tableColor);    
    rectMode(CORNERS);
    rect(plotX1, plotY1, plotX2, plotY2);

    popMatrix();
}


///
///
///
void displayPoints() {

    float pointRadius = 40.0;
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
                pointRadius = 30.0;
            }
            else if (testPoint.isSat == 0) {
                pointRadius = 10.0;
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

