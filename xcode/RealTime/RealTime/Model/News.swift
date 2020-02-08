//
//  NewsAPIStruct.swift
//  RealTime
//
//  Created by Spiro Mifsud on 2/8/20.
//  Copyright © 2020 Material Cause LLC. All rights reserved.
//

import Foundation

struct News: Decodable {
    let headlines: [Headlines]
}
