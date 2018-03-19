//
//  EmoticonManager.swift
//  Demo0308
//
//  Created by QDHL on 2018/3/10.
//  Copyright © 2018年 QDHL. All rights reserved.
//

import Foundation
import YYModel

//MARK：表情管理器
@objcMembers class EmoticonManager : NSObject {
    
    static let emoticonManager = EmoticonManager()
    // 表情包模型数组
    var emotionPackages = [EmotionPackage]()
    
    private override init(){
        super.init()
        loadPackage()
    }
    
    override var description: String{
        return yy_modelDescription()
    }
}

private extension EmoticonManager {
    func loadPackage() {
        guard let path = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil),
                let bundle = Bundle(path: path),
                let emoticonsPlistPath = bundle.path(forResource: "emoticons.plist", ofType: nil),
        let array = NSArray(contentsOfFile: emoticonsPlistPath) as? [[String:String]],
        let emotionPackages = NSArray.yy_modelArray(with: EmotionPackage.self, json: array) as? [EmotionPackage] else {
            return
        }
        
        self.emotionPackages += emotionPackages
    }
}

////MARK：带表情字符串处理
extension EmoticonManager {
    
    /// 根据字符串查找Emotion对象
    ///
    /// - Parameter string:带表情字符串
    /// - Returns: Emotion对象
    func findEmotion(string: String) -> Emotion? {
        for emotionPackage in emotionPackages {
            let result = emotionPackage.emotionArray.filter({ (emotion) -> Bool in
                return emotion.chs == string
            })
            
            if result.count == 1 {
                return result[0]
            }
        }
        
        return nil
    }

    func emotionString(string: String, font: UIFont) -> NSAttributedString {
        let attrString = NSMutableAttributedString(string: string)
        
        //建立正则表达式，遍历所有表情文字
        let pattern = "\\[.*?\\]"
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []) else {
            return attrString
        }
        
        //匹配所有项
        let matches = regx.matches(in: string, options: [], range: NSRange(location: 0, length: string.count))
        
        //遍历所有适配结果
        for m in matches.reversed() {
            let r = m.range
            let subStr = (string as NSString).substring(with: r)
            
            //查找emotion
            if let emotion = EmoticonManager.emoticonManager.findEmotion(string: subStr) {
                //倒序为替换图片属性文本
                attrString.replaceCharacters(in: r, with: emotion.imageText(font:font))
            }
        }
        
        //为字符串统一设置字体属性
        attrString.addAttributes([NSAttributedStringKey.font : font], range: NSRange.init(location: 0, length: attrString.length))
        
        return attrString
    }
}
























