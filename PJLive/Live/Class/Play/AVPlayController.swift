//
//  AVPlayController.swift
//  AVTVObject
//
//  Created by Tony-sg on 2020/4/27.
//  Copyright © 2020 Tony-sg. All rights reserved.
//

import UIKit
import MGJRouter_Swift
import SwiftyJSON

private let kHeaderViewID = "kHeaderViewID"

class AVPlayController: BaseConnectionController,playerDelegate,playVideoDelegate {
    convenience init(movieId : String) {
        self.init()
        self.movieId = movieId
    }
    
    private var sourceIndex = 0
    
    private var info : VodDetail?
    private var playItem : Players?
    private lazy var listData : [Players] = {
        return []
    }()
    private lazy var player : TVPlayer = {
        let player = TVPlayer()
        player.delegate = self
        return player
    }()
    private lazy var playerView: UIView = {
        let view : UIView = UIView.init()
        view.backgroundColor = UIColor.black
        return view
    }()
    private lazy var playView : AVPlayView = {
        let playView = AVPlayView.instanceView()
        playView.favBtn.addTarget(self, action: #selector(favAction(sender:)), for: .touchUpInside)
        playView.delegate = self
        return playView
    }()
    private lazy var backBtn : UIButton = {
        let btn : UIButton = UIButton.init()
        btn.setImage(UIImage.init(named:"icon_nav_back_w"), for: .normal)
        btn.addTarget(self, action: #selector(goBackAction), for: .touchUpInside)
        return btn
    }()
    private var movieId : String? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUI()
        loadDataQueue()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    private func loadUI(){

        self.fd_prefersNavigationBarHidden = true
        self.view.backgroundColor = UIColor.black
        self.view.addSubview(self.playerView)
        self.halfScreen()
        self.playerView.addSubview(self.player.contentView)
        self.player.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.playerView.addSubview(self.playView)
        self.playView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.playerView.addSubview(self.backBtn)
        self.backBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(44)
            if #available(iOS 11.0, *) {
                make.left.equalTo(self.backBtn.superview!.safeAreaLayoutGuide).offset(10)
            } else {
                make.left.equalToSuperview().offset(10)
            }
            make.top.equalToSuperview()
        }
        self.setupRefresh(scrollView: self.collectionView, options: .none)
        self.collectionView.snp.remakeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.playerView.snp.bottom)
        }
        self.view.sendSubviewToBack(self.playerView)
        
        collectionView.register(CollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kHeaderViewID)
    }
    
    private func loadData(){
        self.refreshData(page:RefreshPageStart)
    }
    override func refreshData(page: Int) {
        self.show()
        if self.movieId != nil {
            ApiMoya.apiMoyaRequest(target: .apiShow(movieId: self.movieId!), sucesss: { (json) in
                
                let detailJson: JSON = json.array?.first ?? [:]
                
                guard let info = VodDetail.deserialize(from: detailJson.rawString())else{
                    return
                }
                
                // 推荐视频
                if json.array?.count ?? 0 > 1 {
                    let recommandJson: JSON = json.array?[1] ?? [:]
                    info.related_vod = VodRecommand.deserialize(from: recommandJson.rawString())
                }
                
                self.endRefresh(more: false)
                self.info = info
                self.reloadData()
            }) { (error) in
                self.dismiss()
                ATAlertView.showAlertView(title: "网络问题,是否重试" + error, message: nil, normals: ["取消"], hights: ["确定"]) { (title , index) in
                    if index > 0{
                        self.loadData()
                    }else{
                        self.goBackAction()
                    }
                }
            }
        }
    }
    private func reloadData(){
        self.playView.titleLab.text = self.info?.player_vod.vod_name
        if self.info?.player_vod.vod_play.count ?? 0 > 0 {
            let info : Player_vod = self.info?.player_vod ?? Player_vod()
            let playUrls: [Players] = (info.vod_play.first?.players ?? []).reversed()
            
            if playUrls.count > 0 {
                AVBrowseDataQueue.getBrowseData(movieId: info.vod_id) { (model) in
                    if model.playItem.url.count > 0{
                        let res = playUrls.contains { (new) -> Bool in
                            return model.playItem.title == new.title && model.playItem.url.count > 0
                        }
                        var item = playUrls.first
                        if res{
                            let index = playUrls.firstIndex { (new) -> Bool in
                                return model.playItem.title == new.title && model.playItem.url.count > 0
                            }
                            item = playUrls[index ?? 0]
                        }
                        self.playVideo(item: item!)//https://v5.szjal.cn/20210818/GZ6zZd4V/index.m3u8
                    }else{
                        let item : Players = playUrls.first ?? Players()
                        self.playVideo(item: item)
                    }
                }
                self.listData.removeAll()
                self.listData.append(contentsOf: (info.vod_play.first?.players ?? []).reversed())
                self.collectionView.reloadData()
                self.endRefresh(more: false)
            }else{
                self.endRefreshFailure()
                self.dismiss()
                self.tryAgain(title: info.vod_name)
            }
        }else{
            self.endRefreshFailure()
            self.dismiss()
            self.tryAgain(title: self.info!.player_vod.vod_name)
        }
        
    }
    private func playVideo(item:Players){
        self.playItem = item
        let playUrl: String = item.url
        self.openRoute(playUrl:playUrl)
        AVBrowseDataQueue.getBrowseData(movieId:self.info!.player_vod.vod_id) { (info) in
            if info.playItem.needSeek! && info.playItem.url == item.url {//同一集
                self.player.playUrl(url: playUrl,time:info.playItem.currentTime)
            }else{
                self.player.playUrl(url: playUrl)
            }
        }
        self.collectionView.reloadData()
    }
    private func openRoute(playUrl : String){
        weak var weakSelf = self
        MGJRouter.registerWithHandler(playUrl) { (object) in
            let json = JSON(object as Any)
            if json["type"] == "zhibo"{
                weakSelf!.playView.living = true
            }
        }
        MGJRouter.open(playUrl)
    }
    private func tryAgain(title : String){
        ATAlertView.showAlertView(title:title + "无法播放是否重试！", message: nil, normals:["取消"], hights:["重试"]) { (title, index) in
            if index > 0{
                self.loadData()
            }
        }
    }
    private func loadDataQueue(){
        AVFavDataQueue.getFavData(movieId: self.movieId!) { (movie) in
            let res = movie.vod_id.count > 0 ? true : false
            self.playView.fav = res
        }
    }
    @objc private func goBackAction() {
        insertBrowData()
        BaseMacro.screen() ? orientations(screen: false) : self.goBack()
    }
    private func insertBrowData(){
        guard let item = self.playItem, let model = self.info?.player_vod else { return  }
        if let info : PlayItemInfo = PlayItemInfo.deserialize(from:item.toJSONString()){
            info.currentTime = self.player.current
            info.totalTime = self.player.duration
            info.living = self.playView.living

            model.playItem = info

            guard model.vod_id.count > 0 else {
                return
            }
            AVBrowseDataQueue.browseData(model: model) { (success) in
                
            }
        }
    }
    @objc private func favAction(sender: UIButton){
        if sender.isSelected {
            AVFavDataQueue.cancleFavData(movieId: self.movieId!) { (success) in
                self.playView.fav = false
            }
        }else{
            if let info = Player_vod.deserialize(from: self.info?.player_vod.toJSONString()) {
                AVFavDataQueue.favData(model:info) { (success) in
                    self.playView.fav = true
                }
            }
        }
    }
    private func orientations(screen:Bool){
        let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        delegate.makeOrientation = screen ? (UIInterfaceOrientation.landscapeRight) : (UIInterfaceOrientation.portrait)
        kAppdelegate?.blockRotation = screen ?.landscapeRight :.portrait
    }
    private func fullScreen(){
        self.playerView.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.collectionView.snp.remakeConstraints { (make) in
            make.top.bottom.right.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
        }
        self.playView.screen = true
        self.collectionView.isHidden = self.playView.screen
        setNeedsStatusBarAppearanceUpdate()
        
        self.collectionView.backgroundColor = Appx333333
        self.collectionView.backgroundView?.backgroundColor = Appx333333
    }
    private func halfScreen(){
        self.playerView.snp.remakeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(!iPhoneX ? 0 :STATUS_BAR_HIGHT)
            make.height.equalTo(SCREEN_WIDTH/16*9.0)
        }
        self.collectionView.snp.remakeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.playerView.snp.bottom)
        }
        self.playView.screen = false
        setNeedsStatusBarAppearanceUpdate()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.35) {
            self.collectionView.isHidden = self.playView.screen
            self.collectionView.backgroundColor = Appxffffff
            self.collectionView.backgroundView?.backgroundColor = Appxffffff
        }
    } 
    private func show(){
        if SVProgressHUD.isVisible() {
            SVProgressHUD.popActivity()
        }
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setForegroundColor(Appxdddddd)
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
        SVProgressHUD.setContainerView(self.playView)
        SVProgressHUD.show()
    }
    private func dismiss(){
        if SVProgressHUD.isVisible() {
            SVProgressHUD.popActivity()
        }
        SVProgressHUD.dismiss()
    }
    //MARK: playerDelegate
    func player(player: BasePlayer, progress: TimeInterval) {
        self.playView.player(player: player, progress: progress)
    }
    func player(player: BasePlayer, cache: TimeInterval) {
        self.playView.player(player: player, cache: cache)
    }
    func player(player: BasePlayer, bufferState: BufferState) {
        switch bufferState {
        case .empty:
            self.show()
            break
        default:
            self.dismiss()
            break
        }
    }
    func player(player: BasePlayer, playerstate: PlayerState) {
        self.playView.player(player: player, playerstate: playerstate)
        switch playerstate {
        case .ready:
            self.dismiss()
            break
        case .error:
            self.dismiss()
            self.tryAgain(title: "播放失败,")
            break
        default:
            break
            
        }
    }
    
    //MARK: playVideoDelegate
    func playView(playView: AVPlayView, pause: Bool) {
        self.player.playing ? self.player.pause() : self.player.resume()
    }
    func playView(playView: AVPlayView, screen: Bool) {
        self.orientations(screen:screen)
    }
    func playView(playView: AVPlayView, progress: TimeInterval) {
        self.player.seek(time: progress)
    }
    func playView(playView: AVPlayView, list: Bool) {
        if playView.screen {
            self.collectionView.isHidden = !list
        }
    }
    //MARK: DataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.info?.player_vod.vod_play.count ?? 0
        case 1:
            return self.listData.count
        default:
            return self.info?.related_vod?.videos.count ?? 0
        }
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 2 {
            return kDefaultMargin
        } else {
            let width = CGFloat((SCREEN_WIDTH - 4*itemTop)/3 - 0.1)
            return itemTop
        }
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if section == 2 {
            return kItemMargin
        } else {
            return itemTop
        }
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 2 {
            return UIEdgeInsets(top: kDefaultMargin, left: kDefaultMargin, bottom: kDefaultMargin, right: kDefaultMargin)
        } else {
            return UIEdgeInsets(top:itemTop, left: itemTop, bottom: 0, right: itemTop)
        }
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 2 {
            return CGSize(width: kNormalItemW, height: kNormalItemH)
        } else {
            let width = CGFloat((SCREEN_WIDTH - 4*itemTop)/3 - 0.1)
            return CGSize.init(width: width, height: 50)
        }
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            let cell : AVPlayCell = AVPlayCell.cellForCollectionView(collectionView: collectionView, indexPath: indexPath)
            let item = info?.player_vod.vod_play[indexPath.row].title
            cell.titleLab.text = item
            cell.selectCell = sourceIndex == indexPath.row
            return cell
        case 1:
            let cell : AVPlayCell = AVPlayCell.cellForCollectionView(collectionView: collectionView, indexPath: indexPath)
            let item = self.listData[indexPath.row]
            cell.item = item
            cell.selectCell = (item.url == self.playItem?.url)
            return cell
        default:
            let cell : CollectionNormalCell = CollectionNormalCell.cellForCollectionView(collectionView: collectionView, indexPath: indexPath)
            let video = info?.related_vod!.videos[indexPath.row]
            cell.anchor = video
            return cell
        }
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {//切换源
            listData.removeAll()
            
            let newAlbums = info?.player_vod.vod_play[indexPath.row].players.reversed() ?? []
            listData.append(contentsOf: newAlbums)
            guard let item = newAlbums.first else {
                return
            }
            
            sourceIndex = indexPath.row
            self.playVideo(item: item)
            self.collectionView.reloadData()
        } else if indexPath.section == 1 {//选集
            let item = self.listData[indexPath.row]
            self.playVideo(item: item)
            self.collectionView.reloadData()
        } else {
            //保存当前进度
            insertBrowData()
            
            //播放新的视频
            let item = info!.related_vod!.videos[indexPath.row]
            movieId = item.vod_id
            loadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        //1. 取出 headerView
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kHeaderViewID, for: indexPath) as! CollectionHeaderView
                
        //2. 给 headerView 设置数据
        headerView.titleLabel.text = info?.player_vod.vod_name
        headerView.moreBtn.isHidden = true
        return headerView
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.fd_interactivePopDisabled = size.width > size.height
        size.width > size.height ? self.fullScreen() : self.halfScreen()
        if SVProgressHUD.isVisible() {
            self.show()
        }
    }
    override var shouldAutorotate: Bool{
        return true
    }
    override var prefersStatusBarHidden: Bool{
        return !self.playView.screen
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .allButUpsideDown
    }
    
}

extension AVPlayController: UIApplicationDelegate {
    func applicationWillEnterForeground(_ application: UIApplication) {
        insertBrowData()//即将进入后台时,保存最新的播放记录
    }
}
