//
//  ViewController.swift
//  StarWars
//
//  Created by Alex Paul on 8/10/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class PeopleViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  private var people = [People]() {
    didSet {
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
  private var currentPage = 1
  private var nextPage: String?
  private var isFetching = false

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(UINib(nibName: "LoadingCell", bundle: nil), forCellReuseIdentifier: "LoadingCell")
    searchPeople()
  }
  
  private func searchPeople() {
    StarWarsAPIClient.searchResource(method: "people",
                                   resource: .people([]),
                                   page: currentPage.description) { result, nextPage in
      switch result {
      case .failure(let error):
        print("encountered an error: \(error)")
      case .success(let resource):
        switch resource {
        case .people(let people):
          self.people.append(contentsOf: people)
          self.isFetching = false
          if let nextPage = nextPage {
            self.nextPage = nextPage
            self.currentPage += 1
          } else { self.nextPage = nil }
        case .planets:
          print("planets")
        }
      }
    }
  }
}

extension PeopleViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return people.count
    } else if section == 1 && isFetching {
      return 1
    }
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleCell", for: indexPath)
      let person = people[indexPath.row]
      cell.textLabel?.text = person.name
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath) as! LoadingCell
      cell.activityIndicator.startAnimating()
      return cell
    }
  }
}

extension PeopleViewController: UITableViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let yContentOffset = scrollView.contentOffset.y
    let contentHeight = scrollView.contentSize.height
    if yContentOffset > contentHeight - scrollView.frame.height {
      if !isFetching {
        tableView.reloadSections(IndexSet(integer: 1), with: .none)
        fetchMore()
      }
    }
  }
}

private extension PeopleViewController {
  func fetchMore() {
    isFetching = true
    print("fetch more people")
    guard let _ = nextPage else {
      return
    }
    searchPeople()
  }
}

