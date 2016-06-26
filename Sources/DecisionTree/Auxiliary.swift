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

extension Double {
    // Rounds the double to decimal places value
    func roundToPlaces(_ places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}
