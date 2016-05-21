import Foundation

func printdebug(string: Any) -> () {
    if DEBUG == true {
        print(string)
    }
}

func printfulldebug(string: Any) -> () {
    if FULLDEBUG == true {
        print(string)
    }
}
