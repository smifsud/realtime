//
//  ViewController.swift
//  RealTime
//
//  Created by Spiro Mifsud on 2/8/20.
//  Copyright © 2020 Material Cause LLC. All rights reserved.
//


import UIKit
import SocketIO

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var tableView: UITableView!
    private var itemsArray: [String]?
    private let serverURL = "http://localhost:8080" // webservice URL with port
    
    fileprivate var manager: SocketManager?
    fileprivate var socket: SocketIOClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTable()      // set up table view with autoLayout and add to view
        setSockets()    // enabled websocket event listeners
        getHeadlines()  // make a manual first call to headlines API
    }
 
    private func getHeadlines() {
        itemsArray = []
        //  call to headlines API that is parsed inside Service class
        Service.shared.getHeadlines(token: "ABC438s") { (res, err) in
            
            if err != nil {print(String(describing: err)); return} // an error is received print error to log and stop
            
            //iterate through results and append headline string to the itemsArray for the table datasource
            for item in res {
                self.itemsArray?.append(item.headline)
            }
            DispatchQueue.main.async(execute: {self.tableView?.reloadData()}) // refresh tableview on main thread
        }
    }
    
    // set the websocket manager. fileprivate to protect this call within this specific class file
    fileprivate func setSockets() {
        setSocketManager()
        setSocketEvents()
        socket?.connect()
    }
    
    fileprivate func setSocketManager() {
        
        manager = SocketManager(socketURL: URL(string: serverURL)!, config: [.log(true), .connectParams(["token": "ABC438s"])])
        socket = manager?.defaultSocket
    }
    
    fileprivate func setSocketEvents() {
        
        // socket event handlers
        self.socket?.on(clientEvent: .connect) {_, _ in
            print("socket connected")
        }
        self.socket?.on("headlines_updated") {_, _ in
            self.getHeadlines()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController {
    
    // table setup methods
    private func setTable() {
        tableView = UITableView(frame: CGRect.zero) // set to frame CGRect to zero since dimensions will be handled by autolayout
        view.addSubview(self.tableView)
        
        //set autolayout parameters
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        
        // add datasource and delegate
        tableView.dataSource = self
        tableView.delegate = self
           
        // styling and registering custom cells
        tableView.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
           
         view.addSubview(tableView)
       }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // if itemsArray is not initialized make 0 count
        return itemsArray?.count ?? 0
    }
          
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.itemsArray![indexPath.row]
        return cell
    }
}
