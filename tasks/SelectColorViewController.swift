//
//  SelectColorViewController.swift
//  TasksMe
//
//  Created by Valeriy PETRENKO on 20/10/2017.
//  Copyright © 2017 Slavamax BVBA. All rights reserved.
//

import UIKit

class SelectColorViewController: UIViewController {
    var  colorNumber:Int = 1
    
    @IBAction func yellowPressed(_ sender: Any) {
        colorNumber  = 1
        dismiss(animated: true, completion: nil)
        popoverPresentationController?.delegate?.popoverPresentationControllerDidDismissPopover?(popoverPresentationController!)
    }
    
    @IBAction func bluePressed(_ sender: Any) {
         colorNumber  = 2
        dismiss(animated: true, completion: nil)
        popoverPresentationController?.delegate?.popoverPresentationControllerDidDismissPopover?(popoverPresentationController!)
    }
    
    @IBAction func grayPressed(_ sender: Any) {
           colorNumber  = 3
       dismiss(animated: true, completion: nil)
        popoverPresentationController?.delegate?.popoverPresentationControllerDidDismissPopover?(popoverPresentationController!)
    }
    
    
    @IBAction func greenPressed(_ sender: Any) {
         colorNumber  = 4
        dismiss(animated: true, completion: nil)
        popoverPresentationController?.delegate?.popoverPresentationControllerDidDismissPopover?(popoverPresentationController!)
    }
    
    @IBAction func magentaPressed(_ sender: Any) {
       colorNumber  = 5
       dismiss(animated: true, completion: nil)
        popoverPresentationController?.delegate?.popoverPresentationControllerDidDismissPopover?(popoverPresentationController!)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
