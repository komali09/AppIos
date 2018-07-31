//
//  Step.swift
//  SegurosMtyiOS
//
//  Created by Erwin Perez Tellez on 02/12/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import UIKit
import Lottie

protocol StepViewProtocol {
    func playAnimation()
    func finishAnimation()
}

/*
 View donde se muestra un paso del tutorial.
*/
class StepView: IAUIView {
   
    /*
     View contenedor de la animación
     */
    @IBOutlet weak var containerAnimation: UIView!
    
    /*
     Label donde se visualiza el título del paso del tutorial
     */
    @IBOutlet weak var title: UILabel!
    
    /*
      Label donde se muestra la descripción del paso del tutorial
     */
    @IBOutlet weak var body: UILabel!
    
    /*
     Vista donde se carga la animación desde la librería Lottie
     */
    var animation: LOTAnimationView?
    
    /*
     Constructor de conveniencia donde se recibe la animación, título y body del paso del tutorial
     
     - Parameters:
     animation: view que contiene la animación a reproducir
     title: título del paso del tutorial
     body: descripción del paso del tutorial
     */
    init(frame: CGRect, animation: LOTAnimationView, title: String, body: String) {
        super.init(frame: frame)
        super.viewSetup()
        self.animation = animation
        setupUI(title: title, body: body)
    }
    
    required init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     Función que asigna y muestra los valores de la vista
     
     - Parameters:
     title: título del paso del tutorial
     body: descripción del paso del tutorial
     */
    private func setupUI(title: String, body: String) {
        self.title.text = title
        self.body.text = body
        
        animation?.frame = CGRect(x: 0, y: 0, width: self.containerAnimation.frame.width, height: self.containerAnimation.frame.height)
        
        var safeAreaHeight = 0
        var safeAreaWidth = 0
        if DeviceDetector.DeviceType.IS_IPHONE_5 {
            safeAreaHeight = 50
            safeAreaWidth = -25
        } else if DeviceDetector.DeviceType.IS_IPHONE_6_7_8 {
            safeAreaHeight = 90
        } else if DeviceDetector.DeviceType.IS_IPHONE_6P_7P_8P {
            safeAreaHeight = 110
            safeAreaWidth = 20
        } else if DeviceDetector.DeviceType.IS_IPHONE_X {
            safeAreaHeight = 80
        }
        
        animation?.center = CGPoint(x: (self.containerAnimation.frame.width / 2) + CGFloat(safeAreaWidth), y: (self.containerAnimation.frame.height / 2) + CGFloat(safeAreaHeight))
        animation?.clipsToBounds = false
        animation?.contentMode = UIViewContentMode.center
        animation?.loopAnimation = false
        self.containerAnimation.addSubview(animation!)
    }

}

extension StepView: StepViewProtocol {
    /*
     Función que inicia la reproducción de la animación
     */
    func playAnimation() {
        self.animation?.play(fromProgress: 0.0, toProgress: 0.5, withCompletion: nil)
    }
    
    /*
     Función que inicia la reproducción de la segunda parte de cada animación
     */
    func finishAnimation() {
        self.animation?.play(fromProgress: 0.5, toProgress: 1.0, withCompletion: nil)
    }
}
