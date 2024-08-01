
import UIKit
import SDWebImage
import FontAwesome_swift

import Photos

struct PHOTO_LIST_INFO {
    struct KEY {
        static let TITLE = "TITLE"
        static let URL = "URL"
    }
    static let INFO = [
        [
            KEY.TITLE : "4월 18일(금)",
            "tab" : "558"
        ],
        [
            KEY.TITLE : "4월 19일(토)",
            "tab" : "559"
        ],
        [
            KEY.TITLE : "사용자 사진",
            "tab" : "-1"
        ]
    ]
    
}

class PhotoListViewController: BaseViewController {
    
    var dataArray = [[String:Any]]()
    var imageCollectionView : UICollectionView!
    
    let addNewImageButtonHeight : CGFloat = 50
    var addNewImageButton : IconButtonWithBottom!
    
    var segBackView : UIView!
    
    var bottomView : BottomView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let collectionViewLayout = PhotoCollectionViewLayout()
    
    var photoListSelectButtons = [PhotoButton]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.photoMenuListUpdate(index: self.currentIndex)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.subTitleLabel.text = "포토갤러리"
        
//        self.subTitleView.backgroundColor = mainColor
        self.subTitleView.backgroundColor = #colorLiteral(red: 0.2018971443, green: 0.1664702594, blue: 0.5201563239, alpha: 1)
        self.subTitleLabel.textColor = UIColor.white
        self.backButtonimageView.image = UIImage.fontAwesomeIcon(name: FontAwesome.arrowLeft, style: .solid, textColor: UIColor.white, size: backButtonimageView.frame.size)
        
        segBackView = UIView(frame: CGRect(x: 0, y: subTitleView.frame.maxY, width: SCREEN.WIDTH, height: 50))
        self.view.addSubview(segBackView)
        
        let segUnderView = UIView(frame: CGRect(x: 0, y: segBackView.frame.size.height - 0.5, width: SCREEN.WIDTH, height: 0.5))
        segUnderView.backgroundColor = #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)
        segBackView.addSubview(segUnderView)
        
