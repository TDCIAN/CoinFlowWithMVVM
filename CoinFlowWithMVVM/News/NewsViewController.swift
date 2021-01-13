//
//  NewsViewController.swift
//  CoinFlowWithMVVM
//
//  Created by APPLE on 2021/01/03.
//

import UIKit

class NewsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NetworkManager.requestNewsList { result in
            switch result {
            case .success(let articles):
                print("뉴스리스트 --> \(articles.count)")
            case .failure(let error):
                print("뉴스리스트 에러 --> \(error.localizedDescription)")
            }
            
        }
    }
}

extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsListCell", for: indexPath) as? NewsListCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = UIColor.randomColor()
        return cell
    }
    
    
}

class NewsListCell: UITableViewCell {
    
}
