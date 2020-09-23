//
//  TeachersViewController.swift
//  DeveloperTest
//
//  Created by Ines Ceh on 17/09/2020.
//  Copyright © 2020 Ines Ceh. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class TeachersViewController: UIViewController {
        
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var teachersTableView: UITableView!
    
    var teachersList: [Teacher] = []
    private let tableCellIdentifier = "teachersTableViewCell"
    private var refreshControl = UIRefreshControl()
    private var isFirstTime = true
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.applicationBackgroundColor
        self.title = NSLocalizedString("main_teachers", comment: "")
        
        activityView.style = .large
        createTable()
        refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString("common_pull_to_refresh", comment: ""))
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        teachersTableView.addSubview(refreshControl)
        teachersTableView.setContentOffset(CGPoint(x: 0, y: -refreshControl.frame.size.height), animated: true)
        
        fetchTeachers()
    }
    
    internal func createTable() {
        
        let cellNib = UINib(nibName: "TeachersTableViewCell", bundle: nil)
        teachersTableView.register(cellNib, forCellReuseIdentifier: tableCellIdentifier)
        teachersTableView.separatorInset = UIEdgeInsets.zero
        teachersTableView.tableFooterView = UIView(frame: CGRect.zero)
        teachersTableView.estimatedRowHeight = 110
        teachersTableView.rowHeight = UITableView.automaticDimension
        teachersTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        teachersTableView.delegate = self
        teachersTableView.dataSource = self
    }
    
    func showError(message: String) {
        
        let alertController = UIAlertController(title: NSLocalizedString("error_title", comment: ""), message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: NSLocalizedString("common_action_Ok", comment: ""), style: UIAlertAction.Style.default) {
            UIAlertAction in
            
                self.refreshControl.endRefreshing()
                UIView.animate(withDuration: 0.2, animations: {
                    self.teachersTableView.contentOffset = CGPoint.zero
                })
        }

        alertController.addAction(okAction)

        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func refresh(_ sender: Any) {
        
        fetchTeachers()
        self.refreshControl.endRefreshing()
    }
}

//MARK: UICollectionViewDelegate
extension TeachersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

//MARK: UICollectionViewDataSource 
extension TeachersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teachersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: TeachersTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.tableCellIdentifier) as! TeachersTableViewCell
        cell.selectionStyle = .none
        
        cell.delegate = self
        let teacher = teachersList[indexPath.row]
        cell.teacherID = teacher.id
        cell.nameLabel.text = teacher.name
        cell.classLabel.text = NSLocalizedString("cell_data_class", comment: "") + ": " +  teacher.className
        let schoolId = teacher.school_id
        Utils.getSchoolName(schoolId: schoolId, schoolLabel: cell.schoolLabel)
        getImage(image_url: teacher.image_url, image_view: cell.teacherImageView)
        
        return cell;
    }
}

//MARK: TeachersTableViewCellDelegate
extension TeachersViewController: TeachersTableViewCellDelegate {
    
    func openContactList(teacherID: Int) {
        
        let optionMenu = UIAlertController(title: nil, message: NSLocalizedString("teachers_contact", comment: ""), preferredStyle: .actionSheet)
        
        let messageFont = [kCTFontAttributeName: UIFont(name: "SFProText-Regular", size: 13.0)!]
        let messageAttrString = NSMutableAttributedString(string: "Message Here", attributes: messageFont as [NSAttributedString.Key : Any])
        optionMenu.setValue(messageAttrString, forKey: "attributedMessage")
        
        let attributedTextEmail = getNSMuttableAttributtedString(title: NSLocalizedString("teachers_email", comment: ""))
        let emailAction = UIAlertAction(title: NSLocalizedString("teachers_email", comment: ""), style: .default, handler:{ (UIAlertAction)in
        })

        let attributedTextMessage = getNSMuttableAttributtedString(title: NSLocalizedString("teachers_message", comment: ""))
        let messageAction = UIAlertAction(title: NSLocalizedString("teachers_message", comment: ""), style: .default, handler:{ (UIAlertAction)in
        })
        
        let attributedTextCall = getNSMuttableAttributtedString(title: NSLocalizedString("teachers_call", comment: ""))
        let callAction = UIAlertAction(title: NSLocalizedString("teachers_call", comment: ""), style: .default, handler:{ (UIAlertAction)in
        })
            
        let attributedTextCancel = getNSMuttableAttributtedString(title: NSLocalizedString("common_action_cancel", comment: ""))
        let cancelAction = UIAlertAction(title: NSLocalizedString("common_action_cancel", comment: ""), style: .cancel)
        
        optionMenu.addAction(emailAction)
        optionMenu.addAction(messageAction)
        optionMenu.addAction(callAction)
        optionMenu.addAction(cancelAction)
        
        optionMenu.view.tintColor = UIColor.alertControllerTintColor
            
        self.present(optionMenu, animated: true, completion: nil)
    
        guard let labelEmail = (emailAction.value(forKey: "__representer")as? NSObject)?.value(forKey: "label") as? UILabel else { return }
        labelEmail.attributedText = attributedTextEmail
        guard let labelMessage = (messageAction.value(forKey: "__representer")as? NSObject)?.value(forKey: "label") as? UILabel else { return }
        labelMessage.attributedText = attributedTextMessage
        guard let labelCall = (callAction.value(forKey: "__representer")as? NSObject)?.value(forKey: "label") as? UILabel else { return }
        labelCall.attributedText = attributedTextCall
        guard let labelCancel = (cancelAction.value(forKey: "__representer")as? NSObject)?.value(forKey: "label") as? UILabel else { return }
        labelCancel.attributedText = attributedTextCancel
    }
    
    func getNSMuttableAttributtedString(title: String) -> NSMutableAttributedString {
        let attributedText = NSMutableAttributedString(string: title)
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.addAttribute(NSAttributedString.Key.kern, value: -0.41, range: range)
        attributedText.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "SFProText-Regular", size: 17.0) ?? UIFont.systemFont(ofSize: 17), range: range)
        return attributedText
    }
}

// MARK: - Alamofire
extension TeachersViewController {
  
    func fetchTeachers() {

        if (isFirstTime)
        {
            activityView.startAnimating()
        }
        AF.request("https://zpk2uivb1i.execute-api.us-east-1.amazonaws.com/dev/teachers")
            .validate()
            .responseDecodable(of: [Teacher].self) { (response) in
            
                switch response.result {
                case .success:
                    guard let teachers = response.value else { return }
                    self.teachersList = teachers
                    self.teachersTableView.reloadData()
                case .failure(let error):
                    self.showError(message: Utils.getErrorMessage(error: error))
                }
                if(self.isFirstTime)
                {
                    self.activityView.stopAnimating()
                    self.activityView.isHidden = true
                    self.isFirstTime = false
                }
        }
    }
}

// MARK: - Kingfisher
extension TeachersViewController {
    
    func getImage(image_url: String, image_view: UIImageView ){
    
        let url = URL(string: image_url)!
        let processor = DownsamplingImageProcessor(size: image_view.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: 0)
        image_view.kf.indicatorType = .activity
        image_view.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholderImage"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ], completionHandler:
                {
                    result in
                    switch result {
                    case .success(let value):
                        print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    case .failure(let error):
                        print("Job failed: \(error.localizedDescription)")
                    }
            })
    }
}
