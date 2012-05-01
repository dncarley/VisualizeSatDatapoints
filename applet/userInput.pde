


void mouseWheel(int delta) {

    if (horizonalHover == 1) {
        dataXmax += (float)delta/20; 
        if (dataXmax < 0) dataXmax = 0.2;
    }
    else if (verticalHover == 1) {
        dataYmax += (float)delta*20; 
        if (dataYmax < 0) dataYmax = 0.2;
    }
    else {
    }
}


void mouseMoved() {

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



void mousePressed() {
  
    dataYmin = minElement();
    dataYmax = 1.2*maxElement();

//    savePDF = true;
    
}

void mouseReleased() {

}

