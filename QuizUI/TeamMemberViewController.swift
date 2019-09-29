//
//  ViewController.swift
//  QuizUI
//
//  Created by Mark33699 on 2019/9/26.
//  Copyright © 2019 eLove_ePhone. All rights reserved.
//

import UIKit

class TeamMemberViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    //MARK: - var
    
    var teamMembers = [TeamMember]()
    var animationType = AnimationType.none
    var downloadtask = URLSessionDownloadTask()
    
    //MARK: - let
    
    let cellReuseKey = "cellReuseKey"
    let tableView = UITableView()
    let memoryCache: NSCache<AnyObject, AnyObject> = NSCache()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        func setupUI()
        {
            self.view.backgroundColor = .white
            self.title = "TeamMemberList"
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .refresh, target: self, action: #selector(relaodAnimation))
        }
        
        func setupTableView()
        {
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.dataSource = self
            tableView.delegate = self
            tableView.estimatedRowHeight = 120
            tableView.register(TeamMemberTableViewCell.self, forCellReuseIdentifier: cellReuseKey)
            self.view.addSubview(tableView)
            let width = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[someView]-|",
                                                       options: .init(),
                                                       metrics: nil,
                                                       views: ["someView": tableView])
            let height = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[someView]-|",
                                                        options: .init(),
                                                        metrics: nil,
                                                        views: ["someView": tableView])
            self.view.addConstraints(width)
            self.view.addConstraints(height)
        }
        
        func fetchTeamMembers()
        {
            if let path = Bundle.main.path(forResource: "team", ofType: "json")
            {
                do
                {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    if let jsonTeamMembers = try? JSONDecoder().decode(TeamMembers.self, from: data)
                    {
                        teamMembers = jsonTeamMembers
                        tableView.reloadData()
                    }
                }
                catch
                {
                    print("Error: get jsonData")
                }
            }
        }
        
        setupUI()
        setupTableView()
        fetchTeamMembers()
    }
    
    override func didReceiveMemoryWarning()
    {
        memoryCache.removeAllObjects()
    }
    
    //MARK: - Selector
    
    @objc func relaodAnimation()
    {
        func addAnimationAction(alert: UIAlertController, type: AnimationType)
        {
            alert.addAction(UIAlertAction.init(title: type.rawValue, style: .default, handler:
            {(action) in
                self.animationType = type
                self.tableView.reloadData()
            }))
        }
        
        let animationTypes: [AnimationType] = [.none, .bounce, .fade, .slide, .zoom]
        let alert = UIAlertController.init(title: "Select Animation Type", message: nil, preferredStyle: .alert)
        for type: AnimationType in animationTypes
        {
            addAnimationAction(alert: alert, type: type)
        }
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - UITableView Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return teamMembers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        func downloadImage(teamMember: TeamMember, fullPath: String)
        {
            if let url = URL(string: teamMember.avatar)
            {
                downloadtask = URLSession.shared.downloadTask(with: url, completionHandler:
                { (location, response, error) -> Void in
                        
                    if let data = try? Data(contentsOf: url)
                    {
                        DispatchQueue.main.async(execute:
                        { () -> Void in
                                
                            if let cell = tableView.cellForRow(at: indexPath),
                               let tmCell = cell as? TeamMemberTableViewCell,
                               let img = UIImage(data: data)
                            {
                                tmCell.avatar.image = img
                                print("get image by download")
                                self.memoryCache.setObject(img, forKey: indexPath.row as AnyObject)
                                do
                                {
                                    try data.write(to: URL(fileURLWithPath: fullPath))
                                }
                                catch
                                {
                                    print("Error: save to file")
                                }
                            }
                        })
                    }
                })
                downloadtask.resume()
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseKey, for: indexPath)
        if let teamMemberCell = cell as? TeamMemberTableViewCell
        {
            let teamMember = teamMembers[indexPath.row]
            teamMemberCell.updateUIWith(teamMember)
            
            if let cacheObject = self.memoryCache.object(forKey: indexPath.row as AnyObject),
               let img = cacheObject as? UIImage
            {
                teamMemberCell.avatar.image = img
                print("get image by memory")
            }
            else
            {
                if let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last
                {
                    let fullPath = cachePath + "/" + NSString.init(string: teamMember.avatar).lastPathComponent
                    if let cacheData = NSData.init(contentsOfFile: fullPath),
                    let img = UIImage.init(data: cacheData as Data )
                    {
                        teamMemberCell.avatar.image = img
                        print("get image by file")
                    }
                    else
                    {
                        downloadImage(teamMember: teamMember, fullPath: fullPath)
                    }
                }
            }
        }
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
//    {
//        return 200
//    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        var animation = AnimationFactory.makeFadeAnimationWith(duration: 0.5, delayFactor: 0.1)
        switch animationType
        {
            case .none:
                return
            case .fade:
                animation = AnimationFactory.makeFadeAnimationWith(duration: 0.5, delayFactor: 0.1)
            case .bounce:
                animation = AnimationFactory.makeBounceAnimationWith(rowHeight:cell.frame.height, duration: 1.0, delayFactor: 0.05)
            case .slide:
                animation = AnimationFactory.makeSlideInAnimationWith(duration: 0.5, delayFactor: 0.05)
            case .zoom:
                animation = AnimationFactory.makeZoomAnimationWith(duration: 0.5)
        }
        Animator(animation: animation).animate(cell: cell, at: indexPath, in: tableView)
    }
}

