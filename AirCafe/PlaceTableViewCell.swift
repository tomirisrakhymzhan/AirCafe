//
//  PlaceTableViewCell.swift
//  AirCafe
//
//  Created by Томирис Рахымжан on 21/05/2024.
//

import UIKit
import GooglePlaces
class PlaceTableViewCell: UITableViewCell {
    static let identifier = "PlaceTableViewCell"

    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var distanceAwayLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var priceLevelLabel: UILabel!
    @IBOutlet weak var openClosedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI(place: Place){

        var shownTypes = [String]()
        for type in place.types {
            if type != "point_of_interest" {
                shownTypes.append(type)
            }
        }
        var shownPriceLevel : String = "$$$" // by default
        switch place.priceLevel {
        case "PRICE_LEVEL_INEXPENSIVE":
            shownPriceLevel = "$"
        case "PRICE_LEVEL_MODERATE":
            shownPriceLevel = "$$"
        case "PRICE_LEVEL_EXPENSIVE":
            shownPriceLevel = "$$$"
        
        default:
            shownPriceLevel = "price level unknown"
        }
        
        if let regularOpeningHours = place.regularOpeningHours {
            if regularOpeningHours.openNow {
                openClosedLabel.text = "Open"
                openClosedLabel.textColor = .green
            } else {
                openClosedLabel.text = "Closed"
                openClosedLabel.textColor = .red
            }
        } else {
            openClosedLabel.text = "Open/Closed status unknown"
            openClosedLabel.textColor = .gray
        }

        if let rating = place.rating {
            ratingLabel.text = String(rating)
        } else {
            ratingLabel.text = "n/a"

        }
        
        placeImageView.image = UIImage(named: "restaurant-default")
        titleLabel.text = place.displayName.text
        typeLabel.text = shownTypes.joined(separator: " | ")
        distanceAwayLabel.text = "less than 1 km away"
        addressLabel.text = place.formattedAddress
        priceLevelLabel.text = shownPriceLevel
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        // Round the corners of the imageView
        placeImageView.layer.cornerRadius = placeImageView.bounds.width / 20
//        placeImageView.clipsToBounds = true
    }
    
}
