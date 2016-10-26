//
//  AZLabel.swift
//  TextKit
//
//  Created by Albert Zhu on 16/10/26.
//  Copyright © 2016年 Albert Zhu. All rights reserved.
//

import UIKit

protocol AZLabelDelegate: NSObjectProtocol {
    func didSelectUrl(urlString: String?)
}

class AZLabel: UILabel {

    // 1.使用TextKit接管label的底层实现
    // 2.使用正则表达式过滤URL
    // 3.交互
    /// 属性文本
    lazy var textStorage = NSTextStorage()
    /// 布局
    lazy var layoutManager = NSLayoutManager()
    /// 绘制范围
    lazy var textContainer = NSTextContainer()
    
    weak var delegate: AZLabelDelegate?
    
    override var text: String? {
        didSet {
            prepareTextContent()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareTextSystem()
    }
    
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        
        prepareTextSystem()
        
        text = "@勇敢的苹果V6"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textContainer.size = bounds.size
    }
    
    /// 绘制文本
    override func drawText(in rect: CGRect) {

        let range = NSRange(location: 0, length: textStorage.length)
        
        layoutManager.drawBackground(forGlyphRange: range, at: CGPoint())
        layoutManager.drawGlyphs(forGlyphRange: range, at: CGPoint())
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let point = touches.first?.location(in: self) else {return}
        
        let index = layoutManager.glyphIndex(for: point, in: textContainer)
        
        for r in urlRanges ?? [] {
            if NSLocationInRange(index, r) {
                print("高亮")
                
//                textStorage.addAttribute(NSBackgroundColorAttributeName, value: UIColor.lightGray, range: r)
//                setNeedsDisplay()
                
                let str = textStorage.string as NSString
                let urlStr = str.substring(with: r)
                
                delegate?.didSelectUrl(urlString: urlStr)
            }else{
                print("普通")
            }
        }
    }
}

// MARK: - 设置TextKit核心对象
extension AZLabel {
    /// 准备文本系统
    func prepareTextSystem() {
        
        isUserInteractionEnabled = true
        
        prepareTextContent()
        
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        
    }
    
    /// 准备文本内容：使用textStorage接管label
    func prepareTextContent() {
        
        /// 接管文本
        if let attr = attributedText {
            textStorage.setAttributedString(attr)
        }else if let text = text {
            textStorage.setAttributedString(NSAttributedString(string: text))
        }else{
            textStorage.setAttributedString(NSAttributedString(string: ""))
        }
        
        for range in atRanges ?? [] {
            textStorage.addAttributes([NSForegroundColorAttributeName:UIColor.blue], range: range)
            
        }
    }
    

}

// MARK: - 正则
extension AZLabel {
    /// 返回textStorage中的URL range数组
    var urlRanges: [NSRange]? {
        
        let pattern = "[a-zA-Z]*://[a-zA-Z0-9/\\.]*"
        
        guard let rgs = try? NSRegularExpression(pattern: pattern, options: []) else {return nil}
        
        let matches = rgs.matches(in: textStorage.string, options: [], range: NSRange(location: 0, length: textStorage.length))
        
        var ranges = [NSRange]()
        
        for m in matches {
            ranges.append(m.rangeAt(0))
        }
        
        return ranges
    }
    
    var atRanges: [NSRange]? {
        let pattern = "@[a-zA-Z0-9\\u4e00-\\u9fa5\\-\\_]*"
        
        guard let rgs = try? NSRegularExpression(pattern: pattern, options: []) else {return nil}
        
        let matches = rgs.matches(in: textStorage.string, options: [], range: NSRange(location: 0, length: textStorage.length))
        
        var ranges = [NSRange]()
        
        for m in matches {
            ranges.append(m.rangeAt(0))
        }
        
        return ranges
    }
    
    var topicRanges: [NSRange]? {
        let pattern = "#[a-zA-Z0-9\\u4e00-\\u9fa5\\-\\_]*#"
        
        guard let rgs = try? NSRegularExpression(pattern: pattern, options: []) else {return nil}
        
        let matches = rgs.matches(in: textStorage.string, options: [], range: NSRange(location: 0, length: textStorage.length))
        
        var ranges = [NSRange]()
        
        for m in matches {
            ranges.append(m.rangeAt(0))
        }
        
        return ranges

    }
}
