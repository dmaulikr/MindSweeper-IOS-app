//
//  NumberView.swift
//  MineSweeper
//
//  Created by Eugene Rivera on 2/26/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class NumberView: UIView {
    
    
    override func draw(_ rect: CGRect) {
        let bpath:UIBezierPath = UIBezierPath(rect: rect)
        UIColor.orange.setFill()
        bpath.fill()
        bpath.stroke()
    }
    
}
