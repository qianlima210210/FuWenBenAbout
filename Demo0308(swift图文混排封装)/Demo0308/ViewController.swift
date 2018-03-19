//
//  ViewController.swift
//  Demo0308
//
//  Created by QDHL on 2018/3/8.
//  Copyright © 2018年 QDHL. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var tf: UITextField!
    
    
    let manager = EmoticonManager.emoticonManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        tf.delegate = self
        
        let string = "百度网址https://weibo.com/u/2159844793/home?wvr=5  ，电话是010-123456789"
        label.attributedText =  manager.emotionString(string: string, font: label.font)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let string = "电话https://www.baidu.com是010-123456789欢迎来电百度网址是https://www.baidu.com，"
        label.attributedText =  manager.emotionString(string: string, font: label.font)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        print("--------\(string)")
        
        return true
    }
    


}

//MARK: 属性字符串演示
extension ViewController {
    func testTextAttachment(label: UILabel)  {
        let attributeString = NSMutableAttributedString(string: "开始吧")
        
        //设置Attachment
        let attachment = NSTextAttachment()
        //使用一张图片作为Attachment数据
        attachment.image = #imageLiteral(resourceName: "common_icon_arrowup")
        //这里bounds的x值并不会产生影响
        attachment.bounds = CGRect(x: 0, y: 0, width: 21, height: 21)
        
        let attrStr = NSAttributedString(attachment: attachment)
        attributeString.append(attrStr)
        
        label.attributedText = attributeString
    }
    
