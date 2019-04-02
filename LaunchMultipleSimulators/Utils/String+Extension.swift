//
//  String+Extension.swift
//  LaunchMultipleSimulators
//
//  Created by lifeng on 2019/4/1.
//  Copyright © 2019 Done. All rights reserved.
//

import Cocoa

extension String {
    func trimming(_ characters: String) -> String {
        return trimmingCharacters(in: CharacterSet(charactersIn: characters));
    }
}
