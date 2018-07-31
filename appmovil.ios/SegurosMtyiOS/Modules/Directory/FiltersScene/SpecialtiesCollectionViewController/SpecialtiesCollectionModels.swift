//
//  SpecialtiesCollectionModels.swift
//  SegurosMtyiOS
//
//  Created by Erwin Jonnatan Perez Téllez on 19/12/17.
//  Copyright (c) 2017 IA Interactive. All rights reserved.
//

enum SpecialtiesCollection {

    enum GetSpecialties {
        struct Response {
            let specialtiesArray: [Specialty]!
        }
        struct ViewModel {
            let specialtiesArray: [Specialty]!
        }
    }
}
