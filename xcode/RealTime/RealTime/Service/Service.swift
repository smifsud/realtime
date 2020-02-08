//
//  Service.swift
//  RealTime
//
//  Created by Spiro Mifsud on 2/8/20.
//  Copyright © 2020 Material Cause LLC. All rights reserved.
//

import Foundation

class Service {
    
    static let shared = Service() // singleton
    
    func getHeadlines(token: String, completion: @escaping ([Headlines], Error?) -> Void) {
        let urlString = "http://localhost:3000/headlines/?token=" + token
         guard let url = URL(string: urlString) else {return}
       
        URLSession.shared.dataTask(with: url) { (data, _, err) in
        if let err = err {
            print("Failed to fetch apps:", err)
            completion([], nil)
            return
        }
        // success
        guard let data = data else { return }
        do {
            let serviceResult = try JSONDecoder().decode(ServiceResult.self, from: data)
            completion(serviceResult.headlines, nil)
        } catch let jsonErr {
            print("Failed to decode json:", jsonErr)
            completion([], jsonErr)
            }
        }.resume() // request triggered
    }
}
