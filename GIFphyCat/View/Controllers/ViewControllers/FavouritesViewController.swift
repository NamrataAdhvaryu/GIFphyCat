//
//  FavouritesViewController.swift
//  GIFphyCat
//
//  Created by Namrata Akash on 03/08/21.
//

import UIKit

class FavouritesViewController: UIViewController {
    @IBOutlet weak var tableview : UITableView!
    internal let viewModel = DashboardViewModel()
    
    var likedGifArray = [GIF]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTableView(_:)), name: NSNotification.Name(rawValue: "likedGifArray"), object: nil)
        
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    
    
    @objc func reloadTableView(_ notification: NSNotification){
        if let array = notification.userInfo?["array"] as? [GIF] {
            
            self.likedGifArray = array
            self.tableview.reloadData()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        
    }
}

extension FavouritesViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.likedGifArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Favourites", for: indexPath) as! FavouriteTableViewCell
        self.viewModel.likeGif(for: indexPath, likeGif: self.likedGifArray) { (data: Data?, originalIndexPath: IndexPath) in
            DispatchQueue.main.async {
                if indexPath == originalIndexPath
                {
                    if let data = data
                    {
                        let image =  UIImage.gif(from: data)
                        cell.imageview.image = image
                    }
                }
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    
}
