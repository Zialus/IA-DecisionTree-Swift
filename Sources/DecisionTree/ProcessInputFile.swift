import Foundation

func processFile () {

    print("Trying to open the file: \(filelocation) ... ", terminator:"")
    let fileContent = try? NSString(contentsOfFile: filelocation, encoding: NSUTF8StringEncoding)

    if fileContent == nil {
        print("\(Colors.Red("Something went wrong while trying to open that file!"))")
        exit(1)
    } else {

        print("\(Colors.Green("File opened successfuly!"))")

        printfulldebug("\n\(ANSI.Cyan)######BEGINNING OF FILE CONTENT######\(ANSI.Reset)")
        printfulldebug(fileContent!)
        printfulldebug("\(ANSI.Cyan)######END OF FILE CONTENT######\(ANSI.Reset)\n")

        let delimiter = "\n"
        let linesList = fileContent!.componentsSeparatedByString(delimiter)

        for (index, line) in linesList.enumerate() where index < linesList.count-1 {

            inputMatrix.append([])
            printfulldebug("\(ANSI.Cyan)~~~~~~~~~~~~~~~~BEGINNING OF LINE~~~~~~~~~~~~~~~~\(ANSI.Reset)")

            printfulldebug("\(ANSI.Yellow)$$$$$$--FULL LINE--$$$$$$$\(ANSI.Reset)")
            printfulldebug(line)
            printfulldebug("\(ANSI.Yellow)$$$$$$--END OF IT--$$$$$$$\(ANSI.Reset)")



            let delimiter = ","
            let atributeList = line.componentsSeparatedByString(delimiter)
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
        printdebug("")
        printdebug("The Database has \(Colors.Red("\(inputMatrix[0].count-2)")) atributes and \(Colors.Red("\(inputMatrix.count-1)")) examples ")
        printdebug("")

    }

}

func processMatrix(matrix: [[String]]) -> () {


    // Saved FinalAribute Name
    let finalCol = inputMatrix[0].count-1
    finalAtribute = inputMatrix[0][finalCol]

    for (index, line) in matrix.enumerate() where index > 0 {

        for (col, atributeValue) in line.enumerate() where col > 0 {

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
