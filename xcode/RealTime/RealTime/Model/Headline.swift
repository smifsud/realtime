//
//  Headline.swift
//  RealTime
//
//  Created by Spiro Mifsud on 2/8/20.
//  Copyright © 2020 Material Cause LLC. All rights reserved.
//

import Foundation

struct Headlines: Decodable {
    let newsgroupID: Int
    let newsgroup: String
    let headline: String
}
