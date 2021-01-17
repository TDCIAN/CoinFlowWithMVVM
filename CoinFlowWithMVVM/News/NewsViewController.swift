//
//  NewsViewController.swift
//  CoinFlowWithMVVM
//
//  Created by APPLE on 2021/01/03.
//

import UIKit
import Kingfisher
import SafariServices

class NewsViewController: UIViewController {
    
    @IBOutlet weak var newsTableView: UITableView!
    
    var articles: [Article] = [] {
        didSet {
            DispatchQueue.main.async {
                self.newsTableView.reloadData()
            }
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
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsListCell", for: indexPath) as? NewsListCell else {
            return UITableViewCell()
        }
        
        let article = articles[indexPath.row]
        cell.configCell(article: article)
        return cell
    }
    
    
}

extension NewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        guard  let articleURL = URL(string: article.link) else { return }
        
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        config.barCollapsingEnabled = false
        let safari = SFSafariViewController(url: articleURL, configuration: config)

        safari.preferredBarTintColor = .white
        safari.preferredControlTintColor = .systemBlue
        present(safari, animated: true, completion: nil)
    }
}


