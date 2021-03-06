//
//  photpSelectorViewController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/2/12.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit

private let WDPhotoSelectorCellReuseIdentifier = "WDPhotoSelectorCellReuseIdentifier"
class PhotoSelectorViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI()
    {
        // 1.添加子控件
        view.addSubview(collcetionView)
        
        // 2.布局子控件
        collcetionView.translatesAutoresizingMaskIntoConstraints = false
        var cons = [NSLayoutConstraint]()
        
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[collcetionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["collcetionView": collcetionView])
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[collcetionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["collcetionView": collcetionView])
        view.addConstraints(cons)
        
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - 懒加载
    private lazy var collcetionView: UICollectionView = {
        let clv = UICollectionView(frame: CGRectZero, collectionViewLayout: PhotoSelectorViewLayout())
        //注册cell
        clv.registerClass(PhotoSelectorCell.self, forCellWithReuseIdentifier: WDPhotoSelectorCellReuseIdentifier)
        clv.dataSource = self
        return clv
    }()
    
     lazy var pictureImages = [UIImage]()
    
}

extension PhotoSelectorViewController: UICollectionViewDataSource, PhotoSelectorCellDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureImages.count + 1
        //        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collcetionView.dequeueReusableCellWithReuseIdentifier(WDPhotoSelectorCellReuseIdentifier, forIndexPath: indexPath) as! PhotoSelectorCell
        
        cell.PhotoCellDelegate = self
        cell.backgroundColor = UIColor.whiteColor()
        cell.image = (pictureImages.count == indexPath.item) ? nil : pictureImages[indexPath.item]
        return cell
    }
    
    func photoDidAddSelector(cell: PhotoSelectorCell) {
        /*
        case PhotoLibrary     照片库(所有的照片，拍照&用 iTunes & iPhoto `同步`的照片 - 不能删除)
        case SavedPhotosAlbum 相册 (自己拍照保存的, 可以随便删除)
        case Camera    相机
        */
        // 1.判断能否打开照片库
        if !UIImagePickerController.isSourceTypeAvailable( UIImagePickerControllerSourceType.PhotoLibrary)
        {
            print("不能打开相册")
            return
        }
        
        // 2.创建图片选择器
        let vc = UIImagePickerController()
        vc.delegate = self
        // 设置允许用户编辑选中的图片
        // 如果需要上传头像, 那么请让用户编辑后再上传
        // 这样可以得到一张正方形的图片, 以便于后期处理(圆形)
        presentViewController(vc, animated: true, completion: nil)
        
    }
    
    /**
     选中相片之后调用
     
     :param: picker      促发事件的控制器
     :param: image       当前选中的图片
     :param: editingInfo 编辑之后的图片
     */
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
      
        let newImage = image.imageWithScale(300)
        
        // 1.将当前选中的图片添加到数组中
        pictureImages.append(newImage)
        collcetionView.reloadData()
        
        
        // 注意: 如果实现了该方法, 需要我们自己关闭图片选择器
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func photoDidRemoveSelector(cell: PhotoSelectorCell) {
        // 1.从数组中移除"当前点击"的图片
        let indexPath = collcetionView.indexPathForCell(cell)
        pictureImages.removeAtIndex(indexPath!.item)
        // 2.刷新表格
        collcetionView.reloadData()
    }
}

//创建协议
@objc
protocol PhotoSelectorCellDelegate : NSObjectProtocol
{
    optional func photoDidAddSelector(cell: PhotoSelectorCell)
    optional func photoDidRemoveSelector(cell: PhotoSelectorCell)
}


class PhotoSelectorCell: UICollectionViewCell {
    
    weak var PhotoCellDelegate: PhotoSelectorCellDelegate?
    
    var image: UIImage?
        {
        didSet{
            if image != nil{
                removeButton.hidden = false
                addButton.setBackgroundImage(image!, forState: UIControlState.Normal)
                addButton.userInteractionEnabled = false
            }else
            {
                removeButton.hidden = true
                addButton.userInteractionEnabled = true
                addButton.setBackgroundImage(UIImage(named: "compose_pic_add"), forState: UIControlState.Normal)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    private func setupUI()
    {
        // 1.添加子控件
        contentView.addSubview(addButton)
        contentView.addSubview(removeButton)
        
        
        // 2.布局子控件
        addButton.translatesAutoresizingMaskIntoConstraints = false
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        var cons = [NSLayoutConstraint]()
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[addButton]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["addButton": addButton])
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[addButton]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["addButton": addButton])
        
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:[removeButton]-2-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["removeButton": removeButton])
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-2-[removeButton]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["removeButton": removeButton])
        
        contentView.addConstraints(cons)
    }
    
    // MARK: - 懒加载
    private lazy var removeButton: UIButton = {
        let btn = UIButton()
        btn.hidden = true
        btn.setBackgroundImage(UIImage(named: "compose_photo_close"), forState: UIControlState.Normal)
        btn.addTarget(self, action: #selector(PhotoSelectorCell.removeBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    private lazy  var addButton: UIButton = {
        let btn = UIButton()
        btn.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
        btn.setBackgroundImage(UIImage(named: "compose_pic_add"), forState: UIControlState.Normal)
        btn.addTarget(self, action: #selector(PhotoSelectorCell.addBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    func addBtnClick()
    {

        PhotoCellDelegate?.photoDidAddSelector!(self)
    }
    
    func removeBtnClick()
    {
   
        PhotoCellDelegate?.photoDidRemoveSelector!(self)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PhotoSelectorViewLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        super.prepareLayout()
        
        itemSize = CGSize(width: 80, height: 80)
        minimumInteritemSpacing  = 10
        minimumLineSpacing = 10
        sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
    }
}