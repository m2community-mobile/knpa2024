
import UIKit

class QuestionSelectView: UIView {
    
    weak var questionView : QuestionView2?

    var questionDataArray = [[String:Any]]()
    
    convenience init(questionDataArray kQuestionDataArray : [[String:Any]]) {
        self.init(frame: SCREEN.BOUND, questionDataArray: kQuestionDataArray)
    }
    
    var tableView : UITableView!
    var selectedIndex = -1
    var selectIndexPath : IndexPath?
    
    init(frame: CGRect, questionDataArray kQuestionDataArray : [[String:Any]]) {
        super.init(frame:frame)
        
        self.questionDataArray = kQuestionDataArray
        
        let grayView = UIButton(frame: self.bounds)
        grayView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        grayView.addTarget(event: .touchUpInside) { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 0
            }) { (fi) in
                self.isHidden = true
            }
        }
        self.addSubview(grayView)
        
        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN.WIDTH * 0.85, height: SCREEN.HEIGHT * 0.7))
        contentView.center = CGPoint(x: SCREEN.WIDTH / 2, y: SCREEN.HEIGHT / 2)
        self.addSubview(contentView)
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: 50))
        titleLabel.backgroundColor = UIColor(colorWithHexValue: 0x262D44)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.text = "Select"
        contentView.addSubview(titleLabel)
        
        let closeButton = UIButton(frame: CGRect(x: contentView.frame.size.width - titleLabel.frame.size.height, y: 0, width: titleLabel.frame.size.height, height: titleLabel.frame.size.height))
        closeButton.setImage(UIImage(named: "btn_x2"), for: .normal)
        closeButton.addTarget(event: .touchUpInside) { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 0
            }) { (fi) in
                self.isHidden = true
            }
        }
        contentView.addSubview(closeButton)
        
        tableView = UITableView(frame: CGRect(x: 0, y: titleLabel.frame.maxY, width: contentView.frame.size.width, height: contentView.frame.size.height - titleLabel.frame.maxY))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(QuestionSelectTableViewCell.self, forCellReuseIdentifier: "QuestionSelectTableViewCell")
        tableView.register(QuestionSelectTableViewHeader.self, forHeaderFooterViewReuseIdentifier: "QuestionSelectTableViewHeader")
        contentView.addSubview(tableView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension QuestionSelectView : UITableViewDataSource, UITableViewDelegate, QuestionSelectTableViewHeaderDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return QuestionSelectTableViewCell.height
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 0
//    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//
//        let tempHeaderView = QuestionSelectTableViewHeader(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: QuestionSelectTableViewHeader.height))
//
//        let dataDic = self.questionDataArray[section]
//        if let session = dataDic["title"] as? String {
//            tempHeaderView.titleLabel.text = session
//            tempHeaderView.titleLabel.sizeToFit()
//            tempHeaderView.frame.size.height = tempHeaderView.titleLabel.frame.maxY + 30
//            return tempHeaderView.frame.size.height
//        }
//        return QuestionSelectTableViewHeader.height
//    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
        return self.questionDataArray.count
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

//        return self.questionDataArray.count
        if section == self.selectedIndex {
            let dataDic = self.questionDataArray[section]
            if let rows = dataDic["sub"] as? [[String:Any]] {
                print("numberOfRowsInSection:\(rows.count)")
                return rows.count
            }
        }
        return 0
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionSelectTableViewCell", for: indexPath) as! QuestionSelectTableViewCell
        
        let dataDic = self.questionDataArray[indexPath.section]
        
        if let subArray = dataDic["sub"] as? [[String:Any]] {
            let subDic = subArray[indexPath.row]
            if let title = subDic["title"] as? String {
                cell.titleLabel.text = title
            }
        }
        //        if let rows = dataDic["title"] as? [String] {
        //            cell.titleLabel.text = rows[indexPath.row]
        //        }
        if self.selectIndexPath == indexPath {
            cell.checkButton.isSelected = true
        }else{
            cell.checkButton.isSelected = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let tempHeaderView = AppQuestionSelectTableViewHeader(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: AppQuestionSelectTableViewHeader.height))
        
        let dataDic = self.questionDataArray[section]
        if let session = dataDic["theme"] as? String {
            tempHeaderView.titleLabel.text = session
            tempHeaderView.titleLabel.sizeToFit()
            tempHeaderView.frame.size.height = tempHeaderView.titleLabel.frame.maxY + 30
            return tempHeaderView.frame.size.height
        }
        return AppQuestionSelectTableViewHeader.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectIndexPath = indexPath
        
        tableView.reloadData()
        
        print("didSelectRowAt indexPath:\(indexPath)")
        
        
        self.questionView?.selectQuestionUpdate(indexPath: indexPath)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { (fi) in
            self.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "QuestionSelectTableViewHeader") as! QuestionSelectTableViewHeader
        
        headerView.index = section
        headerView.delegate = self
        
        let dataDic = self.questionDataArray[section]
        if let session = dataDic["theme"] as? String {
            headerView.titleLabel.frame = CGRect(x: 10, y: 0, width: tableView.frame.size.width - 50, height: QuestionSelectTableViewHeader.height)
            
            headerView.titleLabel.text = session
            headerView.titleLabel.sizeToFit()
            headerView.frame.size.height = headerView.titleLabel.frame.maxY + 30
            headerView.bottomLineView.frame.origin.y = headerView.frame.size.height - 0.5
            
            headerView.titleLabel.center.y = headerView.frame.size.height / 2
            headerView.button.frame = headerView.bounds
        }
        
        if selectedIndex == section {
            headerView.contentView.backgroundColor = UIColor(colorWithHexValue: 0xBE2F29)
            headerView.titleLabel.textColor = UIColor.white
        }else{
            headerView.contentView.backgroundColor = UIColor.white
            headerView.titleLabel.textColor = UIColor.black
        }
        
        
        
        return headerView
    }
    
    func questionSelectTableViewHeaderSeleted(index: Int) {
        
        if self.selectedIndex == -1 {
            
            self.selectedIndex = index
            
            var indexPaths = [IndexPath]()
            
            let dataDic = self.questionDataArray[self.selectedIndex]
            let rowArray = dataDic["sub"] as? [[String:Any]] ?? [[String:Any]]()
            for i in 0..<rowArray.count{
                indexPaths.append(IndexPath(row: i, section: self.selectedIndex))
            }
            
            if indexPaths.count > 0{
                print("indexPaths:\(indexPaths)")
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: indexPaths, with: UITableView.RowAnimation.fade)
                self.tableView.endUpdates()
                
                if let headerView = self.tableView.headerView(forSection: self.selectedIndex) as? QuestionSelectTableViewHeader {
                    headerView.contentView.backgroundColor = UIColor(colorWithHexValue: 0xBE2F29)
                    headerView.titleLabel.textColor = UIColor.white
                }
            }
            
        }else if self.selectedIndex == index{
            
            self.selectedIndex = -1
            
            var indexPaths = [IndexPath]()
            
            let dataDic = self.questionDataArray[index]
            let rowArray = dataDic["sub"] as? [[String:Any]] ?? [[String:Any]]()
            
            for i in 0..<rowArray.count{
                indexPaths.append(IndexPath(row: i, section: index))
            }
            
            if indexPaths.count > 0{
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: indexPaths, with: UITableView.RowAnimation.fade)
                self.tableView.endUpdates()
                
                if let headerView = self.tableView.headerView(forSection: index) as? QuestionSelectTableViewHeader {
                    headerView.contentView.backgroundColor = UIColor.white
                    headerView.titleLabel.textColor = UIColor.black
                }
                
            }
        }else{
            
            var beforeIndexPaths = [IndexPath]()
            
            let beforeDataDic = self.questionDataArray[self.selectedIndex]
            let beforeRowArray = beforeDataDic["sub"] as? [[String:Any]] ?? [[String:Any]]()
            
            for i in 0..<beforeRowArray.count{
                beforeIndexPaths.append(IndexPath(row: i, section: self.selectedIndex))
            }
            
            if let beforeHeaderView = self.tableView.headerView(forSection: self.selectedIndex) as? QuestionSelectTableViewHeader {
                beforeHeaderView.contentView.backgroundColor = UIColor.white
                beforeHeaderView.titleLabel.textColor = UIColor.black
            }
            
            self.selectedIndex = index
            
            var afterIndexPaths = [IndexPath]()
            
            let afterDataDic = self.questionDataArray[self.selectedIndex]
            let afterRowArray = afterDataDic["sub"] as? [[String:Any]] ?? [[String:Any]]()
            
            for i in 0..<afterRowArray.count{
                afterIndexPaths.append(IndexPath(row: i, section: self.selectedIndex))
            }
            
            if let afterHeaderView = self.tableView.headerView(forSection: self.selectedIndex) as? QuestionSelectTableViewHeader {
                afterHeaderView.contentView.backgroundColor = UIColor(colorWithHexValue: 0xBE2F29)
                afterHeaderView.titleLabel.textColor = UIColor.white
            }
            
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: beforeIndexPaths, with: UITableView.RowAnimation.fade)
            self.tableView.insertRows(at: afterIndexPaths, with: UITableView.RowAnimation.fade)
            self.tableView.endUpdates()
            
        }
    }
}




