//
//  WDByMeTableViewController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/3/6.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import AFNetworking
import MJRefresh

class WDByMeTableViewController: UITableViewController {
    //数据源
    var byMe = [WDByMe]()
    /// header
    var header:MJRefreshNormalHeader{
        return (self.tableView.tableHeaderView as? MJRefreshNormalHeader)!
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableview()
        setUpRefrshControl()

       
    }
    
    
   func setupTableview()
   {
    tableView.scrollIndicatorInsets = self.tableView.contentInset
    tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
    tableView.contentInset = UIEdgeInsetsMake(-55 , 0, 49, 0)
    tableView.registerNib(UINib(nibName: "WDMessageCell", bundle: nil), forCellReuseIdentifier: WDMessageCellReuseIdentifier)
    tableView.rowHeight = 60 

    
    }
    /**
     上拉刷新
     */
    func setUpRefrshControl()
    {
        /**
        上拉刷新
        */
        tableView.tableHeaderView = MJRefreshNormalHeader.init(refreshingBlock: { () -> Void in
            
            let path = "https://api.weibo.com/2/comments/by_me.json"
            let params = ["access_token": userAccount.loadAccount()!.access_token!]
            let manager = AFHTTPSessionManager()
            manager.GET(path, parameters: params, progress: nil, success: { (_, JSON) -> Void in
                
                let byMeArray = JSON!["comments"] as! [[String:AnyObject]]
                self.byMe = WDByMe.LoadByMe(byMeArray)
                
                self.tableView.reloadData()
                self.header.endRefreshing()

             
                }) { (_, error) -> Void in
                    print(error)
            }
            
        })
        header.automaticallyChangeAlpha = true
        header.beginRefreshing()
        
        
    }

  

    // MARK: - Table view data source

  

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return byMe.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(WDMessageCellReuseIdentifier, forIndexPath: indexPath) as! WDMessageCell
        let byMeData =  byMe[indexPath.row]
        cell.ByMe = byMeData
        return cell
    }
  
  

}
