import Foundation
import GoogleCloudKit
import NIO

public enum PublisherClientError: GoogleCloudError {
    case missingProjectID
}

public final class PublisherClient {
    private let googleConfiguration: GoogleCloudCredentialsConfiguration
    private let pubSubConfiguration: PubSubConfiguration
    private let request: PubSubRequest
    private let eventLoop: EventLoop

    public let project: String

    public init(googleConfiguration: GoogleCloudCredentialsConfiguration,
                pubSubConfiguration: PubSubConfiguration,
                request: PubSubRequest,
                project: String,
                eventLoop: EventLoop) {
        self.googleConfiguration = googleConfiguration
        self.pubSubConfiguration = pubSubConfiguration
        self.request = request
        self.project = project
        self.eventLoop = eventLoop
    }
}

extension PublisherClient {
    public static func client(configuration: GoogleCloudCredentialsConfiguration,
                              pubSubConfiguration: PubSubConfiguration,
                              eventLoop: EventLoop) throws -> PublisherClient {

        let httpClient = HTTPClient.default(with: eventLoop)

        let refreshableToken = try OAuthCredentialLoader.getRefreshableToken(
            credentialFilePath: configuration.serviceAccountCredentialsPath,
            config: pubSubConfiguration,
            client: httpClient,
            eventLoop: eventLoop)

        guard let project = ProcessInfo.processInfo.environment["PROJECT_ID"]
            ?? (refreshableToken as? OAuthServiceAccount)?.credentials.projectId
            ?? pubSubConfiguration.project ?? configuration.project
        else {
            throw PublisherClientError.missingProjectID
        }

        let request = PubSubRequest(httpClient: httpClient,
                                    refreshableToken: refreshableToken,
                                    project: project,
                                    eventLoop: eventLoop)

        return PublisherClient(googleConfiguration: configuration,
                               pubSubConfiguration: pubSubConfiguration,
                               request: request,
                               project: project,
                               eventLoop: eventLoop)
    }
}

extension PublisherClient {
    public func publish<Model: GoogleCloudModelEncodable>(messages models: Model ..., to topic: ProjectTopic)
    -> EventLoopFuture<PublishResponse> {
        let path = "/v1\(topic.path):publish"

        let messageModels = models.map { PubSubMessage(data: $0) }
        let messages = PubSubMessages(messages: messageModels)

        return request.send(method: .POST, path: path, body: messages)
    }
}
