//
//  AVSearchController.swift
//  AVTVObject
//
//  Created by Tony-sg on 2020/4/26.
//  Copyright © 2020 Tony-sg. All rights reserved.
//

import UIKit
import ATKit_Swift
class AVSearchController: BaseTableViewController,searchDelegate {
    private lazy var hotWords: [String] = {
        return []
    }()
    
    private lazy var listData : [Any] = {
        return []
    }()
    private var _keyWord : String?
    private var keyWord  : String?{
        set{
            _keyWord = newValue ?? ""
            self.refreshData(page:RefreshPageStart)
            isSearchMode = _keyWord!.count > 0
        } get {
            return _keyWord ?? ""
        }
    }
    
    var isSearchMode = false
    
    private lazy var searchView : AVSearchView = {
        let searchView = AVSearchView.instanceView()
        searchView.delegate = self
        searchView.backBtn.addTarget(self, action: #selector(back), for: .touchUpInside)
        return searchView
    }()
    
    override func back(animated: Bool) {
        super.back(animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fd_prefersNavigationBarHidden = true
        self.view.addSubview(self.searchView)
        self.searchView.snp.makeConstraints { (make) in
            make.top.equalTo(kTopSafeH)
            make.left.right.equalToSuperview()
            make.height.equalTo(NAVI_BAR_HIGHT)
        }
        self.tableView.snp.remakeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.searchView.snp.bottom)
        }
        self.setupRefresh(scrollView: self.tableView, options: .defaults)
        
        getHotWords()
    }
    
    func getHotWords() {
        NetWorkTools.requestData(type: .get, URLString: kAppdelegate?.appConfig?.hotUrl ?? "", parameters: nil) { (result) in
            //1.1. 将 result 转成字典类型
            guard let resultDic = result as? [String : NSObject] else {
                return
            }
            
            //1.2. 根据 data 该 key，获取数组
            guard let dataArray = resultDic["data"] as? [[String : NSObject]] else {
                return
            }
            
            dataArray.forEach { dic in
                self.hotWords.append("\(dic["id"]!)  \(dic["text"]!)")
            }
            self.tableView.reloadData()
        }
    }
    
    override func refreshData(page: Int) {
        if self.keyWord!.count > 0 {
            let hud = MBProgressHUD.showAdded(to: view, animated: true)
            
            var parameters: [String: Any] = getDefaulParam(type: .search)
            parameters.updateValue(keyWord!, forKey: "search")
            
            NetWorkTools.requestData(type: .post, URLString: currentServer.serverDomain, parameters: parameters) { (result) in
                hud.hide(animated: true)
                
                //1.1. 将 result 转成字典类型
                guard let resultDic = result as? [String : NSObject] else {
                    self.endRefreshFailure()
                    return
                }
                
                //1.2. 根据 data 该 key，获取数组
                guard let dataArray = resultDic["data"] as? [[String : NSObject]] else {
                    self.endRefreshFailure()
                    return
                }
                
                //1.3. 视频
                guard let videoArray = dataArray.last?["videos"] as? [[String : NSObject]] else {
                    self.endRefreshFailure()
                    return
                }
                
                if let datas = [VideoModel].deserialize(from: videoArray) {
                    if page == RefreshPageStart {
                        self.listData.removeAll()
                    }
                    self.listData.append(contentsOf: datas as [Any])
                    self.tableView.reloadData()
                    self.endRefresh(more: datas.count >= RefreshPageSize)
                }else{
                    self.endRefreshFailure()
                }
            }
        }else{
            AVSearchDataQueue.getKeyWords(page: page, size: RefreshPageSize) { (datas) in
                if page == RefreshPageStart{
                    self.listData.removeAll()
                }
                self.listData.append(contentsOf: datas)
                self.tableView.reloadData()
                self.endRefresh(more: datas.count >= RefreshPageSize)
            }
        }
    }
    func searchText(text : String){
        self.keyWord = text;
        if text.count > 0 {
            let keyWord = text.trimmingCharacters(in: .whitespacesAndNewlines);
            self.inseartData(keyWord: keyWord)
        }else{
            self.refreshData(page: RefreshPageStart)
        }
    }
    func inseartData(keyWord : String){
        if keyWord.count > 0 {
            AVSearchDataQueueOC.insertData(toDataBase: keyWord) { (success) in
                
            }
        }
    }
    
    func searchView(searchView: AVSearchView, keyWord: String) {
        if searchView.searchBtn.currentTitle == "取消" {
            if searchView.textField.text == "" {
                back(animated: true)
            } else {
                searchView.textField.text = ""
                self.searchText(text: "")
            }
        } else {
            self.searchText(text: keyWord)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return isSearchMode ? 1 : 2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchMode {
            return listData.count
        } else {
            return section == 0 ? hotWords.count/2 : listData.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isSearchMode {
            return UITableView.automaticDimension
        } else {
            return isSearchMode ? 0 : indexPath.section == 0 ? 30 : 40
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSearchMode {
            let object = self.listData[indexPath.row]
            let cell = AVSearchResultCell.cellForTableView(tableView: tableView, indexPath: indexPath)
            let video = (object as! VideoModel)
            cell.imageV.kf.setImage(with: URL(string: video.vod_pic))
            cell.titleLab.text = video.vod_name
            cell.subTitleLab.text = video.vod_actor
            return cell
        } else {
            if indexPath.section == 0 {
                let cell = AVSearchCell.cellForTableView(tableView: tableView, indexPath: indexPath)
                cell.titleLab.text = hotWords[indexPath.row * 2]
                cell.subTitleLab.text = hotWords[indexPath.row * 2 + 1]
                cell.lineView.alpha = 0
                cell.selectionStyle = .none
                cell.tapBlock = { index in
                    let keyword = self.hotWords[indexPath.row * 2 + index].components(separatedBy: "  ").last ?? ""
                    self.searchText(text: keyword)
                    self.searchView.keyWord = keyword
                }
                return cell
            } else {
                let cell = AVSearchCell.cellForTableView(tableView: tableView, indexPath: indexPath)
                cell.titleLab.text = listData[indexPath.row] as? String
                cell.selectionStyle = .none
                cell.subTitleLab.text = ""
                cell.lineView.alpha = 1
                return cell
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return isSearchMode ? 0 : 44
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isSearchMode {
            return nil
        } else {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 44))
            label.backgroundColor = .white
            label.font = UIFont.boldSystemFont(ofSize: 18)
            label.text = section == 0 ? "    热搜" : "    搜索历史"
            return label
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if isSearchMode {
            let object = self.listData[indexPath.row]
            let model : VideoModel = object as! VideoModel
            AppJump.jumpToPlayControl(movieId: model.vod_id)
        } else {
            if indexPath.section == 0 {
//                let keyword = hotWords[indexPath.row * 2].components(separatedBy: "  ").last ?? ""
//                self.searchText(text: keyword)
//                self.searchView.keyWord = keyword
            } else {
                let keyword = listData[indexPath.row] as! String
                self.searchText(text: keyword)
                self.searchView.keyWord = keyword
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section != 0
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let row = UITableViewRowAction.init(style: .default, title: "删除") { (row, inde) in
            let object = self.listData[indexPath.row];
            if object is String{
                self.deleteAction(title: object as! String)
            }
        };
        return [row]
    }
    func deleteAction(title : String){
        AVSearchDataQueue.deleteKeyWord(keyWord: title) { (success) in
            self.refreshData(page: RefreshPageStart)
        }
    }
}
