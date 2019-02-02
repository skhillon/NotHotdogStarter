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
        
        setupImagePicker()
        setupActionSheet()
        setupTableView()
    }
    
    // MARK: - SETUP
    private func setupImagePicker() {
        // By default we set it to photo library.
        imagePickerController.sourceType = .photoLibrary
        
        // We don't want the user to mark up the photo before the ML model processes it.
        imagePickerController.allowsEditing = true
        
        // Who gets notified of events like "I'm done, here's the photo"? This main view controller!
        // P.S. 99% of the time, you set delegates to "self" if calling from a ViewController.
        imagePickerController.delegate = self
    }
    
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
    
    private func setupTableView() {
        tableView.allowsSelection = false
        
        // Again, standard.
        tableView.dataSource = self
        tableView.delegate = self
        
        // This is how to get rid of those empty cells at the bottom.
        tableView.tableFooterView = UIView()
    }

    // MARK: - IMAGE PICKER
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // TODO5
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - TABLE VIEW
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // We have as many cells as elements in the list.
        return resultHistoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO2
    }
}

