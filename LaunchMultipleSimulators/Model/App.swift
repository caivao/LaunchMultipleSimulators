//
//  App.swift
//  LaunchMultipleSimulators
//
//  Created by lifeng on 2019/3/31.
//  Copyright © 2019 Done. All rights reserved.
//

import Cocoa

struct App: Equatable {
    var bundleIdentifier: String = "";
    var appName: String = "";
    var appPath: String = "";
    var appVersion: String = "";
    var displayName: String = "";
    var appIcon: NSImage? = nil;
    var appIconBig: NSImage? = nil;
    var isDebug: Bool = true;
    
    static func load(from appPath: [String] = []) -> [App] {
        let apps: [App] = appPath.map{ App($0); }
            .compactMap{ $0; };
        return apps;
    }
    
    init?(_ appPath: String) {
        if appPath.isEmpty { return nil; }
        let infoPlistPath = appPath + "/info.plist";
        guard let info = NSDictionary.init(contentsOfFile: infoPlistPath) as? [String: Any]
            else { return nil; }
        guard let bundleIdentifier = info["CFBundleIdentifier"] as? String,
            bundleIdentifier != "$(PRODUCT_BUNDLE_IDENTIFIER)"
            else { return nil; }
        self.bundleIdentifier = bundleIdentifier;
        self.appPath = appPath;
        isDebug = appPath.lowercased().contains("debug");
        displayName = (info["CFBundleDisplayName"] as? String) ?? "";
        appVersion = (info["CFBundleVersion"] as? String) ?? "";
        appName = ((info["CFBundleName"] as? String) ?? "");
        setupIcon(true);
        setupIcon(false);
    }
    
    mutating func setupIcon(_ big: Bool = false) {
        let size = big ? "60x60" : "40x40";
        let appIconName3x = "AppIcon\(size)@3x.png";
        let appIconName2x = "AppIcon\(size)@2x.png";
        let appIconName   = "AppIcon\(size)0.png";
        var image = preferImage([appPath + "/" + appIconName3x,
                                 appPath + "/" + appIconName2x,
                                 appPath + "/" + appIconName]);
        if(image == nil) {
            image = NSImage(named: "icon");
        }
        if(big) {
            self.appIconBig = image;
        } else {
            self.appIcon = image;
        }
    }
}

func preferImage(_ imagePaths: [String]) -> NSImage? {
    for path in imagePaths {
        let image = NSImage(contentsOfFile: path);
        if(image != nil) { return image; }
    }
    return nil;
}
