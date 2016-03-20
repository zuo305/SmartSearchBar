//
//  DestinationListView.swift
//  cicada
//
//  Created by john on 28/08/2015.
//  Copyright (c) 2015 Cozitrip IP Pty Ltd. All rights reserved.
//

import UIKit
import GoogleMaps


extension DestinationListView : GMSAutocompleteTableDataSourceDelegate {

    func tableDataSource(tableDataSource: GMSAutocompleteTableDataSource, didFailAutocompleteWithError error: NSError) {
        print("Error")
        
    }
    
    
    
    
    
    func tableDataSource(tableDataSource: GMSAutocompleteTableDataSource, didAutocompleteWithPlace place: GMSPlace) {
        // Do something with the selected place.
        self.tableView?.hidden = true
        
        let location = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude) //changed!!!
        print(location)
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            print(location)
            
            if error != nil {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
            }
            

            
            if placemarks != nil
            {
                if placemarks!.count > 0 {
                    let pm = placemarks![0]
                    print(pm.locality)
                    print(pm.subLocality) // neighborhood, common name, eg. Mission District
                    print(pm.name) // eg. Apple Inc.
                    print(pm.thoroughfare) // street name, eg. Infinite Loop
                    print(pm.subThoroughfare) // eg. 1
                    print(pm.administrativeArea) // state, eg. CA
                    print(pm.subAdministrativeArea)// county, eg. Santa Clara
                    print(pm.postalCode) // zip code, eg. 95014
                    print(pm.ISOcountryCode) // eg. US
                    print(pm.country) // eg. United States
                    print(pm.inlandWater) // eg. Lake Tahoe
                    print(pm.ocean) // eg. Pacific Ocean
                    print(pm.areasOfInterest) // eg. Golden Gate Park
                    //                    self.cityTextField.setAnimationText(pm.locality)
                    
                }
                else {
                    print("Problem with the data received from geocoder")
                }
            }
            
            
        })

        
        
        

    }
    
    func didRequestAutocompletePredictionsForTableDataSource(tableDataSource: GMSAutocompleteTableDataSource) {
        self.tableView?.reloadData()
    }
    
    func didUpdateAutocompletePredictionsForTableDataSource(tableDataSource: GMSAutocompleteTableDataSource) {
        self.tableView?.reloadData()
    }
    
    
    
    func tableDataSource(tableDataSource: GMSAutocompleteTableDataSource!, didAutocompleteWithError error: NSError!) {
        // TODO: Handle the error.
        print("Error: \(error.description)")
    }
    
}



class DestinationListView: UIView {
    
    var tableView : UITableView?
    var lastSelectedCell: UITableViewCell? = nil
    var isFiltered: Bool = false
    
    var inputString : String?
    
    var tableDataSource : GMSAutocompleteTableDataSource?

    
    func setTableViewHeight()
    {
        self.tableView?.layoutIfNeeded()
        if let tableViewSize=self.tableView?.contentSize
        {
            self.tableView?.frame =  CGRectMake((self.tableView?.frame.origin.x)!,(self.tableView?.frame.origin.y)!,tableViewSize.width,tableViewSize.height)
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.width, (self.tableView?.frame.height)!)
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView = UITableView(frame: self.bounds)
        tableDataSource = GMSAutocompleteTableDataSource()
        tableDataSource?.delegate = self
        
        tableView!.delegate = tableDataSource
        tableView!.dataSource = tableDataSource
        
        tableView!.hidden = true
        
        tableView!.separatorColor = UIColor.clearColor()
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.width, self.frame.height)
        self.addSubview(tableView!)
        self.clipsToBounds = true
        self.backgroundColor = UIColor.whiteColor()
        
        self.tableView?.addObserver(self, forKeyPath: "contentOffset", options: .New , context: nil)
        
        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
  

        
        if keyPath == "contentOffset"  , let scrollview = object as? UIScrollView
        {
            let newContentOffset = scrollview.contentOffset
            if newContentOffset.y > 0 || newContentOffset.y < 0
            {
                UIApplication.sharedApplication().keyWindow?.endEditing(true)
            }
        }
        
    }
    
    
    
    deinit {
        self.tableView?.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func searchByGoogle(inputString : String?)
    {
        self.tableView?.hidden = false
        tableDataSource?.sourceTextHasChanged(inputString)
    }
    
    
    
    
}

