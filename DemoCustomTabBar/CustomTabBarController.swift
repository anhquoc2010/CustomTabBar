//
//  CustomTabBarController.swift
//  DemoCustomTabBar
//
//  Created by QuocLA on 05/06/2024.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    private let spacing: CGFloat = 12
    private let middleButtonSize: CGSize = CGSize(width: 60, height: 60)
    private let gradientColors = [UIColor.systemPink, UIColor.systemPurple]
    
    private var upperView: UIView!
    private var upperLineView: UIView!
    private var middleButton: UIButton!
    private var middleButtonGradientLayer: CAGradientLayer!
    private var upperLineViewGradientLayer: CAGradientLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTabBar()
        addUpperView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.addTabbarIndicatorView(index: 0)
            self.addMiddleButton()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { [weak self] context in
            guard let self = self else { return }
            
            self.middleButtonGradientLayer.removeFromSuperlayer()
            self.upperLineViewGradientLayer.removeFromSuperlayer()
            self.makeFrameUpperLineView(index: self.selectedIndex)
            self.addGradientForUpperLineView()
            self.makeFrameUpperView()
            self.makeFrameMiddleButton()
            self.addGradientForMiddleButton()
            
        }, completion: nil)
    }
}

extension CustomTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let selectedIndex = tabBarController.selectedIndex
        animateIndicatorToTab(index: selectedIndex)
    }
}

extension CustomTabBarController {
    private func configTabBar() {
        let firstVC = UIViewController()
        firstVC.view.backgroundColor = .red
        let secondVC = UIViewController()
        secondVC.view.backgroundColor = .yellow
        let fourthVC = UIViewController()
        fourthVC.view.backgroundColor = .orange
        let fifthVC = UIViewController()
        fifthVC.view.backgroundColor = .systemPink
        
        let firstNVC = makeNavigationController(rootViewController: firstVC, tabTitle: "", tabImage: .icHome, selectedTabImage: .icHome)
        let secondNVC = makeNavigationController(rootViewController: secondVC, tabTitle: "", tabImage: .icPerson, selectedTabImage: .icPerson)
        let fourthNVC = makeNavigationController(rootViewController: fourthVC, tabTitle: "", tabImage: .icMessage, selectedTabImage: .icMessage)
        let fifthNVC = makeNavigationController(rootViewController: fifthVC, tabTitle: "", tabImage: .icSetting, selectedTabImage: .icSetting)
        
        viewControllers = [firstNVC, secondNVC, UIViewController(), fourthNVC, fifthNVC]
        tabBar.items?[(viewControllers?.count ?? 0) / 2].isEnabled = false
        
        self.setValue(CustomTabBar(), forKey: "tabBar")
        tabBar.backgroundColor = .systemBackground
        tabBar.standardAppearance.shadowColor = nil
        tabBar.standardAppearance.shadowImage = nil
        tabBar.standardAppearance.backgroundEffect = nil
        tabBar.standardAppearance.backgroundColor = nil
        
        delegate = self
    }
    
    private func makeNavigationController(rootViewController: UIViewController, tabTitle: String, tabImage: UIImage, selectedTabImage: UIImage) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        let tabBarItem = UITabBarItem(title: tabTitle, image: tabImage, selectedImage: selectedTabImage)
        
        if let gradientImage = selectedTabImage.drawLinearGradient(
            colors: gradientColors.map { $0.cgColor },
            startingPoint: .init(x: 0, y: selectedTabImage.size.height / 2),
            endPoint: .init(x: selectedTabImage.size.height, y: selectedTabImage.size.width / 2)
        ) {
            tabBarItem.selectedImage = gradientImage.withRenderingMode(.alwaysOriginal)
        }
        
