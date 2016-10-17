//
//  NumeralKeyboard.swift
//  SplitKeys
//
//  Created by Jason Lam on 10/16/16.
//  Copyright © 2016 SplitKeys. All rights reserved.
//

import UIKit

class NumeralKeyboard: SingleKeyboard
{
    var charSet: [Character] = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

    private var counter = 0;
    private var timer:Timer? = nil;
    private var waitInterval = 3.0
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.label.text = "\(counter)"
        tapGestureRecognizer.addTarget(self, action: #selector(self.TapNumeralKeyboard(sender:)))
        longPressGestureRecognizer.addTarget(self, action: #selector(self.SelectZero(sender:)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func TapNumeralKeyboard(sender: UITapGestureRecognizer)
    {
        self.label.text = "\(counter)"
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(timeInterval: waitInterval, target: self, selector: #selector(ResetKeyboard), userInfo: nil, repeats: false)
        if (counter + 1 > 9)
        {
            counter = 1
        }
        else
        {
            counter += 1
        }
        self.label.text = "\(counter)"
    }
    
    func SelectZero(sender: UILongPressGestureRecognizer)
    {
        if sender.state == .began
        {
            timer?.invalidate()
            delegate?.didSelect(char: "0")
            counter = 0
            self.label.text = "\(counter)"
        }
    }
    
    func ResetKeyboard()
    {
        delegate?.didSelect(char: charSet[counter - 1])
        counter = 0
        self.label.text = "\(counter)"
    }
}
