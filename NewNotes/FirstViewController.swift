//
//  FirstViewController.swift
//  NewNotes
//
//  Created by EKT DIGIDESIGN on 11/2/17.
//  Copyright © 2017 EKT DIGIDESIGN. All rights reserved.
//



import UIKit
import GoogleMobileAds

let APP_ADS_ID = "ca-app-pub-4450381878329799~7501933738"
let APP_ADS_UNIT_ID = "ca-app-pub-4450381878329799/5931144848"


class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, GADBannerViewDelegate {
      
    var _list1 = [String]()
    var _list2 = [Array<Any>]()
    var _pricesArrays = [Array<Any>]()

    @IBOutlet weak var myInputField: UITextField!
    @IBOutlet weak var _myTableView: UITableView!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var button: UINavigationItem!

    @IBOutlet weak var _viewForBanner: UIView!
    ////// VIEW DID LOAD
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        _myTableView.register(SecondTableCell.classForCoder(), forCellReuseIdentifier: "_myCell")

        let request: GADRequest!
        request =  GADRequest()
        let requestTestList = ["acc8f37f622185236d1f09abd03f2b5d",
                               "df9dfa5edaf80f86ba79f3ad4b8787d9",
                               "9f7ea1062afad6bf37c91212c5e228c4159e26a6",
                               "461383f79e6c870f0b8ff22d30d1368b",
                               "b0438b8c5bcb180bc6e70a0590e9bf01"]
        
        request.testDevices = requestTestList
        adBannerView.load(request)
        
        myInputField.delegate = self

        let identity = "MyArchiveArrayFilePath"
        let identity2 = "MyArchiveArray2FilePath"
        let identity3 = "MyArchiveArray3FilePath"

        if UserDefaults.standard.value(forKey: identity) != nil
        {
            _list1 = (UserDefaults.standard.value(forKey: identity) as! [String])
            if UserDefaults.standard.value(forKey: identity2) != nil
            {
         _list2 = (UserDefaults.standard.value(forKey: identity2) as! [Array])
            }
            else
            {
                // create the array to avoid crash on update
                for _ in _list1
                {
                    _list2.append([])
                }
            }
            if UserDefaults.standard.value(forKey: identity3) != nil
            {
                _pricesArrays = (UserDefaults.standard.value(forKey: identity3) as! [Array])
            }
            else
            {
                // create the array to avoid crash on update
                for _ in _list2
                {
                    // need to add array for each list2 item
                    let newPriceArray = [CGFloat]()
                    _pricesArrays.append(newPriceArray)
                }
            }
            self.saveData()
            _myTableView.reloadData()
        }
        self.didRotate(from: UIInterfaceOrientation.portrait)
}

 ////////////////////////////////////// TABLE VIEW //////////////////////////////
    //COUNT NUMBER OF ROWS IN TABLE
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        
    {
        return (_list1.count)
    }
    
    //FILL TABLE CELLS WITH EXISTING ITEMS
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
         let cell = _myTableView.dequeueReusableCell(withIdentifier: "_myCell", for: indexPath) as! SecondTableCell
        cell.backgroundColor = UIColor.init(red: 0, green: 0.8, blue: 0.1, alpha: 0.3)
     
        cell.textLabel?.text = _list1[indexPath.row]
        let priceListForCell = _pricesArrays[indexPath.row] as! [CGFloat]
        let totalPrice = priceListForCell.reduce(0, +)
        
        if totalPrice != 0
        {
            cell.priceLabel.text = "\(totalPrice)"
        }
        else
        {
            cell.priceLabel.text = " "
        }
        return cell
    }
 // EDIT TABLE
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
   
        
        //>> EDIT TEXT ACTION
        let editTextAction = UITableViewRowAction(style: .normal, title: "Edit text", handler: { (action, indexPath) in
            let alert = UIAlertController(title: "", message: "Set text", preferredStyle: .alert)
            
            alert.addTextField(configurationHandler: { (textField) in
                self.myInputField.text = ""
            })
            alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { (updateAction) in
                
                self._list1[indexPath.row] = alert.textFields!.first!.text!
                self._myTableView.reloadRows(at: [indexPath], with: .fade)
                
                self.saveData()
                
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: false)
        })
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            self._list1.remove(at: indexPath.row)
            self._list2.remove(at: indexPath.row)
            self._pricesArrays.remove(at: indexPath.row)
            self.saveData()
            tableView.reloadData()
        })
        editTextAction.backgroundColor = UIColor.magenta
  //>> EDIT TEXT ACTION
        //>> DELETE ACTION

        
        return [deleteAction, editTextAction]
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
     {
        let val = true
        return val
    }

     func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

        var item :String!
       item = _list1[sourceIndexPath.row]
        self._list1.remove(at: sourceIndexPath.row)
        self._list1.insert(item, at: destinationIndexPath.row)
        
        //<< UPDATE SUB TABLE ARRAY ACCORDING TO NEW ORDER
        
        var item2 :Array<Any>!
                item2 = _list2[sourceIndexPath.row]
                _list2.remove(at: sourceIndexPath.row)
                _list2.insert(item2, at: destinationIndexPath.row)
       
        var item3 :Array<Any>!
                item3 = _pricesArrays[sourceIndexPath.row]
                _pricesArrays.remove(at: sourceIndexPath.row)
                _pricesArrays.insert(item3, at: destinationIndexPath.row)
        self.saveData()
        //>> UPDATE SUB TABLE ARRAY ACCORDING TO NEW ORDER
    }

     public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
      
