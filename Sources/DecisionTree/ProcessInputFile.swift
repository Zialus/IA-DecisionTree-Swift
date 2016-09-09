import Foundation

func processFile() {

    print("Trying to open the file: \(filelocation) ... ", terminator:"")

    let fileContent = try? NSString(contentsOfFile: filelocation, encoding: String.Encoding.utf8.rawValue)

    if fileContent == nil {
        print("\(Colors.Red("Something went wrong while trying to open that file!"))")
        exit(1)
    } else {

        print("\(Colors.Green("File opened successfuly!"))")

        printfulldebug("\n\(ANSI.Cyan)######BEGINNING OF FILE CONTENT######\(ANSI.Reset)")
        printfulldebug(fileContent!)
        printfulldebug("\(ANSI.Cyan)######END OF FILE CONTENT######\(ANSI.Reset)\n")

        let delimiter = "\n"
        let linesList = fileContent!.components(separatedBy: delimiter)

        // last line is blank
        for (index, line) in linesList.enumerated() where index < linesList.count-1 {

            inputMatrix.append([])
            printfulldebug("\(ANSI.Cyan)~~~~~~~~~~~~~~~~BEGINNING OF LINE~~~~~~~~~~~~~~~~\(ANSI.Reset)")

            printfulldebug("\(ANSI.Yellow)$$$$$$--FULL LINE--$$$$$$$\(ANSI.Reset)")
            printfulldebug(line)
            printfulldebug("\(ANSI.Yellow)$$$$$$--END OF IT--$$$$$$$\(ANSI.Reset)")

            let delimiter = ","
            let atributeList = line.components(separatedBy: delimiter)

            printfulldebug(atributeList)

            for atribute in atributeList {
                inputMatrix[index].append(atribute)
            }

            printfulldebug("\(ANSI.Cyan)~~~~~~~~~~~~~~~~END OF LINE~~~~~~~~~~~~~~~~~~~~~~\(ANSI.Reset)")

        }

        printdebug("")
        printdebug(Colors.Green("/----------------------------------------------------------------------\\"))
        printdebug(Colors.Green("|-------EVERYTHING HAS BEEN PROCESSED!! HERE IS THE FINAL RESULT-------|"))
        printdebug(Colors.Green("\\----------------------------------------------------------------------/"))

        let nExamples = inputMatrix.count-1 // first row contains atributes
        let nAtributes = inputMatrix[0].count-2 // first and last col contain ID and Goal respectively

        printdebug("")
        printdebug("The Database has \(Colors.Red("\(nAtributes)")) atributes and \(Colors.Red("\(nExamples)")) examples ")
        printdebug("")

    }

}

func processMatrix(_ matrix: [[String]]) -> () {

    // Saving FinalAribute Name
    let finalCol = inputMatrix[0].count-1
    finalAtribute = inputMatrix[0][finalCol]

    for (index, line) in matrix.enumerated() where index > 0 {

        for (col, atributeValue) in line.enumerated() where col > 0 {

            let atributeName = matrix[0][col]

            if atributeDictionary[atributeName] != nil {
                atributeDictionary[atributeName]!.insert(atributeValue)
                atributeSet.insert(atributeName)
            } else {
                atributeDictionary[atributeName] = Set<String>(arrayLiteral:atributeValue)
            }

            printfulldebug("Index:\(index)")

            printfulldebug("State of the Dictionary so far:\n\(atributeDictionary)\n")

            //            if let atributeNameIndex = atributeSet.indexOf(atribute){
            //                inputMatrix[0][atributeNameIndex]
            //                dictionary[temp_atribute] = atribute
            //            }



        }
    }

    atributeSet.remove(finalAtribute)

}

