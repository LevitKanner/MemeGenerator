//
//  ViewController.swift
//  Challenge7_Meme_Generator
//
//  Created by Levit Kanner on 11/06/2020.
//  Copyright © 2020 Levit Kanner. All rights reserved.
//

import UIKit
import CoreGraphics

class ViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    //MARK: - PROPERTIES
    @IBOutlet var memeView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Meme Generator"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add ,target: self, action: #selector(createMeme))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareMeme))
        welcomeImage()
    }
    
    
    //MARK: - METHODS
    @objc func createMeme() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker , animated: true)
        
    }
    
    @objc func shareMeme() {
        let controller = UIActivityViewController(activityItems: [memeView.image!], applicationActivities: [])
        controller.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(controller, animated: true)
    }
    
    func presentCaptionSheet() {
        let controller = UIAlertController(title: "Meme Caption", message: nil, preferredStyle: .alert)
        controller.addTextField(configurationHandler: nil)
        controller.addAction(UIAlertAction(title: "submit", style: .default, handler: {[weak self, weak controller] (action) in
            guard let text = controller?.textFields?.first?.text else {return }
            let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
            self?.drawMeme(with: trimmed)
        }))
        present(controller, animated: true)
    }
    
    //MARK: - IMAGE PICKER DELEGATE
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        self.memeView.image = image
        
        dismiss(animated: true, completion: nil)
        presentCaptionSheet()
    }
    
    
    //MARK: - DRAWING
    func drawMeme(with caption: String) {
        guard let memeImage = self.memeView.image else { return }
        let size = memeImage.size
        
        let renderer = UIGraphicsImageRenderer(bounds: CGRect(x: 0, y: 0, width: size.width + 20, height: size.height + 150))
        
        let img = renderer.image { context in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key : Any] = [.font : UIFont.systemFont(ofSize: 64),
                                                         .foregroundColor: UIColor.black,
                                                         .paragraphStyle : paragraphStyle,
            ]
            
            let caption = NSAttributedString(string: caption, attributes: attrs)
            
            caption.draw(with: CGRect(x: 10, y: 10, width: size.width, height: 200), options: .usesLineFragmentOrigin, context: nil)
            
            memeImage.draw(in: CGRect(x: 10, y: 220, width: size.width, height: size.height))
        }
        self.memeView.image = img
    }
    
    
    
    func welcomeImage() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 310, height: 400))
        
        let img = renderer.image { context in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .paragraphStyle: paragraphStyle
            ]
            
            let string = "Welcome to Meme Generator"
            let attributedString = NSAttributedString(string: string, attributes: attrs)
            
            attributedString.draw(with: CGRect(x: 8, y: 20, width: 300, height: 448), options: .usesLineFragmentOrigin, context: nil)
            
            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 70, y: 110))
        }
        memeView.image = img
    }
}


