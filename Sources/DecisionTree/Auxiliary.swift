import Foundation

func printdebug(_ string: Any) {
    if DEBUG == true {
        print(string)
    }
}

func printfulldebug(_ string: Any) {
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

func crossPlatformRandom(upperBound num: Int) -> Int {
    let rand: UInt32

    #if os(Linux)
        srandom(UInt32(time(nil)))
        rand = (UInt32(random()) % UInt32(num))
    #else
        rand = arc4random_uniform(UInt32(num))
    #endif

    return Int(rand)
}
