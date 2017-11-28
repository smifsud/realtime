/*
 Copyright 2017 Material Cause LLC
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
 associated documentation files (the "Software"), to deal in the Software without restriction,
 including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
 and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do
 so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial
 portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
 LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


import UIKit
import SocketIO

// Struct for parsed JSON data ------------------------------------

struct NewsAPIStruct:Decodable
{
    let headlines:[Headlines];
}

struct Headlines:Decodable
{
    let newsgroupID:Int;
    let newsgroup: String;
    let headline: String;
    
    init (json: [String: Any])
    {
        newsgroupID = json ["newsgroupID"] as? Int ?? -1;
        newsgroup = json ["newsgroup"] as? String ?? "";
        headline = json ["headline"] as? String ?? "";
    };
};

// Struct end  --------------------------------------------------

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    private var tableView:UITableView!;
    private var headlinesArray = [String]();
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.headlinesArray.count;
    };
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        print ( self.headlinesArray[indexPath.row])
        cell.textLabel?.text = self.headlinesArray[indexPath.row];
        return cell
    };
    
    let manager = SocketManager(socketURL: URL(string: "http://localhost:8080")!,config: [.log(true),.connectParams(["token": "ABC438s"])])
    
    var socket:SocketIOClient!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setTable();
        self.socket = manager.defaultSocket;
        self.setSocketEvents();
        
        self.socket.connect();
        self.getHeadlines();
    }
    private func setTable()
    {
        let displayWidth: CGFloat = self.view.frame.width;
        let displayHeight: CGFloat = self.view.frame.height;
        
        self.tableView = UITableView(frame: CGRect(x: 0, y:0, width: displayWidth, height: displayHeight));
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell");
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.view.addSubview(self.tableView);
    };
    
    func getHeadlines()
    {
        self.headlinesArray = [];
        
        let jsonURLString:String = "http://localhost:3000/headlines/?token=ABC438s";
        guard let url = URL(string: jsonURLString) else
        {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            
            guard let data = data else { return }
            
            do{
                let newsAPIStruct = try
                    JSONDecoder().decode(NewsAPIStruct.self, from: data)
                
                for item in newsAPIStruct.headlines
                {
                    self.headlinesArray.append (item.headline);
                };
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            } catch let jsonErr
            {
                print ("error: ", jsonErr)
            }
            }.resume();
    };
    
    private func setSocketEvents()
    {
        self.socket.on(clientEvent: .connect) {data, ack in
            print("socket connected");
        };
        
        self.socket.on("headlines_updated") {data, ack in
            self.getHeadlines();
        };
    };
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    };
};

