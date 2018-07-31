//
//  IAPopupViewController.swift
//  SegurosMtyiOS
//
//  Created by Erwin Perez Tellez on 07/01/18.
//  Copyright © 2018 IA Interactive. All rights reserved.
//
import UIKit

/** 
 Asignar un nombre a un closure default
*/
typealias completion = (() -> Void)?

/** 
 Clase donde se agregan las animaciones y comportamiento de todas las alertas de la aplicación
 */
class IAPopupViewController: UIViewController {
    var blurEffectView:UIVisualEffectView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        super.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        super.modalPresentationStyle = .overFullScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGestureToCloseView()
        setupUI()
    }
    
    /** 
     Método que oculta el navigationbar antes de aparecer la vista
     */
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    /** 
        Método que asigna el color y la opacidad a las vistas
     */
    internal func setupUI() {
        self.view.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: .light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectView)
        self.view.sendSubview(toBack: blurEffectView)
    }
    
    /** 
     Método que agrega una vista con un TapGesture para ocultarse así misma.
     */
    private func addTapGestureToCloseView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(IAPopupViewController.handleTap(_:)))
        let viewTap = UIView(frame: self.view.frame)
        viewTap.addGestureRecognizer(tap)
        viewTap.isUserInteractionEnabled = true
        self.view.addSubview(viewTap)
        self.view.sendSubview(toBack: viewTap)
    }
    
    /** 
     Método que detecta tap sobre si misma para ocultar la vista
     */
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        hideAnimate()
    }
    
    /** 
        Método que inicia la animación de entrada a la vista
     */
    internal func show() {
        showAnimate()
    }
    
    /** 
     Método que inicia la animación de la vista
     Return: closure cuando términa la animación de salida
     */
    internal func close(completion completionHandler: completion) {
        hideAnimate(completionHandler: completionHandler)
    }
    
    /** 
        Método que realiza la animación de entrada de la vista
     */
    private func showAnimate() {
        self.view.transform.scaledBy(x: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25) {
            self.view.alpha = 1.0
            self.view.transform.scaledBy(x: 1.0, y: 1.0)
        }
    }
    
    /** 
     Método que realiza la animación de salida de la vista
     */
    private func hideAnimate(completionHandler: completion = nil) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25, animations: {
                self.view.transform.scaledBy(x: 1.3, y: 1.3)
                self.view.alpha = 0.0
            }, completion: { (finished : Bool) in
                if finished {
                    if let completion = completionHandler {
                        completion()
                    } else {
                        self.dismiss(animated: false, completion: nil)
                    }
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
