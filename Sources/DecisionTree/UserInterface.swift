import Foundation

func printInstructions() {
    print(ANSI.Yellow)
    print("  .-----------------------------------------------------------------.")
    print(" /  .-.                                                         .-.  \\")
    print("|  /   \\    \(ANSI.Cyan)./DecisionTree\(ANSI.Yellow) [file with routes] <extra args>     /   \\  |")
    print("| |\\_.  |                                                     |    /| |")
    print("|\\|  | /|      debug:     Activates basic debug info          |\\  | |/|")
    print("| `---' |      fulldebug: Activates the full debug info       | `---' |")
    print("|       |                                                     |       |")
    print("|       |-----------------------------------------------------|       |")
    print("\\       |                                                     |       /")
    print(" \\     /                                                       \\     /")
    print("  `---'                                                         `---'")
    print()
}

func welcomeMessage() {
    print(ANSI.Blue)
    print("              _           _             ____  _                 _")
    print("             | |_   _ ___| |_    __ _  / ___|(_)_ __ ___  _ __ | | ___")
    print("          _  | | | | / __| __|  / _` | \\___ \\| | '_ ` _ \\| '_ \\| |/ _ \\")
    print("         | |_| | |_| \\__ \\ |_  | (_| |  ___) | | | | | | | |_) | |  __/")
    print("          \\___/ \\__,_|___/\\__|  \\__,_| |____/|_|_| |_| |_| .__/|_|\\___|")
    print("                                                         |_|")
    print("            ____            _     _               _____")
    print("           |  _ \\  ___  ___(_)___(_) ___  _ __   |_   _| __ ___  ___")
    print("           | | | |/ _ \\/ __| / __| |/ _ \\| '_ \\    | || '__/ _ \\/ _ \\")
    print("           | |_| |  __/ (__| \\__ \\ | (_) | | | |   | || | |  __/  __/")
    print("           |____/ \\___|\\___|_|___/_|\\___/|_| |_|   |_||_|  \\___|\\___|")
    print("")
    print("                  ____                           _")
    print("                 / ___| ___ _ __   ___ _ __ __ _| |_ ___  _ __")
    print("                | |  _ / _ \\ '_ \\ / _ \\ '__/ _` | __/ _ \\| '__|")
    print("                | |_| |  __/ | | |  __/ | | (_| | || (_) | |")
    print("                 \\____|\\___|_| |_|\\___|_|  \\__,_|\\__\\___/|_|")
    print(ANSI.Reset)
}

func proccessCmdLineArgs() -> () {

    if CommandLine.arguments.count < 2 {
        print()
        print("\(Colors.Red("Too few arguments!")) Try launching with the argument \"--help\" ")
        print()
        exit(1)
    } else if CommandLine.arguments[1] == "--help" {

        printInstructions()
        exit(0)

    } else if CommandLine.arguments.count == 2 {

        print("All debug functionality is turned \(Colors.Red("OFF"))!")
        print()
        filelocation = CommandLine.arguments[1]

    } else if CommandLine.arguments.count > 3 {
        print()
        print("\(Colors.Red("Too many arguments!")) Try launching with the argument \"--help\" ")
        print()
        exit(1)
    } else if CommandLine.arguments.count == 3 {

        filelocation = CommandLine.arguments[1]
        let onlyArg = CommandLine.arguments[2]

        switch onlyArg {
        case "debug":
            print("Debug Mode is \(Colors.Green("ON"))!")
            print()

            DEBUG=true
        case "fulldebug":
            print("Full Debug mode is \(Colors.Green("ON"))!!!")
            print()

            DEBUG=true
            FULLDEBUG=true
        default:
            print()
            print("\(Colors.Red("What are you trying to do!?")) \n\"\(onlyArg)\" is an unrecognized argument")
            print()
            exit(1)
        }

    }

}

func menu() -> (Int) {
    print()
    print("                                                               .---.")
    print("                                                              /  .  \\")
    print("                                                             |\\_/|   |")
    print("                                                             |   |  /|")
    print("  .----------------------------------------------------------------' |")
    print(" /  .-.                                                              |")
    print("|  /   \\               Menu:                                         |")
    print("| |\\_.  |              (1) Ask a question or something               |")
    print("|\\|  | /|              (9) Exit!                                     |")
    print("| `---' |                                                            |")
    print("|       |                                                            |")
    print("|       |                                                           /")
    print("|       |----------------------------------------------------------'")
    print("\\       |")
    print(" \\     /")
    print("  `---'")
    print()
    print("Choose your option: ", terminator:"")


    if let userInput = readLine(strippingNewline: true) {
        if let res = Int(userInput) {
            return res
        }
    }

    return 0

}

func findClass() -> () {

    print("Insert the name of the file: ", terminator:"")

    guard let validationSetFile = readLine() else {
        print("\(Colors.Red("Something went wrong while trying to read the filename!"))")
        return
    }

    print()

    guard let validationExamplesMatrix = processValidationSet(validationSetFile) else {
        print("\(Colors.Red("Something went wrong while trying to open that file!"))")
        return
    }

    let finalValidationExamples = descretizeValidationSet(validationExamplesMatrix)

    print()

    for example in finalValidationExamples {
        let answer = searchForClass(exampleMatrix: example, currentNode: decisionTree)
        print("Example \"\(example[1][0])\" belongs to class: \(answer) ")
    }

}
