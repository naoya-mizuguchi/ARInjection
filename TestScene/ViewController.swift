//
//  ViewController.swift
//  TestScene
//
//  Created by Naoya Mizuguchi on 2018/02/28.
//  Copyright © 2018年 Naoya Mizuguchi. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    let openCV = opencvWrapper()
    
    @IBOutlet weak var image : UIImageView!
    
    let opencv = opencvWrapper()
    let metal_src = UIImage(named : "metal.jpg");
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        opencv.setMetalImage(metal_src);

        opencv.createCamera(withParentView: image)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        opencv.start()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

