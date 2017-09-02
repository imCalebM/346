//
//  main.swift
//  COSC346 Assignment 1
//
//  Created by David Eyers on 24/07/17.
//  Copyright © 2017 David Eyers. All rights reserved.
//
//  Some basic tests that aim to assist understanding of the GrammarRules.
//  As noted, this code should be replaced by you doing something better.

import Foundation

// If command line arguments are given, then try to interpret them as filenames, reading them and parsing them in sequence.
// Note that output requested in the specification should be generated during the parsing process: for example, successfully parsing a Print will produce output. Your code should not produce any other output when parsing a string read from a file.
if CommandLine.arguments.count>1 {
    var filenames = CommandLine.arguments
    filenames.removeFirst() // first argument is the name of the executable
    func stderrPrint(_ message:String) {
        let stderr = FileHandle.standardError
        stderr.write(message.data(using: String.Encoding.utf8)!)
    }
    
    for filename in filenames {
        do {
            let filecontents : String = try String.init(contentsOfFile: filename)
            let aGRSpreadsheet = GRSpreadsheet()
            if let remainder = aGRSpreadsheet.parse(input: filecontents) {
                if remainder != "" {
                    stderrPrint("Parsing left remainder [\(remainder)].\n")
                }
            }
        } catch {
            stderrPrint("Error opening and reading file with filename [\(filename)].\n")
        }
    }
    
} else {
    
    print("The code in main.swift is just a basic exercise of the classes that you have been provided with. It is not an example of well structured and/or thoroughly tested code, so you should probably replace it with an improved version!")

    func testGrammarRule(rule:GrammarRule, input:String) {
        if let remainingInput = rule.parse(input: input){
            print("Was able to parse input=\"\(input)\", with remainingInput=\"\(remainingInput)\"")
        } else {
            print("Was unable to parse input=\"\(input)\"")
        }
    }

    print("--- Test GRInteger parsing")
    let myGRInteger = GRInteger()
    // should parse the complete string
    testGrammarRule(rule: myGRInteger,input:"2")
    // should parse just the initial integer
    testGrammarRule(rule: myGRInteger,input:"  1200r3f")
    // should not be able to be parsed
    testGrammarRule(rule: myGRInteger,input:"NaN")

    print("--- Test GRLiteral parsing")
    let bGRLiteral = GRLiteral(literal: "b")
    testGrammarRule(rule: bGRLiteral,input:"2")
    testGrammarRule(rule: bGRLiteral,input:" b+a")

    print("--- Test GRExpression parsing")
    let myExpr = GRExpression()
    testGrammarRule(rule: myExpr, input: " 1+ 2 +4*5 ")
    if let result = myExpr.parse(input: " 1 + 2+4*5 ") {
        // if the parsing was successful, then an GRExpression should contain a calculatedValue, hence the (not ideal) unsafe optional forcing here.
        print("myExpr.calculatedValue is \(myExpr.calculatedValue!)")
    }

//    print("--- Test GRSpreadsheet parsing")
//    let mySpreadsheet = GRSpreadsheet()
//    testGrammarRule(rule: mySpreadsheet, input: "A1 := 2")
//    testGrammarRule(rule: mySpreadsheet, input: "An epsilon GRSpreadsheet match")
//    
//    
//    let myAbsoluteCell = GRAbsoluteCell()
//    testGrammarRule(rule: myAbsoluteCell, input: "A2 A2 A3")
//    
//    let myRelativeCell = GRRelativeCell()
//    testGrammarRule(rule: myRelativeCell, input: "r1c1")
//    let myCellReference = GRCellReference()
//    testGrammarRule(rule: myCellReference, input: "r 1c 2")
//    testGrammarRule(rule: myCellReference, input: " A 2 ")

    let myValue = GRValue()
    testGrammarRule(rule: myValue, input: "     r1c2 444444 +")
    testGrammarRule(rule: myValue, input: "    121321")
    testGrammarRule(rule: myValue, input: "    A12222222")
    testGrammarRule(rule: myValue, input: "  AAA1")
    
    let myExpression = GRExpression()
    testGrammarRule(rule: myExpression, input: "1+1")
    testGrammarRule(rule: myExpression, input: "hello")
    testGrammarRule(rule: myExpression, input: "A1")
    testGrammarRule(rule: myExpression, input: "r4c7")
    testGrammarRule(rule: myExpression, input: "1*4")
    testGrammarRule(rule: myExpression, input: "A1 + 4")
    testGrammarRule(rule: myExpression, input: " ")
    
}