//<< SAVE INDEX TO USER DEFAULT
        let rowNumberString:String = String(format: "%i", indexPath.row)
        let defaults: UserDefaults = UserDefaults.standard
        defaults.set(rowNumberString, forKey: "selectedIndex")
        defaults.synchronize()
//>> SAVE INDEX TO USER DEFAULT

//   LOAD SECOND TABLE VIEW
        //OLD WAY
 /*       let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
        self.present(secondViewController, animated: true, completion: nil)
   */
        ////////////////////////////////<< REPLACE VIEW WITH TRANSITION //////////////////////////////////////

        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        guard let rootViewController = window.rootViewController else {
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SecondViewController")
        vc.view.frame = rootViewController.view.frame
        vc.view.layoutIfNeeded()
        
        UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromRight, animations:
            {
            window.rootViewController = vc
        }, completion: { completed in
            // maybe do something here
        })
        
        ////////////////////////////////>> REPLACE VIEW WITH TRANSITION //////////////////////////////////////

    }
    
     public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        return indexPath
    }
 
    //EDIT BUTTON ACTION
    @IBAction func editButton(_ sender: Any)
    {
        let leftItem: UIBarButtonItem
        
        let val = true
        _myTableView.setEditing(!_myTableView.isEditing, animated:val)
        
        if (_myTableView.isEditing)
        {
            leftItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(FirstViewController.editButton(_:)))
        }
        else
        {
            leftItem = UIBarButtonItem(title: "Reorder", style: .plain, target: self, action: #selector(FirstViewController.editButton(_:)))
        }
        
        navBar.rightBarButtonItem = leftItem;
        
        _myTableView.reloadData()
        self.saveData()
        print("LIST1:",_list1)
        print("LIST2:",_list2)
        print("LIST3:",_pricesArrays)
    }

    //ADD ITEM BUTTON ACTION
    @IBAction func AddItemButton(_ sender: Any)
    {
        myInputField.resignFirstResponder()
        
        self.addNewItemToList()
    }
   
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
       
        self.addNewItemToList()
        
        return true
    }

    func addNewItemToList() {
        if (myInputField.text != "")
        {
            _list1.append(myInputField.text!)
            myInputField.text = ""
            _myTableView.reloadData()
            
            // create new eampty sub array for field
            let newListArray = [String]()
            let newPriceArray = [CGFloat]()
            _list2.append(newListArray)
            _pricesArrays.append(newPriceArray)
            
            self.saveData()
        }
    }
    
    //REFRESH TABLE
    override func viewDidAppear(_ animated: Bool)
    {
        _myTableView.reloadData()
    }
    
    func saveData()
    {
        let identity = "MyArchiveArrayFilePath"
        let identity2 = "MyArchiveArray2FilePath"
        let identity3 = "MyArchiveArray3FilePath"

        UserDefaults.standard.setValue(_list1, forKey: identity)
        UserDefaults.standard.setValue(_list2, forKey: identity2)
        UserDefaults.standard.setValue(_pricesArrays, forKey: identity3)
        UserDefaults.standard.synchronize()
    }
    
    //ADS CODE
    lazy var adBannerView: GADBannerView = {
        let adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        adBannerView.adUnitID = APP_ADS_UNIT_ID//"ca-app-pub-4450381878329799/3303179267"
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
   //     _myTableView.tableHeaderView?.frame = bannerView.frame
   //     _myTableView.tableHeaderView = bannerView
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to receive ads")
        print(error)
    }

   
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        //    print("ROTATED")
        _viewForBanner.frame = CGRect.init(x: self.view.frame.width/2 - adBannerView.frame.width/2,
                                           y: self.view.frame.height - adBannerView.frame.height,
                                           width: adBannerView.frame.width,
                                           height: adBannerView.frame.height)
        _viewForBanner.addSubview(adBannerView)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

