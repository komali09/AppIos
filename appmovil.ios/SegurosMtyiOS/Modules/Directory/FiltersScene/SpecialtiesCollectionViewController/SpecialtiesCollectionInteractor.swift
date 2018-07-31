//
//  SpecialtiesCollectionInteractor.swift
//  SegurosMtyiOS
//
//  Created by Erwin Jonnatan Perez Téllez on 19/12/17.
//  Copyright (c) 2017 IA Interactive. All rights reserved.
//

protocol SpecialtiesCollectionBusinessLogic {
    func requestSpecialties()
}

protocol SpecialtiesCollectionDataStore {
}

class SpecialtiesCollectionInteractor: SpecialtiesCollectionBusinessLogic, SpecialtiesCollectionDataStore {
    var presenter: SpecialtiesCollectionPresentationLogic?
    var worker = SpecialtiesCollectionWorker()

    func requestSpecialties() {
        let array = worker.createDummySpecialties()
        let response = SpecialtiesCollection.GetSpecialties.Response(specialtiesArray: array)
        presenter?.presentSpecialties(response: response)
    }
}
