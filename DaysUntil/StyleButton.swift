//
//  StyleButton.swift
//  DaysUntil
//
//  Created by David Somen on 2018/04/24.
//  Copyright © 2018 David Somen. All rights reserved.
//

import UIKit

@IBDesignable
class StyleButton: UIButton
{
    @IBInspectable var highlightColor: UIColor = UIColor.gray
    @IBInspectable var nonHighlightColor: UIColor = UIColor.white
    {
        didSet
        {
            self.backgroundColor = nonHighlightColor
        }
    }
    
    override var isHighlighted: Bool
    {
        didSet
        {
            self.backgroundColor = isHighlighted ? highlightColor : nonHighlightColor
        }
    }
}
