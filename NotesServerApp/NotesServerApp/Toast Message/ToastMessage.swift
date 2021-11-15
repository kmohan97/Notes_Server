//
//  ToastMessage.swift
//  ToastMessage
//
//  Created by Mohan on 14/11/21.
//

import Foundation
import UIKit

class ToastMessage: NSObject {
	
//	let ShowToast = Notification.Name(rawValue: "showToastNotification")
	
	func showToast(message : String) {
		DispatchQueue.main.async {
			self.showingToast(message: message)
		}
	}
	
	func showingToast(message: String) {
		let toast = ToastViewController()
		toast.configureLabel(message)
		var keyWindow = UIApplication.shared.keyWindow
		guard let keyWindow = keyWindow,let toastView = toast.view else {return}
		
		keyWindow.addSubview(toastView)
		keyWindow.bringSubviewToFront(toastView)
		
		toastView.alpha = 0
		NSLayoutConstraint.activate([
			keyWindow.topAnchor.constraint(equalTo: toastView.topAnchor),
			keyWindow.leadingAnchor.constraint(equalTo: toastView.leadingAnchor),
			keyWindow.trailingAnchor.constraint(equalTo: toastView.trailingAnchor)
		])
	
		
		UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.5, options: .curveLinear) {
			toastView.alpha = 1
		} completion: { [weak self] val in
			toastView.alpha = 0
			toastView.removeFromSuperview()
		}

	}
	
	

}
