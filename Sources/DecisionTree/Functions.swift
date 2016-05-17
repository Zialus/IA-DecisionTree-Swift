//
//  Functions.swift
//  DecisionTree
//
//  Created by Raul Ferreira on 5/16/16.
//  Copyright © 2016 FCUP. All rights reserved.
//

import Foundation

//func calculateEntropy(matrix: [[String]], atribute: String)->(Int){
//    let diffValues = atributeDictionary[atribute]!.count
//    let denum = matrix.count
//    for i in 1...diffValues {
//        getEntropyNumbers(i)
//    }
//
//    let num = 5
//    return denum/num
//
//}


func getGain(atribute: String) -> (Double) {

    let entropyDictionary = getEntropyNumbers(atribute)
    var coeficients = [Double]()

    let denominator = Double( inputMatrix.count-2 )

    for (atribute,goalDict) in entropyDictionary {
        var numerator = 0.0
        for (goal,count) in goalDict {
            numerator+=Double(count)
        }
        print("num:\(numerator) den: \(denominator)")
        coeficients.append(numerator/denominator)
    }

    var result = 0.0

    for (c,dictionaryEntry) in Array(zip(coeficients,entropyDictionary)) {
        var listOfThingsToSendToEntropyCalc = [Double]()

        var denominatorInternal = 0.0

        print("Stuff in the dictionary \(dictionaryEntry)")

        let (atribute,restOfDictionary) = dictionaryEntry

        for (goal,count) in restOfDictionary {
            denominatorInternal+=Double(count)
        }

        for (goal,count) in restOfDictionary {
            listOfThingsToSendToEntropyCalc.append( Double(count)/denominatorInternal )
        }

        printfulldebug("Sending this to EntropyCalc \(listOfThingsToSendToEntropyCalc) * \(c)")
        result+=entropyCalc(listOfThingsToSendToEntropyCalc)*c
    }

    return result
}

func getEntropyNumbers(atribute: String) -> ([String:[String:Int]]) {

    var dictionary = [String:[String:Int]]()

    let possibleValuesOfFinalAtribute = atributeDictionary[finalAtribute]!

    let possibleValuesOfCurrentAtribute = atributeDictionary[atribute]!

    for value in possibleValuesOfCurrentAtribute {
        dictionary[value] = [String:Int]()
        for goal in possibleValuesOfFinalAtribute {
            dictionary[value]![goal] = 0
        }
    }

    let col = inputMatrix[0].indexOf(atribute)!
    let lastCol = inputMatrix[0].count-1
    let lastRow = inputMatrix.count-2

    for (index,_) in inputMatrix.enumerate() where index > 0 && index <= lastRow{

        let value = inputMatrix[index][col]
        let goal = inputMatrix[index][lastCol]

        dictionary[value]![goal]!+=1

    }

    return dictionary
}

func entropyCalc(values: [Double]) -> (Double) {
    var entropy = 0.0
    
    for value in values where value != 0.0 {
        entropy-=value*log2(value)
    }
    
    return entropy
}