        let photoListSelectButtonWidth : CGFloat = SCREEN.WIDTH / CGFloat(PHOTO_LIST_INFO.INFO.count)
        for i in 0..<PHOTO_LIST_INFO.INFO.count{
            let photoListSelectButton = PhotoButton(
                frame: CGRect(
                    x: CGFloat(i) * photoListSelectButtonWidth,
                    y: 0,
                    width: photoListSelectButtonWidth,
                    height: segBackView.frame.size.height),
                titleString: PHOTO_LIST_INFO.INFO[i][PHOTO_LIST_INFO.KEY.TITLE]!)
            segBackView.addSubview(photoListSelectButton)
            photoListSelectButton.photoInfo = PHOTO_LIST_INFO.INFO[i]
            photoListSelectButtons.append(photoListSelectButton)
            
            photoListSelectButton.addTarget(self, action: #selector(photoListSelectButtonPressed(button:)), for: .touchUpInside)

        }
        
        bottomView = BottomView()
        
        
        imageCollectionView = UICollectionView(
            frame: CGRect(
                x: 0,
                y: segBackView.frame.maxY,
                width: SCREEN.WIDTH,
                height: bottomView.frame.minY - self.segBackView.frame.maxY),
            collectionViewLayout: collectionViewLayout)
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.register(PhotoCollectionViewCell_Large.self, forCellWithReuseIdentifier: "PhotoCollectionViewCell_Large")
        imageCollectionView.register(PhotoCollectionViewCell_Small.self, forCellWithReuseIdentifier: "PhotoCollectionViewCell_Small")
        imageCollectionView.bounces = false
        imageCollectionView.showsVerticalScrollIndicator = false
        imageCollectionView.backgroundColor = UIColor.white
        self.view.addSubview(imageCollectionView)
        
        addNewImageButton = IconButtonWithBottom(frame: CGRect(x: 0, y: SCREEN.HEIGHT, width: SCREEN.WIDTH, height: addNewImageButtonHeight), name: "사진 추가", fontAwesome: .camera, fontAwesomeStyle: .solid)
        addNewImageButton.backgroundColor = mainColor
        self.view.addSubview(addNewImageButton)
        
        self.view.addSubview(bottomView)
        
        addNewImageButton.addTarget(event: .touchUpInside) { (button) in
            print("addNewImage")
            
            let imageSelectAlertCon = UIAlertController(title: "Please select an upload method.", message: nil, preferredStyle: .actionSheet)
            imageSelectAlertCon.addAction(UIAlertAction(title: "Camera", style: UIAlertAction.Style.default, handler: { (action) in
                print("Camera")
                
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (grant : Bool) in
                    if grant {
                        let imagePickerController = UIImagePickerController()
                        imagePickerController.sourceType = .camera
                        imagePickerController.showsCameraControls = true
                        imagePickerController.delegate = self
                        imagePickerController.modalPresentationStyle = .fullScreen
                        DispatchQueue.main.async {
                            self.present(imagePickerController, animated: true) { }
                        }
                    }else{
                        DispatchQueue.main.async {
                            let alertCon = UIAlertController(title: "Notice", message: "You cannot access the camera.\nSettings > Privacy > Camera > \(APP_NAME)", preferredStyle: .alert)
                            alertCon.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: { (action : UIAlertAction) in
                                
                            }))
                            alertCon.addAction(UIAlertAction(title: "Setting", style: UIAlertAction.Style.default, handler: { (action : UIAlertAction) in
                                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: { (fi) in
                                    
                                })
                            }))
                            appDel.topVC?.present(alertCon, animated: true, completion: {
                                
                            })
                        }
                    }
                })
                
            }))
            imageSelectAlertCon.addAction(UIAlertAction(title: "Album", style: UIAlertAction.Style.default, handler: { (action) in
                print("Album")
                
                PHPhotoLibrary.requestAuthorization({ (state : PHAuthorizationStatus) in
                    if state == .authorized {
                        let imagePickerController = UIImagePickerController()
                        imagePickerController.sourceType = .photoLibrary
                        imagePickerController.delegate = self
                        imagePickerController.modalPresentationStyle = .fullScreen
                        DispatchQueue.main.async {
                            self.present(imagePickerController, animated: true) { }
                        }
                    }else{
                        DispatchQueue.main.async {
                            let alertCon = UIAlertController(title: "Notice", message: "You cannot access the album.\nSettings > Privacy > album > \(APP_NAME)", preferredStyle: .alert)
                            alertCon.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: { (action : UIAlertAction) in
                                
                            }))
                            alertCon.addAction(UIAlertAction(title: "Setting", style: UIAlertAction.Style.default, handler: { (action : UIAlertAction) in
                                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: { (fi) in
                                    
                                })
                            }))
                            appDel.topVC?.present(alertCon, animated: true, completion: {
                                
                            })
                        }
                    }
                })
                
                
                
            }))
            imageSelectAlertCon.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) in
                print("Cancel")
            }))
            self.present(imageSelectAlertCon, animated: true, completion: {
                
            })
            
        }
        
        photoListSelectButtonPressed(button: self.photoListSelectButtons[0])
    }
    
    var currentIndex = 0
    let taps = ["42","43","44","-1"]//?/
    func photoMenuListUpdate( index : Int ){
        let tab = PHOTO_LIST_INFO.INFO[index]["tab"] ?? ""
        
        currentIndex = index
        
        let urlString = "https://ezv.kr:4447/voting/php/photo/get_photo.php?deviceid=\(deviceID)&code=\(code)&tab=\(tab)"
        print("urlString:\(urlString)")
        
        Server.postData(urlString: urlString, otherInfo: [:]){ [weak self] (kData : Data?) in
            guard let self = self else { return }
            if let data = kData {
                if let array = data.toJson() as? [[String:Any]] {
                    //                    print("array.count \(array.count) \n\(array)")
                    //                    let numberOfGroup = (array.count <= 5) ? 1 : array.count / 5
                    let numberOfGroup = (array.count / 5) + ((array.count % 10 >= 1 && array.count % 10 < 5) ? 1 : 0)
                    print("numberOfGroup:\(numberOfGroup)")
                    
                    var largeItemCount = array.count / 5
//                    if (array.count == 1) || (array.count % 10 == 1) {
                    if (array.count <= 5) || (array.count % 10 == 1) {
                        largeItemCount += 1
                    }
                    print("largeItemCount:\(largeItemCount)")
                    let sortedArray = array.sorted(by: { (dicA : [String : Any], dicB : [String : Any]) -> Bool in
                        if let aCntString = dicA["cnt"] as? String, let bCntString = dicB["cnt"] as? String {
                            if let aCnt = Int(aCntString, radix: 10), let bCnt = Int(bCntString, radix: 10) {
                                
                                return aCnt > bCnt
                            }
                        }
                        return false
                    })
                    
                    print("sortedArray.count:\(sortedArray.count)")
                    var largeArray = [[String:Any]]()
                    var smallArray = [[String:Any]]()
                    
                    for i in 0..<sortedArray.count {
//                        if i <= largeItemCount {
                        if i < largeItemCount {
                            largeArray.append(sortedArray[i])
                        }else{
                            smallArray.append(sortedArray[i])
                        }
                    }
                    print("largeArray.count:\(largeArray.count)")
                    print("smallArray.count:\(smallArray.count)")
                    
                    var largeArrayIndex = 0
                    var smallArrayIndex = 0
                    
                    var newArray = [[String:Any]]()
                    for i in 0..<sortedArray.count {
                        if i % 10 == 0 || i % 10 == 9 {
                            if largeArray.count > largeArrayIndex {
                                //                                print("largeArrayIndex:\(largeArrayIndex)")
                                newArray.append(largeArray[largeArrayIndex])
                                largeArrayIndex += 1
                            }else{
                                print("예외? largeArrayIndex \(largeArrayIndex)")
                            }
                        }else{
                            if smallArray.count > smallArrayIndex {
                                //                                print("smallArrayIndex:\(smallArrayIndex)")
                                newArray.append(smallArray[smallArrayIndex])
                                smallArrayIndex += 1
                            }else{
                                print("예외? smallArray.count:\(smallArray.count)\nsmallArrayIndex \(smallArrayIndex)")
                            }
                        }
                    }
                    
                    //                    print("newArray.count \(newArray.count) \n\(newArray)")
                    self.dataArray = newArray
                    
                    self.collectionViewLayout.numberOfitem = self.dataArray.count
                    self.imageCollectionView.reloadData()
                    
                }
                else{
                    print("데이터 없음")
                    self.dataArray = [[String:Any]]()
                    self.collectionViewLayout.numberOfitem = self.dataArray.count
                    self.imageCollectionView.reloadData()
                }
            }
            
        }
    }
    
    @objc func photoListSelectButtonPressed( button : PhotoButton ){
        
        var index = 0
        for i in 0..<self.photoListSelectButtons.count {
            let photoListSelectButton = self.photoListSelectButtons[i]
            photoListSelectButton.isSelected = (photoListSelectButton == button)
            
            if photoListSelectButton == button {
                photoMenuListUpdate(index: i)
                index = i
            }
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            if index == 2 {
                self.addNewImageButton.frame.origin.y = self.bottomView.frame.minY - self.addNewImageButton.frame.size.height
                self.imageCollectionView.frame.size.height = self.addNewImageButton.frame.minY - self.segBackView.frame.maxY
                
//                self.addNewImageButton.frame.origin.y = SCREEN.HEIGHT - self.addNewImageButton.frame.size.height
//                self.imageCollectionView.frame.size.height = self.addNewImageButton.frame.minY - self.segBackView.frame.maxY
            }else{
                self.addNewImageButton.frame.origin.y = self.bottomView.frame.minY
                self.imageCollectionView.frame.size.height = self.bottomView.frame.minY - self.segBackView.frame.maxY
                
//                self.addNewImageButton.frame.origin.y = SCREEN.HEIGHT
//                self.imageCollectionView.frame.size.height = SCREEN.HEIGHT - self.segBackView.frame.maxY
            }
        }) { (fi) in
            
        }
        
        
    }
    
}

