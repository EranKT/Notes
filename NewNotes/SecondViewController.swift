//
//  SecondViewController.swift
//  NewNotes
//
//  Created by EKT DIGIDESIGN on 11/2/17.
//  Copyright © 2017 EKT DIGIDESIGN. All rights reserved.
//


import UIKit
import GoogleMobileAds

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, GADBannerViewDelegate {
 
 // this array keep list for each item in main menu
    var _arrayOfSubLists = [Array<Any>]()
    var _arrayOfpricesLists = [Array<Any>]()

    var _currentViewList = [String]()
    var _pricesArray = [Double]()
    var _indexForCurrentListInMainList = Int()
    
    @IBOutlet weak var _secondTableView: UITableView!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var _inputField: UITextField!
    @IBOutlet weak var _priceLabel: UILabel!
    
    @IBOutlet weak var _viewForBanner: UIView!
    ////// VIEW DID LOAD
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        _secondTableView.register(SecondTableCell.classForCoder(), forCellReuseIdentifier: "_MyCell2")
        let request: GADRequest!
        request =  GADRequest()
        let requestTestList = ["acc8f37f622185236d1f09abd03f2b5d",
                               "df9dfa5edaf80f86ba79f3ad4b8787d9",
                               "9f7ea1062afad6bf37c91212c5e228c4159e26a6",
                               "461383f79e6c870f0b8ff22d30d1368b",
                               "b0438b8c5bcb180bc6e70a0590e9bf01"]
        
        request.testDevices = requestTestList
        adBannerView.load(request)
        //  adBannerView.load(GADRequest())
        
        _inputField.delegate = self
        //self.textFieldShouldReturn(myInputField)
        // myInputField.textField.delegate = self

        let defaults: UserDefaults = UserDefaults.standard
        let indexStr = defaults.value(forKey: "selectedIndex") as? String
        _indexForCurrentListInMainList = Int(indexStr!)!
        
        let _listIdentity = "MyArchiveArray2FilePath"
        let _pricesListIdentity = "MyArchiveArray3FilePath"
        if UserDefaults.standard.value(forKey: _listIdentity) != nil
        {
            _arrayOfSubLists = (UserDefaults.standard.value(forKey: _listIdentity) as! [Array])
            _arrayOfpricesLists = (UserDefaults.standard.value(forKey: _pricesListIdentity) as! [Array])
            _currentViewList = _arrayOfSubLists[_indexForCurrentListInMainList] as! [String]
            _pricesArray = _arrayOfpricesLists[_indexForCurrentListInMainList] as! [Double]
      
            // add place holders for prices incase of app update
            for _ in 0 ..< _currentViewList.count
            {
                if _pricesArray.count < _currentViewList.count
                {
                    _pricesArray.append(0)
                    if _pricesArray.count == _currentViewList.count{break}

                }
            }
        }
        self.saveData()
        self.didRotate(from: UIInterfaceOrientation.portrait)
    }
    
/////////// TABLE VIEW
    // BUG: when adding this method disapear
    // public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
   //     return 150
   // }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (_currentViewList.count)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = _secondTableView.dequeueReusableCell(withIdentifier: "_MyCell2", for: indexPath) as! SecondTableCell
        cell.backgroundColor = UIColor.init(red: 0, green: 0.8, blue: 0.1, alpha: 0.3)

        cell.textLabel?.text = _currentViewList[indexPath.row]
        if _pricesArray[indexPath.row] != 0
        {
            let x = _pricesArray[indexPath.row]
            let y = Double(round(100*x)/100)
           // cell.priceLabel.text = String(describing: _pricesArray[indexPath.row])
        cell.priceLabel.text = "\(y)"
        }
        else
        {
        cell.priceLabel.text = " "
        }
        return cell
    }
 /// ////////// EDIT ITEMS IN TABLE
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
  
        //<< EDIT TEXT ACTION
      let editTextAction = UITableViewRowAction(style: .normal, title: "Name", handler: { (action, indexPath) in
            let alert = UIAlertController(title: "", message: "Set text", preferredStyle: .alert)
            
            alert.addTextField(configurationHandler: { (textField) in
                self._inputField.text = ""
            })
            alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { (updateAction) in

                self._currentViewList[indexPath.row] = alert.textFields!.first!.text!
                self._secondTableView.reloadRows(at: [indexPath], with: .fade)
                
                 self.saveData()
                
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: false)
        })
        editTextAction.backgroundColor = UIColor.magenta
  //>> EDIT TEXT ACTION

        //<< EDIT PRICE ACTION
        let editPriceAction = UITableViewRowAction(style: .normal, title: "Price", handler: { (action, indexPath) in
            let alert = UIAlertController(title: "", message: "Set price", preferredStyle: .alert)
            
            alert.addTextField(configurationHandler: { (textField) in
             textField.keyboardType = UIKeyboardType.decimalPad
            })
            alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { (updateAction) in
                let floatPrice = Double((alert.textFields!.first!.text! as NSString).floatValue)
                let y = Double(round(100*floatPrice)/100)
                print(y)
                self._pricesArray[indexPath.row] = y
                self._secondTableView.reloadRows(at: [indexPath], with: .fade)
            
            self.saveData()
                
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: false)
        })
        
        editPriceAction.backgroundColor = UIColor.blue
      //>> EDIT PRICE ACTION
        //<< DELETE ACTION
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            self._currentViewList.remove(at: indexPath.row)
            self._pricesArray.remove(at: indexPath.row)
            self.saveData()
        })
        
        let resetAction = UITableViewRowAction(style: .normal, title: "Reset Prices", handler: { (action, indexPath) in
        for i in 0 ..< self._pricesArray.count
        {
            self._pricesArray[i] = 0.0
            }
            self.saveData()
        })
        resetAction.backgroundColor = UIColor.brown
