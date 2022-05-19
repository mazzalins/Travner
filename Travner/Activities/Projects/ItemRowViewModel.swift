//
//  ItemRowViewModel.swift
//  Travner
//
//  Created by Lorenzo Lins Mazzarotto on 02/05/22.
//

import Foundation

extension ItemRowView {
    class ViewModel: ObservableObject {
        let guide: Guide
        let item: Item

        var title: String {
            item.itemTitle
        }

        var icon: String {
            if item.completed {
                return "checkmark.circle"
            } else if item.priority == 3 {
                return "exclamationmark.triangle"
            } else {
                return "checkmark.circle"
            }
        }

        var color: String? {
            if item.completed {
                return guide.guideColor
            } else if item.priority == 3 {
                return guide.guideColor
            } else {
                return nil
            }
        }

        var label: String {
            if item.completed {
                return "\(item.itemTitle), completed."
            } else if item.priority == 3 {
                return "\(item.itemTitle), high priority."
            } else {
                return item.itemTitle
            }
        }

        init(guide: Guide, item: Item) {
            self.guide = guide
            self.item = item
        }
    }
}
