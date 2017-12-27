import Foundation

func chooseAtribute(possibleAtributes: Set<String>, examples: [[String]]) -> (String) {

    var maxGain = -Double.infinity
    var maxAtribute = ""

    printdebug("-------------Atribute Choosing For Loop----------------------")

    for atribute in possibleAtributes {

        printdebug("\(ANSI.Blue)Atribite Stuff --->\(ANSI.Reset) Atributo: \(atribute) \t Ganho: \(getGain(atribute: atribute, examples: examples)) ")

        if getGain(atribute: atribute, examples: examples) > maxGain {
            maxAtribute = atribute
            maxGain = getGain(atribute: atribute, examples: examples)
        }
    }
    printdebug("-------------------------------------------------------------\n\n")


    return maxAtribute
}

func getGain(atribute: String, examples: [[String]]) -> (Double) {

    //----------------------------CurrentAtribute Section---------------//

    let entropyDictionary = getEntropyNumbers(atribute: atribute, examples: examples)
    var coeficients = [Double]()

    let denominator = Double( examples.count-1 )

    // (atribute, goalDict)
    for (_, goalDict) in entropyDictionary {
        var numerator = 0.0
        // (goal, count)
        for (_, count) in goalDict {
            numerator+=Double(count)
        }
        printfulldebug("num:\(numerator) den: \(denominator)")
        coeficients.append(numerator/denominator)
    }

    var atributeEntropy = 0.0

    for (c, dictionaryEntry) in Array(zip(coeficients, entropyDictionary)) {
        var listOfThingsToSendToEntropyCalc = [Double]()

        var denominatorInternal = 0.0

        printfulldebug("Stuff in the dictionary \(dictionaryEntry)")

        // (value, restOfDictionary)
        let (_, restOfDictionary) = dictionaryEntry

        // (goal, count)
        for (_, count) in restOfDictionary {
            denominatorInternal+=Double(count)
        }

        // (goal, count)
        for (_, count) in restOfDictionary {
            //TODO: This is kinda hacky but i won't be fixing it for now
            if denominatorInternal != 0 {
                listOfThingsToSendToEntropyCalc.append( Double(count)/denominatorInternal )
            } else {
                listOfThingsToSendToEntropyCalc.append(0.0)
            }
        }

        printfulldebug("Sending this to EntropyCalc \(listOfThingsToSendToEntropyCalc) * \(c)")
        atributeEntropy += calculateEntropy(values: listOfThingsToSendToEntropyCalc) * c
    }



    //----------------------FinalAtribute Section--------------------//
    let goalEntropyDictionary = getEntropyNumbers(atribute: finalAtribute, examples: examples)

    var goalCoeficients = [Double]()

    for (_, goalDict) in goalEntropyDictionary {
        var numerator = 0.0
        for (_, count) in goalDict {
            numerator+=Double(count)
        }
        printfulldebug("num:\(numerator) den: \(denominator)")
        goalCoeficients.append(numerator/denominator)
    }

    var goalAtributeEntropy = 0.0

    printfulldebug("Sending this to EntropyCalc \(goalCoeficients)")
    goalAtributeEntropy+=calculateEntropy(values: goalCoeficients)



    // Subtract entropy of the goal atribute from the current atribute whos gain is being calculated
    let result = goalAtributeEntropy-atributeEntropy
    return result
}

