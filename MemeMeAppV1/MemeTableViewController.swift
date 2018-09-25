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
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell", for: indexPath) as! MemeTableViewCell
        _ = memes[indexPath.row]
        cell.nameLabel?.text = memes[indexPath.row].topText + " ... " + memes[indexPath.row].bottomText
        cell.memeImageView?.image = memes[indexPath.row].memedImage
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meme = (UIApplication.shared.delegate as! AppDelegate).memes[(indexPath as NSIndexPath).row]
        
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "MemeDetailViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MemeDetailViewController" {
            let MemeDetailViewController = segue.destination as! MemeDetailViewController
            MemeDetailViewController.meme = sender as! Meme
        }
    }
}
