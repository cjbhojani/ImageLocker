//
//  BaseVC.swift
//  Denny
//
//  Created by Darshan Gajera on 11/26/16.
//  Copyright © 2016 . All rights reserved.
//

import Foundation
import UIKit
import CoreData
import SDWebImage
import Reachability
import UserNotifications
import UserNotificationsUI
import MessageUI
import QuartzCore
import CoreLocation
import EventKit
import MBProgressHUD
import SQLite3
import RxSwift
import RxCocoa


//swiftlint:disable all
typealias LeftButton = (_ left: UIButton) -> Void
typealias RightButton = (_ right: UIButton) -> Void
//@available(iOS 13.0, *)
class ClosureSleeve {
    let closure: () -> ()
    
    init(attachTo: AnyObject, closure: @escaping () -> ()) {
        self.closure = closure
        objc_setAssociatedObject(attachTo, "[\(arc4random())]", self, .OBJC_ASSOCIATION_RETAIN)
    }
    @objc func invoke() {
        closure()
    }
}
//@available(iOS 13.0, *)
class BaseVC: UIViewController,MFMailComposeViewControllerDelegate, UITextFieldDelegate {
    let activity = UIActivityIndicatorView()
    let locationManager = CLLocationManager()
    var imgEmptyDataSet = UIImage()
    var titleEmptyDataSet = String()
    var currentLatitude = String()
    var currentLongitude = String()
    let network = NetworkManager.sharedInstance
    var db: OpaquePointer?
    
