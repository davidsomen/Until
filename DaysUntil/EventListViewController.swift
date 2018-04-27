//
//  EventListViewController.swift
//  DaysUntil
//
//  Created by David Somen on 2018/04/03.
//  Copyright © 2018 David Somen. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleMobileAds

class EventCell: UITableViewCell
{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
}

class EventListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GADBannerViewDelegate, UIScrollViewDelegate
{
    let kAnimationDuration = 0.3
    let kBannerHeight: CGFloat = 50
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var bannerHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var buttonImage: UIImageView!
    @IBOutlet weak var buttonText: UILabel!
    
    let defaults = UserDefaults.standard
    
    var isChangingTheme = false
    {
        didSet
        {
            if isChangingTheme == oldValue
            {
                return
            }
            
            tableView.allowsSelection = !isChangingTheme
            
            UIView.animateKeyframes(withDuration: kAnimationDuration, delay: 0, options: .allowUserInteraction, animations:
            {
                self.updateStyle()
                
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations:
                {
                    let element = self.isChangingTheme ? self.buttonImage : self.buttonText
                    element.alpha = 0
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations:
                {
                    let element = self.isChangingTheme ? self.buttonText : self.buttonImage
                    element.alpha = 1
                })
             })
        }
    }
    
    var selectedThemeIndex: Int?
    {
        get
        {
            let index = scrollView.contentOffset.x / scrollView.frame.size.width - 1
            
            if index == floor(index)
            {
                return Int(index)
            }
            
            return nil
        }
    }
    
    lazy var realm: Realm = {
        return try! Realm()
    }()
    
    var events: Results<Event>!
    var token: NotificationToken!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        events = realm.objects(Event.self).filter("isDeleted == false").sorted(byKeyPath: "date")
        
        updateStyle()
        //setupBannerView()
        setupObservation()
        
        bannerHeightContraint.constant = 0
        view.layoutIfNeeded()
        
