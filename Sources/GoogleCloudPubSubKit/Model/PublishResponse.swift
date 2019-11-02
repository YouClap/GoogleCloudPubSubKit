import Foundation
import GoogleCloudKit

public struct PublishResponse {
    public let messageIds: [String]
}

extension PublishResponse: GoogleCloudModel {}
