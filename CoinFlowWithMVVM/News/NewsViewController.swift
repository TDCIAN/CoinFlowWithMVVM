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
    
    var viewModel: NewsListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = NewsListViewModel(changeHandler: { articles in
            DispatchQueue.main.async {
                self.newsTableView.reloadData()
            }
        })
        
        viewModel.fetchData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
}

extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInsection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = viewModel.cell(for: indexPath, at: tableView)
        return cell
    }
    
    
}

extension NewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let article = viewModel.article(at: indexPath)
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


class NewsListViewModel {
    
    typealias Handler = ([Article]) -> Void
    
    var changeHandler: Handler
    
    var articles: [Article] = [] {
        didSet {
            changeHandler(articles)
        }
    }
    
    init(changeHandler: @escaping Handler) {
        self.changeHandler = changeHandler
    }
}

extension NewsListViewModel {
    func fetchData() {
        NetworkManager.requestNewsList { (result: Result<[Article], Error>) in
            switch result {
            case .success(let articles):
                self.articles = articles
            case .failure(let error):
                print("--> News List Error: \(error.localizedDescription)")
            }
        }
    }
    
    var numberOfRowsInsection: Int {
        return articles.count
    }
    
    func cell(for indexPath: IndexPath, at tableView: UITableView) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsListCell", for: indexPath) as? NewsListCell else {
            return UITableViewCell()
        }
        
        let article = articles[indexPath.row]
        cell.configCell(article: article)
        return cell
    }
    
    func article(at indexPath: IndexPath) -> Article {
        let article = articles[indexPath.row]
        return article
    }
}
