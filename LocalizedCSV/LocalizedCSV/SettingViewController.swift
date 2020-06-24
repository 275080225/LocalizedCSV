//
//  SettingViewController.swift
//  LocalizedCSV
//
//  Created by 张行 on 2017/10/26.
//  Copyright © 2017年 张行. All rights reserved.
//

import Cocoa

class SettingViewController: NSViewController {

	@IBOutlet var languageCodeTextView:NSTextView!
    @IBOutlet var searchLocalizetionPrefix:NSTextField!
    @IBOutlet var filterLocalizeNameTextView:NSTextView!
    @IBOutlet var checkPlaceholderTextView:NSTextView!
    @IBOutlet var fixValueTextView:NSTextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let setting = SettingModel.shareSettingModel()
		self.languageCodeTextView.string = setting.languageCodeString()
        self.filterLocalizeNameTextView.string = setting.filterLocalizedNames.joined(separator: "\n")
        self.checkPlaceholderTextView.string = setting.checkPlaceholders.joined(separator: "\n")
        self.searchLocalizetionPrefix.stringValue = setting.searchLocalizetionPrefix
        self.fixValueTextView.string = setting.transferMapToString(map: setting.fixValues)
    }

    @IBAction func save(_ sender:NSButton) {
        if self.languageCodeTextView.string.count>0 {
            let textList = self.languageCodeTextView.string.components(separatedBy: "\n")
            var textDic:[String:String] = [:]
            for text in textList.enumerated() {
                let subList = text.element.components(separatedBy: ":")
                guard subList.count == 2 else {
                    continue
                }
                textDic[subList[0]] = subList[1]
            }
            SettingModel.shareSettingModel().projectLanguageCode = textDic
        }
        if self.searchLocalizetionPrefix.stringValue.count > 0 {
            SettingModel.shareSettingModel().searchLocalizetionPrefix = self.searchLocalizetionPrefix.stringValue
        }
        let filterText = self.filterLocalizeNameTextView.string
        if filterText.count>0 {
            let textList = self.languageCodeTextView.string.components(separatedBy: "\n")
            SettingModel.shareSettingModel().filterLocalizedNames = textList
        }
        
        if self.checkPlaceholderTextView.string.count>0 {
            let textList = self.checkPlaceholderTextView.string.components(separatedBy: "\n")
            SettingModel.shareSettingModel().checkPlaceholders = textList
        }
        
        if self.fixValueTextView.string.count>0 {
            let textList = self.fixValueTextView.string.components(separatedBy: "\n")
            var textDic:[String:String] = [:]
            for text in textList.enumerated() {
                let subList = text.element.components(separatedBy: ":")
                guard subList.count == 2 else {
                    continue
                }
                textDic[subList[0]] = subList[1]
            }
            SettingModel.shareSettingModel().fixValues = textDic
        }
        SettingModel.shareSettingModel().save()
    }
}

let settingModel = SettingModel()

class SettingModel {
    
    var projectRootPath:String?{
        didSet{
            let userDefault = UserDefaults.standard
            userDefault.set(projectRootPath, forKey: "projectRootPath")
            userDefault.synchronize()
        }
    }
    
    var projectLanguagePath:String?{
        didSet{
            let userDefault = UserDefaults.standard
            userDefault.set(projectLanguagePath, forKey: "projectLanguagePath")
            userDefault.synchronize()
        }
    }
    var csvPath:String?{
        didSet{
            let userDefault = UserDefaults.standard
            userDefault.set(csvPath, forKey: "csvPath")
            userDefault.synchronize()
        }
    }

	var projectLanguageCode:[String:String] = [:]
    
    var searchLocalizetionPrefix:String = "GBLocalizedString"
    
    var filterLocalizedNames:[String] = []
    
    var checkPlaceholders:[String] = []
    
    var fixValues:[String:String] = [:]

	init() {
		if let oldLanguageCode = UserDefaults.standard.object(forKey: "projectLanguageCode") as? [String:String] {
			self.projectLanguageCode = oldLanguageCode
		}
        if let fixValues = UserDefaults.standard.object(forKey: "fixValues") as? [String:String] {
            self.fixValues = fixValues
        }
        if let filterLocalizedNames = UserDefaults.standard.object(forKey: "filterLocalizedNames") as? [String]  {
            self.filterLocalizedNames = filterLocalizedNames
        }
        if let checkPlaceholders = UserDefaults.standard.object(forKey: "checkPlaceholders") as? [String]  {
            self.checkPlaceholders = checkPlaceholders
        }
        if let projectRootPath = UserDefaults.standard.object(forKey: "projectRootPath") as? String  {
            self.projectRootPath = projectRootPath
        }
        if let projectLanguagePath = UserDefaults.standard.object(forKey: "projectLanguagePath") as? String  {
            self.projectLanguagePath = projectLanguagePath
        }
        if let csvPath = UserDefaults.standard.object(forKey: "csvPath") as? String  {
            self.csvPath = csvPath
        }
        
        if let searchLocalizetionPrefix = UserDefaults.standard.object(forKey: "searchLocalizetionPrefix") as? String {
            if searchLocalizetionPrefix.count > 0 {
                self.searchLocalizetionPrefix = searchLocalizetionPrefix
            }
        }
	}

	class func shareSettingModel() -> SettingModel {
		return settingModel
	}
    
    func save() {
        let userDefault = UserDefaults.standard
        userDefault.set(self.projectLanguageCode, forKey: "projectLanguageCode")
        userDefault.set(self.filterLocalizedNames, forKey: "filterLocalizedNames")
        userDefault.set(self.checkPlaceholders, forKey: "checkPlaceholders")
        userDefault.set(self.searchLocalizetionPrefix, forKey: "searchLocalizetionPrefix")
        userDefault.set(self.fixValues, forKey: "fixValues")
        userDefault.synchronize()
    }
    
    func languagePath(code:String) -> String {
        guard let projectLanguagePath = SettingModel.shareSettingModel().projectLanguagePath else {
            return ""
        }
        guard projectLanguagePath.count>0 else {
            return ""
        }
        return "\(projectLanguagePath)\(code).lproj/Localizable.strings"
    }
    
	func languageCodeString() -> String {
		return transferMapToString(map: self.projectLanguageCode)
	}
    
    func transferMapToString(map:[String:String]) -> String {
        var codeList:[String] = []
        for (key,value) in map {
            let subString = "\(key):\(value)"
            codeList.append(subString)
        }
        return codeList.joined(separator: "\n")
    }
}
