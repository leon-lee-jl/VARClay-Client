//
//  ViewController.swift
//  ARClay
//
//  Created by Leon Lee on 3/14/18.
//  Copyright © 2018 Leon Lee. All rights reserved.
//

import UIKit
//import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet weak var drawButton: UIButton!
    var drawingModel: String!
    var drawingColor: String!
    var selectedModel: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawingModel = "Cube"
        drawingColor = "255-255-255"
        selectedModel = "Tree"

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.startUnity()
            
            NotificationCenter.default.addObserver(self, selector: #selector(handleUnityReady), name: NSNotification.Name("UnityReady"), object: nil)
//            NotificationCenter.default.addObserver(self, selector: #selector(handleUnityToggleRotation(_:)), name: NSNotification.Name("UnityToggleRotation"), object: nil)
        }
        
        drawButton.addTarget(self, action: #selector(holdRelease), for: .touchUpInside);
        drawButton.addTarget(self, action: #selector(HoldDown), for: .touchDown)
    }

    //target functions
    @objc func HoldDown(sender:UIButton)
    {
        if drawingModel == "XXX1" || drawingModel == "XXX1" || drawingModel == "XXX2" {
            drawingModel = "Sphere"
        }
//        String stringColor =
        let commands = "drawOn" + " " + drawingModel + " " + drawingColor
        UnityPostMessage("PaintManager", "ReceiveCommand", commands)
    }
    
    @objc func holdRelease(sender:UIButton)
    {
        let commands = "drawOff" + " " + drawingModel + " " + drawingColor
        UnityPostMessage("PaintManager", "ReceiveCommand", commands)
    }
    
    
    @objc func handleUnityReady() {
        showUnitySubView()
    }
    func showUnitySubView() {
        if let unityView = UnityGetGLView() {
            // insert subview at index 0 ensures unity view is behind current UI view
            view?.insertSubview(unityView, at: 0)
            
            unityView.translatesAutoresizingMaskIntoConstraints = false
            let views = ["view": unityView]
            let w = NSLayoutConstraint.constraints(withVisualFormat: "|-0-[view]-0-|", options: [], metrics: nil, views: views)
            let h = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: [], metrics: nil, views: views)
            view.addConstraints(w + h)
        }
    }
    
    @IBAction func clearButton(_ sender: Any) {
        let commands = "clear" + " " + drawingModel + " " + drawingColor
        UnityPostMessage("PaintManager", "ReceiveCommand", commands)
    }
    
    
    @IBAction func lockPlaneDetection(_ sender: Any) {
        UnityPostMessage("HitManager", "LockDectingPlane", "lock")

    }
    
    @IBAction func unwindSegue(_ sender: UIStoryboardSegue) {
        if let senderVC = sender.source as? DrawingPickerViewController {
            drawingModel = senderVC.currentDrawingModel
            drawingColor = senderVC.currentDrawingColor
        }
        if let anotherSenderVC = sender.source as? SelectingModelViewController {
            selectedModel = anotherSenderVC.currentModel
            // Send current model to unity
            UnityPostMessage("HitManager", "ChangePrefab", selectedModel)
        }
    }
}
