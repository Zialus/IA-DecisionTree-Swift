import Foundation

#if os(Linux)
    import BSD
#endif

// Store debug information that will be given by cmdLine Args
var DEBUG = false
var FULLDEBUG = false

// Will store the location of the input file which cotains the timetables info
var filelocation: String = ""

// Global Stuff
var atributeDictionary = [String: Set<String>]()
var finalAtribute: String! = nil
var inputMatrix = [[String]]()

var atributeSet = Set<String>()

// Process the given cmdLine Args
proccessCmdLineArgs()

// Process the contents of the input file and isert them into the inputMatrix
processFile()

welcomeMessage()

printdebug("Printing the Matrix before Any kind of Descritization:")
printdebug("----------------------------------------------------------")
for line in inputMatrix {
    printdebug(line)
}
printdebug("----------------------------------------------------------")


// Process the matrix again to try to descretize stuff
let descretizedMatrix = matrixDescretization(inputMatrix)

printdebug("Printing the Matrix after the Descritization Process:")
printdebug("----------------------------------------------------------")
for line in descretizedMatrix {
    printdebug(line)
}
printdebug("----------------------------------------------------------")



// Process the matrix to find some general information about it
processMatrix(descretizedMatrix)

printdebug("Printing the Dictionary of Atributes:")
printdebug("----------------------------------------------------------")
for (key,value) in atributeDictionary{
    printdebug("\(key) --> \(value)")
}
printdebug("----------------------------------------------------------")

printdebug("Printing the Set of Atributes:")
printdebug("----------------------------------------------------------")
printdebug(atributeSet)
printdebug("----------------------------------------------------------")


let decisionTree = ID3(descretizedMatrix, targetAtribute: finalAtribute, atributes: atributeSet, level: 0)


print("\n\nHere is the Decision Tree:")
printdebug("----------------------------------------------------------")
decisionTree.formatedPrint()
printdebug("----------------------------------------------------------")


// Menu Loop
while true {

    switch menu() {
    case 1:
        findClass()
    case 9:
        print("Show me the way way out!!!")
        exit(0)
    default:
        print ("Invalid option!")
        usleep(600000)
    }

}
