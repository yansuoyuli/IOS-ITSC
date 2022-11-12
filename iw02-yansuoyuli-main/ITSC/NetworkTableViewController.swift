

import UIKit
import SwiftSoup
class NetworkTableViewController: UITableViewController {

  
    var News : [NewsItem] = []
    let base_string : String = "https://itsc.nju.edu.cn"
    var i : Int = 0
    var download_file : String = ""
    var page_num:Int = 18
    var flag:Bool = true
    func getNews(){
        do {
            let document = try SwiftSoup.parse(self.download_file)
//            let pages_el: Element = try document.select("em.all_pages").first()!
//            self.page_num = Int(try pages_el.text()) ?? 0
//            print(self.page_num)
            let title_els: Elements = try document.select("span.news_title")
            let meta_els: Elements = try document.select("span.news_meta")
            //let els:Elements = try document.getElementsByClass("span.news_title")
            for link:Element in title_els.array(){//set link and news title
                let s:String = try link.html()
                let linkwebsite: Element = try SwiftSoup.parse(s).select("a").first()!
                let linkhref:String = try linkwebsite.attr("href")
                let item = NewsItem(title:try link.text(),date:"",website:base_string + linkhref)
                self.News.append(item)
               // print(link)
                //print(try link.text())
               
            }
        
            for link:Element in meta_els.array(){//set time
                News[i].date = try link.text()
                i = i + 1
                //print(try link.text())
            }
//            let linkInnerH: String = try link.html(); // "<b>example</b>"
        } catch Exception.Error(let type, let message) {
            print(message)
        } catch {
            print("error")
        }
    }
    
    func downloadhtml(page:Int){
        let url_str = "https://itsc.nju.edu.cn/wlyxqk/list" + String(page+1) + ".htm"
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
                        self.download_file = string
                        self.getNews()
                        if page == 0{
                            self.setPageNum()
                        }
                        self.tableView.reloadData()
                        //print(self.News.count)
                        //print(string)
                    }
                }
        })
        task.resume()
         
    }

    func setPageNum(){
        do {
            let document = try SwiftSoup.parse(self.download_file)
            let pages_el: Element = try document.select("em.all_pages").first()!
            self.page_num = Int(try pages_el.text()) ?? 0
            print(self.page_num)
        } catch Exception.Error(let type, let message) {
            print(message)
        } catch {
            print("error")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.setPageNum()
        let queue = DispatchQueue(label: "com.table")
            queue.sync {
                for j in 0..<self.page_num {
                    self.downloadhtml(page:j)
                    usleep(400000)
                   // print(j)
                }
            }
        //self.getNews()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contentViewController = self.storyboard!.instantiateViewController(withIdentifier: "ContentViewController") as! ContentViewController//segue.destination as! ContentViewController
        let item = News[indexPath.row]
        _ = contentViewController.view
        print(item.title)
        //contentViewController.title1.text = item.title
        navigationController?.pushViewController(contentViewController, animated: true)
        contentViewController.loadhtml(news_item: item)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //print(News.count)
        return News.count
    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//        let contentViewController = self.storyboard!.instantiateViewController(withIdentifier: "ContentViewController") as! ContentViewController//segue.destination as! ContentViewController
//        _ = contentViewController
//        let cell = sender as! NewsTableViewCell
//        let item = News[tableView.indexPath(for: cell)!.row]
//        print(item.title)
//        contentViewController.title1.text = item.title
//        //navigationController?.pushViewController(contentViewController, animated: true)
//        contentViewController.loadhtml(news_item: item)
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> NetworkTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NetworkCell", for: indexPath) as! NetworkTableViewCell
//        if(News.count == 243&&flag){
//            for i in 0..<243{
//                print (News[i].date)
//            }
//            flag = false
//        }
        if(indexPath.row >= News.count){
            cell.title.text! = ""
            cell.date.text! = ""
            return cell
        }
        let notice = News[indexPath.row]
        // Configure the cell...
        cell.title.text! = notice.title
        cell.date.text! = notice.date
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