    /// NSMutableAttributedString的简单演示
    func setAttributeTextSimpleShow2(label: UILabel) -> Void {
        //创建NSMutableAttributedString对象
        let attributeString = NSMutableAttributedString()
        
        //设置文本字体
        let str0 = "设置文本字体"
        let dicAttr0 = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14)]
        let attr0 = NSAttributedString(string: str0, attributes: dicAttr0)
        attributeString.append(attr0)
        
        //设置文本颜色
        let str1 = "\n设置文本颜色\n"
        let dicAttr1 = [NSAttributedStringKey.foregroundColor : UIColor.purple]
        let attr1 = NSAttributedString(string: str1, attributes: dicAttr1)
        attributeString.append(attr1)
        
        //设置文本背景颜色
        let str2 = "设置文本背景颜色"
        let dicAttr2 = [NSAttributedStringKey.backgroundColor : UIColor.cyan]
        let attr2 = NSAttributedString(string: str2, attributes: dicAttr2)
        attributeString.append(attr2)
        
        /*
         注：NSLigatureAttributeName设置连体属性，取值为NSNumber对象（整数），1表示使用默认的连体字符，0表示不使用，2表示使用所有连体符号（iOS不支持2）。
         而且并非所有的字符之间都有组合符合。如 fly ，f和l会连起来。
         */
        //设置连体属性
        let str3 = "而且NSAttributedStringKeyand123ABC"
        let dicAttr3 = [NSAttributedStringKey.font : UIFont.init(name: "futura", size: 14) ?? UIFont.systemFont(ofSize: 14),
                        NSAttributedStringKey.ligature : NSNumber.init(value: 1)]
        let attr3 = NSAttributedString(string: str3, attributes: dicAttr3 )
        attributeString.append(attr3)
        
        /*!
         注：NSKernAttributeName用来设置字符之间的间距，取值为NSNumber对象（整数），负值间距变窄，正值间距变宽
         */
        let str4 = "\n设置字符之间的间距"
        let dicAttr4 = [NSAttributedStringKey.kern : NSNumber.init(value: 4)]
        let attr4 = NSAttributedString(string: str4, attributes: dicAttr4)
        attributeString.append(attr4)
        
        /*!
         注：NSStrikethroughStyleAttributeName设置删除线，取值为NSNumber对象，枚举NSUnderlineStyle中的值。
         NSStrikethroughColorAttributeName设置删除线的颜色。并可以将Style和Pattern相互 取与 获取不同的效果
         */
        let str51 = "\n设置删除线为细的单实线，颜色为红色"
        let dicAttr51 = [NSAttributedStringKey.strikethroughStyle : NSNumber.init(value: NSUnderlineStyle.styleSingle.rawValue),
                         NSAttributedStringKey.strikethroughColor : UIColor.red]
        let attr51 = NSAttributedString(string: str51, attributes: dicAttr51)
        attributeString.append(attr51)
        
        let str52 = "\n设置删除线为粗的单实线，颜色为红色"
        let dicAttr52 = [NSAttributedStringKey.strikethroughStyle : NSNumber.init(value: NSUnderlineStyle.styleThick.rawValue),
                         NSAttributedStringKey.strikethroughColor : UIColor.red]
        let attr52 = NSAttributedString(string: str52, attributes: dicAttr52)
        attributeString.append(attr52)
        
        let str53 = "\n设置删除线为细的双实线，颜色为红色"
        let dicAttr53 = [NSAttributedStringKey.strikethroughStyle : NSNumber.init(value: NSUnderlineStyle.styleDouble.rawValue),
                         NSAttributedStringKey.strikethroughColor : UIColor.red]
        let attr53 = NSAttributedString(string: str53, attributes: dicAttr53)
        attributeString.append(attr53)
        
        let str54 = "\n设置删除线为细的单虚线，颜色为红色"
        let dicAttr54 = [NSAttributedStringKey.strikethroughStyle : NSNumber.init(value: NSUnderlineStyle.styleSingle.rawValue | NSUnderlineStyle.patternDot.rawValue),
                         NSAttributedStringKey.strikethroughColor : UIColor.red]
        let attr54 = NSAttributedString(string: str54, attributes: dicAttr54)
        attributeString.append(attr54)
        
        /*!
         NSStrokeWidthAttributeName 设置笔画的宽度，取值为NSNumber对象（整数），负值填充效果，正值是中空效果。
         NSStrokeColorAttributeName 设置填充部分颜色，取值为UIColor对象。
         设置中间部分颜色可以使用 NSForegroundColorAttributeName 属性来进行
         */
        let str6 = "\n设置笔画的宽度和填充颜色"
        let dicAttr6 = [NSAttributedStringKey.strokeWidth : NSNumber.init(value: 2),
                        NSAttributedStringKey.strokeColor : UIColor.blue]
        let attr6 = NSAttributedString(string: str6, attributes: dicAttr6)
        attributeString.append(attr6)
        
        //设置阴影，取值为NSShadow对象
        let str7 = "\n设置阴影，取值为NSShadow对象"
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.red
        shadow.shadowBlurRadius = 1.0
        shadow.shadowOffset = CGSize(width: 1.0, height: 1.0)
        let dicAttr7 = [NSAttributedStringKey.shadow : shadow]
        let attr7 = NSAttributedString(string: str7, attributes: dicAttr7)
        attributeString.append(attr7)
        
        //设置文本特殊效果，取值为NSString类型，目前只有一个可用效果  NSTextEffectLetterpressStyle（凸版印刷效果）
        let str8 = "\n设置文本特殊效果"
        let dicAttr8 = [NSAttributedStringKey.textEffect : NSAttributedString.TextEffectStyle.letterpressStyle.rawValue]
        let attr8 = NSAttributedString(string: str8, attributes: dicAttr8)
        attributeString.append(attr8)
        
        //设置文本附件，取值为NSTextAttachment对象，常用于文字的图文混排
        let str9 = "\n图1文混排文字的图文混排文字的图文混排"
        let attr90 = NSAttributedString(string: str9)
        attributeString.append(attr90)
        
        let textAttachment = NSTextAttachment()
        textAttachment.image = #imageLiteral(resourceName: "common_icon_arrowup")
        textAttachment.bounds = CGRect(x: 0, y: 0, width: 21, height: 21)
        let attr91 = NSAttributedString(attachment: textAttachment)
        attributeString.append(attr91)
        
        /*!
         添加下划线 NSUnderlineStyleAttributeName。设置下划线的颜色 NSUnderlineColorAttributeName，对象为 UIColor。使用方式同删除线一样。
         */
        //添加下划线
        let str10 = "\n添加下划线"
        let dicAttr10 = [NSAttributedStringKey.underlineStyle : NSNumber.init(value: NSUnderlineStyle.styleSingle.rawValue),
                         NSAttributedStringKey.underlineColor : UIColor.red]
        let attr10 = NSAttributedString(string: str10, attributes: dicAttr10)
        attributeString.append(attr10)
        
        /*!
         NSBaselineOffsetAttributeName 设置基线偏移值。取值为NSNumber （float），正值上偏，负值下偏
         */
        //设置基线偏移值 NSBaselineOffsetAttributeName
        let str11 = "\n设置基线偏移值"
        let dicAttr11 = [NSAttributedStringKey.baselineOffset : NSNumber.init(value: 0),
                         NSAttributedStringKey.backgroundColor : UIColor.blue]
        let attr11 = NSAttributedString(string: str11, attributes: dicAttr11)
        attributeString.append(attr11)
        
        /*!
         NSObliquenessAttributeName 设置字体倾斜度，取值为 NSNumber（float），正值右倾，负值左倾
         */
        //设置字体倾斜度 NSObliquenessAttributeName
        let str12 = "\n设置字体倾斜度"
        let dicAttr12 = [NSAttributedStringKey.obliqueness : NSNumber.init(value: 0.5)]
        let attr12 = NSAttributedString(string: str12, attributes: dicAttr12)
        attributeString.append(attr12)
        
        /*!
         NSExpansionAttributeName 设置字体的横向拉伸，取值为NSNumber （float），正值拉伸 ，负值压缩
         */
        //设置字体的横向拉伸 NSExpansionAttributeName
        let str13 = "\n设置字体的横向拉伸"
        let dicAttr13 = [NSAttributedStringKey.expansion : NSNumber.init(value: 0.5)]
        let attr13 = NSAttributedString(string: str13, attributes: dicAttr13)
        attributeString.append(attr13)
        
        /*!
         NSWritingDirectionAttributeName 设置文字的书写方向，取值为以下组合
         @[@(NSWritingDirectionLeftToRight | NSWritingDirectionEmbedding)]
         @[@(NSWritingDirectionLeftToRight | NSWritingDirectionOverride)]
         @[@(NSWritingDirectionRightToLeft | NSWritingDirectionEmbedding)]
         @[@(NSWritingDirectionRightToLeft | NSWritingDirectionOverride)]
         
         ???NSWritingDirectionEmbedding和NSWritingDirectionOverride有什么不同
         */
        //设置文字的书写方向 NSWritingDirectionAttributeName
        let str14 = "\n设置文字书写方向\n";
        let dictAttr14 = [NSAttributedStringKey.writingDirection:
            [NSNumber.init(value: NSWritingDirection.leftToRight.rawValue|NSWritingDirectionFormatType.embedding.rawValue)]]
        let attr14 = NSAttributedString(string: str14, attributes: dictAttr14)
        attributeString.append(attr14)
        
        /*
         NSVerticalGlyphFormAttributeName 设置文字排版方向，取值为NSNumber对象（整数），0表示横排文本，1表示竖排文本
         The value 0 indicates horizontal text. The value 1 indicates vertical text. In iOS, horizontal text is always used and specifying a different value is undefined.
         */
        //设置文字排版方向 NSVerticalGlyphFormAttributeName
        let str15 = "设置文字排版方向\n";
        let dictAttr15 = [NSAttributedStringKey.verticalGlyphForm : NSNumber.init(value: 1)]
        let attr15 = NSAttributedString(string: str15, attributes: dictAttr15)
        attributeString.append(attr15)
        
        //设置段落样式
        let paragrapStyle = NSMutableParagraphStyle()
        
        //行间距
        paragrapStyle.lineSpacing = 0
        
        //段落间距
        paragrapStyle.paragraphSpacing = 0
        
        //对齐方式
        paragrapStyle.alignment = .left
        
        //指定段落开始的缩进像素
        paragrapStyle.firstLineHeadIndent = 0
        
        //调整全部文字的缩进像素
        paragrapStyle.headIndent = 0
        
        //添加段落属性
        attributeString.addAttribute(.paragraphStyle,
                                     value: paragrapStyle,
                                     range: NSRange.init(location: 0, length: attributeString.length))
        
        label.attributedText = attributeString
    }
    
    /// NSMutableAttributedString的简单演示
    func setAttributeTextSimpleShow1(label: UILabel, text: String) -> Void {
        //创建NSMutableAttributedString对象
        let attrStr = NSMutableAttributedString(string: text)
        
        //设置文字字体和影响范围
        attrStr.addAttribute(.font, value: UIFont.systemFont(ofSize: 30), range: NSMakeRange(0, 5))
        
        //设置文字颜色和影响范围
        attrStr.addAttribute(.foregroundColor, value: UIColor.red, range: NSMakeRange(5, 5))
        
        //设置文字背景颜色和影响范围
        attrStr.addAttribute(.backgroundColor, value: UIColor.yellow, range: NSMakeRange(5, 10))
        
        //设置文字下划线和影响范围
        attrStr.addAttribute(.underlineStyle, value: NSNumber(value: NSUnderlineStyle.styleSingle.rawValue), range: NSMakeRange(10, 10))
        
        label.attributedText = attrStr
        
    }

}

