//
//  GalleryViewController.swift
//  Gallery
//
//  Created by test on 02/09/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    var imagePickerController: UIImagePickerController?
    var refreshControl: UIRefreshControl?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerController = UIImagePickerController()
        imagePickerController?.delegate = self
        
        title = "Gallery"
        
        addRefreshControl()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        if let control = refreshControl {
            imagesCollectionView.addSubview(control)
        }
        imagesCollectionView.alwaysBounceVertical = true

    }
    
    func refresh() {
        imagesCollectionView.reloadData()
        refreshControl?.endRefreshing()

    }
}


extension GalleryViewController {
    
    @IBAction func showImageUploadOptions(_ sender: Any) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { [weak self] action in
            self?.openGallery()
        }))
        alertController.addAction(UIAlertAction(title: "Camera", style: .default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func showSizeSelectors(_ sender: Any) {
        
        let sizesAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sizesAlertController.addAction(UIAlertAction(title: "120x200", style: .default, handler: { [weak self] action in
            
            CloudinaryManager.selectedSize = Size(width: 120, heiht: 200)
            self?.imagesCollectionView.reloadData()
            
        }))
        sizesAlertController.addAction(UIAlertAction(title: "100x150", style: .default, handler: { [weak self] action in
            
            CloudinaryManager.selectedSize = Size(width: 100, heiht: 150)
            self?.imagesCollectionView.reloadData()

        }))
        sizesAlertController.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
        present(sizesAlertController, animated: true, completion: nil)
    }
    
    func openGallery() {
        if let picker = imagePickerController {
            picker.sourceType = .photoLibrary
            present(picker, animated: true, completion: nil)
        }
    }
    
    func showCamera() {
        if let picker = imagePickerController {
            picker.sourceType = .camera
            present(picker, animated: true, completion: nil)
        }
    }
}



extension GalleryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            CloudinaryManager.upload(image: image)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}


extension GalleryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CloudinaryManager.images.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? ImageCollectionViewCell {
            cell.setImage(with: CloudinaryManager.images[indexPath.row])
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let width = CloudinaryManager.selectedSize?.width , let height = CloudinaryManager.selectedSize?.heiht {
            
            return CGSize(width: width, height: height)
        } else {
            return CGSize(width: 120, height: 120)

        }
    }
    
}