func getEntropyNumbers(atribute: String, examples: [[String]]) -> ([String:[String:Int]]) {

    var dictionary = [String:[String:Int]]()

    let possibleValuesOfFinalAtribute = atributeDictionary[finalAtribute]!

    let possibleValuesOfCurrentAtribute = atributeDictionary[atribute]!

    for value in possibleValuesOfCurrentAtribute {
        dictionary[value] = [String:Int]()
        for goal in possibleValuesOfFinalAtribute {
            dictionary[value]![goal] = 0
        }
    }

    let col = examples[0].index(of: atribute)!
    let lastCol = examples[0].count-1
    let lastRow = examples.count-1

    for (index, _) in examples.enumerated() where index > 0 && index <= lastRow {

        let value = examples[index][col]
        let goal = examples[index][lastCol]

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

func ID3(examples: [[String]], targetAtribute: String, atributes: Set<String>, level: Int) -> (Node) {

    if atributes.count == 0 {

        let (label, number) = mostCommonValueOfTargetAtribute(examples: examples, targetAtribute: targetAtribute)

        let node = Node.Value(leaf: Leaf(goal:label, amount: number, level: level))

        printfulldebug("----------FIRST IF START-----------")
        if FULLDEBUG { node.formatedPrint() }
        printfulldebug("------------------------------------\n\n")

        return node

    }

    let (bool, label, amount) = allExamplesSameGoal(examples: examples)

    if bool {
        let node = Node.Value(leaf: Leaf(goal:label, amount: amount, level: level))

        printfulldebug("-------------------------BOOOL TRUE---------------------")
        if FULLDEBUG { node.formatedPrint() }
        printfulldebug("--------------------------------------------------------\n\n")

        return node
    } else {


        let bestAtribute = chooseAtribute(possibleAtributes: atributes, examples: examples)
        let node = Node.Atribute(tree: Tree(atribute: bestAtribute, level: level))


        printfulldebug("---------------------BOOL FALSE-----------------------")
        printfulldebug("bestAtribute: \(bestAtribute)")
        printfulldebug("-----------------------------------------------------\n\n")



        for eachPossibleValue in atributeDictionary[bestAtribute]! {

            printfulldebug("------------------------------Created a Child START-------------------------------------------------------------------------------")


            let subsetOfExamples = exampleSubset(examples: examples, atributeName: bestAtribute, atributeValue: eachPossibleValue)

            if subsetOfExamples.count == 1 {

                printfulldebug("----------------NO_EXAMPLES_LEFT CASE START-----------------------------")

                let (label, number) = mostCommonValueOfTargetAtribute(examples: examples, targetAtribute: targetAtribute)
                let childNode = Node.Value(leaf: Leaf(goal:label, amount: number, level: level))

                let currentNodeLevel = node.getLevel()
                childNode.setEdgeName(eachPossibleValue)
                childNode.setLevel(currentNodeLevel+1)
                node.appendChild(childNode)


                printfulldebug("---------------------------NO_EXAMPLES_LEFT CASE END-------------------------\n")
                if FULLDEBUG { childNode.formatedPrint() }

            } else {

                printfulldebug("-----------------------------REGULAR CASE START------------------------------")
                var newAtributeSet = atributes
                newAtributeSet.remove(bestAtribute)
                let childNode = ID3(examples: subsetOfExamples, targetAtribute: targetAtribute, atributes: newAtributeSet, level: level+1 )

                let currentNodeLevel = node.getLevel()
                childNode.setLevel(currentNodeLevel+1)
                childNode.setEdgeName(eachPossibleValue)

                node.appendChild(childNode)


                printfulldebug("-----------------------------REGULAR CASE END--------------------------------\n")
                if FULLDEBUG { childNode.formatedPrint() }

            }

            printfulldebug("------------------------------Created a Child END----------------------------------------------------------------------------------------")


        }


        printfulldebug("-------------------------------REACHED THE END--------------------------------------")
        if FULLDEBUG { node.formatedPrint() }
        printfulldebug("------------------------------------------------------------------------------------\n\n")


        return node
    }


}

func exampleSubset(examples: [[String]], atributeName: String, atributeValue: String) -> ([[String]]) {

    var examplesSubset: [[String]] = [examples[0]]

    let indexOfWantedAtribute = examples[0].index(of: atributeName)!

    for (indexOfExample, example) in examples.enumerated() where indexOfExample > 0 {
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
    for (indexOfLine, line) in examples.enumerated() where indexOfLine>0 {

        if line[finalCol] != valueOfGoalFirstLine {
            everythingIsEqual = false
        }

    }

    if everythingIsEqual {
        return (true, valueOfGoalFirstLine, count)
    } else {
        return (false, "", 0)
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

    for (index, example) in examples.enumerated() where index > 0 {
        let finalAtributeValue = example[lastCol]
        counter[finalAtributeValue]! += 1
    }

    for (atribute, count) in counter {
        if count > mostCommonValueCounter {
            mostCommonValueName = atribute
            mostCommonValueCounter = count
        }
    }

    return (mostCommonValueName, mostCommonValueCounter)
}

func searchForClass(exampleMatrix: [[String]], currentNode: Node) -> (String) {

    switch currentNode {
    case .Atribute(let tree):

        let indexOfAtribute = exampleMatrix[0].index(of: tree.atribute)!
        let valueOfcurrentAtribute = exampleMatrix[1][indexOfAtribute]

        var nextNode: Node?
        for child in tree.children {
            if child.getEdgeName() == valueOfcurrentAtribute {
                nextNode = child
            }
        }

        guard let nextNodeIsNotNil = nextNode else {
            return "!!WARNING --> The Value \(valueOfcurrentAtribute) is not present in the Tree <-- WARNING!!"
        }

        return searchForClass(exampleMatrix: exampleMatrix, currentNode: nextNodeIsNotNil)

    case .Value(let leaf):
        return leaf.goal

    }

}