class PhotoButton: UIButton {
    var photoInfo = [String:Any]()
    
//    override var isSelected: Bool {
//        willSet(newIsSelected){
//            if newIsSelected {
//                nameLabel.textColor = #colorLiteral(red: 0.09803921569, green: 0.1803921569, blue: 0.5607843137, alpha: 1)
//                underBar.isHidden = false
//            }else{
//                nameLabel.textColor = #colorLiteral(red: 0.2705882353, green: 0.2705882353, blue: 0.2705882353, alpha: 1)
//                underBar.isHidden = true
//            }
//        }
//    }
    
    override var isSelected: Bool {
        willSet(newIsSelected){
            if newIsSelected {
                nameLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                backgroundColor = #colorLiteral(red: 0.5028347373, green: 0.4648861885, blue: 0.8258777261, alpha: 1)
                underBar.isHidden = true
            }else{
                nameLabel.textColor = #colorLiteral(red: 0.2705882353, green: 0.2705882353, blue: 0.2705882353, alpha: 1)
                backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                underBar.isHidden = true
            }
        }
    }
    
    var nameLabel : UILabel!
    var underBar : UIView!
    
    init(frame: CGRect, titleString : String) {
        super.init(frame:frame)
        
        nameLabel = UILabel(frame: self.bounds)
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont(name: Nanum_Barun_Gothic_OTF, size: 15)
        nameLabel.textColor = #colorLiteral(red: 0.2705882353, green: 0.2705882353, blue: 0.2705882353, alpha: 1)
        nameLabel.numberOfLines = 0
        nameLabel.text = titleString
        nameLabel.sizeToFit()
        nameLabel.center = self.frame.center
        self.addSubview(nameLabel)
        
        underBar = UIView(frame: CGRect(x: 0, y: self.frame.size.height - 3.5, width: self.frame.size.width, height: 3.5))
        underBar.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.1803921569, blue: 0.5607843137, alpha: 1)
        self.addSubview(underBar)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension PhotoListViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let getImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            resize(image: getImage) { (kResizedImage : UIImage?) in
                if let resizedImage = kResizedImage {
                    guard let imageData = resizedImage.pngData() else { return print("make png fail") }
                    let imageString = imageData.base64EncodedString(options: Data.Base64EncodingOptions.endLineWithLineFeed)
                    
                    Server.postData(urlString: "https://ezv.kr:4447/voting/php/photo/photo_upload.php", otherInfo: ["img":imageString,"code":code,"deviceid":deviceID]) { (kData : Data?) in
                        if let data = kData {
                            print("sendPhoto : \(String(describing: data.toString()))")
                            self.photoMenuListUpdate(index: self.currentIndex)
                        }
                    }
                    
                }
            }
        }
        
        
        
        picker.dismiss(animated: true) { }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true) { }
    }
}

