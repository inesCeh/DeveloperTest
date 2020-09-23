//
//  StudentsViewController.swift
//  DeveloperTest
//
//  Created by Ines Ceh on 17/09/2020.
//  Copyright © 2020 Ines Ceh. All rights reserved.
//

import UIKit
import Alamofire

class StudentsViewController: UIViewController {
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var studentsTableView: UITableView!

    private let tableCellIdentifier = "studentsTableViewCell"
    private var refreshControl = UIRefreshControl()
    var studentsList: [Student] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.applicationBackgroundColor
        self.title = NSLocalizedString("main_students", comment: "")
        
        activityView.style = .large
        createTable()
        refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString("common_pull_to_refresh", comment: ""))
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        studentsTableView.addSubview(refreshControl)
        studentsTableView.setContentOffset(CGPoint(x: 0, y: -refreshControl.frame.size.height), animated: true)

        fetchStudents()
    }

    internal func createTable() {
        
        let cellNib = UINib(nibName: "StudentsTableViewCell", bundle: nil)
        studentsTableView.register(cellNib, forCellReuseIdentifier: tableCellIdentifier)
        studentsTableView.separatorInset = UIEdgeInsets.zero
        studentsTableView.tableFooterView = UIView(frame: CGRect.zero)
        studentsTableView.estimatedRowHeight = 80
        studentsTableView.rowHeight = UITableView.automaticDimension
        studentsTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        studentsTableView.delegate = self
        studentsTableView.dataSource = self
    }
    
    func showError(message: String) {
        
        let alertController = UIAlertController(title: NSLocalizedString("error_title", comment: ""), message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: NSLocalizedString("common_action_Ok", comment: ""), style: UIAlertAction.Style.default) {
            UIAlertAction in
            
                self.refreshControl.endRefreshing()
                UIView.animate(withDuration: 0.2, animations: {
                    self.studentsTableView.contentOffset = CGPoint.zero
                })
        }

        alertController.addAction(okAction)

        self.present(alertController, animated: true, completion: nil)
    }
    @objc func refresh(_ sender: Any) {
        
        fetchStudents()
        self.refreshControl.endRefreshing()
    }
}

//MARK: UICollectionViewDelegate 
extension StudentsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

//MARK: UICollectionViewDataSource
extension StudentsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: StudentsTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.tableCellIdentifier) as! StudentsTableViewCell
        cell.selectionStyle = .none
        
        let student = studentsList[indexPath.row]
        cell.nameLabel.text = student.name
        cell.gradeLabel.text = NSLocalizedString("cell_data_grade", comment: "") + ": " + String(student.grade)
        let schoolId = student.school_id
        Utils.getSchoolName(schoolId: schoolId, schoolLabel: cell.schoolLabel)
    
        return cell;
    }
}

// MARK: - Alamofire
extension StudentsViewController {
    
  func fetchStudents() {
    
    activityView.startAnimating()
    AF.request("https://zpk2uivb1i.execute-api.us-east-1.amazonaws.com/dev/students")
      .validate()
      .responseDecodable(of: [Student].self) { (response) in
        switch response.result {
            case .success:
                guard let students = response.value else { return }
                self.studentsList = students
                self.studentsTableView.reloadData()
            case .failure(let error):
                print(Utils.getErrorMessage(error: error))
                self.showError(message: Utils.getErrorMessage(error: error))
            }
            self.activityView.stopAnimating()
            self.activityView.isHidden = true
        }
    }
}

