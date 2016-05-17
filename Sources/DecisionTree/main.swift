import Foundation

print("Hello, World!")

// Store debug information that will be given by cmdLine Args
var DEBUG = false
var FULLDEBUG = false

// Will store the location of the input file which cotains the timetables info
var filelocation: String = ""


// Global Stuff


var atributeDictionary = [String: Set<String>]()

var finalAtribute: String

var inputMatrix = [[String]]()

// Process the given cmdLine Args
proccessCmdLineArgs()

// Process the contents of the input file
processFile()

//welcomeMessage()

printfulldebug(inputMatrix)

processMatrix(inputMatrix)

printdebug("--------------")

printdebug(atributeDictionary)

printdebug("---------------")



print(getEntropyNumbers("Type"))

print(getGain("Type"))
//print(getGain("Est"))

// Menu Loop
//while true {
//
//    switch menu() {
//    case 1:
//        findClass()
//    case 9:
//        print("Show me the way way out!!!")
//        exit(0)
//    default:
//        print ("Invalid option!")
//        usleep(600000)
//    }
//
//}
