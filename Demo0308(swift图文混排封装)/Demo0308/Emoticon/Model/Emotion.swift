//
//  Emotion.swift
//  Demo0308
//
//  Created by QDHL on 2018/3/10.
//  Copyright © 2018年 QDHL. All rights reserved.
//

import UIKit
import YYModel

//MARK:表情模型
@objcMembers class Emotion: NSObject {
    //false：图片表情；true：emoji表情
    var type = false
    
    //表情字符串，发送给新浪微博的服务器（节约流量）
    var chs: String?
    
    //表情图片名称，用于本地图文混排
    var png: String?
    
    //emoj的十六进制编码字符串
    var code: String?
    
    //表情模型所在目录
    var directory: String?
    
    //表情对应的图片
    var image: UIImage? {
        if type {
            return nil
        }
        
        guard let path = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil),
        let bundle = Bundle.init(path: path),
        let directory = directory,
        let png = png else {
            return nil
        }
        
        return UIImage.init(named: "\(directory)/\(png)", in: bundle, compatibleWith: nil)
    }
    
    func imageText(font: UIFont) -> NSAttributedString {
        //1.判断图像是否存在
        guard let image = image else {
            return NSAttributedString(string: "")
        }
        
        //2.创建文本附件
        let textAttachment = NSTextAttachment()
        textAttachment.image = image
        textAttachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
        
        //3.返回图片属性字符串
        return NSAttributedString(attachment: textAttachment)
    }
    
    override var description: String{
        return yy_modelDescription()
    }
}
