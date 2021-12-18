//
//  JournalTableViewCell.swift
//  JournalApp-1.0
//
//  Created by STEPHENCOFFARO on 12/8/21.
//

import UIKit

class JournalTableViewCell: UITableViewCell {
    
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var entryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(with journalEntry: JournalEntry) {
        monthLabel.text = journalEntry.loggedTime.monthAbv
        dayLabel.text = String(journalEntry.loggedTime.day)
        timeLabel.text = String(journalEntry.loggedTime.time)
        titleLabel.text = journalEntry.subject
        entryLabel.text = journalEntry.content
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
