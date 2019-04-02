//
//  AppListItemView.swift
//  LaunchMultipleSimulators
//
//  Created by lifeng on 2019/4/1.
//  Copyright © 2019 Done. All rights reserved.
//

import Cocoa

class AppListItemView: NSView {
    
    @IBOutlet weak var radioBoxButton: NSButton!
    @IBOutlet weak var iconImageView: NSImageView!
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var subtitleLabel: NSTextField!
    @IBOutlet weak var showInFinderButton: NSButton!
    
    var didSelectedBlock: (AppListItemView) -> () = {_ in};
    
    var app: App? = nil {
        didSet{
            guard let app = self.app else { return; }
            iconImageView.image = app.appIcon;
            titleLabel.stringValue = app.appName + (app.isDebug ? " (Debug)" : " (Release)");
            subtitleLabel.stringValue = app.appPath;
        }
    }
    
    var selected: Bool = false{
        didSet{
            radioBoxButton.state = (selected ? .on : .off);
            if(selected) { didSelectedBlock(self); }
        }
    }
    
    static func loadFromNib() -> AppListItemView {
        var array: NSArray? = nil;
        Bundle.main.loadNibNamed(NSNib.Name("AppListItemView"), owner: nil, topLevelObjects: &array);
        let result = array?.filter{ $0 is AppListItemView; }
        return result?.first as! AppListItemView;
    }
    
    override func awakeFromNib() {
        super.awakeFromNib();
        wantsLayer = true;
        layer?.backgroundColor = NSColor.white.cgColor;
        
        iconImageView.wantsLayer = true;
        iconImageView.layer?.cornerRadius = 5;
    }
    
    @IBAction func radioBoxAction(_ sender: Any) {
        didSelected();
    }
    
    @IBAction func showInFinderAction(_ sender: NSButton) {
    }
    
    override func mouseDown(with event: NSEvent) {
        didSelected();
    }
    
    func didSelected() {
        selected = true;
    }
}