extension PhotoListViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PhotoCollectionViewCellDelegate {
    
    //PhotoCollectionViewCellDelegate
    func photoCollectionViewCelldidHeartButtonSelected(index: Int) {
        print("\(index) selected")
        
        if index >= self.dataArray.count { return }
        
        var dataDic = self.dataArray[index]
        
        var nextValue = 0
        
        guard let sid = dataDic["sid"] as? String else { return print("sid is nil") }
        guard let myfav = dataDic["myfav"] as? String else { return print("myfav is nil")}
        
        guard let myfavValue = Int(myfav, radix: 10) else { return print("10진수 변환 실패") }
        if myfavValue == 0 { nextValue = 1}
        if myfavValue == 1 { nextValue = 0}
        
        let urlString = "https://ezv.kr:4447/voting/php/photo/set_favor.php?sid=\(sid)&deviceid=\(deviceID)&val=\(nextValue)"
        //        print("set urlString \(urlString)")
        Server.postData(urlString: urlString, otherInfo: [:]) { (kData : Data?) in
            if let data = kData {
                if let afterCnt = data.toString() {
                    dataDic["cnt"] = afterCnt
                    dataDic["myfav"] = myfavValue == 1 ? "0":"1"
                    self.dataArray[index] = dataDic
                    self.imageCollectionView.reloadData()
                }
                self.photoMenuListUpdate(index: self.currentIndex)
            }
        }
        
    }
    
    
    //UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionViewLayout.numberOfitem
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let att = self.collectionViewLayout.layoutAttributesForItem(at: indexPath) as? CollectionViewLayoutAttributes else {
            return UICollectionViewCell()
        }
        
