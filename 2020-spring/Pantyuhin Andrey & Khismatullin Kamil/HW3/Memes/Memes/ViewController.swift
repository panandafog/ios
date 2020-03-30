//
//  ViewController.swift
//  HW2
//
//  Created by panandafog on 20.03.2020.
//  Copyright © 2020 panandafog. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    private let memeService = MemeService()
    private var posts = [Post]()
    
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memeService.getMemes(completion: { newMemes in
            guard let newMemes = newMemes else { return }
            self.posts = newMemes
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        MemeCell.viewController = self
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath.row, ", ", indexPath.section)
        print(tableView.indexPathsForVisibleRows?.last?.row, ", ", tableView.indexPathsForVisibleRows?.last?.section)
        print("")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell", for: indexPath) as? MemeCell else {
            fatalError("Table view is not configured")
        }
        
        let post: Post = posts[indexPath.row]
        cell.setup(with: post, controller: self, index: indexPath)
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row == posts.count - 1 else { return }
        memeService.getMemes {
            guard let posts = $0 else { return }
            self.posts.append(contentsOf: posts)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
                return
        }
        viewController.post = posts[indexPath.row]
        navigationController?.present(viewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension ViewController {
    func updateCell(row: Int, section: Int) {
        print("––––––––––––––––––––")
        print("updating ", row)
        tableView.reloadRows(at: [IndexPath(row: row, section: section)], with: .automatic)
    }
    func updateCells() {
        print("––––––––––––––––––––")
        print("updating all")
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
