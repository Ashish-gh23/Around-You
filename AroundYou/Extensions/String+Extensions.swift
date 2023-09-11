//
//  String+Extensions.swift
//  AroundYou
//
//  Created by Ashish Ranjan on 09/06/23.
//

import Foundation

extension String {
    var formatPhoneForCall: String {
        self.replacingOccurrences(of: " ", with: "")
        .replacingOccurrences(of: "-", with: "")
        .replacingOccurrences(of: "+", with: "")
        .replacingOccurrences(of: "(", with: "")
        .replacingOccurrences(of: ")", with: "")
    }
}
