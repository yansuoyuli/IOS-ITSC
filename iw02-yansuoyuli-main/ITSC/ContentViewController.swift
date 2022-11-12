
import UIKit
import SwiftSoup
class ContentViewController: UIViewController {

    @IBOutlet weak var title1: UILabel!
    @IBOutlet weak var text1: UITextView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var text2: UITextView!
    var pic_str:String = "https://itsc.nju.edu.cn"
    var html:String = ""
    var news_text:String = ""
    var labelText:String?
//    init?(coder: NSCoder, title1: UILabel , text1:UITextView , text2:UITextView, image:UIImageView) {
//        self.title1 = title1
//        self.text1 = text1
//        self.text2 = text2
//        self.image = image
//        super.init(coder: coder)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    func loadContent(){
        do {
            let document = try SwiftSoup.parse(self.html)
            let title = try document.title()
            let pics: Elements = try document.select("img[src]")
           // let srcsStringArray: [String?] = pngs.array().map { try? $0.attr("src").description }
           //self.image.image = UIImage(named: "default.jpg")
            var i = 0
            for pic:Element in pics{
                if(i == 2){//try pic.attr("data-layer") == "photo"){
                    self.pic_str += try pic.attr("src").description
                   // print(self.pic_str)
                    break;
                }
                i += 1
            }
            print(self.pic_str)
            guard let url = URL(string: self.pic_str) else { return }
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print("Failed fetching image:", error ?? 0)
                    return
                }

                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    print("Not a proper HTTPURLResponse or statusCode")
                    return
                }

                DispatchQueue.main.sync {
                    if(data == nil){
                        self.image.image = UIImage(named: "default.jpg")
                    }else{
                        self.image.image = UIImage(data: data!)
                    }
                }
            }.resume()
                
            
            self.title1.text! = title
//            let content:Elements = try document.select("meta")
//            for link:Element in content{
//                if try link.attr("name") == "description"{
//                    self.news_text = try link.attr("content")
//                    break;
//                }
//            }
            let content:Element = try document.select("div.read").first()!
            self.news_text = try content.text()
            print(news_text)
            let constr:String = self.news_text
            if constr.count <= 160{
                self.text1.text = constr
                self.text2.text = " "
            }else{
                var startIndex = constr.index(constr.startIndex, offsetBy: 0)
                var endIndex =  constr.index(constr.startIndex, offsetBy: 160)
                self.text1.text = String(constr[startIndex..<endIndex])
                startIndex = constr.index(constr.startIndex, offsetBy: 160)
                endIndex =  constr.index(constr.startIndex, offsetBy:constr.count )
                self.text2.text = String(constr[startIndex..<endIndex])
            }
        } catch Exception.Error(let type, let message) {
            print(message)
        } catch {
            print("error")
        }
    }
    
    func loadhtml(news_item:NewsItem){
        //print(self.title1.text!)
        //self.title1.text! = news_item.title
        let url = URL(string: news_item.website)!
        let task = URLSession.shared.dataTask(with: url, completionHandler: {
            data, response, error in
            if let error = error {
                print("\(error.localizedDescription)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("server error")
                return
            }
            if let mimeType = httpResponse.mimeType, mimeType == "text/html",
                let data = data,
                let string = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.sync {
                        self.html = string
                        //print(string)
                        self.loadContent()
                    }
                }
        })
        task.resume()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title1.lineBreakMode = .byWordWrapping
        self.title1.numberOfLines = 0
      //  self.navigationController?.toolbar.isHidden = true
        // Do any additional setup after loading the view.
        if let text = labelText{
            self.title1.text = text
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        //navigationController?.setToolbarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
       // navigationController?.setToolbarHidden(false, animated: animated)
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
