import Foundation

func chooseAtribute(possibleAtributes: Set<String>, examples: [[String]]) -> (String) {

    var maxGain = -Double.infinity
    var maxAtribute = ""

    for atribute in possibleAtributes {

        printdebug("\(ANSI.Blue)Atribite Stuff --->\(ANSI.Reset) Atributo: \(atribute) \t Ganho: \(getGain(atribute, examples: examples)) ")

        if getGain(atribute, examples: examples) > maxGain {
            maxAtribute = atribute
            maxGain = getGain(atribute, examples: examples)
        }
    }

    return maxAtribute
}

func getGain(atribute: String, examples: [[String]]) -> (Double) {

    let entropyDictionary = getEntropyNumbers(atribute, examples: examples)
    var coeficients = [Double]()

    let denominator = Double( examples.count-1 )

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
            //TODO: I think this is an hack but i'm not sure
            if denominatorInternal != 0 {
                listOfThingsToSendToEntropyCalc.append( Double(count)/denominatorInternal )
            }
        }

        printfulldebug("Sending this to EntropyCalc \(listOfThingsToSendToEntropyCalc) * \(c)")
        result+=calculateEntropy(listOfThingsToSendToEntropyCalc)*c
    }

    return 1-result
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

    let col = examples[0].indexOf(atribute)!
    let lastCol = examples[0].count-1
    let lastRow = examples.count-1

    for (index, _) in examples.enumerate() where index > 0 && index <= lastRow {

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

        let (label, number) = mostCommonValueOfTargetAtribute(examples, targetAtribute: targetAtribute)

        let node = Node.Value(leaf: Leaf(goal:label, amount: number, level: level))

        print("----------FIRST IF START-----------")
        node.formatedPrint()
        print("----------FIRST IF END-------------")

        return node

    }

    let (bool, label, amount) = allExamplesSameGoal(examples)

    if bool {
        let node = Node.Value(leaf: Leaf(goal:label, amount: amount, level: level))

        print("-------------------------BOOOL TRUE START---------------")
        node.formatedPrint()
        print("-----------------------------BOOOL TRUE END----------------")

        return node
    } else {


        let bestAtribute = chooseAtribute(atributes, examples: examples)
        let node = Node.Atribute(tree: Tree(atribute: bestAtribute, level: level))


        print("ELSE DO BOOL")
        print(bestAtribute)
        print()



        for eachPossibleValue in atributeDictionary[bestAtribute]! {

            print("------------------------------Created a Child START-------------------------------------------------------------------------------")


            let subsetOfExamples = exampleSubset(examples, atributeName: bestAtribute, atributeValue: eachPossibleValue)

            if subsetOfExamples.count == 1 {

                print("----------------NO_EXAMPLES_LEFT CASE START-----------------------------")

                let (label, number) = mostCommonValueOfTargetAtribute(examples, targetAtribute: targetAtribute)
                let childNode = Node.Value(leaf: Leaf(goal:label, amount: number, level: level))

                let currentNodeLevel = node.getLevel()
                childNode.setEdgeName(eachPossibleValue)
                childNode.setLevel(currentNodeLevel+1)
                node.appendChild(childNode)


                print("---------------------------NO_EXAMPLES_LEFT CASE END-------------------------\n")
                childNode.formatedPrint()


            } else {

                print("-----------------------------REGULAR CASE START------------------------------")
                var newAtributeSet = atributes
                newAtributeSet.remove(bestAtribute)
                let childNode = ID3(subsetOfExamples, targetAtribute: targetAtribute, atributes: newAtributeSet, level: level+1 )

                let currentNodeLevel = node.getLevel()
                childNode.setLevel(currentNodeLevel+1)
                childNode.setEdgeName(eachPossibleValue)

                node.appendChild(childNode)


                print("-----------------------------REGULAR CASE END--------------------------------\n")
                childNode.formatedPrint()


            }

            print("------------------------------Created a Child END----------------------------------------------------------------------------------------")


        }


        print("-------------------------------REACHED THE END START--------------------------------")
        node.formatedPrint()
        print("-------------------------------REACHED THE END END----------------------------------")


        return node
    }


}


func exampleSubset (examples: [[String]], atributeName: String, atributeValue: String) -> ([[String]]) {

    var examplesSubset: [[String]] = [examples[0]]

    let indexOfWantedAtribute = examples[0].indexOf(atributeName)!

    printdebug("\n\nTESTE \(indexOfWantedAtribute)")

    for (indexOfExample, example) in examples.enumerate() where indexOfExample > 0 {
        printdebug("\n\n \(example[indexOfWantedAtribute]) == \(atributeValue)")
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

    for (index, example) in examples.enumerate() where index > 0 {
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
