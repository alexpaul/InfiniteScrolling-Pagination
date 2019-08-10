//
//  ViewController.swift
//  InfiniteScrollingExample
//
//  Created by Alex Paul on 8/10/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  private var items = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18]
  private var isFetching = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(UINib(nibName: "LoadingCell", bundle: nil), forCellReuseIdentifier: "LoadingCell")
  }
}

extension ViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return items.count
    } else if section == 1 && isFetching {
      return 1
    }
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
      cell.textLabel?.text = "Item \(items[indexPath.row])"
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath) as! LoadingCell
      cell.activityIndicator.startAnimating()
      return cell
    }
  }
}

extension ViewController: UITableViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let contentOffsetY = scrollView.contentOffset.y
    let contentHeight = scrollView.contentSize.height
    if contentOffsetY > contentHeight - scrollView.frame.height * 4 { // will load earlier with multiplier
      if !isFetching {
        fetchMore()
      }
    }
  }
}

private extension ViewController {
  func fetchMore() {
    isFetching = true
    print("fetching more....")
    tableView.reloadSections(IndexSet(integer: 1), with: .none)
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
      let moreItems = (self.items.count...self.items.count + 12).map { index in index }
      self.items.append(contentsOf: moreItems)
      self.isFetching = false
      self.tableView.reloadData()
    }
  }
}


