//
//  ContentCell.swift
//  GIFV Scroller
//
//  Created by Roman Kravtsov on 02.05.2020.
//  Copyright © 2020 Roman Kravtsov. All rights reserved.
//

import UIKit
import AVKit

class ContentCell: UITableViewCell {
    
    private lazy var title: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private lazy var playerContainer: UIView = {
       let playerContainer = UIView()
        playerContainer.translatesAutoresizingMaskIntoConstraints = false
        return playerContainer
    }()
    
    private lazy var preview: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    var avPlayer: AVPlayer?
    var avPlayerLayer: AVPlayerLayer?
    
    var contentType: DataType = .video
    
    var contentURL: URL? {
        didSet {
            if let contentURL = contentURL {
                if contentType == .video {
                    avPlayer = AVPlayer(url: contentURL)
                    avPlayerLayer = AVPlayerLayer(player: avPlayer)
                    avPlayerLayer?.frame = playerContainer.frame
                    avPlayerLayer?.backgroundColor = UIColor.clear.cgColor
                    avPlayerLayer?.videoGravity = .resizeAspectFill
                    layer.addSublayer(avPlayerLayer!)
                } else {
                    if let data = try? Data(contentsOf: contentURL),
                        let image = UIImage(data: data) {
                    addImageView(with: image)
                    setNeedsLayout()
                    }
                }
                
            } else {
                //avPlayer?.replaceCurrentItem(with: nil)
                avPlayerLayer?.removeFromSuperlayer()
                avPlayer = nil
                avPlayerLayer = nil
                preview.removeFromSuperview()
            }
            
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //layer.sublayers?.removeAll()
        configure(with: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        addTitle()
        addPlayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addTitle() {
        addSubview(title)
        let constraints = [
            title.topAnchor.constraint(equalTo: topAnchor),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            title.trailingAnchor.constraint(equalTo: trailingAnchor),
            title.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func addPlayer() {
        let playerWidth = UIScreen.main.bounds.width
        let playerHeight = playerWidth / 16 * 9
        addSubview(playerContainer)
        let constraints = [
            playerContainer.topAnchor.constraint(equalTo: title.bottomAnchor),
            playerContainer.widthAnchor.constraint(equalToConstant: playerWidth),
            playerContainer.heightAnchor.constraint(equalToConstant: playerHeight),
            playerContainer.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func addImageView(with image: UIImage) {
        preview.image = image
        playerContainer.addSubview(preview)
        let constraints = [
            preview.topAnchor.constraint(equalTo: playerContainer.topAnchor),
            preview.bottomAnchor.constraint(equalTo: playerContainer.bottomAnchor),
            preview.leadingAnchor.constraint(equalTo: playerContainer.leadingAnchor),
            preview.trailingAnchor.constraint(equalTo: playerContainer.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func configure(with contentItem: ContentItem?) {
        if let contentItem = contentItem {
            let urlString = contentItem.cover.url
            contentType = contentItem.cover.additionalData.type
            contentURL = URL(string: urlString)
            title.text = contentItem.intro
            title.alpha = 1
        } else {
            title.alpha = 0
            contentURL = nil
        }
    }
    
    func playVideo() {
        avPlayer?.play()
    }
    
    func pauseVideo() {
        avPlayer?.pause()
    }
}
