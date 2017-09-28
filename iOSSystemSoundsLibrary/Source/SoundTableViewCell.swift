//
//  SoundTableViewCell.swift
//  iOSSystemSoundsLibrary
//
//  Created by user on 22.08.17.
//  Copyright © 2017 nyg. All rights reserved.
//

import UIKit

class SoundTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var identifierLabel: UILabel!

    @discardableResult
    func set(sound: Sound) -> UITableViewCell {
        nameLabel.text = sound.1
        identifierLabel.text = sound.0.description
        return self
    }
}
