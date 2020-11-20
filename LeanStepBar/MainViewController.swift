import UIKit

class MainViewController: UIViewController {
    private var progressView = StepBar(stepCount: 5, currentStep: 3)
    override func viewDidLoad() {
        super.viewDidLoad()
        let stepper = UIStepper()
        stepper.minimumValue = 1
        stepper.value = 3
        stepper.maximumValue = 6
        stepper.center = view.center
        progressView.center = CGPoint(x: view.center.x, y: view.center.y - 50)
        stepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
        view.backgroundColor = .white
        view.addSubview(progressView)
        view.addSubview(stepper)
    }
    @objc func stepperValueChanged(_ sender:UIStepper!)
    {
        progressView.currStep = Int(sender.value)
    }
}

