//
//  UIViewExtension.swift
//  ReadingDBFile
//
//  Created by K Rajeshwar on 29/12/22.
//

import Foundation
import UIKit

extension UIView {
    
    func activityStartAnimating(activityColor: UIColor, backgroundColor: UIColor) {
        let backgroundView = UIView()
        backgroundView.frame = UIScreen.main.bounds
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        backgroundView.tag = 475647
        
        let loadingView: UIView = UIView()
        loadingView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        loadingView.center = backgroundView.center
        loadingView.backgroundColor = backgroundColor
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        loadingView.addBlurredBackground(style: .dark)
        
        var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator = UIActivityIndicatorView(frame: CGRect.init(x: 5, y: 0, width: 90, height: 90))
        activityIndicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        activityIndicator.hidesWhenStopped = true
        activityIndicator.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.color = .gray
        activityIndicator.startAnimating()
        self.isUserInteractionEnabled = false
        
        let textLabel = UILabel(frame: CGRect(x: 0, y: 70, width: 100, height: 21))
        textLabel.textColor = UIColor.gray
        
        textLabel.text = "Loading"
        textLabel.font = .boldSystemFont(ofSize: 16)
        
        textLabel.textAlignment = .center
        loadingView.addSubview(textLabel)
        
        loadingView.addSubview(activityIndicator)
        backgroundView.addSubview(loadingView)
        self.addSubview(backgroundView)
    }
    
    func activityStopAnimating() {
        DispatchQueue.main.async {
            if let background = self.viewWithTag(475647) {
                background.removeFromSuperview()
            }
            self.isUserInteractionEnabled = true
        }
    }
    
    func addBlurredBackground(style: UIBlurEffect.Style) {
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.frame
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurView)
        self.sendSubviewToBack(blurView)
    }
}
