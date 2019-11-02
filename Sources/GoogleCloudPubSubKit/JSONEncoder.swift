import Foundation

extension JSONEncoder {
    static let `default`: JSONEncoder = {
        var encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(.iso8601)
        return encoder
    }()
}
