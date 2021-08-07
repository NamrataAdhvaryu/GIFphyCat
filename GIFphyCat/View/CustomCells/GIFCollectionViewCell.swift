//
//  GIFCollectionViewCell.swift
//  GIFphyCat
//
//  Created by Namrata Akash on 02/08/21.
//

import UIKit

protocol likeGifProtocol {
    func likeGif(index:Int,status:Bool)
}

class GIFCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var staticImageView: UIImageView!
    @IBOutlet weak var hashtags: UILabel!
    @IBOutlet weak var hashtagsPanel: UIVisualEffectView!
    @IBOutlet weak var favouritebutton : UIButton!
    var status:Bool = true
    
    var likedConfiguration: ButtonConfiguration  = (symbol: "suit.heart.fill", configuration: UIImage.SymbolConfiguration(pointSize: 31, weight: .semibold, scale: .default), buttonTint: UIColor.systemPink)
    var normalConfiguation: ButtonConfiguration  = (symbol: "suit.heart", configuration: UIImage.SymbolConfiguration(pointSize: 31, weight: .semibold, scale: .default), buttonTint: UIColor.tertiaryLabel)
    let buttonAnimationFactory: ButtonAnimationFactory = ButtonAnimationFactory()
    var delegate : likeGifProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setButton(with: normalConfiguation)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.setButton(with: normalConfiguation)
    }
    
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        
        
        delegate?.likeGif(index: sender.tag, status: status)
        
        
        if (status) {
            
            buttonAnimationFactory.makeActivateAnimation(for: favouritebutton, likedConfiguration)
            status = false
            
        } else {
            buttonAnimationFactory.makeDeactivateAnimation(for: favouritebutton, normalConfiguation)
            status = true
        }
    }
    func setButton(with config: ButtonConfiguration) {
        self.favouritebutton?.setImage(UIImage(systemName: config.symbol, withConfiguration: config.configuration), for: .normal)
        self.favouritebutton?.tintColor = config.buttonTint
        self.favouritebutton?.layer.cornerRadius = 15
        self.favouritebutton?.layer.opacity = 0.75
    }
    
}

