//
//  NSColor+Extension.swift
//  LaunchMultipleSimulators
//
//  Created by lifeng on 2019/3/31.
//  Copyright © 2019 Done. All rights reserved.
//

import Cocoa

extension NSColor {
    convenience init(_ hex: uint32, _ alpha: CGFloat = 1){
        let r = CGFloat(hex >> 16 & 0xff) / 255.0;
        let g = CGFloat(hex >>  8 & 0xff) / 255.0;
        let b = CGFloat(hex >>  0 & 0xff) / 255.0;
        self.init(red: r, green: g, blue: b, alpha: alpha);
    }
}
