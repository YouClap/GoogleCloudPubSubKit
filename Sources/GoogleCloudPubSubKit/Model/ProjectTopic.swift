import Foundation

public struct ProjectTopic {
    private static let PubSubPath = "/projects/%s/topics/%s"

    public let project: String
    public let name: String

    public init(project: String, name: String) {
        self.project = project
        self.name = name
    }
}

extension ProjectTopic {
    var path: String { "/projects/\(project)/topics/\(name)" }
}
