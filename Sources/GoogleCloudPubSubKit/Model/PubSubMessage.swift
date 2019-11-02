import Foundation
import GoogleCloudKit

struct PubSubMessage<Model: Encodable> {
    let data: Model
    let attributes: [String : String]?

    public init(data: Model, attributes: [String : String]? = nil) {
        self.data = data
        self.attributes = attributes
    }
}

extension PubSubMessage: GoogleCloudModelEncodable {
    enum CodingKeys: String, CodingKey {
        case data
        case attributes
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(attributes, forKey: CodingKeys.attributes)

        let jsonEncoder = JSONEncoder.default
        let messageData = try jsonEncoder.encode(data)

        try container.encode(messageData.base64EncodedString(), forKey: .data)
    }
}
