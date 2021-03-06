//
//  WDForwardTableViewCell.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/2/10.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import KILabel

class WDForwardTableViewCell: WDStatusTableViewCell {
    
  
    override var status: Status?
        {
        didSet{
            let name = status?.retweeted_status?.user?.name ?? ""
            let text = status?.retweeted_status?.text ?? ""
        
            forwardLabel.attributedText = EmoticonPackage.emoticonString("@" + name + ": " + text)
        }
    }
    
    override func setupUI() {
        super.setupUI()
    
        // 1.添加子控件
 
        contentView.insertSubview(forwardButton, belowSubview: pictureView)
        contentView.insertSubview(forwardLabel, aboveSubview: forwardButton)
        
        // 2.布局子控件
        
        // 2.1布局转发背景
        forwardButton.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: contentLabel, size: nil, offset: CGPoint(x: -10, y: 10))
        forwardButton.xmg_AlignVertical(type: XMG_AlignType.TopRight, referView: footerView, size: nil)
        
        // 2.2布局转发正文
        forwardLabel.text = "fjdskljflkdsjflksdjlkfdsjlfjdslfjlkds"
        forwardLabel.xmg_AlignInner(type: XMG_AlignType.TopLeft, referView: forwardButton, size: nil, offset: CGPoint(x: 10, y: 10))
        
        // 2.3重新调整转发配图的位置
        let cons = pictureView.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: forwardLabel, size: CGSize(width: 290, height: 290), offset: CGPoint(x: 0, y: 10))
        
        pictureWidthCons = pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.Width)
        pictureHeightCons =  pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.Height)
        pictureTopCons = pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.Top)
        
    }
    
    // MARK: - 懒加载
    private lazy var forwardLabel: KILabel = {
        let label = KILabel()
        label.textColor = UIColor.darkGrayColor()
        label.font = UIFont.systemFontOfSize(20)
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 20
               // 监听URL
        label.urlLinkTapHandler =  {
            (label, string, range)
            in
            let str = string
            let info = [WDOpenBrowser:str]
            NSNotificationCenter.defaultCenter().postNotificationName(WDOpenBrowser, object: self, userInfo: info)
        }
        
        return label
    }()
    
    private lazy var forwardButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        return btn
    }()
}
