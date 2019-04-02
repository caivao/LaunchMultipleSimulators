//
//  Simulator.swift
//  LaunchMultipleSimulators
//
//  Created by lifeng on 2019/3/29.
//  Copyright © 2019 Done. All rights reserved.
//

import Cocoa

struct Simulator : Equatable {
    
    enum Style {
        case simulator;
        case mac;
        case realMachine;
    }
    
    var nickName: String = "";
    var debugName: String = "";
    var identifier: String = "";
    var style: Simulator.Style = .simulator;
    
    init(_ nickName: String = "",
         _ debugName: String = "",
         _ identifier: String = "",
         _ style: Simulator.Style = .simulator) {
        self.nickName = nickName;
        self.debugName = debugName;
        self.identifier = identifier;
        self.style = style;
    }
    
    static func allSimulator(_ callback: (([Simulator]) -> ())?) {
        DispatchQueue.global().async {
            let simulators: [Simulator] = fetchAllSimulators();
            DispatchQueue.main.async {
                callback?(simulators);
            }
        }
    }
    
    @discardableResult
    func run(app: App) -> String? {
        return runSimulator(identifier, app: app);
    }
    
    static func == (lhs: Simulator, rhs: Simulator) -> Bool {
        return lhs.identifier == rhs.identifier;
    }
}

func runSimulator(_ simulator: String, app: App) -> String? {
    let appPath = app.appPath;
    let bundleIdentifier = app.bundleIdentifier;
    let result = excuteShell(scriptName: "RunSimulators.sh", argv: [simulator, appPath, bundleIdentifier]);
    return result;
}

func fetchAllSimulators() -> [Simulator] {
    guard let result = excuteShell(scriptName: "AllSimulators.sh") else { return []; }
    let trimResult = result.trimmingCharacters(in: CharacterSet.init(charactersIn: " "));
    var metaSimulators: [String] = trimResult.components(separatedBy: "\n");
    metaSimulators = metaSimulators.filter { metaString in
        return metaString.contains("[");
    }
    return metaSimulators.map { metaString in
        var simulator = Simulator();
        let debugNameSeparate = metaString.components(separatedBy: " [");
        let identifierSeparate = debugNameSeparate.last!.components(separatedBy: "] ");
        simulator.debugName = debugNameSeparate.first!;
        simulator.identifier = identifierSeparate.first!;
        return simulator;
    }
}
