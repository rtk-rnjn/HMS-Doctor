//
//  AnnouncementHostingController.swift
//  HMS-Doctor
//
//  Created by RITIK RANJAN on 31/03/25.
//

import SwiftUI

class AnnouncementHostingController: UIHostingController<AnnouncementView> {

    // MARK: Lifecycle

    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: AnnouncementView())
    }

    // MARK: Internal

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        Task {
            if let announcements = await DataController.shared.fetchAnnouncements() {
                rootView.announcements = announcements
            }
        }
    }
}
