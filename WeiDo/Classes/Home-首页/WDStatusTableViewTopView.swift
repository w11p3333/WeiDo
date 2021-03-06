//
//  WDStatusTableViewTopView.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/2/10.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import SDWebImage



class WDStatusTableViewTopView: UIView {

    /// 设置数据
    var status: Status?
        {
        didSet{
            // 设置昵称
            nameLabel.text = status?.user?.name
            // 设置用户头像
            if let iconURL = status?.user?.profile_image_url
            {
                let url = NSURL(string: iconURL)
                iconView.sd_setImageWithURL(url)
               
                /**
                设置图为圆角
                */
                iconView.kay_addCorner(radius: 40)
            }
            // 设置认证图标
            verifiedView.image = status?.user?.verifiedImage
            // 设置会员图标
           
            vipView.image = status?.user?.mbrankImage
            // 设置来源
            sourceLabel.text = status?.source
            // 设置时间
            timeLabel.text = status?.created_at
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 初始化UI
        setupUI()
    }
    
    
    private func setupUI()
    {
        sourceLabel.textColor = UIColor.darkGrayColor()
        timeLabel.textColor = UIColor.darkGrayColor()
        nameLabel.textColor = DFColor
        // 1.添加子控件
        addSubview(iconView)
        addSubview(verifiedView)
        addSubview(nameLabel)
        addSubview(vipView)
        addSubview(timeLabel)
        addSubview(sourceLabel)
        addSubview(loveBtn)
        
        // 2.布局子控件
        iconView.xmg_AlignInner(type: XMG_AlignType.TopLeft, referView: self, size: CGSize(width: 40, height: 40), offset: CGPoint(x: 10, y: 10))
        verifiedView.xmg_AlignInner(type: XMG_AlignType.BottomRight, referView: iconView, size: CGSize(width: 14, height: 14), offset: CGPoint(x:5, y:5))
        nameLabel.xmg_AlignHorizontal(type: XMG_AlignType.TopRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
        vipView.xmg_AlignHorizontal(type: XMG_AlignType.TopRight, referView: nameLabel, size: CGSize(width: 14, height: 14), offset: CGPoint(x: 10, y: 0))
        timeLabel.xmg_AlignHorizontal(type: XMG_AlignType.BottomRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
        sourceLabel.xmg_AlignHorizontal(type: XMG_AlignType.BottomRight, referView: timeLabel, size: nil, offset: CGPoint(x: 10, y: 0))
        loveBtn.xmg_AlignHorizontal(type: XMG_AlignType.TopRight, referView: self, size: CGSize(width: 30, height: 30), offset: CGPoint(x: -40, y: 10))
    }
    
    
    func loveClick()
    {
        if loveBtn.selected
        {
        loveBtn.selected = false
        }
        else
        {
        loveBtn.selected = true
        }
    
    
    }
    
    
    // MARK: - 懒加载
    /// 头像
    private lazy var iconView: UIImageView =
    {
        let iv = UIImageView(image: UIImage(named: "avatar_default_big"))
        return iv
    }()
    /// 认证图标
    private lazy var verifiedView: UIImageView = UIImageView(image: UIImage(named: "avatar_enterprise_vip"))
    
    /// 昵称
    private lazy var nameLabel: UILabel = UILabel.createLabel(UIColor.darkGrayColor(), fontsize: 15)
    
    /// 会员图标
    private lazy var vipView: UIImageView = UIImageView(image: UIImage(named: "common_icon_membership"))
    
    //红心
    private lazy var loveBtn : UIButton =
        {
    
        let btn = UIButton()
            btn.setImage(UIImage(named:"loveheart"), forState: .Normal)
            btn.setImage(UIImage(named:"loveheartClick"), forState: .Selected)
            btn.addTarget(self, action: "loveClick", forControlEvents: .TouchUpInside)
            return btn
    
    }()
    /// 时间
    private lazy var timeLabel: UILabel = UILabel.createLabel(UIColor.darkGrayColor(), fontsize: 12)
    /// 来源
    private lazy var sourceLabel: UILabel = UILabel.createLabel(UIColor.darkGrayColor(), fontsize: 12)
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
