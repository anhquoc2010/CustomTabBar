//
//  CustomTabBar.swift
//  DemoCustomTabBar
//
//  Created by QuocLA on 05/06/2024.
//

import UIKit

class CustomTabBar: UITabBar {
    private var shapeLayer: CALayer?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        addShape()
    }
    
    private func addShape() {
        let shapeLayer = CAShapeLayer()
        
        if let oldShapeLayer = self.shapeLayer {
            layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            layer.insertSublayer(shapeLayer, at: 0)
        }
        
        self.shapeLayer = shapeLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var tabFrame = self.frame
        tabFrame.size.height = 100
        tabFrame.origin.y = self.frame.origin.y + self.frame.height - 100
        self.frame = tabFrame
    }
}
