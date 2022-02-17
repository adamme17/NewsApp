//
//  NewsCell.swift
//  NewsApp
//
//  Created by Adam Bokun on 16.02.22.
//

import UIKit
import SnapKit

class NewsCell: UITableViewCell {
    var safeArea: UILayoutGuide!
    let imageIV = UIImageView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let dateLabel = UILabel()
    let authorLabel = UILabel()
    var favoriteButton = UIButton()

    var isFavotite: Bool = false {
        didSet {
            if isFavotite == false {
                let config = UIImage.SymbolConfiguration(
                    pointSize: 25, weight: .medium, scale: .default)
                let image = UIImage(systemName: "heart", withConfiguration: config)
                favoriteButton.setImage(image, for: .normal)
            } else {
                let config = UIImage.SymbolConfiguration(
                    pointSize: 25, weight: .medium, scale: .default)
                let image = UIImage(systemName: "heart.fill", withConfiguration: config)
                favoriteButton.setImage(image, for: .normal)
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupView() {
        self.backgroundColor = .clear
        safeArea = layoutMarginsGuide
        self.imageIV.image = UIImage(named: "NoImage")
        self.titleLabel.text = "Jabra's Elite 4 Active Offer Great Bang for Your Buck"
        self.descriptionLabel.text = "U.S. stock index futures jumped on Tuesday on news that Russia was pulling back some troops from near the Ukrainian border, in signs of a de-escalation in tensions between the two countries."
        self.dateLabel.text = "15 Jan, 2022"
        self.authorLabel.text = "by Mitchel Broussard"
        self.isFavotite = false
        setupImageIV()
        setupTitleLabel()
        setupDescriptionLabel()
        setupDateLabel()
        setupAuthorLabel()
        setupFavouriteButton()
    }

    private func setupImageIV() {
        contentView.addSubview(imageIV)
        imageIV.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(15)
            make.height.equalTo(80)
            make.width.equalTo(160)
        }
    }

    private func setupDateLabel() {
        contentView.addSubview(dateLabel)
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.textAlignment = .left
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalTo(imageIV.snp.trailing).offset(10)
        }
    }

    private func setupAuthorLabel() {
        contentView.addSubview(authorLabel)
        authorLabel.font = UIFont.italicSystemFont(ofSize: 12)
        authorLabel.textAlignment = .left
        authorLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.equalTo(imageIV.snp.trailing).offset(10)
        }
    }

    private func setupTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        titleLabel.numberOfLines = 0
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(imageIV.snp.bottom).offset(10)
        }
    }

    private func setupDescriptionLabel() {
        contentView.addSubview(descriptionLabel)
        if descriptionLabel.text!.count > 50 {
            let readmoreFont = UIFont(name: "Helvetica", size: 16.0)
            let readmoreFontColor = UIColor.blue
            DispatchQueue.main.async {
                self.descriptionLabel.addTrailing(with: "... ", moreText: "Show more", moreTextFont: readmoreFont!, moreTextColor: readmoreFontColor)
            }
        }
        descriptionLabel.numberOfLines = 3
        descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.bottom.equalToSuperview().offset(-10)
        }
    }

    private func setupFavouriteButton() {
        contentView.addSubview(favoriteButton)
        favoriteButton.tintColor = .red
        favoriteButton.clipsToBounds = true
        favoriteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-15)
            make.width.greaterThanOrEqualTo(20)
        }
    }
}

extension UILabel {
    func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
        let readMoreText: String = trailingText + moreText

        let lengthForVisibleString: Int = self.vissibleTextLength
        let mutableString: String = self.text!
        let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: ((self.text?.count)! - lengthForVisibleString)), with: "")
        let readMoreLength: Int = (readMoreText.count)
        let trimmedForReadMore: String = (trimmedString! as NSString).replacingCharacters(in: NSRange(location: ((trimmedString?.count ?? 0) - readMoreLength), length: readMoreLength), with: "") + trailingText
        let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedString.Key.font: self.font])
        let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: moreTextFont, NSAttributedString.Key.foregroundColor: moreTextColor])
        answerAttributed.append(readMoreAttributed)
        self.attributedText = answerAttributed
    }

    var vissibleTextLength: Int {
        let font: UIFont = self.font
        let mode: NSLineBreakMode = self.lineBreakMode
        let labelWidth: CGFloat = self.frame.size.width
        let labelHeight: CGFloat = self.frame.size.height
        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)

        let attributes: [AnyHashable: Any] = [NSAttributedString.Key.font: font]
        let attributedText = NSAttributedString(string: self.text!, attributes: attributes as? [NSAttributedString.Key : Any])
        let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)

        if boundingRect.size.height > labelHeight {
            var index: Int = 0
            var prev: Int = 0
            let characterSet = CharacterSet.whitespacesAndNewlines
            repeat {
                prev = index
                if mode == NSLineBreakMode.byCharWrapping {
                    index += 1
                } else {
                    index = (self.text! as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: self.text!.count - index - 1)).location
                }
            } while index != NSNotFound && index < self.text!.count && (self.text! as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [NSAttributedString.Key : Any], context: nil).size.height <= labelHeight
            return prev
        }
        return self.text!.count
    }
}
