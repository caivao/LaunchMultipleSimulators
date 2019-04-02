//
//  DragFileView.swift
//  LaunchMultipleSimulators
//
//  Created by lifeng on 2019/3/29.
//  Copyright © 2019 Done. All rights reserved.
//

import Cocoa

protocol DragFileDelegate: NSObject {
    func didFinishDrag(_ filePath: String);
}

class DragFileView: NSView {
    
    weak var delegate: DragFileDelegate?;
    
    override func awakeFromNib() {
        super.awakeFromNib();
        wantsLayer = true;
        registerForDraggedTypes([NSPasteboard.PasteboardType.fileURL]);
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        layer?.backgroundColor = NSColor(0xf1f1f1, 0.6).cgColor;
        let pastedboard = sender.draggingPasteboard;
        if(pastedboard.types?.contains(.fileURL) == true) {
            return NSDragOperation.copy;
        }
        return super.draggingEntered(sender);
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        layer?.backgroundColor = NSColor.clear.cgColor;
    }
    
    override func draggingEnded(_ sender: NSDraggingInfo) {
        layer?.backgroundColor = NSColor.clear.cgColor;
    }
    
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        layer?.backgroundColor = NSColor.clear.cgColor;
        let pastedboard = sender.draggingPasteboard;
        guard let list = pastedboard.propertyList(forType: NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")) as? [String],
            !list.isEmpty,
            let path = list.first
        else { return false }
        // 3）、将接受到的文件链接数组通过代理传送
        delegate?.didFinishDrag(path);
        return true;
    }
}
