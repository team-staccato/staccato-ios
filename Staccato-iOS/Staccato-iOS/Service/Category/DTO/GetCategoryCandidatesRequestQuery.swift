//
//  GetCategoriesCandidatesRequestQuery.swift
//  Staccato-iOS
//
//  Created by 김유림 on 5/31/25.
//

import Foundation

struct GetCategoryCandidatesRequestQuery: Encodable {

    let specificDate: String

    let isPrivate: Bool?

}
