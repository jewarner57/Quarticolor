//
//  GameViewController.swift
//  ColorSwarm
//
//  Created by Jonathan Warner on 2/13/16.
//  Copyright (c) 2016 TeedethGaming. All rights reserved.
//

import UIKit
import SpriteKit
import GoogleMobileAds

class GameViewController: UIViewController {

     var interstitial: GADInterstitial!
    
    
    func displayAd() {
        
        if interstitial.isReady {
            print("Ad displayed")
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
        loadAd()
    }
    
    func loadAd() {
        
        interstitial = GADInterstitial(adUnitID: "KEY")
        let request = GADRequest()
        interstitial.load(request)
        request.testDevices = [ kGADSimulatorID, "KEY" ]
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(displayAd), name: Notification.Name("showAd") as NSNotification.Name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadAd), name: Notification.Name("loadAd") as NSNotification.Name, object: nil)
        
        
        
        
        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFill
            
            scene.size = skView.bounds.size
            
            skView.presentScene(scene)
            
            
        }
    }

    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    
    
}
