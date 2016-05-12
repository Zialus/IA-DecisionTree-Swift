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
    print("    _____ _     _       _         _           _                 _ _ _")
    print("   |_   _| |__ (_)___  (_)___    (_)_   _ ___| |_    __ _   ___(_) | |_   _")
    print("     | | | '_ \\| / __| | / __|   | | | | / __| __|  / _` | / __| | | | | | |")
    print("     | | | | | | \\__ \\ | \\__ \\   | | |_| \\__ \\ |_  | (_| | \\__ \\ | | | |_| |")
    print("     |_| |_| |_|_|___/ |_|___/  _/ |\\__,_|___/\\__|  \\__,_| |___/_|_|_|\\__, |")
    print("                               |__/                                   |___/")
    print("        _____ _ _       _     _      ____ _               _")
    print("       |  ___| (_) __ _| |__ | |_   / ___| |__   ___  ___| | _____ _ __")
    print("       | |_  | | |/ _` | '_ \\| __| | |   | '_ \\ / _ \\/ __| |/ / _ \\ '__|")
    print("       |  _| | | | (_| | | | | |_  | |___| | | |  __/ (__|   <  __/ |")
    print("       |_|   |_|_|\\__, |_| |_|\\__|  \\____|_| |_|\\___|\\___|_|\\_\\___|_|")
    print("                  |___/")
    print("          _                  _   _           _         _")
    print("         / \\   _ __  _ __   | |_| |__   __ _| |_    __| | ___   ___  ___")
    print("        / _ \\ | '_ \\| '_ \\  | __| '_ \\ / _` | __|  / _` |/ _ \\ / _ \\/ __|")
    print("       / ___ \\| |_) | |_) | | |_| | | | (_| | |_  | (_| | (_) |  __/\\__ \\")
    print("      /_/   \\_\\ .__/| .__/   \\__|_| |_|\\__,_|\\__|  \\__,_|\\___/ \\___||___/")
    print("              |_|   |_|")
    print("                                               _          __  __")
    print("                ___  ___  _ __ ___   ___   ___| |_ _   _ / _|/ _|")
    print("               / __|/ _ \\| '_ ` _ \\ / _ \\ / __| __| | | | |_| |_")
    print("               \\__ \\ (_) | | | | | |  __/ \\__ \\ |_| |_| |  _|  _|")
    print("               |___/\\___/|_| |_| |_|\\___| |___/\\__|\\__,_|_| |_|")
    print(ANSI.Reset)
}

func proccessCmdLineArgs() -> () {

    if Process.arguments.count < 2 {
        print()
        print("\(Colors.Red("Too few arguments!")) Try launching with the argument \"--help\" ")
        print()
        exit(1)
    } else if Process.arguments[1] == "--help" {

        printInstructions()
        exit(0)

    } else if Process.arguments.count == 2 {

        print("All debug functionality is turned \(Colors.Red("OFF"))!")
        print()
        filelocation = Process.arguments[1]

    } else if Process.arguments.count > 3 {
        print()
        print("\(Colors.Red("Too many arguments!")) Try launching with the argument \"--help\" ")
        print()
        exit(1)
    } else if Process.arguments.count == 3 {

        filelocation = Process.arguments[1]
        let onlyArg = Process.arguments[2]

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
    print("|\\|  | /|              (9) Exit!                                    |")
    print("| `---' |                                                            |")
    print("|       |                                                            |")
    print("|       |                                                           /")
    print("|       |----------------------------------------------------------'")
    print("\\       |")
    print(" \\     /")
    print("  `---'")
    print()
    print("Choose your option: ", terminator:"")


    if let userInput = readLine(stripNewline: true) {
        if let res = Int(userInput) {
            return res
        }
    }

    return 0

}

func findClass() -> () {

}