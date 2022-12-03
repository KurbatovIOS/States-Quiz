//
//  GameHistoryViewController.swift
//  States Quiz
//
//  Created by Kurbatov Artem on 23.11.2022.
//

import UIKit
import CoreData
import SnapKit

class ResultsViewController: UIViewController {
    
    private let resultsTableView = UITableView()
    private let resultModel = ResultModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        resultsTableView.register(ResultTableViewCell.self, forCellReuseIdentifier: "resultCell")
        
        navigationItem.title = "Results"
        
        setUpResults()
        view.backgroundColor = .systemBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        resultModel.fetchResults(tableView: resultsTableView)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setUpResults() {
        
        view.addSubview(resultsTableView)
        
        resultsTableView.allowsSelection = false
        
        resultsTableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.top.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(20)
        }
        
    }
}

extension ResultsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultModel.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  let cell = resultsTableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as? ResultTableViewCell {
            cell.setUpCell(resultToDisplay: resultModel.results[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { action, view, complitionHandler in
            
            self.resultModel.removeResult(resultId: indexPath.row, tableView: self.resultsTableView)
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
}