//MARK: BYButton演示
extension ViewController {
    func constraint() {
        let btn = BYButton()
        
        //设置必要属性
        btn.isAdjustTitleLabelAndImageView = true
        btn.setImage(#imageLiteral(resourceName: "common_icon_arrowup"), for: .normal)
        btn.setTitle("呵呵", for: .normal)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.addTarget(self, action: #selector(constraintClicked), for: .touchUpInside)
        //设置可选属性
        btn.backgroundColor = UIColor.yellow
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btn)
        
        let left = NSLayoutConstraint(item: btn, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 30.0)
        let top = NSLayoutConstraint(item: btn, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 100.0)
        
        let width = NSLayoutConstraint(item: btn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 120)
        let height = NSLayoutConstraint(item: btn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40)
        
        btn.addConstraints([width, height])
        view.addConstraints([left, top])
    }
    
    @objc func constraintClicked() {
        print("constraintClicked")
    }
    
    func autoResing() {
        let btn = BYButton(frame: CGRect(x: 30, y: 100, width: 90, height: 50))
        //设置必要属性
        btn.setImage(#imageLiteral(resourceName: "common_icon_arrowup"), for: .normal)
        btn.setTitle("呵呵", for: .normal)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.addTarget(self, action: #selector(autoResingClicked), for: .touchUpInside)
        //设置可选属性
        btn.backgroundColor = UIColor.yellow
        
        view.addSubview(btn)
        
    }
    
    @objc func autoResingClicked() {
        print("autoResing")
    }
}

