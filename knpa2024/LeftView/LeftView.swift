import UIKit
import FontAwesome_swift
import UserNotifications

let leftViewContentViewWidth = SCREEN.WIDTH * 0.8

class LeftView: UIView {
    
    var grayView : UIView!
    var contentView : UIView!
    
    var tableView : UITableView!
    var selectedIndex = -1
    
    var loginButton : LoginButton!
    var settingButton : SettingButton!
    var favoriteButton : FavoriteButton!
    
    
    
    
    var favoriteButton1: FavoriteButton!
    var loginButton1: LoginButton!
    var logoutButton : LogoutButton!
    var naviBarHomeButton : UIButton!
    
    convenience init() {
        self.init(frame: SCREEN.BOUND)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        grayView = UIView(frame: SCREEN.BOUND)
        grayView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        grayView.isUserInteractionEnabled = false
        self.addSubview(grayView)
        
        //이동 대상
        contentView = UIView(frame: SCREEN.BOUND)
        contentView.backgroundColor = UIColor.clear
        contentView.isUserInteractionEnabled = true
        self.addSubview(contentView)
        
        let grayCloseButton = UIButton(frame: self.bounds)
        grayCloseButton.addTarget(event: UIControl.Event.touchUpInside) { [weak self] (button) in
            self?.close()
        }
        contentView.addSubview(grayCloseButton)
        
        let statusBar = UIView(frame: CGRect(x: 0, y: 0, width: leftViewContentViewWidth, height: STATUS_BAR_HEIGHT))
        statusBar.backgroundColor = #colorLiteral(red: 0.2018063664, green: 0.1636839807, blue: 0.5171515942, alpha: 1)
//        rgb 72 119 45
        contentView.addSubview(statusBar)
        
        let naviBar = UIView(frame: CGRect(x: 0, y: statusBar.frame.maxY, width: leftViewContentViewWidth, height: NAVIGATION_BAR_HEIGHT))
        naviBar.backgroundColor = #colorLiteral(red: 0.2018063664, green: 0.1636839807, blue: 0.5171515942, alpha: 1)
        contentView.addSubview(naviBar)
        
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        
        //        let closeButton = UIButton(frame: CGRect(x: naviBar.frame.size.width - naviBar.frame.size.height, y: 0, width: naviBar.frame.size.height, height: naviBar.frame.size.height))
        //        naviBar.addSubview(closeButton)
        //        closeButton.addTarget(event: .touchUpInside) { [weak self] (butotn) in
        //            self?.close()
        //        }
        
        let closeButtonImageBackView = UIView(frame: CGRect(x: leftViewContentViewWidth, y: STATUS_BAR_HEIGHT, width: SCREEN.WIDTH - leftViewContentViewWidth, height: naviBar.frame.size.height))
        //        closeButtonImageBackView.backgroundColor = UIColor.red.withAlphaComponent(0.3)
        closeButtonImageBackView.isUserInteractionEnabled = false
        contentView.addSubview(closeButtonImageBackView)
        
        let closeButtonImageView = UIImageView(frame: closeButtonImageBackView.bounds)
        closeButtonImageView.frame.size.width = closeButtonImageView.frame.size.height
        closeButtonImageView.frame.size.width *= 0.5
        closeButtonImageView.frame.size.height *= 0.5
        closeButtonImageView.center = closeButtonImageBackView.frame.center
        closeButtonImageView.isUserInteractionEnabled = false
        closeButtonImageView.image = UIImage(named: "btnX2")
        closeButtonImageBackView.addSubview(closeButtonImageView)
        
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        logoutButton = LogoutButton(frame: CGRect(x: 0, y: 0, width: 100, height: NAVIGATION_BAR_HEIGHT))
        logoutButton.frame.origin.x = naviBar.frame.size.width - logoutButton.frame.size.width
        naviBar.addSubview(logoutButton)
        
        logoutButton.addTarget(event: .touchUpInside) { (button) in
            let alertCon = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
            alertCon.addAction(UIAlertAction(title: "아니오", style: .cancel, handler: { (action) in
                //?/
            }))
            alertCon.addAction(UIAlertAction(title: "예", style: .default, handler: { (action) in
                DispatchQueue.main.async {
                    userD.removeObject(forKey: REGIST_ID)
                    userD.removeObject(forKey: NAME_ID)
                    userD.removeObject(forKey: LICENSE_ID)
                    userD.synchronize()
                    
                    appDel.leftView?.close()
                    appDel.naviCon?.popToRootViewController(animated: true)
                    
                    toastShow(message: "로그아웃 되었습니다.")
                }
            }))
            
            self.close()
            appDel.topVC?.present(alertCon, animated: true, completion: {
                
            })
        }
        
        let homeButton = ImageButton(frame: CGRect(x: 0, y: 0, width: NAVIGATION_BAR_HEIGHT, height: NAVIGATION_BAR_HEIGHT), image: UIImage(named: "LeftHome"), ratio: 0.5)
        homeButton.addTarget(event: .touchUpInside) { [weak self] (button) in
            self?.goHome()
        }
        naviBar.addSubview(homeButton)
        
        naviBarHomeButton = UIButton(frame: CGRect(x: 0, y: 0, width: logoutButton.frame.minX, height: naviBar.frame.size.height))
        naviBarHomeButton.addTarget(event: .touchUpInside) { [weak self] (button) in
            self?.goHome()
        }
        naviBar.addSubview(naviBarHomeButton)
        
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        let bottomButtonHeight : CGFloat = 50
        
        let bottomView = UIView(frame: CGRect(x: 0, y: naviBar.maxY, width: leftViewContentViewWidth, height: bottomButtonHeight))
        bottomView.backgroundColor = UIColor.white
        contentView.addSubview(bottomView)
        
        let buttonBackView = UIView(frame: CGRect(x: 0, y: 0, width: leftViewContentViewWidth, height: bottomButtonHeight))
        bottomView.addSubview(buttonBackView)
        
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        loginButton = LoginButton(frame: CGRect(x: 0, y: 0, width: buttonBackView.frame.size.width / 2, height: bottomButtonHeight), name: "로그인", imageName: "btnLogin")
        loginButton.backgroundColor = #colorLiteral(red: 0.3986980915, green: 0.2682008743, blue: 0.494336307, alpha: 1)
        loginButton.nameLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        buttonBackView.addSubview(loginButton)

        loginButton.addTarget(event: .touchUpInside) { (button) in
            print("loginButtonPressed")
//            showLoginAlert()
            goLogin()
        }

        favoriteButton = FavoriteButton(frame: CGRect(x: 0, y: 0, width: buttonBackView.frame.size.width / 2, height: bottomButtonHeight), name: "즐겨찾기", imageName: "btnFavOff1")
        favoriteButton.backgroundColor = #colorLiteral(red: 0.3986980915, green: 0.2682008743, blue: 0.494336307, alpha: 1)
        favoriteButton.nameLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        buttonBackView.addSubview(favoriteButton)

        favoriteButton.addTarget(event: .touchUpInside) { (button) in
            goURL(urlString: URL_KEY.mySchedule)
        }
//        favoriteButton.isHidden = true //todo remove

        settingButton = SettingButton(frame: CGRect(x: buttonBackView.frame.size.width / 2, y: 0, width: buttonBackView.frame.size.width / 2, height: bottomButtonHeight), name: "설정", imageName: "btnSetting")
        settingButton.iconImageView.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        settingButton.backgroundColor = #colorLiteral(red: 0.3986980915, green: 0.2682008743, blue: 0.494336307, alpha: 1)
        settingButton.nameLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        settingButton.isSelected = false
        buttonBackView.addSubview(settingButton)
        settingButton.addTarget(event: .touchUpInside) {  (button) in
            goSetting()
//            goQuestion()
//            goVoting()
        }
        
        let buttonSeparaterView = UIView(frame: CGRect(x: 0, y: 0, width: 0.5, height: buttonBackView.frame.size.height * 0.35))
        buttonSeparaterView.backgroundColor = UIColor.white.withAlphaComponent(0.35)
        buttonSeparaterView.center = buttonBackView.frame.center
        buttonBackView.addSubview(buttonSeparaterView)
        
        
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
//        tableView = UITableView(frame: CGRect(x: 0, y: bottomView.maxY, width: leftViewContentViewWidth, height: SCREEN.HEIGHT - bottomView.frame.maxY))
        tableView = UITableView(frame: CGRect(x: 0, y: naviBar.maxY, width: leftViewContentViewWidth, height: SCREEN.HEIGHT - bottomView.frame.maxY))
        
//        tableView = UITableView(frame: CGRect(x: 0, y: naviBar.maxY, width: leftViewContentViewWidth, height: SCREEN.HEIGHT - bottomView.frame.maxY))
        tableView.register(LeftTableViewHeader.self, forHeaderFooterViewReuseIdentifier: "LeftTableViewHeader")
        tableView.register(LeftTableViewCell.self, forCellReuseIdentifier: "LeftTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.bounces = false
        contentView.addSubview(tableView)
        
        
        
        
        var setView = UIView(frame: CGRect(x: 0, y: tableView.frame.maxY, width: tableView.frame.width, height: 50))
        
        contentView.addSubview(setView)
        
        loginButton1 = LoginButton(frame: CGRect(x: 0, y: 0, width: buttonBackView.frame.size.width / 2, height: bottomButtonHeight), name: "로그인", imageName: "btnLogin")
        loginButton1.backgroundColor = #colorLiteral(red: 0.7275169492, green: 0.7153788209, blue: 0.8877316117, alpha: 1)
        loginButton1.nameLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        setView.addSubview(loginButton1)

        loginButton1.addTarget(event: .touchUpInside) { (button) in
            print("loginButtonPressed")
//            showLoginAlert()
            goLogin()
        }
        
         favoriteButton1 = FavoriteButton(frame: CGRect(x: 0, y: 0, width: buttonBackView.frame.size.width / 2, height: bottomButtonHeight), name: "즐겨찾기", imageName: "btnFavOff1")
        favoriteButton1.backgroundColor = #colorLiteral(red: 0.7275169492, green: 0.7153788209, blue: 0.8877316117, alpha: 1)
        favoriteButton1.nameLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        setView.addSubview(favoriteButton1)

        favoriteButton1.addTarget(event: .touchUpInside) { (button) in
            goURL(urlString: URL_KEY.mySchedule)
        }
//        favoriteButton1.isHidden = true //todo remove
        
        
        
        var settingButton1 = SettingButton(frame: CGRect(x: buttonBackView.frame.size.width / 2, y: 0, width: buttonBackView.frame.size.width / 2, height: bottomButtonHeight), name: "설정", imageName: "btnSetting")
        settingButton1.iconImageView.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        settingButton1.backgroundColor = #colorLiteral(red: 0.7275169492, green: 0.7153788209, blue: 0.8877316117, alpha: 1)
        settingButton1.nameLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        settingButton1.isSelected = false
        setView.addSubview(settingButton1)
        settingButton1.addTarget(event: .touchUpInside) {  (button) in
            goSetting()
//            goQuestion()
//            goVoting()
        }
        
        
        
        // bottom button  수정 후 (-> 수정 전에는 네비바 위에 있었음)
        
//        let tableBottomView = UIView(frame: CGRect(x: 0, y: tableView.frame.maxY, width: leftViewContentViewWidth, height: bottomButtonHeight))
//        tableBottomView.backgroundColor = UIColor.yellow
//        contentView.addSubview(tableBottomView)
//
//        loginButton = LoginButton(frame: CGRect(x: 0, y: 0, width: buttonBackView.frame.size.width / 2, height: bottomButtonHeight), name: "로그인", imageName: "btnLogin")
//        loginButton.backgroundColor = #colorLiteral(red: 0.462745098, green: 0.6549019608, blue: 0.3529411765, alpha: 1)
//        loginButton.nameLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        tableBottomView.addSubview(loginButton)
//
//        loginButton.addTarget(event: .touchUpInside) { (button) in
//            print("loginButtonPressed")
//
//            goLogin()
//        }
//
//        favoriteButton = FavoriteButton(frame: CGRect(x: 0, y: 0, width: buttonBackView.frame.size.width / 2, height: bottomButtonHeight), name: "즐겨찾기", imageName: "btnFavOff1")
//        favoriteButton.backgroundColor = #colorLiteral(red: 0.462745098, green: 0.6549019608, blue: 0.3529411765, alpha: 1)
//        favoriteButton.nameLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        tableBottomView.addSubview(favoriteButton)
//
//        favoriteButton.addTarget(event: .touchUpInside) { (button) in
//            goURL(urlString: URL_KEY.mySchedule)
//        }
//        favoriteButton.isHidden = true //todo remove
//
//        settingButton = SettingButton(frame: CGRect(x: buttonBackView.frame.size.width / 2, y: 0, width: buttonBackView.frame.size.width / 2, height: bottomButtonHeight), name: "설정", imageName: "btnSetting")
//        settingButton.iconImageView.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        settingButton.backgroundColor = #colorLiteral(red: 0.462745098, green: 0.6549019608, blue: 0.3529411765, alpha: 1)
//        settingButton.nameLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        settingButton.isSelected = false
//        tableBottomView.addSubview(settingButton)
//        settingButton.addTarget(event: .touchUpInside) {  (button) in
//            goSetting()
////            goQuestion()
////            goVoting()
//        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        self.isHidden = true
        self.contentView.frame.origin.x = -SCREEN.WIDTH
        self.grayView.alpha = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var currentVC : UIViewController?
    var isOpen = false
    func open(currentVC kCurrentVC : UIViewController? = nil) {
        
        self.loginCheck()
        
        self.currentVC = kCurrentVC
        self.isOpen = true
        self.currentVC?.setNeedsStatusBarAppearanceUpdate()
        
        appDel.window?.endEditing(true)
        
        self.isHidden = false
        self.grayView.alpha = 0
        
        UIView.animate(withDuration: 0.4, animations: {
            self.grayView.alpha = 1
            self.contentView.frame.origin.x = 0
            
        }) { (fi : Bool) in
            self.currentVC?.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    @objc func close(){
        
        self.isOpen = false
        
        UIView.animate(withDuration: 0.4, animations: {
            self.contentView.frame.origin.x = -SCREEN.WIDTH
            self.grayView.alpha = 0
            self.currentVC?.setNeedsStatusBarAppearanceUpdate()
        }) { (fi : Bool) in
            self.isHidden = true
        }
    }
    
    func goHome(){
        appDel.naviCon?.popToRootViewController(animated: false)
        self.close()
    }
    ////
    
    func loginCheck(){
        if isLogin{
            logoutButton.isHidden = false
            naviBarHomeButton.frame.size.width = logoutButton.frame.minX
            
            loginButton1.isHidden = true
            favoriteButton1.isHidden = false
        }else{
            logoutButton.isHidden = true
            naviBarHomeButton.frame.size.width = leftViewContentViewWidth
            
            loginButton1.isHidden = false
            favoriteButton1.isHidden = true
        }
    }
    
}

extension LeftView : UITableViewDelegate, UITableViewDataSource, LeftTableViewHeaderDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.selectedIndex == section {
            
            let subDic = INFO.INFOS[section]
            if let subMenues = subDic[INFO.KEY.SUB_MENU] as? [[String:Any]] {
                return subMenues.count
            }
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return INFO.INFOS.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LeftTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return LeftTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return LeftTableViewHeader.height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return LeftTableViewHeader.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeftTableViewCell", for: indexPath) as! LeftTableViewCell
        
        let subDic = INFO.INFOS[indexPath.section]
        if let subMenues = subDic[INFO.KEY.SUB_MENU] as? [[String:Any]] {
            let subMenu = subMenues[indexPath.row]
            if let subMenuTitleString = subMenu[INFO.KEY.TITLE] as? String {
                cell.titleLabel.text = "᛫ \(subMenuTitleString)"
                
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "LeftTableViewHeader") as! LeftTableViewHeader
        
        headerView.index = section
        headerView.delegate = self
        let subDic = INFO.INFOS[section]
        if let headerTitleString = subDic[INFO.KEY.TITLE] as? String {
            headerView.titleLabel.text = headerTitleString
        }
        
        if let _ = subDic[INFO.KEY.SUB_MENU] as? [[String:Any]] {
            headerView.arrowImageView.isHidden = false
            headerView.arrowImageView.image = (section == self.selectedIndex) ? UIImage.fontAwesomeIcon(name: FontAwesome.angleUp, style: FontAwesomeStyle.solid, textColor: #colorLiteral(red: 0.662745098, green: 0.662745098, blue: 0.662745098, alpha: 1), size: headerView.arrowImageView.frame.size) : UIImage.fontAwesomeIcon(name: FontAwesome.angleDown, style: FontAwesomeStyle.solid, textColor: #colorLiteral(red: 0.662745098, green: 0.662745098, blue: 0.662745098, alpha: 1), size: headerView.arrowImageView.frame.size)
            
            
            headerView.contentView.backgroundColor = (section == self.selectedIndex) ? #colorLiteral(red: 0.9176470588, green: 0.9450980392, blue: 0.9137254902, alpha: 1): #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            headerView.underBar.isHidden = (section == self.selectedIndex)
            
            
            
            
                
                        
            
            
            
            
            
            
        }else{
            headerView.arrowImageView.isHidden = true
        }
        headerView.titleImageView.image = UIImage(named: "left_ico\(section + 1)")
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! LeftTableViewCell
        cell.isSelected = false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! LeftTableViewCell
        
        cell.isSelected = true
        
        
        
        //todo test
        //        let baseVC = BaseViewController()
        //        baseVC.subTitleString = "서브 타이틀"
        //        appDel.naviCon?.popToRootViewController(animated: false)
        //        appDel.naviCon?.pushViewController(baseVC, animated: true)
        //        appDel.leftView?.close()
        
        let dataDic = INFO.INFOS[indexPath.section]
        let rowArray = dataDic[INFO.KEY.SUB_MENU] as? [[String:Any]] ?? [[String:Any]]()
        if rowArray.count > indexPath.row {
            contentShow(dataDic: rowArray[indexPath.row])
            return
        }
    }
    
    func headrSeletedUpdate(){

        if self.selectedIndex != -1 {
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: self.selectedIndex), at: UITableView.ScrollPosition.middle, animated: true)
        }
        
        for i in 0..<INFO.INFOS.count{
            if let headerView = self.tableView.headerView(forSection: i) as? LeftTableViewHeader {
                
                let subDic = INFO.INFOS[i]
                if let _ = subDic[INFO.KEY.SUB_MENU] as? [[String:Any]] {
                    headerView.arrowImageView.isHidden = false
                    headerView.arrowImageView.image = (i == self.selectedIndex) ? UIImage.fontAwesomeIcon(name: FontAwesome.angleUp, style: FontAwesomeStyle.solid, textColor: #colorLiteral(red: 0.662745098, green: 0.662745098, blue: 0.662745098, alpha: 1), size: headerView.arrowImageView.frame.size) : UIImage.fontAwesomeIcon(name: FontAwesome.angleDown, style: FontAwesomeStyle.solid, textColor: #colorLiteral(red: 0.662745098, green: 0.662745098, blue: 0.662745098, alpha: 1), size: headerView.arrowImageView.frame.size)
                    headerView.contentView.backgroundColor = (i == self.selectedIndex) ? #colorLiteral(red: 0.9529412389, green: 0.9529412389, blue: 0.9529412389, alpha: 1): #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    headerView.underBar.isHidden = (i == self.selectedIndex)
                    headerView.titleLabel.textColor = (i == self.selectedIndex) ? #colorLiteral(red: 0.1604290903, green: 0.1205421463, blue: 0.4928777814, alpha: 1): #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                }else{
                    headerView.arrowImageView.isHidden = true
                    
                }
            }
        }
    }
    
    func leftTableViewHeader(_ leftTableViewHeader: LeftTableViewHeader, didSelectHeader index: Int) {
        
        let headerDataDic = INFO.INFOS[index]
        let headerRowArray = headerDataDic[INFO.KEY.SUB_MENU] as? [[String:Any]] ?? [[String:Any]]()
        if headerRowArray.count == 0 {
            contentShow(dataDic: headerDataDic)
            return
        }
        
        if self.selectedIndex == -1 {
            self.selectedIndex = index
            
            var indexPaths = [IndexPath]()
            
            let dataDic = INFO.INFOS[self.selectedIndex]
            let rowArray = dataDic[INFO.KEY.SUB_MENU] as? [[String:Any]] ?? [[String:Any]]()
            for i in 0..<rowArray.count{
                indexPaths.append(IndexPath(row: i, section: self.selectedIndex))
            }
            
            if indexPaths.count > 0{
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: indexPaths, with: UITableView.RowAnimation.fade)
                self.tableView.endUpdates()
                
            }
            
        }else if self.selectedIndex == index{
            
            self.selectedIndex = -1
            
            var indexPaths = [IndexPath]()
            
            let dataDic = INFO.INFOS[index]
            let rowArray = dataDic[INFO.KEY.SUB_MENU] as? [[String:Any]] ?? [[String:Any]]()
            
            for i in 0..<rowArray.count{
                indexPaths.append(IndexPath(row: i, section: index))
            }
            
            if indexPaths.count > 0{
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: indexPaths, with: UITableView.RowAnimation.fade)
                self.tableView.endUpdates()
                
            }
        }else{
            
            var beforeIndexPaths = [IndexPath]()
            let beforeDataDic = INFO.INFOS[self.selectedIndex]
            let beforeRowArray = beforeDataDic[INFO.KEY.SUB_MENU] as? [[String:Any]] ?? [[String:Any]]()
            for i in 0..<beforeRowArray.count{
                beforeIndexPaths.append(IndexPath(row: i, section: self.selectedIndex))
            }
            
            self.selectedIndex = index
            var afterIndexPaths = [IndexPath]()
            let afterDataDic = INFO.INFOS[self.selectedIndex]
            let afterRowArray = afterDataDic[INFO.KEY.SUB_MENU] as? [[String:Any]] ?? [[String:Any]]()
            
            for i in 0..<afterRowArray.count{
                afterIndexPaths.append(IndexPath(row: i, section: self.selectedIndex))
            }
            
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: beforeIndexPaths, with: UITableView.RowAnimation.fade)
            self.tableView.insertRows(at: afterIndexPaths, with: UITableView.RowAnimation.fade)
            self.tableView.endUpdates()
            
        }
        
        self.headrSeletedUpdate()
    }
    
}


class LeftViewHomeButton : UIButton {
    