class QuestionSelectTableViewCell: UITableViewCell {
    
    static let height : CGFloat = 50
    
    var titleLabel : UILabel!
    var checkButton : UIButton!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.frame.size = CGSize(width: SCREEN.WIDTH * 0.85, height: QuestionSelectTableViewCell.height)
        
        self.contentView.backgroundColor = UIColor(colorWithHexValue: 0xE2E2E2)
        
        titleLabel = UILabel(frame: CGRect(x: 10, y: 0, width: self.frame.size.width - 50, height: self.frame.size.height))
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(titleLabel)
        
        checkButton = UIButton(frame: CGRect(x: self.frame.size.width - 50, y: 0, width: 40, height: 40))
        checkButton.center.y = self.frame.size.height / 2
        checkButton.setImage(UIImage(named: "btn"), for: .normal)
        checkButton.setImage(UIImage(named: "btn_o"), for: .selected)
        checkButton.isUserInteractionEnabled = false
        self.addSubview(checkButton)
        
        let view1 = UIView(frame: CGRect(x: 0, y: self.frame.size.height - 0.5, width: self.frame.size.width, height: 0.5))
        view1.backgroundColor = UIColor(colorWithHexValue: 0xD8D8D8)
        self.addSubview(view1)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


@objc protocol QuestionSelectTableViewHeaderDelegate {
    @objc optional func questionSelectTableViewHeaderSeleted(index : Int)
}

class QuestionSelectTableViewHeader: UITableViewHeaderFooterView {
    
    var delegate : QuestionSelectTableViewHeaderDelegate?
    var index : Int = 0
    
    var titleLabel : UILabel!
    var button : UIButton!
    var bottomLineView : UIView!
    
    static let height : CGFloat = 50
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.frame.size = CGSize(width: SCREEN.WIDTH * 0.85, height: QuestionSelectTableViewHeader.height)
        
        titleLabel = UILabel(frame: CGRect(x: 10, y: 0, width: self.frame.size.width - 50, height: self.frame.size.height))
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        self.addSubview(titleLabel)
        
        bottomLineView = UIView(frame: CGRect(x: 0, y: self.frame.size.height - 0.5, width: self.frame.size.width, height: 0.5))
        bottomLineView.backgroundColor = UIColor(colorWithHexValue: 0xD8D8D8)
        self.addSubview(bottomLineView)
        
        button = UIButton(frame: self.bounds)
        button.addTarget(event: .touchUpInside) { (button) in
            self.delegate?.questionSelectTableViewHeaderSeleted?(index: self.index)
        }
        self.addSubview(button)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
