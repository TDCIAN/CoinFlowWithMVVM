//
//  ChartListViewController.swift
//  CoinFlowWithMVVM
//
//  Created by APPLE on 2021/01/03.
//

import UIKit

class ChartListViewController: UIViewController {

    @IBOutlet weak var chartCollectionView: UICollectionView!
    
    @IBOutlet weak var chartTableView: UITableView!
    
    @IBOutlet weak var chartTableViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 이 시점에 contentSize 파악 후 tableView의 높이를 조정
        print(chartTableView.contentSize.height)
    }

    private func showDetail() {
        let storyboard = UIStoryboard(name: "Chart", bundle: .main)
        let chartDetailViewController = storyboard.instantiateViewController(withIdentifier: "ChartDetailViewController")
        
        navigationController?.pushViewController(chartDetailViewController, animated: true)
    }
}


// MARK: - CollectionView
extension ChartListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChartCardCell", for: indexPath) as? ChartCardCell
        else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = UIColor.randomColor()
        return cell
    }

}

extension ChartListViewController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = collectionView.bounds.width - 20 * 2 - 15
        let height: CGFloat = 200
        
        return CGSize(width: width, height: height)
        
    }
    
}

class ChartCardCell: UICollectionViewCell {
    
}

// MARK: - CollectionView
extension ChartListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChartListCell", for: indexPath) as? ChartListCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = UIColor.randomColor()
        return cell
    }
    
    
}

class ChartListCell: UITableViewCell {
    
}
