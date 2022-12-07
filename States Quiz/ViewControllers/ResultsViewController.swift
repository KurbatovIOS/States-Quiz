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
    private let clearButton = UIButton()
    private let resultModel = ResultModel()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        resultsTableView.register(ResultTableViewCell.self, forCellReuseIdentifier: "resultCell")
        
        navigationItem.title = "Results"
        view.backgroundColor = .systemBackground
                
        setUpClearButton()
        setUpResults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        resultModel.fetchResults(tableView: resultsTableView)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setUpResults() {
        
        view.addSubview(resultsTableView)
        
        resultsTableView.allowsSelection = false
        
        resultsTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(clearButton.snp.top).offset(-10)
        }
    }
    
    private func setUpClearButton() {
        
        view.addSubview(clearButton)
        clearButton.addTarget(self, action: #selector(clearButtonAction), for: .touchUpInside)
        
        clearButton.configuration = .filled()
        clearButton.configuration?.cornerStyle = .capsule
        clearButton.configuration?.title = "Clear"
        clearButton.configuration?.baseForegroundColor = .white
        clearButton.configuration?.baseBackgroundColor = .systemRed
        
        clearButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalTo(40)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
    }
    
    @objc private func clearButtonAction() {
        resultModel.clearResults(tableView: resultsTableView)
    }
}



extension ResultsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ResultModel.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  let cell = resultsTableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as? ResultTableViewCell {
            cell.setUpCell(resultToDisplay: ResultModel.results[indexPath.row])
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
