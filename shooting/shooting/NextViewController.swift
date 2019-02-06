//
//  NextViewController.swift
//  shooting
//
//  Created by 洞井僚太 on 2018/10/30.
//  Copyright © 2018 洞井僚太. All rights reserved.
//

import UIKit

class NextViewController: UIViewController {
    var pageNum:Int=1
    var image:UIImage!
    var imageview:UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let imag=UIImage(named:"thearth")
        let View=UIImageView(image:imag)
        view.addSubview(View)
        self.view.sendSubviewToBack(View)
        let button=UIButton(frame:CGRect(x:view.frame.width/10,y:view.frame.height/2+100,width:100,height:100))
        let left=UIImage(named:"left")
        button.setImage(left,for:.normal)
        button.addTarget(self, action:#selector(backpage(sender:)), for:.touchUpInside)
        view.addSubview(button)
        let button2=UIButton(frame:CGRect(x:view.frame.width/2,y:view.frame.height/2+100,width:100,height:100))
        let right=UIImage(named:"right")
       // button2.backgroundColor=UIColor.red
        button2.setImage(right,for:.normal)
        button2.addTarget(self, action:#selector(gopage(sender:)), for:.touchUpInside)
        view.addSubview(button2)
        image=UIImage(named:"intro1")
        imageview=UIImageView(image:image)
        let scale:CGFloat=self.view.bounds.size.width/image.size.width
        imageview.frame=CGRect(x:0,y:0,width:image.size.width*scale,height:image.size.height*scale)
        imageview.center=CGPoint(x:view.frame.width/2,y:view.frame.height/3)
        view.addSubview(imageview)
        // Do any additional setup after loading the view.
    }
    @objc func backpage(sender:UIButton){
        if pageNum==1{
            return
        }
        imageview.removeFromSuperview()
        pageNum-=1
        image=UIImage(named:"intro\(pageNum)")
        imageview=UIImageView(image:image)
        let scale:CGFloat=self.view.bounds.size.width/image.size.width
        imageview.frame=CGRect(x:0,y:0,width:image.size.width*scale,height:image.size.height*scale)
        imageview.center=CGPoint(x:view.frame.width/2,y:view.frame.height/3)
        view.addSubview(imageview)
    }
    @objc func gopage(sender:UIButton){
        if pageNum==3{
            return
        }
        imageview.removeFromSuperview()
        pageNum+=1
        
        image=UIImage(named:"intro\(pageNum)")
        imageview=UIImageView(image:image)
        let scale:CGFloat=self.view.bounds.size.width/image.size.width
        imageview.frame=CGRect(x:0,y:0,width:image.size.width*scale,height:image.size.height*scale)
        imageview.center=CGPoint(x:view.frame.width/2,y:view.frame.height/3)
        view.addSubview(imageview)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
