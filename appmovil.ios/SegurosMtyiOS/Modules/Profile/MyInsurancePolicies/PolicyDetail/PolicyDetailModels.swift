//
//  PolicyDetailModels.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 1/8/18.
//  Copyright (c) 2018 IA Interactive. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

enum PolicyDetail {
    // MARK: Use cases
    
    enum loadPolicyDetail {
        struct ViewModel {
            var expDate: String
            var name: String
            var planName: String
            var number: String
            var certificateId: String?
            var cardId: PolicyCardType
            var planForm: PolicyType
            var isFavHidden: Bool
            var items: [PolicyDetailInfoDataItem?]
        }
    }
    enum loadRemotePolicyDetail {
        struct ViewModel {
            var isTitular: Bool
            var items: [PolicyDetailInfoDataItem?]
            var copaymentParticipationItems: [PolicyCopaymentParticipationData]?
        }
    }
    
    enum PolicyBeneficiaries {
        struct ViewModel {
            var items: [BeneficiarieDataItem?]
        }
    }
    
    enum PolicyCoverages {
        struct ViewModel {
            var items: [Coverage]
        }
    }
    
    enum BeneficiaresToWallet {
        struct ViewModel {
            var items: [Beneficiarie]
        }
    }
}