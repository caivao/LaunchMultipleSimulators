//
//  AppListView.swift
//  LaunchMultipleSimulators
//
//  Created by lifeng on 2019/4/1.
//  Copyright © 2019 Done. All rights reserved.
//

import Cocoa

class AppListView: NSView {
    
    var apps: [App] = [];
    var selectedApp: App? = nil;
    var selectedAppTmp: App? = nil;
    var didSelectedApp: (App?) -> () = { _ in };
    
    var currentSelectedItem: AppListItemView? = nil;
    
    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet weak var cancelButton: NSButton!
    @IBOutlet weak var selectedButton: NSButton!
    @IBOutlet weak var contentView: NSView!
    @IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentWidthConstraint: NSLayoutConstraint!
    
    static func loadFromNib() -> AppListView {
        var array: NSArray? = nil;
        Bundle.main.loadNibNamed(NSNib.Name("AppListView"), owner: nil, topLevelObjects: &array);
        let result = array?.filter{ $0 is AppListView; }
        return result?.first as! AppListView;
    }
    
    override func awakeFromNib() {
        super.awakeFromNib();
        setupLayer();
    }
    
    @IBAction func cancelAction(_ sender: NSButton) {
        hide();
    }
    
    @IBAction func selectedAction(_ sender: NSButton) {
        selectedApp = selectedAppTmp;
        didSelectedApp(selectedApp);
        hide();
    }
    
    private func setupLayer() {
        wantsLayer = true;
        layer?.backgroundColor = NSColor(0xf1f1f1, 0.6).cgColor;
        
        contentView.wantsLayer = true;
        contentView.layer?.backgroundColor = NSColor.white.cgColor;
        contentView.layer?.cornerRadius = 4;
        contentView.layer?.borderWidth = 1;
        contentView.layer?.borderColor =  NSColor(0xf0f0f0).cgColor;
    }
    
    func reload(_ apps: [App], _ maxSize: CGSize) {
        scrollView.documentView = nil;
        self.apps = apps;
        if(apps.isEmpty) {
            selectedApp = nil;
            return;
        }
        
        selectedAppTmp = apps.first;
        
        let width = maxSize.width;
        let height: CGFloat = 50;
        let contentView = ListContentView();
        let contentViewWidth = width;
        let contentViewHeight = height * CGFloat(apps.count);
        contentView.frame = CGRect(x: 0, y: 0, width: contentViewWidth, height: contentViewHeight);
        apps.enumerated().forEach { (offset, app) in
            let frame = CGRect(x: 0, y: height * CGFloat(offset), width: width, height: height);
            let item = AppListItemView.loadFromNib();
            item.frame = frame;
            item.app = app;
            item.radioBoxButton.tag = offset;
            item.didSelectedBlock = {
                self.willSelectedApp($0);
            };
            if(app == selectedAppTmp) {
                self.currentSelectedItem = item;
            }
            item.selected = (app == selectedAppTmp);
            contentView.addSubview(item);
        }
        
        scrollView.documentView = contentView;
        scrollView.scroll(CGPoint(x: 0, y: contentViewHeight));
        contentWidthConstraint.constant = width + 2;
        contentHeightConstraint.constant = min(maxSize.height, contentViewHeight + 40 + 2 + 26);
    }
    
    func willSelectedApp(_ sender: AppListItemView) {
        if sender == currentSelectedItem { return; }
        currentSelectedItem?.selected = false;
        currentSelectedItem = sender;
        currentSelectedItem?.selected = true;
        selectedAppTmp = apps[sender.radioBoxButton.tag];
    }
    
    func show(inView: NSView) {
        NSAnimationContext.current.allowsImplicitAnimation = false;
        frame = inView.bounds;
        if(superview == nil) {
            inView.addSubview(self);
        }
        animator().isHidden = false;
    }
    
    func hide() {
        selectedAppTmp = nil;
        selectedApp = nil;
        animator().isHidden = true;
    }
}
