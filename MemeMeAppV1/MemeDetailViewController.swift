//
//  MemeDetailViewController.swift
//  MemeMeAppV1
//
//  Created by Rosario A Robinson on 9/17/18.
//  Copyright © 2018 Rosario Robinson. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    
    var meme : Meme!
    
    //removed label outlet
    @IBOutlet weak var imageView: UIImageView!
    //@IBOutlet weak var label: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.image = meme.memedImage
    }

}