        //tableView.delaysContentTouches = false
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        updateScrollView(index: defaults.integer(forKey: "Theme"), width: scrollView.frame.width)
    }
    
    private func updateScrollView(index: Int, width: CGFloat)
    {
        scrollView.contentOffset.x = scrollView.frame.size.width * CGFloat(index + 1)
    }
    
    private func setupBannerView()
    {
        bannerView.adUnitID = "ca-app-pub-4731939656577901/7213518808" //"ca-app-pub-3940256099942544/2934735716" FOR TEST
        bannerView.load(GADRequest())
    }
    
    private func setupObservation()
    {
        token = events.observe
        {
            [unowned self] (changes: RealmCollectionChange) in
        
            switch changes
            {
            case .initial:
                self.tableView.reloadData()
           
            case .update(_, let deletions, let insertions, let modifications):
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                self.tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
                self.tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                self.tableView.endUpdates()
            
                if let insertion = insertions.first
                {
                    self.tableView.scrollToRow(at: IndexPath(row: insertion, section: 0), at: .top, animated: true)
                }
                
                UIView.animate(withDuration: self.kAnimationDuration)
                {
                    for indexPath in self.tableView.indexPathsForVisibleRows!
                    {
                        if let cell = self.tableView.cellForRow(at: indexPath)
                        {
                            self.updateCell(cell: cell, indexPath: indexPath)
                        }
                    }
                }
           
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        showEditView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let event = events[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! EventCell
        cell.titleLabel.text = event.title
        
        let calendar = Calendar.current
        let date = event.date
        let components = calendar.dateComponents([Calendar.Component.day], from: Date(), to: date)
        
        cell.daysLabel.text = String(components.day!)
        
        let selectedView = UIView(frame: .zero)
        selectedView.backgroundColor = Style.selectedColor
        
        cell.selectedBackgroundView = selectedView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        updateCell(cell: cell, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return !isChangingTheme
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            let event = events[indexPath.row]
            
            try! realm.write
            {
                event.isDeleted = true
            }
        }
    }
    
    func updateCell(cell: UITableViewCell, indexPath: IndexPath)
    {
        guard let cell = cell as? EventCell else { return }
        
        cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? Style.evenCellColor : Style.oddCellColor
        cell.selectedBackgroundView?.backgroundColor = Style.selectedColor
        
        cell.daysLabel.alpha = isChangingTheme ? 0.5 : 1
        cell.titleLabel.alpha = isChangingTheme ? 0.5 : 1
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView)
    {
        bannerHeightContraint.constant = kBannerHeight
        tableView.contentInset = UIEdgeInsetsMake(0, 0, kBannerHeight, 0)
        
        UIView.animate(withDuration: kAnimationDuration, animations:
        {
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func plusViewPressed(sender: AnyObject)
    {
        if self.isChangingTheme
        {
            self.isChangingTheme = false
            self.commitTheme()
        }
        else
        {
            self.showEditView()
        }
    }
    
    private func showEditView()
    {
        isChangingTheme = false
        
        DispatchQueue.main.async
        {
            self.performSegue(withIdentifier: "NewEvent", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let viewController = segue.destination as? EventEditViewController
        {
            if let indexPath = tableView.indexPathForSelectedRow
            {
                viewController.event = events[indexPath.row]
                tableView.deselectRow(at: indexPath, animated: false)
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if scrollView == self.scrollView
        {
            let index = scrollView.contentOffset.x / scrollView.frame.size.width
            if index == 0
            {
                scrollView.contentOffset.x = scrollView.frame.size.width * 4
            }
            else if index == 5
            {
                scrollView.contentOffset.x = scrollView.frame.size.width * 1
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        if scrollView == self.scrollView
        {
            if let index = selectedThemeIndex
            {
                changeTheme(index: index, animate: true)
            }
        }
    }
    
    private func changeTheme(index: Int, animate: Bool)
    {
        isChangingTheme = index != defaults.integer(forKey: "Theme")
        
        switch index
        {
        case 1:
            Style.themePurple()
            break
        case 2:
            Style.themeBlue()
            break
        case 3:
            Style.themeGreen()
            break
        default:
            Style.themeOrange()
        }
        
        UIView.animate(withDuration: animate ? kAnimationDuration : 0, delay: 0, options: .allowUserInteraction, animations:
        {
            self.updateStyle()
        })
    }
    
    private func commitTheme()
    {
        isChangingTheme = false
        
        if selectedThemeIndex == defaults.integer(forKey: "Theme")
        {
            return
        }
            
        defaults.set(selectedThemeIndex, forKey: "Theme")
        
        switch selectedThemeIndex
        {
        case 1:
            UIApplication.shared.setAlternateIconName("Purple")
            break
        case 2:
            UIApplication.shared.setAlternateIconName("Blue")
            break
        case 3:
            UIApplication.shared.setAlternateIconName("Green")
            break
        default:
            UIApplication.shared.setAlternateIconName(nil)
        }
    }
    
    private func updateStyle()
    {
        self.tableView.backgroundColor = Style.tableColor
        
        if let indexPaths = self.tableView.indexPathsForVisibleRows
        {
            for indexPath in indexPaths
            {
                let cell = self.tableView.cellForRow(at: indexPath)!
                self.updateCell(cell: cell, indexPath: indexPath)
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: {
            _ in
            
            if let index = self.selectedThemeIndex
            {
                self.updateScrollView(index: index, width: size.width)
            }
        })
    }
    
    /*var themeIndex = 0
    @IBAction func cycleTheme()
    {
        themeIndex = themeIndex + 1
        
        switch themeIndex
        {
        case 1:
            Style.themePurple()
            break
        case 2:
            Style.themeBlue()
            break
        case 3:
            Style.themeGreen()
            break
        default:
            Style.themeOrange()
            themeIndex = 0
        }
        
        updateScrollView(index: themeIndex + 1, width: scrollView.frame.width)
        
        self.updateStyle()
    }*/
}
