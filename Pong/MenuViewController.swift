//
//  MenuViewController.swift
//  Pong
//
//  Created by Christopher Grayston on 5/2/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import UIKit

enum gameType {
    case easy
    case medium
    case hard
    case player2
    case unset
}

class MenuViewController: UIViewController {
    

    @IBAction func mutliplePlayerTapped(_ sender: Any) {
        moveToGame(game: .player2)
    }
    
    @IBAction func easyTapped(_ sender: Any) {
        moveToGame(game: .easy)
    }
    
    @IBAction func mediumTapped(_ sender: Any) {
        moveToGame(game: .medium)
    }
    
    @IBAction func hardTapped(_ sender: Any) {
        moveToGame(game: .hard)
    }
    
    func moveToGame(game: gameType) {
        let gameVC = self.storyboard?.instantiateViewController(identifier: "gameVC") as! GameViewController
        
        currentGameType = game
        
        self.navigationController?.pushViewController(gameVC, animated: true)
    }
    
}
