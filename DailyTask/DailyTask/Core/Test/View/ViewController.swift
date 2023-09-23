//
//  ViewController.swift
//  DailyTask
//
//  Created by Eduardo on 19/09/23.
//

import UIKit

class ViewController: UIViewController {
    var viewModel : ViewModel?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        title = "Home"
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 220, height: 55))
        view.addSubview(button)
        button.center = view.center
        button.backgroundColor = UIColor(.customBlue)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.setTitle("Tap Me!", for: .normal)
    }
    @objc func didTapButton() {
        viewModel?.path()
    }
}

#Preview {
    ViewController()
}