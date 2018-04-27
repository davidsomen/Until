//
//  ScrollViewWithButtons.swift
//  DaysUntil
//
//  Created by David Somen on 2018/04/24.
//  Copyright © 2018 David Somen. All rights reserved.
//

import UIKit

class ScrollViewWithButtons: UIScrollView
{
    override func touchesShouldCancel(in view: UIView) -> Bool
    {
        return view is UIButton ? true : super.touchesShouldCancel(in: view)
    }
}
