

import UIKit
import SwiftSoup

class InfoViewController: UIViewController {
    
    @IBOutlet weak var text: UITextView!
    
    var info:String = ""
    var text1:String = ""
    func set_info(){
        do {
            let document = try SwiftSoup.parse(self.info)
            let content:Elements = try document.select("div.news_box")
            var i = 0
            for link in content{
                //print(try link.text())
                i += 1
                text1 += try link.text() + "\n"
                text1 += "\n"
                if(i > 4){
                    break
                }
            }
            text.text = text1
//            self.news_text = try content.text()
//            print(news_text)
//            let constr:String = self.news_text
//            if constr.count <= 160{
//                self.text1.text = constr
//                self.text2.text = " "
//            }else{
//                var startIndex = constr.index(constr.startIndex, offsetBy: 0)
//                var endIndex =  constr.index(constr.startIndex, offsetBy: 160)
//                self.text1.text = String(constr[startIndex..<endIndex])
//                startIndex = constr.index(constr.startIndex, offsetBy: 160)
//                endIndex =  constr.index(constr.startIndex, offsetBy:constr.count )
//                self.text2.text = String(constr[startIndex..<endIndex])
//            }
        } catch Exception.Error(let type, let message) {
            print(message)
        } catch {
            print("error")
        }
    }
    
    func downloadhtml(){
        let url_str = "https://itsc.nju.edu.cn/xwdt/list.htm"
        let url = URL(string: url_str)!
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
                        self.info = string
                        self.set_info()
                    }
                }
        })
        task.resume()
         
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.downloadhtml()
        // Do any additional setup after loading the view.
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
