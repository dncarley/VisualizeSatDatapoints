
void processTSV(String filename) {

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