    var iconImageView : UIImageView!
    var nameLabel : UILabel!
    
    init(frame: CGRect, name : String, imageName : String) {
        super.init(frame: frame)
        
        let innerView = UIView(frame: self.bounds)
        innerView.isUserInteractionEnabled = false
        self.addSubview(innerView)
        
        iconImageView  = UIImageView(frame: CGRect(x: 20, y: 0, width: 0, height: self.frame.size.height * 0.4))
        iconImageView.setImageWithFrameWidth(image: UIImage(named: imageName))
        iconImageView.center.y = self.frame.size.height / 2
        iconImageView.isUserInteractionEnabled = false
        innerView.addSubview(iconImageView)
        
        nameLabel = UILabel(frame: CGRect(x: iconImageView.frame.maxX + 20, y: 0, width: 100, height: self.frame.size.height))
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        nameLabel.text = name
        nameLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        nameLabel.font = UIFont(name: Nanum_Barun_Gothic_OTF_Bold, size: 17)
        nameLabel.sizeToFit()
        nameLabel.center.y = self.frame.size.height / 2
        nameLabel.isUserInteractionEnabled = false
        innerView.addSubview(nameLabel)
        
        innerView.frame.size.width = nameLabel.frame.maxX
        //        innerView.center.x = self.frame.size.width / 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SettingButton : LeftBottomButton {}

class LoginButton : LeftBottomButton { }

class FavoriteButton : LeftBottomButton {}

class LeftBottomButton: UIButton {
    
    var iconImageView : UIImageView!
    var nameLabel : UILabel!
    
    init(frame: CGRect, name : String, imageName : String) {
        super.init(frame: frame)
        
        let innerView = UIView(frame: self.bounds)
        innerView.isUserInteractionEnabled = false
        self.addSubview(innerView)
        
        iconImageView  = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: self.frame.size.height * 0.4))
        iconImageView.setImageWithFrameWidth(image: UIImage(named: imageName))
        iconImageView.center.y = self.frame.size.height / 2
        iconImageView.isUserInteractionEnabled = false
        innerView.addSubview(iconImageView)
        
        nameLabel = UILabel(frame: CGRect(x: iconImageView.frame.maxX + 10, y: 0, width: 100, height: self.frame.size.height))
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        nameLabel.text = name
        nameLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        nameLabel.font = UIFont(name: ROBOTO_REGULAR, size: 15)
        nameLabel.sizeToFit()
        nameLabel.center.y = self.frame.size.height / 2
        nameLabel.isUserInteractionEnabled = false
        innerView.addSubview(nameLabel)
        
        innerView.frame.size.width = nameLabel.frame.maxX
        innerView.center.x = self.frame.size.width / 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class LogoutButton: UIButton {
    
    var iconImage : UIImageView!
    var nameLabel : UILabel!
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let innerView = UIView(frame: self.bounds)
        
        
        innerView.isUserInteractionEnabled = false
        innerView.backgroundColor = #colorLiteral(red: 0.1384948492, green: 0.07517490536, blue: 0.1841403842, alpha: 1)
//        self.addSubview(innerView)
        
        iconImage  = UIImageView(frame: CGRect(x: innerView.minX + 5, y: innerView.minY, width: 0, height: self.frame.size.height * 0.4))
        iconImage.setImageWithFrameWidth(image: UIImage(named: "logoutBtn"))
        iconImage.center.y = self.frame.size.height / 2
        iconImage.isUserInteractionEnabled = false
//        self.addSubview(iconImage)
        
        nameLabel = UILabel(frame: CGRect(x: iconImage.frame.maxX + 5, y: innerView.maxY, width: 100, height: 45))
        nameLabel.text = "로그아웃"
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        nameLabel.textColor = #colorLiteral(red: 0.2125732005, green: 0.1512659788, blue: 0.4730849266, alpha: 1)
        nameLabel.font = UIFont(name: NotoSansCJKkr_Bold, size: 13)
        nameLabel.sizeToFit()
        nameLabel.frame.size.width += 30
        nameLabel.frame.size.height += 5
        nameLabel.layer.cornerRadius = nameLabel.frame.size.height / 2
//        nameLabel.layer.borderWidth = 1
        nameLabel.layer.cornerRadius = 11
//        nameLabel.layer.borderColor = UIColor.white.cgColor
        nameLabel.clipsToBounds = true
        self.addSubview(nameLabel)
        
        self.frame.size.width = nameLabel.frame.size.width + 20
        
        
        nameLabel.center = self.frame.center
        
        innerView.frame = CGRect(x: -5, y: 5, width: nameLabel.frame.size.width + 10, height: iconImage.frame.size.height * 1.9)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
