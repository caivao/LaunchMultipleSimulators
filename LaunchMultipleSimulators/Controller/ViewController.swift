//
//  ViewController.swift
//  LaunchMultipleSimulators
//
//  Created by lifeng on 2019/3/29.
//  Copyright © 2019 Done. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var simulatorContentView: SimulatorListView!
    @IBOutlet weak var appIconImageView: SimulatorIconView!;
    @IBOutlet weak var reloadSimulatorButton: NSButton!;
    @IBOutlet weak var runSimulatorButton: NSButton!;
    @IBOutlet weak var appPathTextfield: NSTextField!;
    @IBOutlet weak var closeAllSimulatorsBeforeRestartButton: NSButton!
    @IBOutlet weak var dragDropView: DragFileView!
    
    var simulators: [Simulator] = [];
    var selectedSimulators: [Simulator] = [];
    var app: App? = nil;
    
    lazy var openPanel: NSOpenPanel = {
        let openPanel = NSOpenPanel();
        openPanel.allowsMultipleSelection = false;
        openPanel.canChooseDirectories = true;
        openPanel.canChooseFiles = false;
        openPanel.allowedFileTypes = ["app"];
        openPanel.allowsOtherFileTypes = false;
        openPanel.prompt = "打开";
        return openPanel;
    }();
    
    lazy var appSelectedView: AppListView = {
        let appSelectedView = AppListView.loadFromNib();
        appSelectedView.didSelectedApp = {
            self.didPickupApp($0);
        }
        return appSelectedView;
    }();

    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true;
        view.layer?.backgroundColor = NSColor.white.cgColor;
        setupDelegate();
        simulatorContentView.fetchAllSimulators();
    }
    
    // MARK: - IBAction
    // MARK: - 点击 app 图标 选择应用要 debug 的应用程序
    @IBAction func selectedAppAction(_ sender: Any) {
        if openPanel.runModal() == .OK {
            guard let appURL = openPanel.urls.first else { return; }
            pickupApp(projectPath: appURL.absoluteString);
        }
    }
    
    // MARK: - 点击运行按钮
    @IBAction func runAppAction(_ sender: NSButton) {
        simulatorContentView.run(app, closeAllSimulatorsBeforeRestartButton.state.rawValue == 1);
    }
    
    // MARK: - 点击重新加载模拟器按钮
    @IBAction func reloadSimulatorsAction(_ sender: NSButton) {
        reloadSimulatorButton.isEnabled = false;
        runSimulatorButton.isEnabled = false;
        simulatorContentView.fetchAllSimulators();
    }
    
    func didPickupApp(_ app: App?) {
        guard let app = app else { return; }
        self.app = app;
        updateAppIcon();
        appPathTextfield.stringValue = app.appPath;
    }
    
    /// 项目路径, 默认使用 *.xcodeproj 的文件名做为 app 的名称
    /// 产品名称, 默认产品名和 app 的名一样
    func pickupApp(projectPath: String) {
        var apps: [App] = [];
        defer { preferApp(apps); }
        
        let path = projectPath.trimming("\n ");
        
        if(path.contains(".app")) {
            let appPaths: [String] = path.components(separatedBy: " ");
            apps = App.load(from: appPaths);
            return;
        }
        
        var projectName: String = path;
        if(path.contains("/")) {
            /// 项目路径, 拆解出项目名
            let result = excuteShell(scriptName: "FindProjectNameByProjectPath.sh", argv: [path]);
            if(result != nil) {
                projectName = result!.trimming("\n ");
            }
        }
        /// 其他情况均认为是项目名称
        let result = excuteShell(scriptName: "FindAppByProjectName.sh", argv: [projectName, projectName]);
        guard var appPathString = result else { return ; }
        appPathString = appPathString.trimming("\n ");
        let appPaths: [String] = appPathString.components(separatedBy: " ");
        apps = App.load(from: appPaths);
    }
    
    func preferApp(_ apps: [App]) {
        if(apps.count <= 1) {
            didPickupApp(apps.first);
            return;
        }
        appSelectedView.reload(apps, CGSize(width: view.frame.width * 0.8, height: view.frame.height));
        appSelectedView.show(inView: view);
    }
    
    private func setupDelegate() {
        appPathTextfield.delegate = self;
        dragDropView.delegate = self;
        simulatorContentView.delegate = self;
    }
    
    func updateAppIcon() {
        appIconImageView.app = self.app;
    }
}

extension ViewController : NSTextFieldDelegate {
    func controlTextDidEndEditing(_ obj: Notification) {
        let filePath = appPathTextfield.stringValue;
        guard !filePath.isEmpty else {
            return;
        }
        pickupApp(projectPath: filePath);
    }
}

extension ViewController: DragFileDelegate {
    func didFinishDrag(_ filePath: String) {
        pickupApp(projectPath: filePath);
    }
}

extension ViewController: SimulatorListDelegate {
    func didFinishReloadSimulators(_ simulators: [Simulator]) {
        reloadSimulatorButton.isEnabled = true;
    }
    
    func didSelectedSimulators(_ simulators: [Simulator]) {
        runSimulatorButton.isEnabled = !simulators.isEmpty && app != nil;
    }
}

