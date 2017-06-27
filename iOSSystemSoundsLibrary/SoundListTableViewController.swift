//
//  SoundListTableViewController.swift
//  iOSSystemSoundsLibrary
//
//  Created by nyg on 27.06.17.
//  Copyright © 2017 nyg. All rights reserved.
//

import UIKit
import AVFoundation

class SoundListTableViewController: UITableViewController {

    var audioFileList = [URL]()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadAudioFileList()
    }

    // MARK: Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioFileList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "systemSoundCell", for: indexPath)
        cell.textLabel?.text = audioFileList[indexPath.row].lastPathComponent
        return cell
    }

    // MARK: Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let systemSoundId = UnsafeMutablePointer<SystemSoundID>.allocate(capacity: 1)
        AudioServicesCreateSystemSoundID(audioFileList[indexPath.row] as NSURL, systemSoundId)
        AudioServicesPlaySystemSound(systemSoundId.pointee)

        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: Private methods

    func loadAudioFileList() {

        guard let url = URL(string: "/System/Library/Audio/UISounds") else {
            fatalError("Couldn't create URL.")
        }

        let key = URLResourceKey.isDirectoryKey

        guard let enumerator = FileManager.default.enumerator(at: url, includingPropertiesForKeys: [ key ]) else {
            fatalError("Couldn't create enunerator.")
        }

        for case let url as URL in enumerator {

            do {
                let resourceValues = try url.resourceValues(forKeys: [ key ])
                if resourceValues.isDirectory == false {
                    audioFileList.append(url)
                }
            }
            catch {
                fatalError("Error getting resource values for URL.")
            }
        }
    }
}
