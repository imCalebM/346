//
//  SpreadsheetGrammar.swift
//  COSC346 Assignment 1
//
//  Created by David Eyers on 24/07/17.
//  Copyright © 2017 David Eyers. All rights reserved.
//

import Foundation

// Simplified example grammar
// (Rules are also shown next to their parsing classes, in this file)
//
// Spreadsheet -> Expression | Epsilon
// Expression -> Integer ExpressionTail
// ExpressionTail -> [+] Integer
//
// This code shows the key aspects of recursive descent parsing. Also, note how the object oriented structure matches the grammar. Having said that, this code is by no means optimal / neat / nice!

/** The top-level GrammarRule.
 This GrammarRule handles Spreadsheet -> Expression | Epsilon
 Note that it uses the GrammarRule's default parse method
 */
class GRSpreadsheet : GrammarRule {
    let myGRExpression = GRExpression()
    init(){
        super.init(rhsRules: [[myGRExpression], [Epsilon.theEpsilon]])
    }
}

///// A GrammarRule for handling: Expression -> Integer ExpressionTail
//class GRExpression : GrammarRule {
//    let num = GRInteger()
//    let exprTail = GRExpressionTail()
//
//    init(){
//        super.init(rhsRule: [num,exprTail])
//    }
//    override func parse(input: String) -> String? {
//        let rest = super.parse(input:input)
//        if rest != nil {
//            self.calculatedValue = num.calculatedValue! + exprTail.calculatedValue!
//        }
//        return rest
//    }
//}

/// New GrammarRule for handling: Expression -> ProductTerm ExpressionTail | QuotedString
class GRExpression : GrammarRule {
    let exprTail = GRExpressionTail()
    let prodTerm = GRProductTerm()
    let strNoQ = GRStringNoQuote()
    
    init(){
        super.init(rhsRules: [[prodTerm, exprTail], [strNoQ]])
    }
    
}

/// A GrammarRule for handling: ExpressionTail -> "+" ProductTerm ExpressionTail | Epsilon
class GRExpressionTail : GrammarRule {
    let plus = GRLiteral(literal: "+")
    let num = GRInteger()
    let prodTerm = GRProductTerm()
    
    init(){
        super.init(rhsRules: [[plus,prodTerm], [Epsilon.theEpsilon]])
    }
    
    override func parse(input: String) -> String? {
        if let rest = super.parse(input: input) {
            self.calculatedValue =  Int(num.stringValue!)
            if rest != ""{
                let exprTail = GRExpressionTail()
                let rest = exprTail.parse(input: rest)
                if rest != nil{
                    self.calculatedValue = self.calculatedValue! + exprTail.calculatedValue!
                }
            }
            return rest
        }
        return nil
    }
}

// A GrammarRule for handling: ProductTerm -> Value ProductTermTail
class GRProductTerm : GrammarRule {
    let value = GRValue()
    let prodTail = GRProductTermTail()
    
    init(){
        super.init(rhsRules: [[value, prodTail]])
    }
}

// A GrammarRule for handling: ProductTermTail -> "*" Value ProductTermTail | Epsilon
class GRProductTermTail : GrammarRule {
    let multiply = GRLiteral(literal: "*")
    let num = GRInteger()
    init(){
        super.init(rhsRules: [[multiply, num], [Epsilon.theEpsilon]])
        
    }
    override func parse(input: String) -> String? {
        if let rest = super.parse(input: input){
            self.calculatedValue = Int(num.stringValue!)
            
            if (rest != "") {
                let prodTail = GRProductTermTail()
                let rest = prodTail.parse(input: rest)
                
                if rest != nil {
                    self.calculatedValue = self.calculatedValue! * prodTail.calculatedValue!
                }
                
            }
            return rest
        }
        return nil
        
    }
    
}

// A GrammarRule for handling Value -> CellReference | Integer
class GRValue : GrammarRule{
    let cellRef = GRCellReference()
    let num = GRInteger()
    
    init(){
        super.init(rhsRules: [[cellRef],[num]])
    }
}

// A GrammarRule for handling CellReference -> AbsoluteCell | Relative Cell
class GRCellReference : GrammarRule {
    let absCell = GRAbsoluteCell()
    let relCell = GRRelativeCell()
    
    init(){
        super.init(rhsRules: [[absCell], [relCell]])
    }
}

/// A GrammarRule for handling AbsoluteCell -> ColumnLabel RowNumber
class GRAbsoluteCell : GrammarRule {
    let col = GRColumnLabel()
    let row = GRRowNumber()
    
    init() {
        super.init(rhsRule: [col,row])
    }
}

/// A GrammarRule for handling RelativeCell -> "r" Integer "c" Integer
class GRRelativeCell : GrammarRule {
    let row = GRLiteral(literal: "r")
    let col = GRLiteral(literal: "c")
    let rowNum = GRInteger()
    let colNum = GRInteger()
    
    init(){
        super.init(rhsRule: [row, rowNum, col, colNum])
    }
}







