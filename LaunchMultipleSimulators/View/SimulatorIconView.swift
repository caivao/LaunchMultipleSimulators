//
//  SimulatorIconView.swift
//  LaunchMultipleSimulators
//
//  Created by lifeng on 2019/3/29.
//  Copyright © 2019 Done. All rights reserved.
//

import Cocoa

class SimulatorIconView: NSImageView {
    
    var app: App? = nil {
        didSet{
            guard let app = self.app else { return; }
            self.image = app.appIconBig;
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib();
        wantsLayer = true;
        layer?.cornerRadius = 10;
    }
    
    override func mouseDown(with event: NSEvent) {
        guard let action = action, let target = target else {
            return;
        }
        NSApp.sendAction(action, to: target, from: self);
    }
}
