//
//  ViewImageViewController.swift
//  PicturePerfect
//
//  Created by Gus Silva on 4/16/17.
//  Copyright © 2017 Gus Silva. All rights reserved.
//

import UIKit

class ViewImageViewController: UIViewController {

    @IBOutlet weak var savedBanner: UILabel!
    @IBOutlet weak var previewImageView: UIImageView!
    
    @IBOutlet weak var shareButton: MaterialButton!
    @IBOutlet weak var saveButton: MaterialButton!
    
    var imageToPreview: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = imageToPreview {
            previewImageView.image = image
            
            // Flip horizontal to match preview
            previewImageView.transform = CGAffineTransform(scaleX: -1, y: 1)
        } else {
            print("image is nil!")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        slideButtonsIn()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func slideButtonsIn() {
        self.shareButton.frame.origin.y = self.shareButton.frame.origin.y + 200
        self.saveButton.frame.origin.y = self.saveButton.frame.origin.y + 800
        
        UIView.animate(withDuration: 0.4, delay: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.shareButton.frame.origin.y = self.shareButton.frame.origin.y - 200
            self.saveButton.frame.origin.y = self.saveButton.frame.origin.y - 800
        }) { _ in
        }
    }
    
    func slideButtonsOut(onComplete: ((Void) -> Swift.Void)?) {
        UIView.animate(withDuration: 0.4, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.shareButton.frame.origin.y = self.shareButton.frame.origin.y + 200
            self.saveButton.frame.origin.y = self.saveButton.frame.origin.y + 800
        }) { _ in
            if let onComplete = onComplete {
                onComplete()
            }
        }
    }
    
    
    func showSavedBanner() {
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.savedBanner.frame.origin.y = 0
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.3, delay: 1.0, options: [], animations: {
                            self.savedBanner.frame.origin.y = -80
                        }, completion: nil)
                        
        })
    }
    
    func saveAttemptCompleted(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            showSavedBanner()
        }
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        slideButtonsOut { _ in
            self.performSegue(withIdentifier: "previewToCamera", sender: self)
        }
    }

    @IBAction func saveToCameraRoll(_ sender: MaterialButton) {
        sender.animatePress { _ in
            if let image = self.imageToPreview {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.saveAttemptCompleted(_:didFinishSavingWithError:contextInfo:)), nil)
            } else {
                print("Can't save to camera roll image is nil!")
            }
        }
    }
    
    @IBAction func shareButtonPressed(_ sender: MaterialButton) {
        sender.animatePress { _ in
            if let image = self.imageToPreview {
                let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
                // present the view controller
                self.present(activityViewController, animated: true, completion: nil)
            }
        }
    }
}
