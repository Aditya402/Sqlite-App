//
//  BaseViewController.swift
//  Sqlite App
//
//  Created by Adithya on 04/12/20.
//

import UIKit
let backButtonImage = "Back"
let notoficationImage = "notificationBell"
class BaseViewController: UIViewController {
    
    var titleLabel = UILabel()
    var UsarNameText : String = ""
    var navigationTitle: String = "" {
        didSet{
            let attributedString = NSMutableAttributedString(string: navigationTitle)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1.15), range: NSRange(location: 0, length: attributedString.length))
            titleLabel.attributedText = attributedString
        }
    }
    
    var kn_tabBar: knTabBar!
    var selectedColor = UIColor.init(red: 246/255, green: 138/255, blue: 97/255, alpha: 0.57)
    
    var normalColor = UIColor.init(red: 24/255, green: 68/255, blue: 102/255, alpha: 1.0) {
        didSet {
            kn_tabBar.tintColor = UIColor.init(red: 246/255, green: 138/255, blue: 97/255, alpha: 0.57)
        }}
    var kn_tabBarHeight: CGFloat = 53
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        showNavigationtitle()
    }
    func showNavigationtitle()
    {
        titleLabel = UILabel.init(frame: CGRect(x:0,y:0,width:104,height:44))
        titleLabel.textColor = UIColor.black
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.font = UIFont.init(name: "Gotham Rounded Book", size: 15.0)
        if #available(iOS 10.0, *) {
            titleLabel.adjustsFontForContentSizeCategory = true
        }
        else
        {
            titleLabel.adjustsFontSizeToFitWidth = true
        }
        titleLabel.textAlignment = NSTextAlignment.center
        self.navigationItem.titleView = titleLabel
    }
    
    
    func showBackButton()
    {
        let backButn = UIButton.init(frame: CGRect(x:0,y:0,width:25,height:25))
        backButn.setImage(UIImage.init(named: backButtonImage), for: UIControl.State.normal)
        backButn.addTarget(self, action: #selector(backBtnTapped(sender:)), for: .touchUpInside)
        let backButtonItem = UIBarButtonItem.init(customView: backButn)
        self.navigationItem.leftBarButtonItems = [backButtonItem]
    }
    
    func resizeImage(image: UIImage, targetHeight: CGFloat) -> UIImage {
        let size = image.size
        let heightRatio = targetHeight / size.height
        let newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func hideBackButton()
    {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem()
    }
    @objc func backBtnTapped(sender:UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showRightnavigationItems()
    {
        let refreshButn = UIButton.init(frame: CGRect(x:0,y:0,width:25,height:25))
        refreshButn.setImage(UIImage.init(named: notoficationImage), for: UIControl.State.normal)
        refreshButn.addTarget(self, action: #selector(notificationButtonTapped(sender:)), for: .touchUpInside)
        let notificationButtonItem = UIBarButtonItem.init(customView: refreshButn)
        let nameView = UIView.init(frame: CGRect(x:0,y:0,width:34,height:34))
        let nameLabel = UILabel.init(frame: CGRect(x:5,y:5,width:24,height:24))
        nameLabel.text = UsarNameText.uppercased()
        nameLabel.textColor = UIColor(named: "TransactionAmountColor")
        nameLabel.font = UIFont(name: "proximanova-regular", size: 15)
        nameLabel.textAlignment = .center
        nameView.addSubview(nameLabel)
        let profileButn = UIButton.init(frame: CGRect(x:0,y:0,width:34,height:34))
        profileButn.addTarget(self, action: #selector(profileButtonTapped(sender:)), for: .touchUpInside)
        profileButn.layer.cornerRadius = profileButn.frame.size.width / 2
        profileButn.layer.masksToBounds = true
        nameView.addSubview(profileButn)
        nameView.layer.cornerRadius = nameView.frame.size.width/2
        nameView.layer.borderColor = UIColor(named: "TransactionAmountColor")?.cgColor
        nameView.layer.borderWidth = 2
        nameView.layer.masksToBounds = true
        nameView.backgroundColor = UIColor().colorWithCustomHexString(hex: "#68DFDB")
        let profileButtonItem = UIBarButtonItem.init(customView: nameView)
        self.navigationItem.rightBarButtonItems = [profileButtonItem]
    }
    
    @objc func notificationButtonTapped(sender:UIButton)
    {
    }
    
    @objc func profileButtonTapped(sender:UIButton)
    {
        
    }
    
    func showbottomBar(SIndex : Int)
    {
        let transfer = knTabBarItem(icon: #imageLiteral(resourceName: "Transactions"), title: "NOTIFICATIONS")
        let utilities = knTabBarItem(icon: #imageLiteral(resourceName: "Reports"), title: "CHAT HISTORY")
        let pay = knTabBarItem(icon: #imageLiteral(resourceName: "homebutton"), title: "")
        pay.lock = true
        pay.itemHeight = 70
        let merchants = knTabBarItem(icon: #imageLiteral(resourceName: "CC icon"), title: "SUPPORT")
        let profile = knTabBarItem(icon: #imageLiteral(resourceName: "Settings"), title: "SETTINGS")
        setTabBar(items: [transfer, utilities, pay, merchants, profile], SelectedBtn: SIndex)
    }
    
    /**
     settabbar methos is used to fix the bottomtab and height of the tab selected btn index
     
     - Parameters:
     - items: it is array of data which is applied to custom tab bar
     - height: it will fix the height in format og cgfloat
     - SelectedBtn: it is int format and based on index the tab action will be change
     */
    
    func setTabBar(items: [knTabBarItem], height: CGFloat = 55, SelectedBtn: Int)
    {
        guard items.count > 0 else { return }
        kn_tabBar = knTabBar(items: items)
        guard let bar = kn_tabBar else { return }
        kn_tabBar.tintColor = normalColor
        bar.kn_items[SelectedBtn].color = selectedColor
        let appearance = bar.standardAppearance
        appearance.shadowImage = nil
        appearance.shadowColor = UIColor.white
        bar.standardAppearance = appearance;
        bar.layer.shadowColor = UIColor.gray.cgColor
        bar.layer.shadowOffset = CGSize(width: 2, height: 10)
        bar.layer.shadowOpacity = 1
        bar.layer.shadowRadius = 10
        bar.layer.shouldRasterize = true
        view.addSubviews(views: bar)
        bar.horizontal(toView: view)
        bar.bottom(toView: view)
        kn_tabBarHeight = height
        bar.height(kn_tabBarHeight)
        for i in 0 ..< items.count {
            items[i].tag = i
            items[i].addTarget(self, action: #selector(switchTab), for: .touchUpInside)
        }
    }
    /**
     Bottom tab bar actions
     - Parameters:
     - button: it is used to navigate the from one tab to another tab by using the button tag
     */
    
    @objc func switchTab(button: UIButton)
    {
        let newIndex = button.tag
        for i in 0 ..< kn_tabBar.kn_items.count
        {
            if i == newIndex
            {
                kn_tabBar.kn_items[newIndex].color = selectedColor
            }
            else
            {
                kn_tabBar.kn_items[i].color = normalColor
            }
        }
        if(newIndex == 0)
        {
            
        }
        if(newIndex == 1)
        {
            
        }
        if(newIndex == 2)
        {
            
        }
        if(newIndex == 3)
        {
            
        }
        if(newIndex == 4)
        {
            
        }
    }
    
    /**
     addShadowEffectToTheView method is used to apply cardview of uiview
     - Parameters:
     - vw: the view which is converted into cardtype by applying cornerradius, shadowcolor, shadowoffset
     */
    
    func addShadowEffectToTheView(vw:UIView) {
        vw.layer.cornerRadius = 5
        vw.layer.shadowColor = UIColor.gray.cgColor
        vw.layer.shadowOpacity = 0.5
        vw.layer.shadowOffset = CGSize.zero
        vw.layer.shadowRadius = 5
    }
    
}
