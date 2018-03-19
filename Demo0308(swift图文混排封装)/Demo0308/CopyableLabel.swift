//
//  CopyableLabel.swift
//  Demo0308
//
//  Created by QDHL on 2018/3/8.
//  Copyright © 2018年 QDHL. All rights reserved.
//

import UIKit

class CopyableLabel: UILabel {
    
    var touchesBeganLocationMapRange: NSRange?
    
    override var text: String? {
        didSet {
            prepareTextContent()
        }
    }
    
    override var attributedText: NSAttributedString? {
        didSet {
            prepareTextContent()
        }
    }
    
    //TextKit核心对象
    private var textStorage = NSTextStorage()       //存放属性字符串及一组NSLayoutManager对象
    private var layoutManager = NSLayoutManager()   //字形管理对象，形成TextView，并显示到NSTextContainer
    private var textContainer = NSTextContainer()   //属性字符串绘制范围
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareTextSystem()
        addLongPressGestureRecognizer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        
        prepareTextSystem()
        addLongPressGestureRecognizer()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //指定绘制文本的区域
        textContainer.size = bounds.size
    }
    
    //绘制文本--TextKit接管底层实现，本质上是绘制NSTextStorage中的属性字符串
    override func drawText(in rect: CGRect) {
        let range = NSRange.init(location: 0, length: textStorage.length)
        
        //绘制背景颜色
        layoutManager.drawBackground(forGlyphRange: range, at: CGPoint())
        
        //绘制glyphs
        layoutManager.drawGlyphs(forGlyphRange: range, at: CGPoint())
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else {
            return
        }
        
        let index = layoutManager.glyphIndex(for: location, in: textContainer, fractionOfDistanceThroughGlyph: nil)
        
        for r in urlRanges ?? [] {
            if NSLocationInRange(index, r) {
                textStorage.addAttributes([NSAttributedStringKey.foregroundColor : UIColor.red], range: r)
                setNeedsDisplay()
                
                //记录touchesBeganLocationMapRange
                touchesBeganLocationMapRange = r
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self),
         let touchesBeganLocationMapRange = touchesBeganLocationMapRange else {
            return
        }
        
        //先恢复touchesBeganLocationMapRange显示状态
        self.touchesBeganLocationMapRange = nil
        textStorage.addAttributes([NSAttributedStringKey.foregroundColor : UIColor.blue], range: touchesBeganLocationMapRange)
        setNeedsDisplay()
        
        //判断是否发出通知
        let index = layoutManager.glyphIndex(for: location, in: textContainer, fractionOfDistanceThroughGlyph: nil)
        
        for r in urlRanges ?? [] {
            if NSLocationInRange(index, r) {
                if NSEqualRanges(touchesBeganLocationMapRange, r) {
                    print("点击了URL连接")
                }
            }
        }
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(copy(_:)) || action == #selector(share(_:))
    }
    
    override func copy(_ sender: Any?){
        print("copy")
    }
}

//设置TextKit核心对象
extension CopyableLabel {
    //准备文本系统
    func prepareTextSystem() {
        //准备文本内容
        prepareTextContent()
        
        //设置对象的关系
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        textContainer.lineFragmentPadding = 0.0
    }
    
    //准备文本内容
    func prepareTextContent() {
        if let attributedText = attributedText {
            textStorage.setAttributedString(attributedText)
        }else if let text = text {
            textStorage.setAttributedString(NSAttributedString(string: text))
        }else{
            textStorage.setAttributedString(NSAttributedString(string: ""))
        }
        
        //设置URL颜色及背景颜色
        for range in urlRanges ?? [] {
            textStorage.addAttributes([NSAttributedStringKey.foregroundColor : UIColor.blue,
                                    NSAttributedStringKey.backgroundColor : UIColor.gray],
                                      range: range)
        }
        
    }
}

//正则表达处理
extension CopyableLabel {
    var urlRanges: [NSRange]?{
        //设置正则表达式
        let pattern = "((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)"
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []) else {
            return nil
        }
        
        //匹配所有项
        let matches = regx.matches(in: textStorage.string, options: [],
                                   range: NSRange(location: 0, length: textStorage.string.count))
        
        //遍历所有适配结果
        var ranges = [NSRange]()
        
        for m in matches.reversed() {
            let r = m.range
            ranges.append(r)
        }
        
        return ranges
    }
    
}

//菜单及拷贝处理
extension CopyableLabel {
    /// 添加长按手势识别器
    func addLongPressGestureRecognizer() -> Void {
        isUserInteractionEnabled = true
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(recognizer:)))
        recognizer.minimumPressDuration = 1.0
        self.addGestureRecognizer(recognizer)
    }
    
    @objc func longPressAction(recognizer: UILongPressGestureRecognizer) -> Void {
        if recognizer.state == .began {
            print("longPressAction: state = \(recognizer.state.rawValue)")
            //变为第一响应
            becomeFirstResponder()
            //创建自定义菜单项
            let shareItem = UIMenuItem(title: "分享", action: #selector(share(_:)))
            UIMenuController.shared.menuItems = [shareItem]
            UIMenuController.shared.setTargetRect(frame, in: superview!)
            UIMenuController.shared.setMenuVisible(true, animated: true)
        }
    }
    
    @objc private func share(_ sender: Any?){
        print("share")
    }
}
























