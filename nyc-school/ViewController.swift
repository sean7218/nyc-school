//
//  ViewController.swift
//  nyc-school
//
//  Created by Sean Zhang on 10/25/21.
//

import UIKit
import Combine

class ViewController: UIViewController {

    var schools: [School] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var scores: [Score] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    let detailViewController = DetailViewController()
    var subscriptions = Set<AnyCancellable>()
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        Service.shared.fetchSchools().sink { complete in
            switch (complete) {
            case .failure(let e): print(e.localizedDescription)
            case .finished: print("finished")
            }
        } receiveValue: { [weak self] schools in
            self?.schools = schools
        }.store(in: &subscriptions)
        
        Service.shared.fetchScores().sink { complete in
            switch (complete) {
            case .failure(let e): print(e.localizedDescription)
            case .finished: print("finished")
            }
        } receiveValue: { [weak self] scores in
            self?.scores = scores
        }.store(in: &subscriptions)
    }

    private func setupViews() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SchoolTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schools.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SchoolTableViewCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = schools[indexPath.row].school_name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let vc = DetailViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
