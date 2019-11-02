import Foundation

struct PubSubMessages<Model: Encodable> {
    let messages: [PubSubMessage<Model>]
}

extension PubSubMessages: Encodable {}
