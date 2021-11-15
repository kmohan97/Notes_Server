//
//  ViewController.swift
//  NotesServerApp
//
//  Created by Mohan on 14/11/21.
//

import UIKit
import CoreLocationUI

protocol updateNotesBack {
	func addNotes(model: NotesModel?)
}

class ViewController: UIViewController {
	
	let tableView: UITableView = {
		let p = UITableView()
		p.translatesAutoresizingMaskIntoConstraints = false
		return p
	}()
	
	var notesArray: [NotesModel]  = []
	
	var apiHelper = DataBaseFetcher()
	
	var toastMessageObject = ToastMessage()
	
	var spinner: UIActivityIndicatorView = {
		var p = UIActivityIndicatorView(style: .large)
		p.translatesAutoresizingMaskIntoConstraints = false
		p.startAnimating()
		return p
	}()
	
	var refreshControl: UIRefreshControl = {
		let p = UIRefreshControl()
		p.addTarget(self, action: #selector(showData), for: .valueChanged)
		p.attributedTitle = NSAttributedString(string: "Fetching from Server")
		return p
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		tableView.dataSource = self
		tableView.delegate = self
		self.navigationItem.title = "Notes"
		view.addSubview(tableView)
		view.addSubview(spinner)
		view.backgroundColor = .systemGreen
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuse")
		tableView.refreshControl = refreshControl
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createNewNotes))
		addConst()
		showData()
		view.bringSubviewToFront(spinner)
	}
	
	@objc func showData() {
		let url = Constants.fetchURL
		apiHelper.fetchData(url: url.rawValue, body: nil) { res in
			DispatchQueue.main.async { [weak self] in
				switch res {
					case .success(let model):
						self?.notesArray = model
						self?.tableView.reloadData()
						self?.refreshControl.endRefreshing()
					case.failure(let err):
						print("Error while fetching")
						self?.showAlert()
				}
				self?.spinner.removeFromSuperview()
			}
		}
	}
	
	@objc func createNewNotes() {
		var vc = NotesVC()
		vc.delegate = self
		self.navigationController?.pushViewController(vc, animated: true)
	}
	
	func addConst() {
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			
			spinner.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
			spinner.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
		])
	}
	
	func showAlert() {
		var alCont = UIAlertController(title: "Error", message: "Connection Error", preferredStyle: .alert)
		var okButton = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
		alCont.addAction(okButton)
		present(alCont, animated: true) { [weak self] in
			self?.refreshControl.endRefreshing()
		}
	}

}


extension ViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		notesArray.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let deq = tableView.dequeueReusableCell(withIdentifier: "reuse")
		let model = notesArray[indexPath.row]
		deq?.textLabel?.text = model.title
		return deq!
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			var model = notesArray[indexPath.row]
			var body = [
				"id": model._id
			]
			print(body)
			apiHelper.deleteUpdateAddData(url: Constants.deleteURL.rawValue, body: body)
			notesArray.remove(at: indexPath.row)
			toastMessageObject.showToast(message: "Deleted Note")
			tableView.beginUpdates()
			tableView.deleteRows(at: [indexPath], with: .fade)
			tableView.endUpdates()
		}
	}
}

extension ViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		var notesVC = NotesVC()
		var model = notesArray[indexPath.row]
		notesVC.delegate = self
		notesVC.configure(model: model)
		self.navigationController?.pushViewController(notesVC, animated: true)
	}
	
}

extension ViewController: updateNotesBack {
	func addNotes(model: NotesModel?) {
		if let model = model {
			var j = 0;
			for i in notesArray {
				if i._id == model._id {
					break;
				}
				j += 1
			}
			notesArray[j] = model
			tableView.reloadData()
			toastMessageObject.showToast(message: "Updated Note")
		} else {
			DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(0.1)), execute: { [weak self] in
				self?.showData()
				self?.toastMessageObject.showToast(message: "Saved Note")
			})
		}
	}
}
