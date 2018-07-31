//
//  SpecialtiesCollectionWorker.swift
//  SegurosMtyiOS
//
//  Created by Erwin Jonnatan Perez Téllez on 19/12/17.
//  Copyright (c) 2017 IA Interactive. All rights reserved.
//

class SpecialtiesCollectionWorker {

    func createDummySpecialties() -> [Specialty] {
        let specialtiesName = ["Cardiología", "Anatomía Patológica", "Anestesiología", "Bariatría", "Oncología", "Reumatología"]
        var specArray = [Specialty]()
        for index in 0 ..< specialtiesName.count {
            specArray.append(Specialty(id: index + 1, name: specialtiesName[index]))
        }
        return specArray
    }
}
