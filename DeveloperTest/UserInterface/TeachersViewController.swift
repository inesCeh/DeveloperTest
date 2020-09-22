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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.applicationBackgroundColor
        self.title = NSLocalizedString("main_teachers", comment: "")
        
        activityView.style = .large
        createTable()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
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
    
    @objc func refresh(_ sender: Any) {
        fetchTeachers()
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
        getSchoolName(schoolId: schoolId, schoolLabel: cell.schoolLabel)
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
        
        let emailAction = UIAlertAction(title: NSLocalizedString("teachers_email", comment: ""), style: .default, handler:{ (UIAlertAction)in
        })
        let attributedTextEmail = NSMutableAttributedString(string: NSLocalizedString("teachers_email", comment: ""))
        let range = NSRange(location: 0, length: attributedTextEmail.length)
        attributedTextEmail.addAttribute(NSAttributedString.Key.kern, value: -0.41, range: range)
        attributedTextEmail.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "SFProText-Regular", size: 17.0)!, range: range)

        
        let messageAction = UIAlertAction(title: NSLocalizedString("teachers_message", comment: ""), style: .default, handler:{ (UIAlertAction)in
        })
        let callAction = UIAlertAction(title: NSLocalizedString("teachers_call", comment: ""), style: .default, handler:{ (UIAlertAction)in
        })
            
        let cancelAction = UIAlertAction(title: NSLocalizedString("common_action_cancel", comment: ""), style: .cancel)
        
        optionMenu.addAction(emailAction)
        optionMenu.addAction(messageAction)
        optionMenu.addAction(callAction)
        optionMenu.addAction(cancelAction)
        
        //optionMenu.view.tintColor = alertControllerTintColor
            
        self.present(optionMenu, animated: true, completion: nil)
    
        guard let labelEmail = (emailAction.value(forKey: "__representer")as? NSObject)?.value(forKey: "label") as? UILabel else { return }
        labelEmail.attributedText = attributedTextEmail
    }
}

// MARK: - Alamofire
extension TeachersViewController {
  
    func fetchTeachers() {

        activityView.isHidden = false
        activityView.startAnimating()
        AF.request("https://zpk2uivb1i.execute-api.us-east-1.amazonaws.com/dev/teachers")
            .validate()
            .responseDecodable(of: [Teacher].self) { (response) in
            
                switch response.result {
                case .success:
                    guard let teachers = response.value else { return }
                    self.teachersList = teachers
                    self.teachersTableView.reloadData()
                case .failure(let error):
                    print(self.getErrorMessage(error: error))
                }
                self.activityView.stopAnimating()
                self.activityView.isHidden = true
                self.refreshControl.endRefreshing()
        }
    }
    
    func getSchoolName(schoolId: Int, schoolLabel: UILabel) {
        
        AF.request("https://zpk2uivb1i.execute-api.us-east-1.amazonaws.com/dev/schools/\(schoolId)").validate(statusCode: 200..<600)
            .responseDecodable(of: SchoolDetails.self) { response in
          
                switch response.result {
                case .success:
                    guard let schoolsDetails = response.value else { return }
                    schoolLabel.text = NSLocalizedString("cell_data_school", comment: "") + ": " + schoolsDetails.name
                case .failure(let error):
                    print(self.getErrorMessage(error: error))
                }
            }
    }
    
    func getErrorMessage(error: AFError) -> String{
        
        var errorMessage = ""
        if let underlyingError = error.underlyingError {
            if let urlError = underlyingError as? URLError {
                switch urlError.code {
                case .timedOut:
                    errorMessage = "Timed out error"
                case .notConnectedToInternet:
                    errorMessage = "Not connected"
                default:
                    errorMessage = "Unmanaged error"
                }
            }
        }
        return errorMessage
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
