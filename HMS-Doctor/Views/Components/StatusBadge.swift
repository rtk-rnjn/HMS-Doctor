import SwiftUI

struct StatusBadge: View {

    // MARK: Lifecycle

    init(status: Status, size: Size = .regular) {
        self.status = status
        self.size = size
    }

    // MARK: Internal

    enum Status {
        case active
        case inactive
        case onLeave
        case pending
        case completed
        case cancelled

        // MARK: Internal

        var title: String {
            switch self {
            case .active: return "Active"
            case .inactive: return "Inactive"
            case .onLeave: return "On Leave"
            case .pending: return "Pending"
            case .completed: return "Completed"
            case .cancelled: return "Cancelled"
            }
        }

        var colors: (background: Color, foreground: Color) {
            switch self {
            case .active:
                return (Color.green.opacity(0.15), .green)
            case .inactive, .cancelled:
                return (Color.red.opacity(0.15), .red)
            case .onLeave:
                return (Color.orange.opacity(0.15), .orange)
            case .pending:
                return (Color.blue.opacity(0.15), .blue)
            case .completed:
                return (Color.purple.opacity(0.15), .purple)
            }
        }
    }

    enum Size {
        case small
        case regular

        // MARK: Internal

        var font: Font {
            switch self {
            case .small: return .caption.weight(.medium)
            case .regular: return .footnote.weight(.medium)
            }
        }

        var padding: (h: CGFloat, v: CGFloat) {
            switch self {
            case .small: return (8, 4)
            case .regular: return (12, 6)
            }
        }
    }

    let status: Status
    let size: Size

    var body: some View {
        Text(status.title)
            .font(size.font)
            .padding(.horizontal, size.padding.h)
            .padding(.vertical, size.padding.v)
            .background(status.colors.background)
            .foregroundColor(status.colors.foreground)
            .cornerRadius(8)
    }
}
