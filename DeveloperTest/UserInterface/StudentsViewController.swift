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
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
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
    
    @objc func refresh(_ sender: Any) {
        fetchStudents()
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
        getSchoolName(schoolId: schoolId, schoolLabel: cell.schoolLabel)
    
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
                self.activityView.stopAnimating()
                self.activityView.isHidden = true
                self.refreshControl.endRefreshing()
            case .failure(let error):
                print(self.getErrorMessage(error: error))
            }
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

