//
//  Module: Navigator_Example
//  Created by: MrTrent on 10.10.2022
//  Copyright (c) 2022 Zordz Union
//  


import Foundation
import UIKit
import ZUNavigator

class PolicySettingsVC: UIViewController {
    
    var identicalLinksItems: [Navigator.IdenticalLinksPolicy] = Navigator.IdenticalLinksPolicy.allCases
    var updateItems: [Navigator.UpdatePolicy] = Navigator.UpdatePolicy.allCases
    
    lazy var wrapperView: UIView = {
        let view = UIView.init(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        return view
    }()
    
    lazy var identicalLinksLbl: UILabel = {
        let view = UILabel.init(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        view.text = "Identical Links Policy"
        view.textAlignment = .center
        return view
    }()
    
    lazy var identicalLinksSegmentedControl: UISegmentedControl = {
        let view = UISegmentedControl.init(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var updateLbl: UILabel = {
        let view = UILabel.init(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        view.text = "Update Policy"
        view.textAlignment = .center
        return view
    }()
    
    lazy var updateSegmentedControl: UISegmentedControl = {
        let view = UISegmentedControl.init(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var printMapBtn: UIButton = {
        let view = UIButton.init(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        let title: String = "Print map to console"
        view.setTitle(title, for: .normal)
        view.setTitle(title, for: .highlighted)
        view.setTitleColor(.link, for: .normal)
        view.setTitleColor(.link, for: .highlighted)
        return view
    }()
    
    lazy var closeBtn: UIButton = {
        let view = UIButton.init(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        let title: String = "Close"
        view.setTitle(title, for: .normal)
        view.setTitle(title, for: .highlighted)
        view.setTitleColor(.link, for: .normal)
        view.setTitleColor(.link, for: .highlighted)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        let offset: CGFloat = 8
        
        //view.backgroundColor = .white
        
        view.addSubview(wrapperView)
        wrapperView.addSubview(identicalLinksLbl)
        wrapperView.addSubview(identicalLinksSegmentedControl)
        wrapperView.addSubview(updateLbl)
        wrapperView.addSubview(updateSegmentedControl)
        wrapperView.addSubview(printMapBtn)
        wrapperView.addSubview(closeBtn)
        
        identicalLinksSegmentedControl.addSegemnts(Navigator.IdenticalLinksPolicy.allCases)
        updateSegmentedControl.addSegemnts(Navigator.UpdatePolicy.allCases)
        
        // set layouts
        NSLayoutConstraint.activate([
            // content wrapper
            wrapperView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            wrapperView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            wrapperView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: offset),
            wrapperView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -offset),
            
            // identical links policy
            identicalLinksLbl.topAnchor.constraint(equalTo: wrapperView.topAnchor, constant: 2*offset),
            identicalLinksLbl.centerXAnchor.constraint(equalTo: wrapperView.centerXAnchor),
            
            identicalLinksSegmentedControl.topAnchor.constraint(equalTo: identicalLinksLbl.bottomAnchor, constant: offset),
            identicalLinksSegmentedControl.widthAnchor.constraint(equalTo: wrapperView.widthAnchor, constant: -2*offset),
            identicalLinksSegmentedControl.centerXAnchor.constraint(equalTo: wrapperView.centerXAnchor),
            
            // update policy
            updateLbl.topAnchor.constraint(equalTo: identicalLinksSegmentedControl.bottomAnchor, constant: 2*offset),
            updateLbl.centerXAnchor.constraint(equalTo: wrapperView.centerXAnchor),
            
            updateSegmentedControl.topAnchor.constraint(equalTo: updateLbl.bottomAnchor, constant: offset),
            updateSegmentedControl.widthAnchor.constraint(equalTo: wrapperView.widthAnchor, constant: -2*offset),
            updateSegmentedControl.centerXAnchor.constraint(equalTo: wrapperView.centerXAnchor),
            
            // print tab bar controller map
            printMapBtn.topAnchor.constraint(equalTo: updateSegmentedControl.bottomAnchor, constant: 2*offset),
            printMapBtn.widthAnchor.constraint(equalTo: updateSegmentedControl.widthAnchor),
            printMapBtn.heightAnchor.constraint(equalTo: updateSegmentedControl.heightAnchor),
            
            // close btn
            closeBtn.topAnchor.constraint(equalTo: printMapBtn.bottomAnchor, constant: offset),
            closeBtn.widthAnchor.constraint(equalTo: printMapBtn.widthAnchor),
            closeBtn.heightAnchor.constraint(equalTo: printMapBtn.heightAnchor),
            closeBtn.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor, constant: -offset),
        ])
        
        // sync segment with Navigator.identicalLinksPolicy
        identicalLinksSegmentedControl.selectedSegmentIndex = index(for: Navigator.identicalLinksPolicy)
        updateSegmentedControl.selectedSegmentIndex = index(for: Navigator.updatePolicy)
        
        // taps
        identicalLinksSegmentedControl.addTarget(self, action: #selector(identicalLinksHandleTapSegment), for: .valueChanged)
        updateSegmentedControl.addTarget(self, action: #selector(updateHandleTapSegment), for: .valueChanged)
        printMapBtn.addTarget(self, action: #selector(handleTapMapLinks), for: .touchUpInside)
        closeBtn.addTarget(self, action: #selector(handleTapClose), for: .touchUpInside)
    }
    
    @objc func identicalLinksHandleTapSegment(_ sender: UISegmentedControl) {
        Navigator.identicalLinksPolicy = identicalLinksItems[sender.selectedSegmentIndex]
    }
    
    @objc func updateHandleTapSegment(_ sender: UISegmentedControl) {
        Navigator.updatePolicy = updateItems[sender.selectedSegmentIndex]
    }
    
    @objc func handleTapMapLinks(_ sender: UIButton) {
        Navigator.linksMapTabs()
    }
    
    @objc func handleTapClose(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    func index(for policy: Navigator.IdenticalLinksPolicy) -> Int {
        return identicalLinksItems.firstIndex(of: policy) ?? 0
    }
    
    func index(for policy: Navigator.UpdatePolicy) -> Int {
        return updateItems.firstIndex(of: policy) ?? 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
