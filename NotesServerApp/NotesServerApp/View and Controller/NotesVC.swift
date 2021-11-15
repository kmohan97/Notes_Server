//
//  NotesVC.swift
//  NotesVC
//
//  Created by Mohan on 14/11/21.
//

import UIKit

class NotesVC: UIViewController {
	
	var dataBaseHelper = DataBaseFetcher()

	let titleField: UITextField = {
		let p = UITextField()
		p.translatesAutoresizingMaskIntoConstraints = false
		p.backgroundColor = .lightText
		p.placeholder = "Enter the Title"
		p.font = UIFont.systemFont(ofSize: 20, weight: .medium)
		p.adjustsFontForContentSizeCategory = true
		return p
	}()
	
	let bodyField: UITextView = {
		let p = UITextView()
		p.backgroundColor = .lightText
		p.font = UIFont.systemFont(ofSize: 20, weight: .medium)
		p.adjustsFontForContentSizeCategory = true
		p.translatesAutoresizingMaskIntoConstraints = false
		return p
	}()
	
	let seperator: UIView = {
		let p = UIView()
		p.backgroundColor = .gray
		p.translatesAutoresizingMaskIntoConstraints = false
		return p
	}()
	
	var delegate: updateNotesBack?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .systemGreen
		view.addSubview(titleField)
		view.addSubview(bodyField)
		view.addSubview(seperator)
        addConst()
    }
	
	override func viewWillDisappear(_ animated: Bool) {
		if let model = model {
			// already present, so update
			var notesModel = NotesModel(_id: model._id, body: bodyField.text!, title: titleField.text!)
			delegate?.addNotes(model: notesModel)
			var body = [
				"id": model._id,
				"body": bodyField.text!,
				"title": titleField.text!
			]
			dataBaseHelper.deleteUpdateAddData(url: Constants.updateURL.rawValue, body: body)
		} else {
			// new one add it
			var body = [
				"body": bodyField.text!,
				"title": titleField.text!
			]
			dataBaseHelper.deleteUpdateAddData(url: Constants.addURL.rawValue, body: body)
			delegate?.addNotes(model: nil)
		}
	}
	
	var model: NotesModel?
	
	func configure(model: NotesModel) {
		self.model = model
		titleField.text = model.title
		bodyField.text = model.body
	}
	
	func addConst() {
		NSLayoutConstraint.activate([
			titleField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			titleField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			titleField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			titleField.heightAnchor.constraint(equalToConstant: 50),
			
			seperator.topAnchor.constraint(equalTo: titleField.bottomAnchor),
			seperator.widthAnchor.constraint(equalTo: titleField.widthAnchor),
			seperator.heightAnchor.constraint(equalToConstant: 1),
			
			bodyField.topAnchor.constraint(equalTo: seperator.bottomAnchor,constant: 0),
			bodyField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			bodyField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			bodyField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
			
		])
		
	}
}
