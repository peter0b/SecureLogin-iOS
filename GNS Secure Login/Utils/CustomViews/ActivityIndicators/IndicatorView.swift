//
//  IndicatorView.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 06/09/2021.
//

import Foundation
import UIKit

open class IndicatorView: UIView {
    var overlayView = UIView()
    var backView = LoaderView()
    
    class var shared: IndicatorView {
        struct Static {
            static let instance: IndicatorView = IndicatorView()
        }
        return Static.instance
    }
    
    open func showOverlay(_ view: UIView,dots_color:UIColor!,bg_color:UIColor!,dots_count:Int!) {
        overlayView.frame = CGRect(x: 0, y: 0, width: view.frame.width , height: view.frame.height)
        backView.frame = CGRect(x: 0, y: 0, width: view.frame.width , height: view.frame.height)
        if dots_color != nil {
            backView.tintColor = dots_color
        }
        if bg_color != nil {
            overlayView.backgroundColor = bg_color
            overlayView.alpha = 0.4
        }
        if dots_count != nil {
            if dots_count <= 1 {
                self.backView.dotsCount = 2
            } else {
                backView.dotsCount = dots_count
            }
        }
        view.addSubview(overlayView)
        view.addSubview(backView)
        
        backView.startAnimating()
    }
    
    open func hideOverlayView() {
        backView.stopAnimating()
        overlayView.removeFromSuperview()
        backView.removeFromSuperview()
    }
}

@IBDesignable
class LoaderView : UIView {
    private var dotLayers = [CAShapeLayer]()
    private var dotsScale = 1.7
    
    @IBInspectable var dotsCount :Int = 3 {
        didSet {
            self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            self.dotLayers.removeAll()
            self.setupLayers()
        }
    }
    @IBInspectable var dotsRadius :CGFloat = 10 {
        didSet {
            for layer in dotLayers {
                layer.bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: dotsRadius*2.0, height: dotsRadius*2.0))
                layer.path = UIBezierPath(roundedRect: layer.bounds, cornerRadius: dotsRadius).cgPath
            }
            self.setNeedsLayout()
        }
    }
    @IBInspectable var dotsSpacing :CGFloat = 10 {
        didSet {
            self.setNeedsLayout()
        }
    }
    override var tintColor: UIColor! {
        didSet {
            for layer in dotLayers {
                layer.fillColor = tintColor.cgColor
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setupLayers()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let center = CGPoint(x: self.frame.size.width/2.0, y: self.frame.size.height/2.0)
        let even = (dotsCount % 2 == 0)
        let middle :Int = dotsCount/2
        for (index, layer) in dotLayers.enumerated() {
            let x = center.x+CGFloat(index-middle)*((dotsRadius*2)+dotsSpacing)+(even ? (dotsRadius+(dotsSpacing/2)) : 0)
            layer.position = CGPoint(x: x, y: center.y)
        }
        startAnimating()
    }
    
    func startAnimating() {
        var offset :TimeInterval = 0.0
        dotLayers.forEach {
            $0.removeAllAnimations()
            $0.add(scaleAnimation(offset), forKey: "scaleAnim")
            offset = offset+0.25
        }
    }
    
    func stopAnimating() {
        dotLayers.forEach { $0.removeAllAnimations() }
    }
    
    private func dotLayer() ->   CAShapeLayer {
        let layer = CAShapeLayer()
        layer.bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: dotsRadius*2.0, height: dotsRadius*2.0))
        layer.path = UIBezierPath(roundedRect: layer.bounds, cornerRadius: dotsRadius).cgPath
        layer.fillColor = tintColor.cgColor
        return layer
    }
    
    private func setupLayers() {
        for _ in 0..<dotsCount {
            let layer = dotLayer()
            self.dotLayers.append(layer)
            self.layer.addSublayer(layer)
        }
    }
    
    private func scaleAnimation(_ after: TimeInterval = 0) ->  CAAnimationGroup {
        let scaleUp = CABasicAnimation(keyPath: "transform.scale")
        scaleUp.beginTime = after
        scaleUp.fromValue = 1
        scaleUp.toValue = dotsScale
        scaleUp.duration = 0.3
        scaleUp.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        let scaleDown = CABasicAnimation(keyPath: "transform.scale")
        scaleDown.beginTime = after+scaleUp.duration
        scaleDown.fromValue = dotsScale
        scaleDown.toValue = 1.0
        scaleDown.duration = 0.2
        scaleDown.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        let group = CAAnimationGroup()
        group.animations = [scaleUp, scaleDown]
        group.repeatCount = Float.infinity
        let sum = CGFloat(dotsCount)*0.3+CGFloat(0.4)
        group.duration = CFTimeInterval(sum)
        return group
    }
}
