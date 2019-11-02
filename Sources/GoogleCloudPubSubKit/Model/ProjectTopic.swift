import Foundation

public struct ProjectTopic {
    private static let PubSubPath = "/projects/%@/topics/%@"

    public let project: String
    public let name: String

    public init(project: String, name: String) {
        self.project = project
        self.name = name
    }
}

extension ProjectTopic {
    var path: String { String(format: Self.PubSubPath, project, name) }
}
