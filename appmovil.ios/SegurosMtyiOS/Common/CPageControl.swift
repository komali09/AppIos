//
//  CPageControl.swift
//  SegurosMtyiOS
//
//  Created by Rafael Jimeno Osornio on 12/6/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import UIKit

enum PageControlStyle: Int {
    case allFilled = 0
    case fillSelected
    case fillUnselected
    case noneFilled
}

class CPageControl: UIView {

    var selectedPage = 0
    
    var selectedColor: UIColor? {
        didSet {
            configStyle()
        }
    }
    
    var unselectedColor: UIColor? {
        didSet {
            configStyle()
        }
    }
    
    var style: PageControlStyle = .allFilled {
        didSet {
            configStyle()
        }
    }
    
    private var numberOfPages = 0
    private var yPos: CGFloat = 0
    private var dots = [UIView]()
    private var selectedDot: UIView?
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(yPosition: CGFloat, numberOf pages: Int) {
        super.init(frame: CGRect.zero)
        
        numberOfPages = pages
        yPos = yPosition
        config()
    }
    
    //MARK: Private
    private func config() {
        let screen = UIScreen.main.bounds
        let gap: CGFloat = 16
        let diam: CGFloat = (screen.width * 0.0265).rounded(.down)
        let width = CGFloat(numberOfPages) * (diam + gap)
        let height: CGFloat = 30
        
        frame = CGRect(x: (screen.width - width) / 2 , y: yPos, width: width, height: height)
        
        var xPos: CGFloat = 0
        for _ in 0..<numberOfPages {
            let circle = UIView(frame: CGRect(x: xPos, y: yPos, width: diam, height: diam))
            circle.layer.cornerRadius = diam / 2
            addSubview(circle)
            dots.append(circle)
            
            xPos += diam + gap
        }
    }
    
    private func configStyle() {
        switch style {
        case .allFilled:
            for (index, circle) in dots.enumerated() {
                if index != selectedPage {
                    circle.backgroundColor = unselectedColor
                    
                } else {
                    circle.backgroundColor = selectedColor
                }
            }
            
        case .fillSelected:
            for (index, circle) in dots.enumerated() {
                if index != selectedPage {
                    circle.backgroundColor = UIColor.white
                    circle.layer.borderColor = unselectedColor?.cgColor
                    circle.layer.borderWidth = 1
                    
                } else {
                    circle.backgroundColor = selectedColor
                }
            }
            
        case .fillUnselected:
            for (index, circle) in dots.enumerated() {
                if index > selectedPage {
                    circle.backgroundColor = unselectedColor
                } else {
                    circle.backgroundColor = selectedColor
                }
            }
            
        case .noneFilled:
            for (index, circle) in dots.enumerated() {
                if index != selectedPage {
                    circle.backgroundColor = UIColor.white
                    circle.layer.borderColor = unselectedColor?.cgColor
                    circle.layer.borderWidth = 1
                    
                } else {
                    circle.backgroundColor = UIColor.white
                    circle.layer.borderColor = selectedColor?.cgColor
                    circle.layer.borderWidth = 1
                }
            }
        }
    }
    
    //MARK: Public
    func selectPageAt(index: Int) {
        selectedPage = index
        configStyle()
    }
}
