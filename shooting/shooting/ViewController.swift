import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let image=UIImage(named:"thearth")
        let View=UIImageView(image:image)
        view.addSubview(View)
        self.view.sendSubviewToBack(View)
  /*      let Gbutton=UIButton(frame:CGRect(x:100,y:200,width:200,height:200))
        Gbutton.backgroundColor=UIColor.white
        Gbutton.setTitle("How To Play",for :.normal)
        Gbutton.setTitleColor(UIColor.black, for: .normal)
        Gbutton.addTarget(self, action:#selector(goGame(sender:)), for:.touchUpInside)
        view.addSubview(Gbutton)
        let button=UIButton(frame:CGRect(x:100,y:400,width:200,height:200))
        button.backgroundColor=UIColor.white
        button.setTitle("How To Play",for :.normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action:#selector(goto(sender:)), for:.touchUpInside)
        view.addSubview(button)
        // Do any additional setup after loading the view.*/
    }
    @objc func goto(sender:UIButton){
        let next=NextViewController()
        self.present(next,animated:false,completion: nil)
        
    }
    @objc func goGame(sender:UIButton){
        let next=GameViewController()
        self.present(next,animated:false,completion: nil)
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
