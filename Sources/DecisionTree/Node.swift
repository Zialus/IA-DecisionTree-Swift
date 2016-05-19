
import Foundation

enum Node {
    case Atribute(tree: Tree)
    case Value(leaf: Leaf)

    func appendChildern (node: Node){
        switch self {
        case .Atribute(let value):
            value.children.append(node)
        case .Value:
            return
        }
    }
}

class Tree {

    let atribute: String
    var children: [Node]

    init(atribute:String){
        self.atribute = atribute
        children = [Node]()
    }
}

class Leaf {
    let goal:String

    init(goal:String){
        self.goal = goal
    }
}