        navigationController.tabBarItem = tabBarItem
        return navigationController
    }
    
    private func addMiddleButton() {
        middleButton = UIButton()
        
        if let iconImage = UIImage(systemName: "plus") {
            let largerIconSize = CGSize(width: 40, height: 40) // Adjust the size as needed
            let resizedIconImage = UIGraphicsImageRenderer(size: largerIconSize).image { _ in
                iconImage.draw(in: CGRect(origin: .zero, size: largerIconSize))
            }.withRenderingMode(.alwaysTemplate)
            
            middleButton.setImage(resizedIconImage, for: .normal)
        }
        middleButton.layer.cornerRadius = middleButtonSize.width / 2
        middleButton.imageView?.layer.zPosition = 1
        middleButton.tintColor = .white
        makeFrameMiddleButton()
        addGradientForMiddleButton()
        addShadowForMiddleButton()
        tabBar.addSubview(middleButton)
    }
    
    private func makeFrameMiddleButton() {
        middleButton.frame = CGRect(x: (view.bounds.width - middleButtonSize.width) / 2,
                                    y: -self.middleButtonSize.width / 2,
                                    width: middleButtonSize.width,
                                    height: middleButtonSize.height)
    }
    
    private func addGradientForMiddleButton() {
        middleButtonGradientLayer = CAGradientLayer()
        middleButtonGradientLayer.frame = middleButton.bounds
        middleButtonGradientLayer.colors = gradientColors.map { $0.cgColor }
        middleButtonGradientLayer.cornerRadius = middleButtonSize.width / 2
        middleButtonGradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        middleButtonGradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        middleButton.layer.insertSublayer(middleButtonGradientLayer, at: 0)
    }

    private func addShadowForMiddleButton() {
        middleButton.layer.shadowColor = UIColor.black.cgColor
        middleButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        middleButton.layer.shadowOpacity = 0.7
        middleButton.layer.shadowRadius = 10.0
        middleButton.layer.masksToBounds = false
    }
    
    private func addUpperView() {
        upperView = UIView()
        upperView.backgroundColor = .systemGray.withAlphaComponent(0.4)
        
        makeFrameUpperView()
        tabBar.addSubview(upperView)
    }
    
    private func makeFrameUpperView() {
        upperView.frame = CGRect(x: 0,
                                 y: 0,
                                 width: tabBar.frame.size.width,
                                 height: 3)
    }
    
    private func addTabbarIndicatorView(index: Int) {
        if upperLineView != nil {
            upperLineView.removeFromSuperview()
        }
        
        upperLineView = UIView()
        upperLineView.backgroundColor = .systemPink
        upperLineView.layer.cornerRadius = 3
        
        makeFrameUpperLineView(index: index)
        addGradientForUpperLineView()
        tabBar.addSubview(upperLineView)
    }
    
    private func animateIndicatorToTab(index: Int) {
        guard let tabView = tabBar.items?[index].value(forKey: "view") as? UIView else {
            return
        }
        
        UIView.animate(withDuration: 0.3) {
            self.upperLineView.frame = CGRect(x: tabView.frame.minX - 1 + self.spacing / 2 + tabView.frame.size.width * 0.25,
                                              y: 0,
                                              width: (tabView.frame.size.width - self.spacing * 2) * 0.5,
                                              height: 3)
        }
    }
    
    private func makeFrameUpperLineView(index: Int) {
        guard let tabView = tabBar.items?[index].value(forKey: "view") as? UIView else {
            return
        }
        
        upperLineView.frame = CGRect(x: tabView.frame.minX - 1 + spacing / 2 + tabView.frame.size.width * 0.25,
                                     y: 0,
                                     width: (tabView.frame.size.width - spacing * 2) * 0.5,
                                     height: 3)
    }
    
    private func addGradientForUpperLineView() {
        upperLineViewGradientLayer = CAGradientLayer()
        upperLineViewGradientLayer.frame = upperLineView.bounds
        upperLineViewGradientLayer.colors = gradientColors.map { $0.cgColor }
        upperLineViewGradientLayer.cornerRadius = upperLineView.frame.height / 2
        upperLineViewGradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        upperLineViewGradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        upperLineView.layer.addSublayer(upperLineViewGradientLayer)
    }
}
