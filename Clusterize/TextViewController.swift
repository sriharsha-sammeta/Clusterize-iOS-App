//
//  TextViewController.swift
//  Psychologist
//
//  Created by Sriharshaa Sammeta on 2/15/15.
//  Copyright (c) 2015 Sriharshaa Sammeta. All rights reserved.
//

import UIKit

class TextViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!{
        didSet{
            textView.text = text

        }
    }
    
    var text: String = ""

    override var preferredContentSize: CGSize{
        get{
            if textView != nil && presentingViewController != nil{
                return textView.sizeThatFits(presentingViewController!.view.bounds.size)
            }else{
                return super.preferredContentSize
            }
            
        }
        set{
        super.preferredContentSize = newValue
        }
    }
}
