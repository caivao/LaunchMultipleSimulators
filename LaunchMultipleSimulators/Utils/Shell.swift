//
//  Shell.swift
//  LaunchMultipleSimulators
//
//  Created by lifeng on 2019/3/29.
//  Copyright © 2019 Done. All rights reserved.
//

import Cocoa

@discardableResult
func excuteShell(scriptName: String, argv: [String] = [], shell: String = "/bin/sh") -> String? {
    guard let scriptPath = Bundle.main.path(forResource: scriptName, ofType: nil) else { return nil; }
    return excuteShell(scriptPath: scriptPath, argv: argv);
}

@discardableResult
func excuteShell(scriptPath: String, argv: [String] = [], shell: String = "/bin/sh") -> String? {
    var argv = argv;
    argv.insert(scriptPath, at: 0);
    return excuteShell(launchPath: shell, arguments: argv);
}

@discardableResult
func excuteShell(launchPath: String = "/usr/bin/env", arguments: [String] = []) -> String? {
    let task = Process();
    task.launchPath = launchPath;
    task.arguments = arguments;
    
    let pipe = Pipe();
    task.standardOutput = pipe;
    task.launch();
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile();
    return String(data: data, encoding: String.Encoding.utf8);
}