func processValidationSet(_ validationSetFile: String) -> ([[[String]]]?){

    var returnMatrix = [[[String]]]()
    let firstRow = inputMatrix[0]

    print("Trying to open the file: \(validationSetFile) ... ", terminator:"")

    guard let fileContent = try? NSString(contentsOfFile: validationSetFile, encoding: String.Encoding.utf8.rawValue) else {
        return nil
    }

    print("\(Colors.Green("File opened successfuly!"))")

    printfulldebug("\n\(ANSI.Cyan)######BEGINNING OF FILE CONTENT######\(ANSI.Reset)")
    printfulldebug(fileContent)
    printfulldebug("\(ANSI.Cyan)######END OF FILE CONTENT######\(ANSI.Reset)\n")

    let delimiter = "\n"
    let linesList = fileContent.components(separatedBy: delimiter)

    // last line is blank
    for (index, line) in linesList.enumerated() where index < linesList.count-1 {

        var tmpArray = [String]()
        printfulldebug("\(ANSI.Cyan)~~~~~~~~~~~~~~~~BEGINNING OF LINE~~~~~~~~~~~~~~~~\(ANSI.Reset)")

        printfulldebug("\(ANSI.Yellow)$$$$$$--FULL LINE--$$$$$$$\(ANSI.Reset)")
        printfulldebug(line)
        printfulldebug("\(ANSI.Yellow)$$$$$$--END OF IT--$$$$$$$\(ANSI.Reset)")

        let delimiter = ","
        let atributeList = line.components(separatedBy: delimiter)

        printfulldebug(atributeList)

        for atribute in atributeList {
            tmpArray.append(atribute)
        }

        let tmpMatrix: [[String]] = [firstRow,tmpArray]
        returnMatrix.append(tmpMatrix)


        printfulldebug("\(ANSI.Cyan)~~~~~~~~~~~~~~~~END OF LINE~~~~~~~~~~~~~~~~~~~~~~\(ANSI.Reset)")

    }

    return returnMatrix

}

func matrixDescretization(_ inputMatrix: [[String]]) -> ([[String]]) {

    var matrix = inputMatrix

    let numOfCols = matrix[0].count

    rowLoop: for colIndex in 1..<numOfCols-1 {

        var arrayOfDoubles = [Double]()

        for (index,line) in matrix.enumerated() where index != 0 {
            guard let double = Double(line[colIndex]) else {
                print("Something went wrong while trying to convert a string to double in the Column \(matrix[0][colIndex])!")
                continue rowLoop
            }
            arrayOfDoubles.append(double)
        }

        printdebug("\nFinished creating an array for the atribute: \(matrix[0][colIndex])")
        printdebug("------------------------------------------------------")
        printdebug(arrayOfDoubles)
        printdebug("------------------------------------------------------")

        var pointsVector = [Vector]()

        for elem in arrayOfDoubles {
            pointsVector.append(Vector([elem]))
        }

        let kMeanCalculator = KMeans<String>(labels: ["Group1","Group2","Group3"])

        kMeanCalculator.trainCenters(pointsVector,convergeDistance: 0.001)

        printdebug("\nThe Centroids are:")
        printdebug("------------------------------------------------------")
        printdebug(kMeanCalculator.centroids)
        printdebug("------------------------------------------------------")

        for (index,centro) in kMeanCalculator.centroids.enumerated() {
            kMeanCalculator.labels[index] = String(centro.data[0].roundToPlaces(2))
        }

        let listWithLabelsApplied = kMeanCalculator.fit(pointsVector)

        printdebug("\nList after applying labels:")
        printdebug("------------------------------------------------------")
        printdebug(listWithLabelsApplied)
        printdebug("-------------------------------------------------------")

        for i in 1..<matrix.count {
            matrix[i][colIndex] = listWithLabelsApplied[i-1]
        }

    }

    return matrix

}

func descretizeValidationSet(_ inputMatrix: [[[String]]]) -> ([[[String]]]){

    var finalMatrix = inputMatrix

    for (matrixNumber,matrix) in inputMatrix.enumerated() {

        let numOfCols = matrix[0].count

        colLoop: for colIndex in 1..<numOfCols-1 {

            guard let double = Double(matrix[1][colIndex]) else {
                print("Something went wrong while trying to convert a string to double in the Column \(matrix[0][colIndex])!")
                continue colLoop
            }

            let descretizedDouble = findNearestLabel(double, colName: matrix[0][colIndex])

            finalMatrix[matrixNumber][1][colIndex] = descretizedDouble
        }





    }

    return finalMatrix

}

func findNearestLabel(_ doubleValue : Double, colName: String) -> (String) {

    var nearestLabel = ""
    var minDif = Double.infinity
    let values = atributeDictionary[colName]!

    for value in values {
        let dif = abs(Double(value)! - doubleValue)
        if dif < minDif{
            nearestLabel = value
            minDif = dif
        }
    }

    return String(nearestLabel)

}
