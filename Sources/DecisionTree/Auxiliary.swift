import Foundation

func printdebug(_ string: Any) -> () {
    if DEBUG == true {
        print(string)
    }
}

func printfulldebug(_ string: Any) -> () {
    if FULLDEBUG == true {
        print(string)
    }
}

// Rounds the double to decimal places value
extension Double {
    func roundToPlaces(_ places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
