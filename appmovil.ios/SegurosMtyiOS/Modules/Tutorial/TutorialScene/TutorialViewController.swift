//
//  TutorialViewController.swift
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

protocol TutorialDisplayLogic: class {
    func displayTutorial(viewModel: Tutorial.LoadTutorial.ViewModel)
    func changedCurrentPage(viewModel: Tutorial.SwipeTutorial.ViewModel)
}

class TutorialViewController: UIViewController, TutorialDisplayLogic {
    var interactor: TutorialBusinessLogic?
    var router: (NSObjectProtocol & TutorialRoutingLogic & TutorialDataPassing)?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var firstPage: UIImageView!
    @IBOutlet weak var secondPage: UIImageView!
    @IBOutlet weak var thirdPage: UIImageView!
    @IBOutlet weak var skip: UIButton!
    
    var numbersOfSteps: Int = 0
    var stepsViews: [StepView]?
    var isTutorialLoaded: Bool = false
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = TutorialInteractor()
        let presenter = TutorialPresenter()
        let router = TutorialRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        loadStepsTutorial()
    }
    
    // MARK: Actions
    
    func loadStepsTutorial() {
        
        if isTutorialLoaded { return }
        
        interactor?.loadTutorial()
        interactor?.changedCurrentStep(currentStep: Tutorial.SwipeTutorial.Request(currentStep: 0))
        isTutorialLoaded = true
    }
    
    func displayTutorial(viewModel: Tutorial.LoadTutorial.ViewModel) {
        if self.numbersOfSteps == 3 {
            return
        }
        
        for index in 0...2 {
            let stepView = viewModel.steps[index]
            stepView.frame = CGRect(x: CGFloat(Int(self.scrollView.frame.width) * index), y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
            self.stepsViews?.append(stepView)
            self.numbersOfSteps = self.numbersOfSteps + 1
            self.scrollView.addSubview(stepView)
        }
        
        self.scrollView.contentSize = CGSize(width: CGFloat(Int(self.scrollView.frame.width) * viewModel.steps.count), height: self.scrollView.frame.height)
    }
    
    func changedCurrentPage(viewModel: Tutorial.SwipeTutorial.ViewModel) {
        self.firstPage.image = viewModel.firstTick
        self.secondPage.image = viewModel.secondTick
        self.thirdPage.image = viewModel.thirdTick
        self.skip.setTitle(viewModel.titleCloseButton, for: .normal)
    }
    
    @IBAction func skipPressed(_ sender: Any) {
        UserDefaultsManager.shared.isTutorialShown = true
        self.router?.goToWelcomeViewController(segue: nil)
    }
}

// MARK: UIScrollView Delegate
extension TutorialViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth : CGFloat = self.scrollView.frame.size.width
        let offsetLooping = 1
        let step : Int = Int (floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth)) + offsetLooping
        let request = Tutorial.SwipeTutorial.Request(currentStep: step)
        interactor?.changedCurrentStep(currentStep: request)
    }
}