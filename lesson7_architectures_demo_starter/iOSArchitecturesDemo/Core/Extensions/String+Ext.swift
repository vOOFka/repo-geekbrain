//
//  String+Ext.swift
//  iOSArchitecturesDemo
//
//  Created by Home on 01.01.2022.
//  Copyright © 2022 ekireev. All rights reserved.
//

import Foundation

extension String {
    func convertDateFormat() -> String {
         let olDateFormatter = DateFormatter()
         olDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
         let oldDate = olDateFormatter.date(from: self)
         let convertDateFormatter = DateFormatter()
         convertDateFormatter.dateFormat = "MMM dd yyyy"
        
         return convertDateFormatter.string(from: oldDate!)
    }
}


