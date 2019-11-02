import Foundation
import GoogleCloudKit

public struct PubSubConfiguration: GoogleCloudAPIConfiguration {
    public let scope: [GoogleCloudAPIScope]
    public let serviceAccount: String
    public let project: String?

    public init(scope: [PubSubAPIScope], serviceAccount: String, project: String? = nil) {
        self.scope = scope
        self.serviceAccount = serviceAccount
        self.project = project
    }
}

public enum PubSubAPIScope: GoogleCloudAPIScope {
    case cloudPlatform
    case cloudPlatformReadOnly
    case fullControl
    case readOnly
    case readWrite

    public var value: String {
        switch self {
        case .cloudPlatform: return "https://www.googleapis.com/auth/cloud-platform"
        case .cloudPlatformReadOnly: return "https://www.googleapis.com/auth/cloud-platform.read-only"
        case .fullControl: return "https://www.googleapis.com/auth/pubsub"
        case .readOnly: return "https://www.googleapis.com/auth/pubsub.read_only"
        case .readWrite: return "https://www.googleapis.com/auth/pubsub.read_write"
        }
    }
}
