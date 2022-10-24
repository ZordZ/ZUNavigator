//
//  Module: Navigator_Example
//  Created by: MrTrent on 08.10.2022
//  Copyright (c) 2022 Zordz Union
//  


import Foundation
import UIKit
import ZUNavigator

class BaseViewController: UIViewController {
    
    // MARK: for story board
    var url: URL?
    
    // MARK: - Main
    @IBInspectable var titleBackgroundColor: UIColor = .white
    @IBInspectable var titleText: String = "Screen title"
    @IBInspectable var urlAsString: String = "" {
        didSet {
            url = URL(string: urlAsString)
        }
    }
    
    lazy var coloredTitleLbl: UILabel = {
        let view = UILabel.init(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        view.text = "\n\(titleText.uppercased())\n"
        view.textAlignment = .center
        view.backgroundColor = titleBackgroundColor
        view.font = UIFont.systemFont(ofSize: 22)
        return view
    }()
    
    lazy var oldDataLbl: UILabel = {
        let view = UILabel.init(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        view.textAlignment = .left
        return view
    }()
    
    lazy var dataLbl: UILabel = {
        let view = UILabel.init(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        view.textAlignment = .left
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView.init(frame: .zero)
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .fill
        view.spacing = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        // default data
        if dataLbl.text == nil {
            setDate(Date().timeAsString)
        }
        
        // add urls policy button
        let linksPolicySettingsBtn = UIBarButtonItem.init(title: "Settings", style: .plain, target: self, action: #selector(handleLinksPolicyTap))
        let mapBtn = UIBarButtonItem.init(title: "Map", style: .plain, target: self, action: #selector(handlePrintMapTap))
        self.navigationItem.rightBarButtonItems  = [linksPolicySettingsBtn, mapBtn]
    }
    
    @objc func handleLinksPolicyTap(_ sender: UIBarButtonItem) {
        let policyViewController = PolicySettingsVC.init(nibName: nil, bundle: nil)
        present(policyViewController, animated: true)
    }
    
    @objc func handlePrintMapTap(_ sender: UIBarButtonItem) {
        Navigator.linksMap(for: navigationController)
    }
    
    func configure() {
        view.backgroundColor = .white
        
        let offset: CGFloat = 8
        
        view.addSubview(coloredTitleLbl)
        view.addSubview(oldDataLbl)
        view.addSubview(dataLbl)
        view.addSubview(stackView)
        
        configureStackView()
        
        // set layouts
        let constraints: [NSLayoutConstraint] = [
            coloredTitleLbl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            coloredTitleLbl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: offset),
            coloredTitleLbl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: offset),
            coloredTitleLbl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -offset),
            
            oldDataLbl.centerXAnchor.constraint(equalTo: coloredTitleLbl.centerXAnchor),
            oldDataLbl.topAnchor.constraint(equalTo: coloredTitleLbl.bottomAnchor, constant: 4*offset),
            oldDataLbl.widthAnchor.constraint(equalTo: coloredTitleLbl.widthAnchor),
            
            dataLbl.centerXAnchor.constraint(equalTo: oldDataLbl.centerXAnchor),
            dataLbl.topAnchor.constraint(equalTo: oldDataLbl.bottomAnchor, constant: offset),
            dataLbl.widthAnchor.constraint(equalTo: oldDataLbl.widthAnchor),
            
            stackView.centerXAnchor.constraint(equalTo: dataLbl.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: dataLbl.bottomAnchor, constant: 4*offset),
            stackView.widthAnchor.constraint(equalTo: dataLbl.widthAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -offset),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func configureStackView() {
        let urlPatterns: [String] = Navigator.urlPatterns.sorted()
        urlPatterns.forEach { urlPattern in
            let title = urlPattern.dropFirstAndUppercasedFirst()
            let color = String(urlPattern.dropFirst()).color
            let view = SeguesView.init(url: URL(string: urlPattern)!, titleText: title, color: color)
            self.stackView.addArrangedSubview(view)
        }
    }
    
    func setDate(_ date: String?) {
        guard let date = date else { return }

        oldDataLbl.text = (dataLbl.text ?? "- - -").replacingOccurrences(of: "New", with: "Old")
        dataLbl.text = "New time: \(date)"
    }
    
    func setTitle(_ text: String) {
        coloredTitleLbl.text = "\n\(text.uppercased())\n"
        coloredTitleLbl.backgroundColor = text.lowercased().color
    }
}


fileprivate extension String {
    var color: UIColor {
        switch self {
        case "red":
            return UIColor.red.withAlphaComponent(0.3)
        case "blue":
            return UIColor.blue.withAlphaComponent(0.3)
        case "green":
            return UIColor.green.withAlphaComponent(0.3)
        case "yellow":
            return UIColor.yellow.withAlphaComponent(0.3)
        default:
            return .white
        }
    }
}
