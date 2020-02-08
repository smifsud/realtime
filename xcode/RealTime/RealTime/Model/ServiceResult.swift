//
//  ServiceResult.swift
//  RealTime
//
//  Created by Spiro Mifsud on 2/8/20.
//  Copyright © 2020 Material Cause LLC. All rights reserved.
//

import Foundation

struct ServiceResult: Decodable {
    // necessary result items captured in the service result
    let headlines: [Headlines]
}
