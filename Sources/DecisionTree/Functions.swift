import Foundation

func chooseAtribute(possibleAtributes: Set<String>) -> (String) {

    var maxGain = -Double.infinity
    var maxAtribute = ""

    for atribute in possibleAtributes {

        printdebug("\(ANSI.Blue)Atribite Stuff --->\(ANSI.Reset) Atributo: \(atribute) \t Ganho: \(getGain(atribute)) ")

        if getGain(atribute) > maxGain {
            maxAtribute = atribute
            maxGain = getGain(atribute)
        }
    }

    return maxAtribute
}

func getGain(atribute: String) -> (Double) {

    let entropyDictionary = getEntropyNumbers(atribute)
    var coeficients = [Double]()

    let denominator = Double( inputMatrix.count-1 )

    for (atribute, goalDict) in entropyDictionary {
        var numerator = 0.0
        for (goal, count) in goalDict {
            numerator+=Double(count)
        }
        printfulldebug("num:\(numerator) den: \(denominator)")
        coeficients.append(numerator/denominator)
    }

    var result = 0.0

    for (c, dictionaryEntry) in Array(zip(coeficients, entropyDictionary)) {
        var listOfThingsToSendToEntropyCalc = [Double]()

        var denominatorInternal = 0.0

        printfulldebug("Stuff in the dictionary \(dictionaryEntry)")

        let (atribute, restOfDictionary) = dictionaryEntry

        for (goal, count) in restOfDictionary {
            denominatorInternal+=Double(count)
        }

        for (goal, count) in restOfDictionary {
            listOfThingsToSendToEntropyCalc.append( Double(count)/denominatorInternal )
        }

        printfulldebug("Sending this to EntropyCalc \(listOfThingsToSendToEntropyCalc) * \(c)")
        result+=calculateEntropy(listOfThingsToSendToEntropyCalc)*c
    }

    return 1-result
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
    let lastRow = inputMatrix.count-1

    for (index, _) in inputMatrix.enumerate() where index > 0 && index <= lastRow {

        let value = inputMatrix[index][col]
        let goal = inputMatrix[index][lastCol]

        dictionary[value]![goal]!+=1

    }

    return dictionary
}

func calculateEntropy(values: [Double]) -> (Double) {
    var entropy = 0.0

    for value in values where value != 0.0 {
        entropy-=value*log2(value)
    }

    return entropy
}

func ID3(examples: [[String]], targetAtribute: String, atributes: Set<String>) -> (Node) {

    if examples.count == 1 {

        let (label,number) = mostCommonValueOfTargetAtribute(inputMatrix, targetAtribute: targetAtribute)

        let node = Node.Value(leaf: Leaf(goal:label, amount: number))

        print("FIRST IF  ---------------------------------------------------------------FIRST IF START")
        node.formatedPrint()
        print("FIRST IF ------------------------------------------------------------------FIRST IF END")

        return node

    }

    let (bool, label, amount) = allExamplesSameGoal(examples)

    if bool {
        let node = Node.Value(leaf: Leaf(goal:label,amount: amount))

        print("BOOOL TRUE  ---------------------------------------------------------------BOOOL START")
        node.formatedPrint()
        print("BOOOL TRUE ------------------------------------------------------------------BOOOL END")

        return node
    } else {

        let bestAtribute = chooseAtribute(atributes)
        let node = Node.Atribute(tree: Tree(atribute: bestAtribute))

        for eachPossibleValue in atributeDictionary[bestAtribute]! {

            let subsetOfExamples = exampleSubset(examples, atributeName: bestAtribute, atributeValue: eachPossibleValue)

            if subsetOfExamples.count == 1 {
                let (label,number) = mostCommonValueOfTargetAtribute(inputMatrix, targetAtribute: targetAtribute)
                let node = Node.Value(leaf: Leaf(goal:label, amount: number))

                print("NO EXAMPLES LEFT---------------------------------------------------------------START")
                node.formatedPrint()
                print("NO EXAMPLES LEFT-----------------------------------------------------------------END")


                return node

            } else {
                var newAtributeSet = atributes

                newAtributeSet.remove(bestAtribute)
                let childNode = ID3(subsetOfExamples, targetAtribute: targetAtribute, atributes: newAtributeSet )

                let currentNodeLevel = node.getLevel()

                childNode.setEdgeName(eachPossibleValue)
                childNode.setLevel(currentNodeLevel+1)
                print("created a child---------------------------------------------------------------START")
                childNode.formatedPrint()
                print("created a child-----------------------------------------------------------------END")


                node.appendChild(childNode)
            }
        }


        print("REACHED THE END---------------------------------------------------------------START")
        node.formatedPrint()
        print("REACHED THE END-----------------------------------------------------------------END")


        return node
    }


}


func exampleSubset (allTheExamples: [[String]], atributeName: String, atributeValue: String) -> ([[String]]) {

    var examplesSubset: [[String]] = [allTheExamples[0]]

    let indexOfWantedAtribute = allTheExamples[0].indexOf(atributeName)!

    for (indexOfExample, example) in allTheExamples.enumerate() where indexOfExample > 0 {
        if example[indexOfWantedAtribute] == atributeValue {
            examplesSubset.append(example)
        }
    }

    return examplesSubset

}


func allExamplesSameGoal(examples: [[String]]) -> (Bool, String, Int) {

    let count = examples.count-1
    let finalCol = examples[0].count-1
    let valueOfGoalFirstLine = examples[1][finalCol]

    var everythingIsEqual = true
    for (indexOfLine, line) in examples.enumerate() where indexOfLine>0 {

        if line[finalCol] != valueOfGoalFirstLine {
            everythingIsEqual = false
        }

    }

    if everythingIsEqual {
        return (true, valueOfGoalFirstLine,count)
    } else {
        return (false, "",0)
    }

}

func mostCommonValueOfTargetAtribute(examples: [[String]], targetAtribute: String) -> (String, Int) {

    var mostCommonValueName = ""
    var mostCommonValueCounter = 0

    let possibleValuesForFinalAtribute = atributeDictionary[targetAtribute]!

    var counter = [String:Int]()

    for values in possibleValuesForFinalAtribute {
        counter[values] = 0
    }

    let lastCol = examples[0].count-1
    
    for (index,example) in examples.enumerate() where index > 0 {
        let finalAtributeValue = example[lastCol]
        counter[finalAtributeValue]! += 1
    }
    
    for (atribute,count) in counter {
        if count > mostCommonValueCounter {
            mostCommonValueName = atribute
            mostCommonValueCounter = count
        }
    }

    return (mostCommonValueName, mostCommonValueCounter)
}