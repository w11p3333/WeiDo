//
//  WDStatusPictureView.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/2/10.
//  Copyright © 2016年 卢良潇. All rights reserved.
//


import UIKit
import SDWebImage

class WDStatusPictureView: UICollectionView {
    var status: Status?
        {
        didSet{
            // 1. 刷新表格
            reloadData()
        }
    }
    
    private var pictureLayout: UICollectionViewFlowLayout =  UICollectionViewFlowLayout()
    init()
    {
        super.init(frame: CGRectZero, collectionViewLayout: pictureLayout)
        
        // 1.注册cell
        registerClass(PictureViewCell.self, forCellWithReuseIdentifier: WDPictureViewCellReuseIdentifier)
        
        // 2.设置数据源和代理
        dataSource = self
        delegate = self
        
        
        // 2.设置cell之间的间隙
        pictureLayout.minimumInteritemSpacing = 10
        pictureLayout.minimumLineSpacing = 10
        
        // 3.设置配图的背景颜色
        backgroundColor = UIColor.clearColor()
    }
    
    
    /**
     计算配图的尺寸
     */
    func calculateImageSize() -> CGSize
    {
        // 1.取出配图个数
        let count = status?.storedPicURLS?.count
        // 2.如果没有配图zero
        if count == 0 || count == nil
        {
            return CGSizeZero
        }
        // 3.如果只有一张配图, 返回图片的实际大小
        if count == 1
        {

    
            pictureLayout.itemSize = CGSizeMake(90, 90)
            // 3.2返回缓存图片的尺寸
            return CGSizeMake(90, 90)

        }
        // 4.如果有4张配图, 计算田字格的大小
        let width = 100
        let margin = 20
        pictureLayout.itemSize = CGSize(width: width, height: width)
        
        if count == 4
        {
            let viewWidth = width * 2 + margin
            return CGSize(width: viewWidth, height: viewWidth)
        }
        
        // 5.如果是其它(多张), 计算九宫格的大小
        // 5.1计算列数
        let colNumber = 3
        // 5.2计算行数
        let rowNumber = (count! - 1) / 3 + 1
        // 宽度 = 列数 * 图片的宽度 + (列数 - 1) * 间隙
        let viewWidth = colNumber * width + (colNumber - 1) * margin
        // 高度 = 行数 * 图片的高度 + (行数 - 1) * 间隙
        let viewHeight = rowNumber * width + (rowNumber - 1) * margin
        return CGSize(width: viewWidth, height: viewHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private class PictureViewCell: UICollectionViewCell {
        
        // 定义属性接收外界传入的数据
        var imageURL: NSURL?
            {
            didSet{
                //设置图片
                iconImageView.sd_setImageWithURL(imageURL!)
                  //判断是否是gif
              if  (imageURL!.absoluteString as NSString).pathExtension == "gif"
              {
                 gifImageView.hidden = false
                
                }
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            // 初始化UI
            setupUI()
        }
        
        private func setupUI()
        {
            // 1.添加子控件
            contentView.addSubview(iconImageView)
            iconImageView.addSubview(gifImageView)
            // 2.布局子控件
            iconImageView.xmg_Fill(contentView)
            gifImageView.xmg_AlignInner(type: XMG_AlignType.TopLeft, referView: iconImageView, size: nil)
        }
        
        // MARK: - 懒加载
        private lazy var iconImageView:UIImageView = UIImageView()
        private lazy var gifImageView:UIImageView = {
            let gv = UIImageView(image: UIImage(named: "common-gif"))
            gv.hidden = true
            return gv
         
        }()
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
}
/// 选中图片的通知名称
let WDStatusPictureViewSelected = "WDStatusPictureViewSelected"
/// 选中图片的索引对应的key名称
let WDStatusPictureViewIndexKey = "WDStatusPictureViewIndexKey"

/// 选中图片的路径对应的key的名称
let WDStatusPictureViewURLsKey = "WDStatusPictureViewURLsKey"

extension WDStatusPictureView: UICollectionViewDataSource, UICollectionViewDelegate
{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return status?.storedPicURLS?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // 1.取出cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(WDPictureViewCellReuseIdentifier, forIndexPath: indexPath) as! PictureViewCell
        
        // 2.设置数据
        cell.imageURL = status?.storedPicURLS![indexPath.item]
        
        // 3.返回cell
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        let info = [WDStatusPictureViewIndexKey:indexPath, WDStatusPictureViewURLsKey:status!.storedLargePicURLS!]
        //发布一个通知
        NSNotificationCenter.defaultCenter().postNotificationName(WDStatusPictureViewSelected, object: self, userInfo: info)
    }
    
}