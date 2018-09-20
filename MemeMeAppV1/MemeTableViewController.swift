//
//  MemeTableViewController.swift
//  MemeMeAppV1
//
//  Created by Rosario A Robinson on 8/30/18.
//  Copyright © 2018 Rosario Robinson. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    //Mark: TableView Data
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //dequeue
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell", for: indexPath)
        _ = memes[indexPath.row]
        cell.textLabel?.text = memes[indexPath.row].topText + " ... " + memes[indexPath.row].bottomText
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "MemeDetailViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MemeDetailViewController" {
            let controller = segue.destination as! MemeDetailViewController
            if let indexPath = tableView.indexPathForSelectedRow{
                let selectedRow = indexPath.row
                controller.meme = self.appDelegate.memes[selectedRow] as! Meme
                controller.memeIndex = selectedRow
            }
        }
    }
}
