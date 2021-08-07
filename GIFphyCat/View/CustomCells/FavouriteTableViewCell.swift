//
//  FavouriteTableViewCell.swift
//  GIFphyCat
//
//  Created by Namrata Akash on 03/08/21.
//

import UIKit

class FavouriteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageview : UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imageview.image = UIImage(systemName: "person.fill")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
}
