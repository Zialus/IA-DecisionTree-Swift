import Foundation

enum Node {
    case Atribute(tree: Tree)
    case Value(leaf: Leaf)

    func formatedPrint() {
        switch self {
        case .Atribute(let tree):

            for _ in 0..<tree.level {
                print("\t",terminator:"")
            }

            print( "Level: \(tree.level) Atribute = \(tree.atribute) ParentEdge = \(tree.edgeName) ")

            for child in tree.children {
                child.formatedPrint()
            }

        case .Value(let leaf):

            for _ in 0..<leaf.level {
                print("\t",terminator:"")
            }

            print( "Level: \(leaf.level) Value = \(leaf.goal) Amount:\(leaf.amount) ParentEdge = \(leaf.edgeName)")
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

    func getEdgeName () -> (String) {
        switch self {
        case .Atribute(let tree):
            return tree.edgeName
        case .Value(let leaf):
            return leaf.edgeName
        }
    }
}

class Tree {
    var edgeName: String
    var level: Int
    let atribute: String
    var children: [Node]
    init(atribute: String, level: Int) {
        self.atribute = atribute
        self.children = [Node]()
        self.level = level
        self.edgeName = ""
    }
}

class Leaf {
    var edgeName: String
    var level: Int
    let goal: String
    let amount: Int

    init(goal: String, amount: Int, level: Int) {
        self.goal = goal
        self.amount = amount
        self.level = 0
        self.edgeName = ""
    }
}
