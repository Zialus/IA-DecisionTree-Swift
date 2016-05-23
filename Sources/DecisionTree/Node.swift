import Foundation

enum Node {
    case Atribute(tree: Tree)
    case Value(leaf: Leaf)

    func formatedPrint() {
        switch self {
        case .Atribute(let tree):
            print( "Level: \(tree.level) Atribute = \(tree.atribute) ParantEdge = \(tree.edgeName) ")

            for child in tree.children {
                child.formatedPrint()
            }
        case .Value(let leaf):
            print( "Level: \(leaf.level) Value = \(leaf.goal) Amount:\(leaf.amount) ParantEdge = \(leaf.edgeName)")
        }
    }

    func appendChild (node: Node) {
        switch self {
        case .Atribute(let value):
            value.children.append(node)
        case .Value:
            print("This should never happend!!")
            exit(1)
        }
    }

    func setLevel (lvl: Int) {
        switch self {
        case .Atribute(let tree):
            tree.level = lvl
        case .Value(let leaf):
            leaf.level = lvl
        }
    }

    func setEdgeName (name: String) {
        switch self {
        case .Atribute(let tree):
            tree.edgeName = name
        case .Value(let leaf):
            leaf.edgeName = name
        }
    }

    func getLevel () -> (Int) {
        switch self {
        case .Atribute(let tree):
            return tree.level
        case .Value(let leaf):
            return leaf.level
        }
    }
}

class Tree {
    var edgeName: String
    var level: Int
    let atribute: String
    var children: [Node]
    init(atribute: String) {
        self.atribute = atribute
        self.children = [Node]()
        self.level = 0
        self.edgeName = ""
    }
}

class Leaf {
    var edgeName: String
    var level: Int
    let goal: String
    let amount: Int

    init(goal: String, amount: Int) {
        self.goal = goal
        self.amount = amount
        self.level = 0
        self.edgeName = ""
    }
}
