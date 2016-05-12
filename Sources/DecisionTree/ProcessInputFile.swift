import Foundation

func processFile () {

    print("Trying to open the file: \(filelocation) ... ",terminator:"")
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

        for line in linesList {

            printfulldebug("\(ANSI.Cyan)~~~~~~~~~~~~~~~~BEGINNING OF LINE~~~~~~~~~~~~~~~~\(ANSI.Reset)")

            printfulldebug("\(ANSI.Yellow)$$$$$$--FULL LINE--$$$$$$$\(ANSI.Reset)")
            printfulldebug(line)
            printfulldebug("\(ANSI.Yellow)$$$$$$--END OF IT--$$$$$$$\(ANSI.Reset)")



            printfulldebug("\(ANSI.Cyan)~~~~~~~~~~~~~~~~END OF LINE~~~~~~~~~~~~~~~~~~~~~~\(ANSI.Reset)")
        }

        printdebug("")
        printdebug(Colors.Green("/----------------------------------------------------------------------\\"))
        printdebug(Colors.Green("|-------EVERYTHING HAS BEEN PROCESSED!! HERE IS THE FINAL RESULT-------|"))
        printdebug(Colors.Green("\\----------------------------------------------------------------------/"))

        printdebug("The Database has \(dicionario.count) blablalblalbla: ")
        printdebug("")

    }

}
