//
//  NSRangeExtension.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 16/6/3.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import Foundation

//扩展NSRange，让swift的string能使用stringByReplacingCharactersInRange
extension NSRange {
    func toRange(_ string: String) -> Range<String.Index> {
        let startIndex = string.characters.index(string.startIndex, offsetBy: self.location)
        let endIndex = <#T##String.CharacterView corresponding to `startIndex`##String.CharacterView#>.index(startIndex, offsetBy: self.length)
        return startIndex..<endIndex
    }
}
