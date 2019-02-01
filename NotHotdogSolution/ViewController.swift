//
//  ViewController.swift
//  NotHotdogSolution
//
//  Created by Sarthak Khillon on 1/30/19.
//  Copyright © 2019 Sarthak Khillon. All rights reserved.
//

import UIKit
import SwiftSpinner // Fancy loading

class ViewController: UIViewController, // Inherit from general class
        UINavigationControllerDelegate, UIImagePickerControllerDelegate, // To launch camera (image picker)
        UITableViewDataSource, UITableViewDelegate // To control table view.
{

    let imagePickerController = UIImagePickerController()
    let imageChoiceSheet = UIAlertController()
    
    let checkmark = UIImage(named: "checkmark")
    let cross = UIImage(named: "cross")
    
    var resultHistoryList = [Result]()
    
    @IBOutlet weak var tableView: UITableView!
    
    // Called whenever camera button is tapped.
    @IBAction func launchCamera(_ sender: Any) {
        present(imageChoiceSheet, animated: true)
    }
    
    // For any additional setup after loading the view.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActionSheet()
        setupImagePicker()
        setupTableView()
    }
    
    // MARK: - SETUP
    private func setupActionSheet() {
        let useCamera = UIAlertAction(title: "Take Photo", style: .default) { _ in
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true)
        }
        
        let pickPhoto = UIAlertAction(title: "Choose from Library", style: .default) { _ in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true)
        }
        
        imageChoiceSheet.addAction(useCamera)
        imageChoiceSheet.addAction(pickPhoto)
    }
    
    private func setupImagePicker() {
        // By default we set it to photo library.
        imagePickerController.sourceType = .photoLibrary
        
        // We don't want the user to mark up the photo before the ML model processes it.
        imagePickerController.allowsEditing = true
        
        // Who gets notified of events like "I'm done, here's the photo"? This main view controller!
        // P.S. 99% of the time, you set delegates to "self" if calling from a ViewController.
        imagePickerController.delegate = self
    }
    
    private func setupTableView() {
        tableView.allowsSelection = false
        
        // Again, standard.
        tableView.dataSource = self
        tableView.delegate = self
        
        // This is how to get rid of those empty cells at the bottom.
        tableView.tableFooterView = UIView()
    }
    
    private func updateTableView() {
        tableView.beginUpdates()
        tableView.reloadData()
        tableView.endUpdates()
    }

    // MARK: - IMAGE PICKER
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.originalImage] as? UIImage else {
            print("No image found")
            return
        }
        
        let alertVC = UIAlertController(title: "Name your photo!", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            SwiftSpinner.show("Getting image results")
            
            Client.classify(image) { isHotdog in
                SwiftSpinner.hide()
                
                let imageTitle = alertVC.textFields?.first?.text ?? ""
                let currentResult = Result(image: image, title: imageTitle, isHotdog: isHotdog)
                
                self.resultHistoryList.append(currentResult)
                self.updateTableView()
            }
        }
        
        alertVC.addTextField { textField in
            textField.placeholder = "Name"
        }
        alertVC.addAction(cancelAction)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // We have as many cells as elements in the list.
        return resultHistoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Make sure the row isn't greater than the size of our result list.
        guard indexPath.row < resultHistoryList.count else {
            // Return a generic, empty cell on failure.
            return UITableViewCell()
        }
        
        // Make sure all cells are HistoryCells and not some other type.
        guard let historyCell = tableView.cellForRow(at: indexPath) as? HistoryCell else {
            return UITableViewCell()
        }
        
        // Get the appropriate Result object from our list.
        let result = resultHistoryList[indexPath.row]
        
        // Now that we've verified, we can use the historyCell.
        historyCell.foodItemImageView.image = result.image
        historyCell.titleLabel.text = result.title
        historyCell.dateLabel.text = result.formattedDate
        historyCell.statusImageView.image = result.isHotdog ? checkmark : cross
        
        return historyCell
    }
}

