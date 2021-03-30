//
//  WeatherCollectionViewCell.swift
//  WeatherApp
//
//  Created by Александра Самсонова on 27.03.2021.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {

    static let identifier = "WeatherCollectionViewCell"

    static func nib() -> UINib {
        return UINib(nibName: "WeatherCollectionViewCell",
                     bundle: nil)
    }

    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var tempLabel: UILabel!

    func configure(with model: HourlyWeatherEntry) {
        self.tempLabel.text = String(format: "%.0f°C", (model.temperature-32)*(5/9))
        self.iconImageView.contentMode = .scaleAspectFit
        self.iconImageView.image = UIImage(named: "clear")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
