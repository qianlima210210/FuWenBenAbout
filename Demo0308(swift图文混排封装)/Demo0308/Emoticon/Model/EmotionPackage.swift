//
//  EmotionPackage.swift
//  Demo0308
//
//  Created by QDHL on 2018/3/10.
//  Copyright © 2018年 QDHL. All rights reserved.
//

import UIKit

//MARK：表情包模型
@objcMembers class EmotionPackage: NSObject {
    //表情包分组名
    var groupName: String?
    //表情包目录，从该目录下加载info.plist可以创建表情模型数组
    var directory: String? {
        didSet{
            guard let directory = directory,
            let path = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil),
            let bundle = Bundle(path: path),
            let infoPlistPath = bundle.path(forResource: "info.plist", ofType: nil, inDirectory: directory),
            let array = NSArray(contentsOfFile: infoPlistPath) as? [[String:String]],
            let emotionArray = NSArray.yy_modelArray(with: Emotion.self, json: array) as? [Emotion] else {
                return
            }
            
            for item in emotionArray {
                item.directory = directory
            }
            
            self.emotionArray = emotionArray
        }
    }
    
    //表情模型数组
    var emotionArray = [Emotion]()
    
    override var description: String{
        return yy_modelDescription()
    }
}
