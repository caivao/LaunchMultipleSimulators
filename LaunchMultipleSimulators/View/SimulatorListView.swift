//
//  SimulatorListView.swift
//  LaunchMultipleSimulators
//
//  Created by lifeng on 2019/3/31.
//  Copyright © 2019 Done. All rights reserved.
//

import Cocoa

protocol SimulatorListDelegate: NSObject {
    
    func didSelectedSimulators(_ simulators: [Simulator]);
    func didFinishReloadSimulators(_ simulators:[ Simulator]);
}

class SimulatorListView: NSView {
    
    lazy var scrollView: NSScrollView = {
        let scrollView = NSScrollView();
        addSubview(scrollView);
        return scrollView;
    }();
    
    weak var delegate: SimulatorListDelegate? = nil;
    var simulators:[Simulator] = [];
    var selectedSimulators: [Simulator] = [];
    
    override func awakeFromNib() {
        super.awakeFromNib();
        wantsLayer = true;
        layer?.cornerRadius = 4;
        layer?.borderWidth = 1;
        layer?.borderColor =  NSColor(0xf0f0f0).cgColor;
        
        scrollView.scrollerStyle = .overlay
    }
    
    override func layout() {
        super.layout();
        scrollView.frame = bounds;
    }
    
    func fetchAllSimulators() {
        Simulator.allSimulator{
            self.simulators = $0;
            self.delegate?.didFinishReloadSimulators($0);
            self.reloadSimulators();
        };
    }
    
    func reloadSimulators() {
        scrollView.documentView = nil;
        if(simulators.isEmpty) {
            selectedSimulators.removeAll();
            return;
        }
        
        var selectedSimulatorsTmp: [Simulator] = [];
        let height: CGFloat  = 18;
        let padding: CGFloat = 10;
        let width = frame.width;
        
        let contentView = ListContentView();
        var contentFrame = contentView.frame;
        contentFrame.origin.y = 0;
        contentFrame.size.height = (height + padding) * CGFloat(simulators.count) + padding;
        contentFrame.size.width = width;
        contentView.frame = contentFrame;
        
        simulators.enumerated().forEach{ (offset, simulator) in
            let checkBoxButton = NSButton();
            checkBoxButton.frame = NSRect(x: 0, y: CGFloat(offset) * (height + padding) + padding, width: width, height: height);
            checkBoxButton.setButtonType(.switch);
            checkBoxButton.title = simulator.debugName;
            contentView.addSubview(checkBoxButton);
            checkBoxButton.target = self;
            checkBoxButton.action = #selector(checkBoxAction(_:));
            checkBoxButton.tag = offset;
            if(selectedSimulators.contains(simulator)) {
                checkBoxButton.state = NSButton.StateValue(1);
                selectedSimulatorsTmp.append(simulator);
            }
        }
        
        selectedSimulators.removeAll();
        selectedSimulators.append(contentsOf: selectedSimulatorsTmp);
        delegate?.didSelectedSimulators(selectedSimulators);
        
        scrollView.documentView = contentView;
        scrollView.scroll(CGPoint(x: 0, y: contentView.frame.height));
    }
    
    @objc func checkBoxAction(_ checkBox: NSButton) {
        let clickSimulator = simulators[checkBox.tag];
        if(checkBox.state == .on) { // 选中
            if(!selectedSimulators.contains(clickSimulator)) {
                selectedSimulators.append(clickSimulator);
            }
        } else { // 移除
            selectedSimulators.removeAll { $0.identifier == clickSimulator.identifier; }
        }
        delegate?.didSelectedSimulators(selectedSimulators);
    }
    
    func run(_ app: App?, _ closeAllSimulatorsBeforeRun: Bool = false) {
        guard let app = app else { return; }
        if(!selectedSimulators.isEmpty &&
            closeAllSimulatorsBeforeRun) {
            excuteShell(scriptName: "CloseAllSimulators.sh");
        }
        
        selectedSimulators.forEach { (simulator) in
            DispatchQueue.global().async {
                simulator.run(app: app);
            }
        }
    }
}