    func adjustUITextViewHeight(arg : UITextView)
    {
        arg.translatesAutoresizingMaskIntoConstraints = true
        arg.sizeToFit()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
//        KeyboardAvoiding.avoidingView = self.view

        if #available(iOS 13, *)
        {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
                
            let statusBar = UIView(frame: window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
            statusBar.backgroundColor = UIColor.AppColor()
            window?.addSubview(statusBar)
        }
        else{
            UIApplication.shared.statusBarView?.backgroundColor = UIColor.AppColor()
        }
        
        self.hideKeyboardWhenTappedAround()
        if Connectivity.isConnectedToInternet {
        } else {
            let noConnection = Storyboard.main.storyboard().instantiateViewController(withIdentifier: Identifier.NoConnection.rawValue) as! NoConnectionVC
            self.present(noConnection, animated: true, completion: nil)
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        network.reachability.whenUnreachable = { reachability in
            let noConnection = Storyboard.main.storyboard().instantiateViewController(withIdentifier: Identifier.NoConnection.rawValue) as! NoConnectionVC
            self.present(noConnection, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showLoading(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    
    func hideLoading(){
//        self.activity.removeFromSuperview()
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (_) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func drawLIne(label : UILabel)
    {
        let labelLine = UILabel(frame: CGRect(x: 0 , y: label.frame.height / 2, width: label.frame.width, height: 1))
        labelLine.backgroundColor = UIColor.darkGray
        label.addSubview(labelLine)
    }
    
    
    
    // MARK: Navigation
    func setNavigationBar(title : NSString? ,
                          titleImage : UIImage?,
                          leftImage : UIImage? ,
                          rightImage : UIImage?,
                          leftTitle : String?,
                          rightTitle : String?,
                          isLeft : Bool ,
                          isRight : Bool,
                          isLeftMenu : Bool ,
                          isRightMenu : Bool ,
                          bgColor : UIColor ,
                          textColor : UIColor,
                          isStatusBarSame: Bool,
                          leftClick : @escaping LeftButton ,
                          rightClick : @escaping RightButton)  {
        
        if isStatusBarSame {
            if #available(iOS 13, *)
            {
                let statusBar = UIView(frame: (UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame)!)
                statusBar.backgroundColor = UIColor.AppColor()
                UIApplication.shared.keyWindow?.addSubview(statusBar)
            }
            else{
                UIApplication.shared.statusBarView?.backgroundColor = UIColor.AppColor()
            }
        }
        
        self.navigationController?.navigationBar.clipsToBounds = true
        self.navigationItem.hidesBackButton = true
        // Left Item
        let btnLeft : UIButton = UIButton(type: .custom)
        btnLeft.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        btnLeft.imageView?.contentMode = .scaleAspectFit
        let addImg = leftImage
        if leftTitle != nil {
            btnLeft.setTitle(leftTitle, for: .normal)
            self.addConstaintsWithWidth(width: 50, height: 30, btn: btnLeft)
        } else {
            btnLeft.setImage(addImg, for: .normal)
            self.addConstaintsWithWidth(width: 30, height: 30, btn: btnLeft)
        }
        btnLeft.sendActions(for: .touchUpInside)
        let leftBarItem : UIBarButtonItem = UIBarButtonItem(customView: btnLeft)
        if isLeft {
            self.navigationItem.leftBarButtonItem = leftBarItem
        }
        if isLeftMenu {
            btnLeft.addTarget(self, action: #selector(btnLeftMenuOpen(sender:)), for: .touchUpInside)
        }
        else
        {
            btnLeft.addAction {
                leftClick(btnLeft)
            }
        }
        
        // right item
        let btnRight : UIButton = UIButton(type: .custom)
        btnRight.frame = CGRect(x: self.view.frame.size.width, y: 0, width: 25, height: 25)
        btnRight.imageView?.contentMode = .scaleAspectFit
        let addImg1 = rightImage
        if rightTitle != nil {
            btnRight.frame = CGRect(x: self.view.frame.size.width, y: 0, width: 50, height: 30)
            btnRight.titleLabel?.setSizeFont(font: AppFont.Avenir.rawValue, sizeFont: 18.0)
            btnRight.setTitleColor(UIColor.white, for: .normal)
            btnRight.setTitle(rightTitle, for: .normal)
        } else {
            self.addConstaintsWithWidth(width: 30, height: 30, btn: btnRight)
            btnRight.setImage(addImg1, for: .normal)
        }
        
        btnRight.sendActions(for: .touchUpInside)
        
        let rightBarItem : UIBarButtonItem = UIBarButtonItem(customView: btnRight)
        if isRight {
            self.navigationItem.rightBarButtonItem = rightBarItem
        }
        if isRightMenu {
            btnRight.addTarget(self, action: #selector(btnRightMenuOpen(sender:)), for: .touchUpInside)
        }
        else
        {
            btnRight.addAction {
                rightClick(btnRight)
            }
        }
        
        // title
        if title == nil {
            let imgViewTitle = UIImageView(frame: CGRect(x: self.view.frame.size.width/2-50, y: self.view.frame.size.height/2-40, width:20, height: 40.0)) as UIImageView
            imgViewTitle.backgroundColor = UIColor.clear
            imgViewTitle.contentMode = .scaleAspectFit
            imgViewTitle.image = titleImage
            self.navigationItem.titleView = imgViewTitle
        } else {
            let  lblNavigationTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40.0)) as UILabel
            lblNavigationTitleLabel.text = title! as String
            lblNavigationTitleLabel.font = UIFont.boldSystemFont(ofSize: 18.0   )
            lblNavigationTitleLabel.textColor = textColor
            lblNavigationTitleLabel.textAlignment = .center
            lblNavigationTitleLabel.frame = CGRect(x: 100, y: 0, width: 100, height: 100)
            self.navigationItem.titleView = lblNavigationTitleLabel
        }
        
        
        self.navigationController?.navigationBar.barTintColor = bgColor
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    func animateTable(tblView : UITableView) {
        tblView.reloadData()
        
        let cells = tblView.visibleCells
        let tableHeight: CGFloat = tblView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animate(withDuration: 1, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
            }, completion: nil)
            index += 1
        }
    }
    
    @objc func btnLeftMenuOpen(sender: UIButton) {
        
//        panel?.openLeft(animated: true)
    }
    
    @objc func btnRightMenuOpen(sender: UIButton) {
        
    }

    func addConstaintsWithWidth(width: CGFloat ,height: CGFloat, btn: UIButton) {
        NSLayoutConstraint(item: btn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width).isActive = true
        NSLayoutConstraint(item: btn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height).isActive = true
    }
    
    func addEventToCalendar(title: String, description: String?, startDate: Date, endDate: Date,location: EKStructuredLocation, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        let eventStore = EKEventStore()
        let dayBefore = startDate.addingTimeInterval(-1*24*60*60)
        let alermOneDayBefore = EKAlarm(absoluteDate: dayBefore)
        
        let hourBefore = startDate.addingTimeInterval(-1*60*60)
        let alermOneHourBefore = EKAlarm(absoluteDate: hourBefore)
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate
                event.endDate = endDate
                event.notes = description
                event.structuredLocation = location
                event.alarms = [alermOneDayBefore, alermOneHourBefore]
                event.calendar = eventStore.defaultCalendarForNewEvents
                do{
                    try eventStore.save(event, span: .thisEvent)
                } catch let e as NSError {
                    completion?(false, e)
                    return
                }
                completion?(true, nil)
            } else {
                completion?(false, error as NSError?)
            }
        })
    }
    
    //MARK: App functions
    func openAppPage() {
        guard let url = URL(string: GlobalConstants.APPURL) else {
            return //be safe
        }
        
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
       
    }
    
    
    // Folder method
    func listFilesFromDocumentsFolder() -> [String]? {
        let fileMngr = FileManager.default;
        // Full path to documents directory
        let docs = fileMngr.urls(for: .documentDirectory, in: .userDomainMask)[0].path
        // List all contents of directory and return as [String] OR nil if failed
        return try? fileMngr.contentsOfDirectory(atPath:docs)
    }
    
    func listFilesFromFolder(str: String) -> [String]? {
        let fileMngr = FileManager.default;
        // Full path to documents directory
        let docs = fileMngr.urls(for: .documentDirectory, in: .userDomainMask)[0].path
        // List all contents of directory and return as [String] OR nil if failed
        return try? fileMngr.contentsOfDirectory(atPath:String(format: "%@/%@", docs,str))
    }
    
    func getImageFromName(str: String) -> UIImage?
    {
        let fileMngr = FileManager.default;
        // Full path to documents directory
        let docs = fileMngr.urls(for: .documentDirectory, in: .userDomainMask)[0].path
        // List all contents of directory and return as [String] OR nil if failed
        let imageURL =
            URL(fileURLWithPath: docs).appendingPathComponent(str, isDirectory: false)
        let image = UIImage(contentsOfFile: imageURL.path)
        return image
    }
    
    
    func deleteDirectory(str: String)-> Bool{
        
        let fileMngr = FileManager.default;
        let docs = fileMngr.urls(for: .documentDirectory, in: .userDomainMask)[0].path
        let strPath = String(format: "%@/%@", docs,str)
        if fileMngr.fileExists(atPath: strPath){
            try! fileMngr.removeItem(at: URL(string: "file://\(strPath)")!)
            return true
        }else{
            print("Something wrong.")
            return false
        }
    }
    
    func saveImageDocumentDirectory(img: UIImage, strFileName: String, strFolderName: String){
        let fileMngr = FileManager.default;
        let paths = "\(fileMngr.urls(for: .documentDirectory, in: .userDomainMask)[0].path)/\(strFolderName)/\(strFileName)"
        print(paths)
        let imageData = img.jpegData(compressionQuality: 1.0)
        fileMngr.createFile(atPath: paths as String, contents: imageData, attributes: nil)
    }
    
    func shareApp() {
        
        let text = String(format: "You have been invited to use %@, I love using %@, It's simple and incredible, You should try it here : %@",GlobalConstants.APPNAME ,GlobalConstants.APPNAME,GlobalConstants.APPURL)
        let shareAll = [text]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
}
//@available(iOS 13.0, *)
extension UIControl {
    func addAction(for controlEvents: UIControl.Event = .primaryActionTriggered, action: @escaping () -> ()) {
        let sleeve = ClosureSleeve(attachTo: self, closure: action)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
    }
}
@available(iOS 13.0, *)
extension BaseVC: CLLocationManagerDelegate {
    // Location
    func currentLocation() {
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func configuredMailComposeViewController(strMail: String) {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([strMail])
        mailComposerVC.setSubject("noriu tapti profesionalu")
        mailComposerVC.setMessageBody("Aprašykite savo astrologo patirtį: \n Bendra patirtis:", isHTML: false)
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposerVC, animated: true, completion: nil)
        }
    }
    
    func removeAllPreference() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
}

@IBDesignable
class DesignableUITextField: UITextField {

    // Provides left padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }

    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }

    @IBInspectable var leftPadding: CGFloat = 0

    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }

    func updateView() {
        if let image = leftImage {
            leftViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 12, height: 12))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = color
            leftView = imageView
        } else {
            leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }

        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: color])
    }
}

extension BaseVC : UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension URL {
    static func createFolder(folderName: String) -> URL? {
        let fileManager = FileManager.default
        // Get document directory for device, this should succeed
        if let documentDirectory = fileManager.urls(for: .documentDirectory,
                                                    in: .userDomainMask).first {
            // Construct a URL with desired folder name
            let folderURL = documentDirectory.appendingPathComponent(folderName)
            // If folder URL does not exist, create it
            print(folderURL)
            if !fileManager.fileExists(atPath: folderURL.path) {
                do {
                    // Attempt to create folder
                    try fileManager.createDirectory(atPath: folderURL.path,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
                } catch {
                    // Creation failed. Print error & return nil
                    print(error.localizedDescription)
                    return nil
                }
            }
            // Folder either exists, or was created. Return URL
            return folderURL
        }
        // Will only be called if document directory not found
        return nil
    }
}
