

PrintWriter output;


void saveDatapointsTSV() {

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

