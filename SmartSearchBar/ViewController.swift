//
//  ViewController.swift
//  SmartSearchBar
//
//  Created by john on 3/20/16.
//  Copyright © 2016 john. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var smartSearchBar : SmartSearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController : UIScrollViewDelegate
{
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 20
        {
            smartSearchBar.changeToStatus( .Circle, screenWidth: self.view.bounds.width,scrollView : scrollView)
        }
        else
        {
            smartSearchBar.changeToStatus( .Normal, screenWidth: self.view.bounds.width,scrollView : scrollView)
        }

    }
}

extension ViewController : UITableViewDataSource
{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        cell.textLabel?.text = "\(indexPath.row + 1)"
        return cell
    }
}

