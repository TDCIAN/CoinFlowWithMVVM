//
//  ChartListCell.swift
//  CoinFlowWithMVVM
//
//  Created by APPLE on 2021/01/15.
//

import UIKit

class ChartListCell: UITableViewCell {
    
    @IBOutlet weak var currentStatusBox: UIView!
    @IBOutlet weak var coinName: UILabel!
    @IBOutlet weak var currentPrice: UILabel!
    @IBOutlet weak var change24Hours: UILabel!
    @IBOutlet weak var changePercent: UILabel!
    @IBOutlet weak var currentStatusImageView: UIImageView!
    
    
    func configCell(_ info: CoinInfo) {
        let coinType = info.key
        let coin = info.value
        
        let isUnderPerform = coin.usd.changeLast24H < 0
        let upColor = UIColor.systemPink
        let downColor = UIColor.systemBlue
        let color = isUnderPerform ? downColor : upColor
        
        currentStatusBox.backgroundColor = color
        coinName.text = coinType.rawValue
        currentPrice.text = String(format: "%.1f", coin.usd.price)
        change24Hours.text = String(format: "%.1f", coin.usd.changeLast24H)
        changePercent.text = String(format: "%.1f %%", coin.usd.changePercentLast24H)
        
        change24Hours.textColor = color
        changePercent.textColor = color
        
        let statusImage = isUnderPerform ? UIImage(systemName: "arrowtriangle.down.fill") : UIImage(systemName: "arrowtriangle.up.fill")
        
        currentStatusImageView.image = statusImage
        currentStatusImageView.tintColor = color
    }
}
