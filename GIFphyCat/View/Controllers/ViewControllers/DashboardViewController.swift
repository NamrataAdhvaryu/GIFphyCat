//
//  DashboardViewController.swift
//  GIFphyCat
//
//  Created by Namrata Akash on 02/08/21.
//

import UIKit


class DashboardViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backgroundCollectionView: UICollectionView!
    
    
    
    
    internal let viewModel = DashboardViewModel()
    
    
    private let speechController = SpeechController()
    
    
    private lazy var settingsController: SettingsController = SettingsController(with: self)
    
    var gifsArray = [GIF]()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureViewModel()
        self.configureCollectionView()
        self.configureSearchBar()
        self.viewModel.setNeedsRefresh()
        self.configureButtons()
        for viewController in tabBarController?.viewControllers ?? [] {
            if let navigationVC = viewController as? UINavigationController, let rootVC = navigationVC.viewControllers.first {
                let _ = rootVC.view
            } else {
                let _ = viewController.view
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - Configuring the Collection View
    
    func configureCollectionView()
    {
        self.configure(collectionView: self.collectionView)
        self.configure(collectionView: self.backgroundCollectionView)
        if viewModel.gifs != nil {
            self.gifsArray = viewModel.gifs!
        }
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.collectionView.refreshControl = refreshControl
    }
    
    func configure(collectionView: UICollectionView)
    {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let layout = GiphyLayout()
        layout.scrollDirection = .vertical
        
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let height = collectionView.bounds.size.height / 4.0
        let width = collectionView.bounds.size.width / 4.0
        
        layout.itemSize = CGSize(width: width, height: height)
        collectionView.contentInset = .zero
        
        collectionView.collectionViewLayout = layout
        
    }
    
    // MARK: - Configuring the Search Bar
    
    // Set up the search bar.
    func configureSearchBar()
    {
        self.searchBar.delegate = self
        self.searchBar.placeholder = NSLocalizedString("Type to Search Giphy", comment: "A string with search instructions.")
    }
    
    // MARK: - Configuring UIBarButtonItems
    
    func configureButtons()
    {
        let speakButton = UIBarButtonItem(title: "💬 (🎧)", style: .plain, target: self, action: #selector(speak))
        self.navigationItem.rightBarButtonItem = speakButton
        
        let settingsButton = UIBarButtonItem(title: "⚙️", style: .plain, target: self, action: #selector(showSettings))
        self.navigationItem.leftBarButtonItems = [settingsButton]
    }
    
    // MARK: - Configuring Our Response to ViewModel Updates
    
    
    func configureViewModel()
    {
        self.viewModel.refreshHandler = { [weak self] in
            
            guard let strongSelf = self else {
                return
            }
            
            DispatchQueue.main.async {
                
                strongSelf.title = strongSelf.viewModel.title
                
                strongSelf.collectionView.performBatchUpdates({
                    let itemIndexSet = IndexSet(integer: 0)
                    strongSelf.collectionView.reloadSections(itemIndexSet)
                }) { (complete: Bool) in
                    strongSelf.backgroundCollectionView.reloadData()
                }
                
                strongSelf.collectionView.refreshControl?.endRefreshing()
            }
        }
        
    }
    
    // MARK: - Manually Refreshing
    
    @objc func refresh()
    {
        self.collectionView.refreshControl?.beginRefreshing()
        self.viewModel.setNeedsRefresh()
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.gifs?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.viewModel.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "com.namrata.cell", for: indexPath) as! GIFCollectionViewCell
        
        /*
         give tag to button to identify which button click
         */
        cell.favouritebutton.tag = indexPath.item
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let cell = cell as! GIFCollectionViewCell
        
        if collectionView == self.collectionView
        {
            if let hashtags = self.viewModel.hashtags(for: indexPath)
            {
                cell.hashtags.text = hashtags
                cell.hashtagsPanel.alpha = 1.0
            }
            else
            {
                cell.hashtagsPanel.alpha = 0.0
            }
        }
        
        let _ = self.viewModel.gif(for: indexPath) { (data: Data?, originalIndexPath: IndexPath) in
            DispatchQueue.main.async {
                if indexPath == originalIndexPath
                {
                    if let data = data
                    {
                        let image =  UIImage.gif(from: data)
                        if let cell = collectionView.cellForItem(at: originalIndexPath) as? GIFCollectionViewCell
                        {
                            cell.staticImageView.image = image
                        }
                    }
                }
            }
            
        }
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.collectionView
        {
            self.backgroundCollectionView.contentOffset = self.collectionView.contentOffset
        }
    }
    
    // MARK: - Speak
    
    
    @objc func speak()
    {
        self.speechController.pronounce(text: "This app uses UICollectionView, NSURLSession, and Swift to display trending images from Giphy.com. You can search GIF using the search bar. You can also like multiple GIF and that can be store in favorite viewcontroller")
    }
    
    // MARK: - Showing Settings
    
    // Show the settings menu.
    // For now, just skip to ratings.
    @objc func showSettings()
    {
        self.settingsController.present()
    }
    
    
}



extension DashboardViewController: likeGifProtocol{
    func likeGif(index: Int, status: Bool) {
        
        /*
         Logic:- when click on like button first it check that gifs id match with likedGifIDArray's id or not. if it not match then it add id in likedGifIDArray and data in likedGifArray. if it match then it remove id and data from likedGifIDArray and likedGifArray resp.
         */
        if self.viewModel.likedGifIDArray.contains(self.viewModel.gifs![index].id){
            let itemIndex =  self.viewModel.likedGifIDArray.firstIndex{ $0 ==  self.viewModel.gifs![index].id}
            self.viewModel.likedGifArray.remove(at: itemIndex ?? 0)
            self.viewModel.likedGifIDArray.remove(at: itemIndex ?? 0)
            
            /*
             use notification to immediately change in favouritesVC
             */
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "likedGifArray"), object: nil, userInfo: ["array":self.viewModel.likedGifArray])
            print("likedGifArray",self.viewModel.likedGifArray.count)
            
        }else{
            
            self.viewModel.likedGifArray.append(self.viewModel.gifs![index])
            self.viewModel.likedGifIDArray.append(self.viewModel.gifs![index].id)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "likedGifArray"), object: nil, userInfo: ["array":self.viewModel.likedGifArray])
            print("likedGifArray",self.viewModel.likedGifArray.count)
            
        }
    }
    
}

