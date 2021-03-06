//
//  Token.swift
//  COSC346 Assignment 1
//
//  Created by David Eyers on 24/07/17.
//  Copyright © 2017 David Eyers. All rights reserved.
//
//  Subclasses of GrammarRule that assist reading "tokens" from input, such as literal strings, and integers.

import Foundation

/**
 A Token is a GrammarRule that parses tokens from the input string using regular expressions.
 This is more convenient than developing a complete recursive descent parser down to the character level of the input string.
 */
class Token : GrammarRule {
    /// The regular expression that this Token instance uses
    let regExp : NSRegularExpression
    
    /// The initialiser requires a regular expression pattern, and optionally some options to the NSRegularExpression system
    init(regExpPattern:String, options:NSRegularExpression.Options = []){
        self.regExp = try! NSRegularExpression(pattern: regExpPattern, options: options)
        super.init(rhsRule: [])
    }
    
    override func parse(input: String) -> String? {
        // Trim off whitespace
        let trimmedInput = input.trimmingCharacters(in: .whitespacesAndNewlines)
        // Find the first match
        let rangeOfFirstMatch = regExp.rangeOfFirstMatch(in: trimmedInput, options: [], range: NSRange(location: 0, length: trimmedInput.characters.count))
        
        // We require the regular expression to match right at the start of the whitespace-trimmed input string
        if(rangeOfFirstMatch.location != 0){
            return nil //no match
        }
        
        // Determine where the match finishes and the start of the restOfInput begins
        let index = trimmedInput.index(trimmedInput.startIndex, offsetBy: rangeOfFirstMatch.length)
        let match = trimmedInput.substring(to: index)
        // The string value of this Token is the text that matched
        self.stringValue = match

        let restOfInput = trimmedInput.substring(from: index)
        return restOfInput
    }
}

/// A Token subclass for parsing integers
class GRInteger : Token {
    init(){
        // parse integers
        super.init(regExpPattern: "-?[0-9]+")
    }
    override func parse(input:String) -> String? {
        let returnValue = super.parse(input: input)
        if let strVal = self.stringValue {
            // if a stringValue has been parsed, we should be able to record the integer value too
            self.calculatedValue = Int(strVal)
        }
        return returnValue
    }
}

/// A Token subclass for parsing specific string tokens
class GRLiteral : Token {
    /// literal is the string token we want this GRLiteral to match
    init(literal:String){
        super.init(regExpPattern: literal, options: NSRegularExpression.Options.ignoreMetacharacters )
    }
}

/// A Token subclass for parsing column labels
class GRColumnLabel : Token {
    init(){
        // Matches 1 or more capital letter (UpperAlphaString)
        super.init(regExpPattern: "([A-Z]+)")
    }
}

/// A Token subclass for parsing row numbers
class GRRowNumber : Token {
    init(){
        // Matches 1 or more integers greater than 0 (PositiveInteger)
        super.init(regExpPattern: "[1-9]+[0-9]*")
    }
}

// A Token subcladd for parsing strings
class GRStringNoQuote : Token {
    init(){
        // Matches a string with no single or double quotes (StringNoQuote)
        super.init(regExpPattern: "^[^\'\"]*$")
    }
}


