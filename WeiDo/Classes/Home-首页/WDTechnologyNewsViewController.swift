//
//  WDTechnologyNewsViewController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/3/11.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import AFNetworking
import MJRefresh

let WDTechnologyNewsWillOpen = "WDTechnologyNewsWillOpen"

class WDTechnologyNewsViewController: UITableViewController {

    /// 数据源
    var technologyNew = [WDNews]()
    /// header
    var header:MJRefreshNormalHeader{
        return (self.tableView.tableHeaderView as? MJRefreshNormalHeader)!
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
        setupTableView()
        loadNews()
        
        //添加通知
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openBrowser:", name: WDTechnologyNewsWillOpen, object: nil)

    }
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
    }
    
    /**
     打开网页
     */
    func openBrowser(notify: NSNotification)
    {
        guard let urls = notify.userInfo![WDTechnologyNewsWillOpen] as? String else
        {
            return
        }
        print(urls)
        let url = NSURL(string: urls)
        let request = NSURLRequest(URL: url!)
        
        let vc = WDWebBrowserViewController(request:request)
        let nav = UINavigationController(rootViewController: vc)
        presentViewController(nav, animated: true, completion: nil)
        
        
    }
    
    
    func setupNavigation()
    {
        navigationItem.title = "科技新闻"
        let navigationTitleAttribute : NSDictionary = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName)
        self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as? [String : AnyObject]
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: "back")
        navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        
    }
    
    func setupTableView()
    {
        tableView.contentInset = UIEdgeInsetsMake(-55 , 0, 49, 0)
        tableView.rowHeight = 200
        tableView.registerNib(UINib(nibName: "WDNewsCell", bundle: nil), forCellReuseIdentifier: WDNewCellReuseIdentifier)
        
    }
    
    func  loadNews()
    {
        /**
        上拉刷新
        */
        tableView.tableHeaderView = MJRefreshNormalHeader.init(refreshingBlock: { () -> Void in
            let path = "http://api.huceo.com/keji/"
            let params = ["key":"28874a32bce9a4b984c57c3538e68809","num":20]
            let manager = AFHTTPSessionManager()
            manager.GET(path, parameters: params, progress: nil, success: { (_, JSON) -> Void in
                
                let sportarray = JSON!["newslist"] as! [[String:AnyObject]]
                self.technologyNew =  WDNews.LoadNews(sportarray)
                
                self.tableView.reloadData()
                self.header.endRefreshing()
                
                }) { (_, error) -> Void in
                    print(error)
            }
            
        })
        header.automaticallyChangeAlpha = true
        header.beginRefreshing()
        
        
    }
    
    func back()
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    


    // MARK: - Table view data source


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.technologyNew.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(WDNewCellReuseIdentifier, forIndexPath: indexPath) as! WDNewsCell
        let data = technologyNew[indexPath.row]
        cell.technologynew = data
        return cell

      }

}
