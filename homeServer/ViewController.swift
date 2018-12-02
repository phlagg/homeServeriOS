//
//  ViewController.swift
//  homeServer
//
//  Created by Michael Woods on 2018-12-01.
//  Copyright © 2018 Michael Woods. All rights reserved.
//
import SwiftWebSocket
import UIKit
var ws : WebSocket!

class ViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Transparent navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    let ws = WebSocket("ws://phlagg.freeddns.org:443")
    let impact = UIImpactFeedbackGenerator()
    
    @IBAction func buzzer(_ sender: UIButton) {
        impact.impactOccurred()
        
        print("Buzz")
        
        buzz(ws:ws)
        
    }
}
//let notification = UINotificationFeedbackGenerator()
//
//    notification.notificationOccurred(.success)
func buzz(ws:WebSocket){
    ws.send("#0")
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // change 2 to desired number of seconds
        // Your code with delay
        ws.send("#3ff")
    }
    
}

func echoTest(){
    var messageNum = 0
    let ws = WebSocket("ws://phlagg.freeddns.org:443")
    let send : ()->() = {
        messageNum += 1
        let msg = "\(messageNum): \(NSDate().description)"
        print("send: \(msg)")
        ws.send(msg)
    }
    ws.event.open = {
        print("opened")
        send()
    }
    ws.event.close = { code, reason, clean in
        print("close")
    }
    ws.event.error = { error in
        print("error \(error)")
    }
    ws.event.message = { message in
        if let text = message as? String {
            print("recv: \(text)")
            if messageNum == 10 {
                ws.close()
            } else {
                send()
            }
        }
    }
}
