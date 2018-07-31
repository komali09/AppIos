//
//  SpecialtiesCollectionRouter.swift
//  SegurosMtyiOS
//
//  Created by Erwin Jonnatan Perez Téllez on 19/12/17.
//  Copyright (c) 2017 IA Interactive. All rights reserved.
//

import UIKit

@objc protocol SpecialtiesCollectionRoutingLogic {
    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol SpecialtiesCollectionDataPassing {
    var dataStore: SpecialtiesCollectionDataStore? { get set }
}

class SpecialtiesCollectionRouter: NSObject, SpecialtiesCollectionRoutingLogic, SpecialtiesCollectionDataPassing {
    weak var viewController: SpecialtiesCollectionViewController?
    var dataStore: SpecialtiesCollectionDataStore?
}
