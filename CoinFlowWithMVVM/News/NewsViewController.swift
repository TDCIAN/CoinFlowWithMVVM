//
//  NewsViewController.swift
//  CoinFlowWithMVVM
//
//  Created by APPLE on 2021/01/03.
//

import UIKit

class NewsViewController: UIViewController {
    
    @IBOutlet weak var newsTableView: UITableView!
    
    var articles: [Article] = [] {
        didSet {
            newsTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.requestNewsList { result in
            switch result {
            case .success(let articles):
                self.articles = articles
                print("뉴스리스트 --> \(articles.count)")
            case .failure(let error):
                print("뉴스리스트 에러 --> \(error.localizedDescription)")
            }
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
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
        
        let article = articles[indexPath.row]
        
        cell.configCell(article: article)
        return cell
    }
    
    
}

class NewsListCell: UITableViewCell {
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsDate: UILabel!
    
    func configCell(article: Article) {
        article.link
        newsTitle.text = article.title
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        newsDate.text = formatter.string(from: Date(timeIntervalSince1970: article.timestamp))
    }
}
