import Foundation

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

// Process the contents of the input file
processFile()

// welcomeMessage()

printfulldebug(inputMatrix)


processMatrix(inputMatrix)

printdebug("--------------")
printdebug(atributeDictionary)
printdebug("---------------")

printdebug("--------------")
printdebug(atributeSet)
printdebug("---------------")


let decisionTree = ID3(inputMatrix, targetAtribute: finalAtribute, atributes: atributeSet, level: 0)

decisionTree.formatedPrint()


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
