//
//  ToastViewController.swift
//  ToastViewController
//
//  Created by Mohan on 29/10/21.
//

import UIKit

class ToastViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .clear
		let xCoord = self.view.bounds.width / 2 - 50
		let yCoord = self.view.bounds.height / 2 - 50

		toastView.frame = CGRect(x: xCoord, y: yCoord, width: 200, height: 100)
		toastView.backgroundColor = .black
		view.addSubview(toastView)
		toastView.addSubview(label)

		NSLayoutConstraint.activate([
			toastView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			toastView.centerYAnchor.constraint(equalTo: view.centerYAnchor),


			label.centerXAnchor.constraint(equalTo: toastView.centerXAnchor),
			label.centerYAnchor.constraint(equalTo: toastView.centerYAnchor)
		])
		
    }

	let toastView: UIView = {
		let p = UIView()
		p.translatesAutoresizingMaskIntoConstraints = false
		return p
	}()
	
	func configureLabel(_ str: String) {
		label.text = str
	}
	
	let label : UILabel = {
		let p = UILabel()
		p.backgroundColor = .lightGray
		p.layer.borderWidth = 0.005
		p.layer.cornerRadius = 5
		p.textColor = .white
		p.layer.masksToBounds = true
		p.translatesAutoresizingMaskIntoConstraints = false
		return p
	}()
}
