//
//  SoundListTableViewController.swift
//  iOSSystemSoundsLibrary
//
//  Created by nyg on 27.06.17.
//  Copyright © 2017 nyg. All rights reserved.
//

import UIKit
import AVFoundation

class SoundListTableViewController: UITableViewController, UISearchBarDelegate {

    typealias Sound = (SystemSoundID, String)

    var fullAudioFileList = [Sound]()
    var filteredAudioFileList: [Sound]?

    var audioFileList: [Sound] {
        return filteredAudioFileList ?? fullAudioFileList
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadAudioFileList()
    }

    // MARK: Search bar delegate

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText.isEmpty {
            filteredAudioFileList = nil
        }
        else {
            filteredAudioFileList = fullAudioFileList.filter {
                $0.1.localizedCaseInsensitiveContains(searchText)
            }
        }

        tableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        filteredAudioFileList = nil
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    // MARK: Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioFileList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "systemSoundCell", for: indexPath) as? SoundTableViewCell
            else { fatalError("Could not dequeue SoundTableViewCell instance.") }

        cell.nameLabel.text = audioFileList[indexPath.row].1
        cell.identifierLabel.text = audioFileList[indexPath.row].0.description
        return cell
    }

    // MARK: Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AudioServicesPlaySystemSound(audioFileList[indexPath.row].0)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: Private methods

    private func loadAudioFileList() {

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

                    var soundId: SystemSoundID = 0
                    if kAudioServicesNoError == AudioServicesCreateSystemSoundID(url as NSURL, &soundId) {
                        fullAudioFileList.append(Sound(soundId, url.lastPathComponent))
                        print("\(soundId): \(url)")
                    }
                }
            }
            catch {
                fatalError("Error getting resource values for URL.")
            }
        }
    }
}
