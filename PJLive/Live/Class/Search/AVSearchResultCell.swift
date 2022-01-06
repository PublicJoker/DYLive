//
//  AVSearchResultCell.swift
//  AVTVObject
//
//  Created by Tony-sg on 2020/4/27.
//  Copyright © 2020 Tony-sg. All rights reserved.
//

import UIKit

class AVSearchResultCell: UITableViewCell {
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var subTitleLab: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    var model : AVMovie?{
        didSet{
            guard let item = model else { return }
            self.titleLab.text = item.name
            self.imageV.kf.setImage(with: URL.init(string: item.pic),placeholder: placeholder)
            self.subTitleLab.text = item.type + "/" + item.state + "/" + item.info
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageV.layer.cornerRadius = 3
        imageV.layer.masksToBounds = true
        playBtn.layer.cornerRadius = 15
        playBtn.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

typealias TapBlock = (Int) -> Void

class AVSearchCell : UITableViewCell {
    var tapBlock: TapBlock?
    
    public lazy var titleLab : UILabel = {
        let label = UILabel.init()
        label.font = UIFont .systemFont(ofSize: 16);
        label.textColor = Appx333333
        return label
    }()
    
    public lazy var subTitleLab : UILabel = {
        let label = UILabel.init()
        label.font = UIFont .systemFont(ofSize: 16)
        label.textColor = Appx333333
        return label
    }()
    
    public lazy var lineView : UIView = {
        let line = UIView.init()
        line.backgroundColor = Appxdddddd
        return line
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        loadUI()
    }
    private func loadUI(){
        contentView.addSubview(titleLab)
        titleLab.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.right.equalTo(contentView.snp.centerX).offset(-5)
        }
        
        titleLab.tag = 0
        titleLab.isUserInteractionEnabled = true
        titleLab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapLabel(sender:))))
        
        contentView.addSubview(subTitleLab)
        subTitleLab.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(contentView.snp.centerX).offset(5)
            make.right.equalToSuperview().offset(-12)
        }
        subTitleLab.tag = 1
        subTitleLab.isUserInteractionEnabled = true
        subTitleLab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapLabel(sender:))))
        
        self.contentView.addSubview(self.lineView)
        self.lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    @objc func tapLabel(sender: UIGestureRecognizer) {
        tapBlock?(sender.view!.tag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
