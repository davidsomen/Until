//
//  Style.swift
//  DaysUntil
//
//  Created by David Somen on 2018/04/19.
//  Copyright © 2018 David Somen. All rights reserved.
//

import UIKit

struct Style
{
    static var oddCellColor = UIColor(named: "Grey/500")
    static var evenCellColor = UIColor(named: "Grey/400")
    static var tableColor = UIColor(named: "Grey/600")
    static var selectedColor = UIColor(named: "Grey/800")
    
    static func themeOrange()
    {
        oddCellColor = UIColor(named: "Orange/500")
        evenCellColor = UIColor(named: "Orange/400")
        tableColor = UIColor(named: "Orange/600")
        selectedColor = UIColor(named: "Orange/800")
    }
    
    static func themeBlue()
    {
        oddCellColor = UIColor(named: "Blue/500")
        evenCellColor = UIColor(named: "Blue/400")
        tableColor = UIColor(named: "Blue/600")
        selectedColor = UIColor(named: "Blue/800")
    }
    
    static func themePurple()
    {
        oddCellColor = UIColor(named: "Purple/500")
        evenCellColor = UIColor(named: "Purple/400")
        tableColor = UIColor(named: "Purple/600")
        selectedColor = UIColor(named: "Purple/800")
    }
    
    static func themeGreen()
    {
        oddCellColor = UIColor(named: "Green/500")
        evenCellColor = UIColor(named: "Green/400")
        tableColor = UIColor(named: "Green/600")
        selectedColor = UIColor(named: "Green/800")
    }
}
