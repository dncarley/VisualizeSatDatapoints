
int horizonalHover;
int verticalHover;
String currentMetricDescription;


void drawHorizonalAxis() {
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

    for (float v = 0.1; v < dataXmax; v += volumeInterval) {
        float x = map(v, dataXmin, dataXmax, plotX1, plotX2);
        text(nf(v, 1, 1), x, plotY2+30);
    }
}

void updateHorizonalAxis() {

    horizonalHover = 0;
    if (mouseX > plotX1 && mouseX < plotX2) {
        if (mouseY > plotY2 && mouseY < plotY2+100) {
            horizonalHover = 1;
        }
    }
}


void drawVerticalAxis() {
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

void updateVerticalAxis() {

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




int maxElement() {

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


int minElement() {

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

