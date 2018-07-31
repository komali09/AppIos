//
//  TutorialInteractor.swift
//  SegurosMtyiOS
//
//  Created by Erwin Perez Tellez on 02/12/17.
//  Copyright (c) 2017 IA Interactive. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

protocol TutorialBusinessLogic {
    func loadTutorial()
    func changedCurrentStep(currentStep: Tutorial.SwipeTutorial.Request)
}

protocol TutorialDataStore {
    var currentStep: Int { get set }
}

class TutorialInteractor: TutorialBusinessLogic, TutorialDataStore {
    var presenter: TutorialPresentationLogic?
    var worker: TutorialWorker?
    
    // MARK: DataStore
    var currentStep: Int = -1
    var steps: [StepView]?
    
    // MARK: functions
    
    func loadTutorial() {
        if steps != nil {
            return
        } else {
            self.steps = [StepView]()
        }
        
        worker = TutorialWorker()
        worker?.loadSteps(completionHandler: { (result) in
            let response = Tutorial.LoadTutorial.Response(steps: result.steps)
            
            for step in response.steps {
                self.steps?.append(step)
            }
            
            self.presenter?.presentStepsTutorial(response: response)
        })
    }
    
    func changedCurrentStep(currentStep: Tutorial.SwipeTutorial.Request) {
        if self.currentStep == currentStep.currentStep { return }
        self.currentStep = currentStep.currentStep
        
        self.steps![currentStep.currentStep].playAnimation()
        
        let response = Tutorial.SwipeTutorial.Response(currentStep: currentStep.currentStep)
        self.presenter?.presentStickForSteps(response: response)
    }
}