//>> DELETE ACTION
        return [deleteAction,editTextAction, editPriceAction, resetAction]
    }
 
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    { 
        let val = true
        return val
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var item :String!
        item = _currentViewList[sourceIndexPath.row]
        self._currentViewList.remove(at: sourceIndexPath.row)
        self._currentViewList.insert(item, at: destinationIndexPath.row)
        var price :Double!
        price = _pricesArray[sourceIndexPath.row]
        self._pricesArray.remove(at: sourceIndexPath.row)
        self._pricesArray.insert(price, at: destinationIndexPath.row)
        
        self.saveData()
    }

    
    //REFRESH TABLE
    override func viewDidAppear(_ animated: Bool)
    {
        _secondTableView.reloadData()
    }
///////////// BUTTONS //////////////////
    //// EDIT BUTTON
    @IBAction func EditButton(_ sender: Any)
    {
        let rightItem: UIBarButtonItem
        
        let val = true
        _secondTableView.setEditing(!_secondTableView.isEditing, animated:val)
        
        if (_secondTableView.isEditing)
        {
            rightItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(SecondViewController.EditButton(_:)))
        }
        else
        {
            rightItem = UIBarButtonItem(title: "Reorder", style: .plain, target: self, action: #selector(SecondViewController.EditButton(_:)))
        }
        
        navBar.rightBarButtonItem = rightItem;

        self.saveData()
    }
    //// ADD BUTTON
    @IBAction func addButton(_ sender: Any)
    {
        self.addNewItemToList()
        _inputField.resignFirstResponder()
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        self.addNewItemToList()
        textField.resignFirstResponder()
        return true
    }
    
    func addNewItemToList() {
        if (_inputField.text != "")
        {
            _currentViewList.append(_inputField.text!)
            _pricesArray.append(0)
            _inputField.text = ""
            
            self.saveData()
        }
    }
    
    func setTitle() {
        
        let identityOriginalList = "MyArchiveArrayFilePath"
        var originalList = (UserDefaults.standard.value(forKey: identityOriginalList) as! [String])
        let totalPrice = _pricesArray.reduce(0, +)
        let strPrice: String
        let title: String
        
        if totalPrice == 0{
            strPrice = ""
            title = originalList[self._indexForCurrentListInMainList]
  }
        else
        {
            strPrice = String(describing: totalPrice)
            title = strPrice
        }
        
        self.navBar.title = title
    }
    
    func saveData()
    {
        self.setTitle()
        _secondTableView.reloadData()

        let _listIdentity = "MyArchiveArray2FilePath"
        let _pricesListIdentity = "MyArchiveArray3FilePath"

        _arrayOfSubLists[_indexForCurrentListInMainList] = _currentViewList
        _arrayOfpricesLists[_indexForCurrentListInMainList] = _pricesArray
        UserDefaults.standard.setValue(_arrayOfSubLists, forKey: _listIdentity)
        UserDefaults.standard.setValue(_arrayOfpricesLists, forKey: _pricesListIdentity)
    }
    
  
    @IBAction func BackButton(_ sender: Any)
    {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        guard let rootViewController = window.rootViewController else {
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FirstViewController")
        vc.view.frame = rootViewController.view.frame
        vc.view.layoutIfNeeded()
        
        UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromLeft, animations:
            {
                window.rootViewController = vc
        }, completion: { completed in
        })
        
        ////////////////////////////////>> REPLACE VIEW WITH TRANSITION //////////////////////////////////////

        
    }
    
    
    
    
    //ADS CODE
    lazy var adBannerView: GADBannerView = {
        let adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        adBannerView.adUnitID = "ca-app-pub-4450381878329799/3303179267"
        adBannerView.delegate = self
        adBannerView.rootViewController = self
        
        return adBannerView
    }()
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")

        _viewForBanner.frame = CGRect.init(x: self.view.frame.width/2 - bannerView.frame.width/2,
                                           y: self.view.frame.height - bannerView.frame.height,
                                           width: bannerView.frame.width,
                                           height: bannerView.frame.height)
        _viewForBanner.addSubview(bannerView)

        //  _secondTableView.tableHeaderView?.frame = bannerView.frame
      //  _secondTableView.tableHeaderView = bannerView
        
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        //    print("ROTATED")
        _viewForBanner.frame = CGRect.init(x: self.view.frame.width/2 - adBannerView.frame.width/2,
                                           y: self.view.frame.height - adBannerView.frame.height,
                                           width: adBannerView.frame.width,
                                           height: adBannerView.frame.height)
        _viewForBanner.addSubview(adBannerView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