        let cell : PhotoCollectionViewCell
        
        if att.isLarge {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell_Large", for: indexPath) as! PhotoCollectionViewCell_Large
        }else{
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell_Small", for: indexPath) as! PhotoCollectionViewCell_Small
        }
        
        cell.index = indexPath.row
        cell.delegate = self
        
        if let fav = dataArray[indexPath.row]["myfav"] as? String {
            if fav == "0" {
//
                cell.heartImageView.image = UIImage.fontAwesomeIcon(name: .heart, style: FontAwesomeStyle.solid, textColor: .lightGray, size: cell.heartImageView.frame.size)
            } else {
                
                cell.heartImageView.image = UIImage.fontAwesomeIcon(name: .heart, style: FontAwesomeStyle.solid, textColor: .red, size: cell.heartImageView.frame.size)
            }
        }
        //        cell.numberOfLike = Int.random(in: 0..<10)
        
        if let cnt = dataArray[indexPath.row]["cnt"] as? String {
            if let cnt_Int = Int(cnt, radix: 10) {
                cell.numberOfLike = cnt_Int
            }
        }
        
        if let fileURL = dataArray[indexPath.row]["url"] as? String {
            cell.loadImage(urlString: fileURL)
//            OperationQueue.main.addOperation {
//                cell.photoImageView.sd_setImage(with: URL(string: "https://ezv.kr:4447/voting/upload/photo/\(fileURL)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!), completed: nil)
//            }
        }else{
            cell.photoImageView.image = nil
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let photoBaseVC = PhotoPopUpBaseViewController()
        photoBaseVC.photoInfos = self.dataArray
        photoBaseVC.startIndex = indexPath.row
        let naviCon = RotatableNavigationController(rootViewController: photoBaseVC)
        naviCon.modalPresentationStyle = .fullScreen
        self.present(naviCon, animated: true) { }
        
        self.presentationController?.delegate
        
    }
    
}

@objc protocol PhotoCollectionViewCellDelegate {
    @objc optional func photoCollectionViewCelldidHeartButtonSelected( index : Int )
}


class PhotoCollectionViewCell: UICollectionViewCell {
    
    var delegate : PhotoCollectionViewCellDelegate?
    
    var defalultImageView : UIImageView!
    var photoImageView : UIImageView!
    
    var heartInfoLabelBackView : UIView!
    var heartImageView : UIImageView!
    var heartInfoLabel : UILabel!
    
    var heartButton : UIButton!
    
    var isLarge = false
    
    lazy var heartInfoLabelHeight : CGFloat = {
        return self.frame.size.height * (isLarge ? 0.12 : 0.15)
    }()
    
    var index = 0
    
