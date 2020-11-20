import Foundation
import UIKit

class StepBar: UIStackView {
    @objc dynamic var currStep: Int = 0
    var stepCount : Int = 0
    var stepPoints = [UIButton]()
    let progress = UIProgressView(frame: CGRect(x: 0, y: 10, width: UIScreen.main.bounds.width - 100, height:50))
    let currStepObservingContext = UnsafeMutableRawPointer(bitPattern: 1)
    let progressTintColor : UIColor = UIColor(red: 0.33, green: 0.41, blue: 0.45, alpha: 1.00)
    
    convenience init(stepCount: Int, currentStep: Int) {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 70, height: 50))
        currStep = currentStep
        self.stepCount = stepCount
        addObserver(self, forKeyPath: #keyPath(currStep), options: [.new, .old], context: currStepObservingContext)
        progress.tintColor = progressTintColor
        drawSteps()
    }
    
    func drawSteps()
    {
        addSubview(progress)
        progress.progress = Float(Double(currStep - 1) / 10) * 2.5
        for i in 0...stepCount-1 {
            let stepPoint = UIButton(frame: CGRect(x:  i * Int(progress.frame.width) / (stepCount - 1), y: 0, width: 25, height: 25))
            let shapeLayer = CAShapeLayer()
            shapeLayer.lineWidth = 5.0
            shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 25, height: 25), cornerRadius: 12).cgPath
            shapeLayer.strokeColor = UIColor.white.cgColor
            if i+1 == currStep {
                shapeLayer.fillColor = progressTintColor.cgColor
                let whiteDotLayer = CALayer()
                whiteDotLayer.frame = stepPoint.bounds.inset(by: UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8))
                whiteDotLayer.backgroundColor = UIColor.white.cgColor
                whiteDotLayer.cornerRadius = 5
                shapeLayer.addSublayer(whiteDotLayer)
            }
            else if i+1 < currStep{
                shapeLayer.fillColor = UIColor.green.cgColor
                let imageLayer = CALayer()
                imageLayer.frame = stepPoint.bounds.inset(by: UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8))
                imageLayer.contents = UIImage(named: "check.svg")!.cgImage
                shapeLayer.addSublayer(imageLayer)
            }
            else{
                shapeLayer.fillColor = UIColor.lightGray.cgColor
            }
            stepPoint.layer.addSublayer(shapeLayer)
            stepPoints.append(stepPoint)
            addSubview(stepPoint)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?,of object: Any?, change: [NSKeyValueChangeKey : Any]?,context: UnsafeMutableRawPointer?) {       
        guard let observingContext = context, observingContext == currStepObservingContext else {
            super.observeValue(forKeyPath: keyPath,of: object, change: change,context: context)
            return
        }
        guard let change = change else {
            return
        }
        if let oldValue = change[.oldKey] {
            print("Old step \(oldValue)")
        }
        if let newValue = change[.newKey]  {
            print("New step \(newValue)")
            subviews.forEach({ $0.removeFromSuperview() })
            drawSteps()
        }
    }
    
    deinit {
        removeObserver(self, forKeyPath: #keyPath(currStep))
    }
}
