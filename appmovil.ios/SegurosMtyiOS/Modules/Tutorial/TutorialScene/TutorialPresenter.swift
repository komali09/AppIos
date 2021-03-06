//
//  TutorialPresenter.swift
//  SegurosMtyiOS
//
//  Created by Erwin Perez Tellez on 02/12/17.
//  Copyright (c) 2017 IA Interactive. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol TutorialPresentationLogic {
    func presentStepsTutorial(response: Tutorial.LoadTutorial.Response)
    func presentStickForSteps(response: Tutorial.SwipeTutorial.Response)
}

class TutorialPresenter: TutorialPresentationLogic {
    weak var viewController: TutorialDisplayLogic?
    
    // MARK: Do something
    
    func presentStepsTutorial(response: Tutorial.LoadTutorial.Response) {
        let viewModel = Tutorial.LoadTutorial.ViewModel(steps: response.steps)
        viewController?.displayTutorial(viewModel: viewModel)
    }
    
    func presentStickForSteps(response: Tutorial.SwipeTutorial.Response) {
        var viewModel: Tutorial.SwipeTutorial.ViewModel?
        
        switch response.currentStep {
        case 0:
            viewModel = Tutorial.SwipeTutorial.ViewModel(firstTick: UIImage(named: "tickSelected")!, secondTick: UIImage(named: "tick")!, thirdTick: UIImage(named: "tick")!, titleCloseButton: "Omitir")
        case 1:
            viewModel = Tutorial.SwipeTutorial.ViewModel(firstTick: UIImage(named: "tickSelected")!, secondTick: UIImage(named: "tickSelected")!, thirdTick: UIImage(named: "tick")!, titleCloseButton: "Omitir")
        case 2:
            viewModel = Tutorial.SwipeTutorial.ViewModel(firstTick: UIImage(named: "tickSelected")!, secondTick: UIImage(named: "tickSelected")!, thirdTick: UIImage(named: "tickSelected")!, titleCloseButton: "Comenzar")
        default:
            break
        }
        
        viewController?.changedCurrentPage(viewModel: viewModel!)
    }
}