    func uiSetting() {
        
        self.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
        self.layer.borderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
        self.layer.borderWidth = 1
        
        defalultImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width * 0.8, height: 0))
        defalultImageView.setImageWithFrameHeight(image: UIImage(named: "photoLogo"))
        defalultImageView.center = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        self.addSubview(defalultImageView)
        
        photoImageView = UIImageView(frame: self.bounds)
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
        self.addSubview(photoImageView)
        
        heartInfoLabelBackView = UIView(frame: CGRect(x: 0, y: self.frame.size.height - (heartInfoLabelHeight * 2), width: self.frame.size.width, height: heartInfoLabelHeight * 2))
        heartInfoLabelBackView.setGradientBackgroundColor(colors: [#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5),#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)])
        self.addSubview(heartInfoLabelBackView)
        
        heartImageView = UIImageView(frame: CGRect(x: 15, y: 0, width: heartInfoLabelHeight, height: heartInfoLabelHeight))
        heartImageView.image = UIImage.fontAwesomeIcon(name: .heart, style: FontAwesomeStyle.solid, textColor: #colorLiteral(red: 0.7647058824, green: 0.7647058824, blue: 0.7647058824, alpha: 1), size: heartImageView.frame.size)
        self.addSubview(heartImageView)
        
        heartButton = UIButton(frame: CGRect(x: 15, y: 0, width: heartInfoLabelHeight * 1.5, height: heartInfoLabelHeight * 1.5))
        heartButton.addTarget(self , action: #selector(heartButtonPressed), for: .touchUpInside)
        self.addSubview(heartButton)
        
        heartInfoLabel = UILabel(frame: CGRect(x: heartImageView.frame.maxX + 3, y: self.frame.size.height - (heartInfoLabelHeight * 1.5), width: self.frame.size.width - (heartImageView.frame.maxX + 3), height: heartInfoLabelHeight))
        heartInfoLabel.font = UIFont(name: Nanum_Barun_Gothic_OTF_Ultra_Light, size: heartInfoLabelHeight * 0.9)
        heartInfoLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.addSubview(heartInfoLabel)
        
        heartImageView.center.y = heartInfoLabel.center.y
        heartButton.center = heartImageView.center
        
    }
    
    @objc func heartButtonPressed(){
        print("heartButtonPressed : \(self.index)")
        self.delegate?.photoCollectionViewCelldidHeartButtonSelected?(index: self.index)
    }
    
    var numberOfLike : Int = 0 {
        willSet(newNumberOfLike){
            
            if newNumberOfLike != 0 {
//                heartImageView.image = UIImage.fontAwesomeIcon(name: .heart, style: FontAwesomeStyle.solid, textColor: #colorLiteral(red: 0.9450980392, green: 0.05882352941, blue: 0.3725490196, alpha: 1), size: heartImageView.frame.size)
            }else{
//                heartImageView.image = UIImage.fontAwesomeIcon(name: .heart, style: FontAwesomeStyle.regular, textColor: #colorLiteral(red: 0.7647058824, green: 0.7647058824, blue: 0.7647058824, alpha: 1), size: heartImageView.frame.size)
            }
            
            heartInfoLabel.text = "\(newNumberOfLike)"
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.photoImageView.sd_cancelCurrentImageLoad()
    }
    
    func loadImage(urlString : String){
        OperationQueue.main.addOperation {
            self.photoImageView.sd_setImage(with: URL(string: "https://ezv.kr:4447/voting/upload/photo/\(urlString)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!), completed: nil)
        }
    }
}

class PhotoCollectionViewCell_Large: PhotoCollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame.size = PhotoCollectionViewLayout().largeSize
        
        self.isLarge = true
        
        self.uiSetting()
        
        //        heartInfoLabel.frame.origin.y = self.frame.size.height - (heartInfoLabelHeight * 1.5)
        //        heartImageView.center.y = heartInfoLabel.center.y
        //        heartInfoLabelBackView.frame = CGRect(x: 0, y: self.frame.size.height - (heartInfoLabelHeight * 2), width: self.frame.size.width, height: heartInfoLabelHeight * 2)
        //        heartInfoLabelBackView.setGradientBackgroundColor(colors: [#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5),#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)])
        //
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PhotoCollectionViewCell_Small: PhotoCollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame.size = PhotoCollectionViewLayout().smallSize
        
        self.isLarge = false
        
        self.uiSetting()
        
        //        heartInfoLabel.frame.origin.y = self.frame.size.height - (heartInfoLabelHeight * 1.5)
        //        heartImageView.center.y = heartInfoLabel.center.y
        //        heartInfoLabelBackView.frame = CGRect(x: 0, y: self.frame.size.height - (heartInfoLabelHeight * 2), width: self.frame.size.width, height: heartInfoLabelHeight * 2)
        //        heartInfoLabelBackView.setGradientBackgroundColor(colors: [#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5),#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class PhotoListSelectButton: UIButton {
    
    override var isSelected: Bool {
        willSet(newIsSelected){
            if newIsSelected {
                self.backgroundColor = #colorLiteral(red: 0.1411764706, green: 0.337254902, blue: 0.662745098, alpha: 1)
                self.nameLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }else{
                self.backgroundColor = UIColor.clear
                self.nameLabel.textColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
            }
            
        }
    }
    
    var nameLabel : UILabel!
    init(frame: CGRect, name : String) {
        super.init(frame: frame)
        
        nameLabel = UILabel(frame: self.bounds)
        nameLabel.font = UIFont(name: Nanum_Barun_Gothic_OTF, size: 12)
        nameLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        nameLabel.text = name
        self.addSubview(nameLabel)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}





class AddNewImageButtonBackView: UIView {
    
    var iconImageView : UIImageView!
    var nameLabel : UILabel!
    
    init(frame: CGRect, name kName : String) {
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = false
        
        let innerView = UIView(frame: self.bounds)
        self.addSubview(innerView)
        
        iconImageView  = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.size.height * 0.5, height: self.frame.size.height * 0.5))
        iconImageView.image = UIImage.fontAwesomeIcon(name: .camera, style: .solid, textColor: UIColor.white, size: iconImageView.frame.size)
        iconImageView.center.y = self.frame.size.height / 2
        iconImageView.isUserInteractionEnabled = false
        innerView.addSubview(iconImageView)
        
        nameLabel = UILabel(frame: CGRect(x: iconImageView.frame.maxX + 10, y: 0, width: 100, height: self.frame.size.height))
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        nameLabel.text = kName
        nameLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        nameLabel.font = UIFont(name: Nanum_Barun_Gothic_OTF, size: 20)
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


func resize(image: UIImage, complete: @escaping ( (_ image : UIImage?) -> Void))
{
    
    let maxSize = max(image.size.width, image.size.height)
    let scale = 720 / maxSize
    
    let transform = CGAffineTransform(scaleX: scale, y: scale)
    let size = image.size.applying(transform)
    UIGraphicsBeginImageContext(size)
    image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
    let afterImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    complete(afterImage)
    
}


class SegButton: UIButton {
    
    override var isSelected: Bool {
        willSet(newIsSelected){
            if newIsSelected {
                nameLabel.textColor = #colorLiteral(red: 0.09803921569, green: 0.1803921569, blue: 0.5607843137, alpha: 1)
                underBar.isHidden = false
            }else{
                nameLabel.textColor = #colorLiteral(red: 0.2705882353, green: 0.2705882353, blue: 0.2705882353, alpha: 1)
                underBar.isHidden = true
            }
        }
    }
    
    
    var nameLabel : UILabel!
    var underBar : UIView!
    
    init(frame: CGRect, titleString : String) {
        super.init(frame:frame)
        
        nameLabel = UILabel(frame: self.bounds)
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont(name: Nanum_Barun_Gothic_OTF, size: 15)
        nameLabel.textColor = #colorLiteral(red: 0.2705882353, green: 0.2705882353, blue: 0.2705882353, alpha: 1)
        nameLabel.numberOfLines = 0
        nameLabel.text = titleString
        nameLabel.sizeToFit()
        nameLabel.center = self.frame.center
        self.addSubview(nameLabel)
        
        underBar = UIView(frame: CGRect(x: 0, y: self.frame.size.height - 3.5, width: self.frame.size.width, height: 3.5))
        underBar.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.1803921569, blue: 0.5607843137, alpha: 1)
        self.addSubview(underBar)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



