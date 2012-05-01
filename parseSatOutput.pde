
// This function returns all the files in a directory as an array of File objects
// This is useful if you want more info about the file
File[] listFiles(String dir) {
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



void displayDirectory(String path) {

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


void processDirectory(String path) {

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

