//
//  SpecialtiesCollectionPresenter.swift
//  SegurosMtyiOS
//
//  Created by Erwin Jonnatan Perez Téllez on 19/12/17.
//  Copyright (c) 2017 IA Interactive. All rights reserved.
//

protocol SpecialtiesCollectionPresentationLogic {
    func presentSpecialties(response: SpecialtiesCollection.GetSpecialties.Response)
}

class SpecialtiesCollectionPresenter: SpecialtiesCollectionPresentationLogic {
    weak var viewController: SpecialtiesCollectionDisplayLogic?

    func presentSpecialties(response: SpecialtiesCollection.GetSpecialties.Response) {
        let viewModel = SpecialtiesCollection.GetSpecialties.ViewModel(specialtiesArray: response.specialtiesArray)
        viewController?.displaySpecialties(viewModel: viewModel)
    }
}
