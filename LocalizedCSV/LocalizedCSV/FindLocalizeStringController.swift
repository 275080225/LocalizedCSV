//
//  FindLocalizeStringController.swift
//  LocalizedCSV
//
//  Created by 张行 on 2017/8/19.
//  Copyright © 2017年 张行. All rights reserved.
//

import Cocoa

/* 查找工程存在的多语言 */
class FindLocalizeStringController: NSViewController, NSTableViewDataSource {
    /* 显示查找的状态 */
    @IBOutlet var stateLabel: NSTextField!
    /* 超找出来结果的表格 */
    @IBOutlet var tableView: NSTableView!
    /* 显示正在查找的路径地址 */
    @IBOutlet var filePathLabel: NSTextField!
    
    /* 显示超找的总数量 */
    @IBOutlet var countLabel: NSTextField!
    /* 查找管理器的单利对象 */
    let findKit:FindLocalizeStringKit = FindLocalizeStringKit.shareManager()
    /* 需要查找的路径 */
    var findPath:String?
    /* 查找出来的数据数组 */
    var keys:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /* 如果路径不存在 结束查询 */
        guard let path  = findPath else {
            return
        }
        /* 开始查询 */
        self.stateLabel.stringValue = "正在查找..."
        /* 查找管理器查找完成的回调 */
        findKit.completionLog = {log in
            DispatchQueue.main.async {
                self.filePathLabel.stringValue = log
            }
        }
        /* 查找管理器查找一组最新的数据回调 */
        findKit.updateCompletion = { key, value in
            DispatchQueue.main.async {
                self.keys.append(key)
                self.tableView.reloadData()
                self.countLabel.stringValue = "\(self.keys.count)"
            }
        }
        DispatchQueue.global().async {
            FindLocalizeStringKit.shareManager().findAllLocalizeString(path: path)
            DispatchQueue.main.async {
                self.stateLabel.stringValue = "✅查询完毕"
                if FindLocalizeStringKit.shareManager().exitSameKeyList.keys.count > 0 {
                    let alert = NSAlert()
                    var message = "以下Key 存在多个值可能造成程序运行问题\n"
                    for key in FindLocalizeStringKit.shareManager().exitSameKeyList {
                        message += "\n\n\n\(key.key) \n"
                        for text in key.value {
                            message += ":\(text)"
                        }
                    }
                    alert.messageText = message
                    alert.runModal()
                }
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(nil)
    }
    @IBAction func export(_ sender: Any) {
        var content = ""
        
        let keys = FindLocalizeStringKit.shareManager().list.keys.sorted(by: { (name1, name2) -> Bool in
            return name1.localizedStandardCompare(name2) == ComparisonResult.orderedAscending
        })
        for c in keys.enumerated() {
            let key = c.element
            
            guard let value = FindLocalizeStringKit.shareManager().list[key], value.count > 0 else {
                continue
            }
            content += "\"\(key)\" = \"\(value)\";\n"
        }
//        content = content.replacingOccurrences(of: "\\", with: "\\\\")
        let filePath = SettingModel.shareSettingModel().languagePath(code: "en")
        
        try? content.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
        self.dismiss(nil)
    }
    
    public func numberOfRows(in tableView: NSTableView) -> Int {
        return keys.count
    }
    
    public func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        guard let co = tableColumn else {
            return nil
        }
        let key = keys[row]
        if co.title == "Key" {
            return key
        } else if co.title == "Value" {
            return FindLocalizeStringKit.shareManager().list[key]
        }
        return nil
    }
}
