//
//  Module: Navigator_Example
//  Created by: MrTrent on 13.10.2022
//  Copyright (c) 2022 Zordz Union
//  


import Foundation
import UIKit
import ZUNavigator

@IBDesignable class SeguesView: UIView {
    @IBInspectable var titleText: String = "Title"
    @IBInspectable var urlAsString: String = ""
    @IBInspectable var color: UIColor = .white
    
    // generates url
    var url: URL {
        get {
            let url = URL(string: urlAsString)
            assert(url != nil, "urlAsString - not setted.")
            return url!
        }
    }
    
    /// Preffered initializer
    init(url: URL, titleText: String, color: UIColor) {
        self.urlAsString = url.path
        self.titleText = titleText
        self.color = color
        super.init(frame: .zero)
        configure()
    }
    
    /// Preffered initializer
    init(urlAsString: String, titleText: String, color: UIColor) {
        self.urlAsString = urlAsString
        self.titleText = titleText
        self.color = color
        super.init(frame: .zero)
        configure()
    }
    
    // for storyboard
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    func configure() {
        let titleLbl = generateLbl()
        let pushBtn = generateBtn("PUSH")
        let popBtn = generateBtn("POP")
        let updateBtn = generateBtn("UPDATE")
        
        addSubview(titleLbl)
        addSubview(pushBtn)
        addSubview(popBtn)
        addSubview(updateBtn)
        
        titleLbl.text = self.titleText
        
        NSLayoutConstraint.activate([
            titleLbl.topAnchor.constraint(equalTo: topAnchor),
            
            titleLbl.leadingAnchor.constraint(equalTo: leadingAnchor),
            pushBtn.leadingAnchor.constraint(equalTo: titleLbl.trailingAnchor),
            popBtn.leadingAnchor.constraint(equalTo: pushBtn.trailingAnchor),
            updateBtn.leadingAnchor.constraint(equalTo: popBtn.trailingAnchor),
            
            updateBtn.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            titleLbl.widthAnchor.constraint(equalTo: pushBtn.widthAnchor),
            pushBtn.widthAnchor.constraint(equalTo: popBtn.widthAnchor),
            popBtn.widthAnchor.constraint(equalTo: updateBtn.widthAnchor),
            
            titleLbl.heightAnchor.constraint(equalTo: pushBtn.heightAnchor),
            pushBtn.heightAnchor.constraint(equalTo: popBtn.heightAnchor),
            popBtn.heightAnchor.constraint(equalTo: updateBtn.heightAnchor),
            
            titleLbl.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        pushBtn.addTarget(self, action: #selector(handlePush), for: .touchUpInside)
        popBtn.addTarget(self, action: #selector(handlePop), for: .touchUpInside)
        updateBtn.addTarget(self, action: #selector(handleUpdate), for: .touchUpInside)
    }
    
    func generateLbl() -> UILabel {
        let view = UILabel.init(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        view.text = titleText
        view.backgroundColor = color
        view.textAlignment = .left
        return view
    }
    
    func generateBtn(_ title: String) -> UIButton {
        let view = UIButton.init(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.titleLabel?.textColor = .black
        let title: String = title
        let textColor: UIColor = .link
        view.setTitle(title, for: .normal)
        view.setTitle(title, for: .highlighted)
        view.setTitleColor(textColor, for: .normal)
        view.setTitleColor(textColor, for: .highlighted)
        return view
    }
    
    @objc func handlePush(_ sender: UIButton) {
        Navigator.push(by: url, queryItems: [URLQueryItem(name: "date", value: Date().timeAsString)]) { state in
            switch state {
            case .Success(_):
                break
            default:
                self.showAlert(message: state.description)
                break
            }
        }
    }
    
    @objc func handlePop(_ sender: UIButton) {
        Navigator.popTo(url: url, queryItems: [URLQueryItem(name: "date", value: Date().timeAsString)]) { state in
            switch state {
            case .Success(_), .SuccessWithUpdate(_):
                break
            default:
                self.showAlert(message: state.description)
                break
            }
        }
    }
    
    @objc func handleUpdate(_ sender: UIButton) {
        let queryItems: [URLQueryItem] = [URLQueryItem(name: "date", value: Date().timeAsString)]
        Navigator.update(by: url, queryItems: queryItems)
        // replace to test update for tab 0
//        Navigator.updateTabBar(by: url, queryItems: queryItems, tabIndex: 0)
        // replace to tests global update - updateEveryWhere
//        Navigator.updateEveryWhere(by: url, queryItems: queryItems, forceUpdate: false)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Ooops", message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Close", style: .default)
        alert.addAction(closeAction)
        Navigator.navigationController?.viewControllers.last?.present(alert, animated: true)
    }
}
