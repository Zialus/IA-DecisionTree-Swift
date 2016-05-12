import Foundation

print("Hello, World!")

// Store debug information that will be given by cmdLine Args
var DEBUG = false
var FULLDEBUG = false

// Will store the location of the input file which cotains the timetables info
var filelocation: String = ""


// Global Stuff

var dicionario = [String:[String:Int]]()


// Process the given cmdLine Args
proccessCmdLineArgs()

// Process the contents of the input file
processFile()

welcomeMessage()

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
