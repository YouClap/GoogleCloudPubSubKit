import Foundation
import GoogleCloudKit
import NIO
import NIOHTTP1

private enum Constants {
    static let hostname = "https://pubsub.googleapis.com"
}

enum PubSubRequestError: GoogleCloudError {
    case failedToBuildURL
    case failedToBuildURLComponents(URL)
    case failedToBuildURLFromPathQueryItems(String, [URLQueryItem]?)
    case noResponseData
}

final public class PubSubRequest: GoogleCloudAPIRequest {
    public let refreshableToken: OAuthRefreshable
    public let project: String
    public let httpClient: HTTPClient
    public let responseDecoder: JSONDecoder

    public var currentToken: OAuthAccessToken?
    public var tokenCreatedTime: Date?

    public let eventLoop: EventLoop

    private let requestEncoder: JSONEncoder

    public init(httpClient: HTTPClient,
                refreshableToken: OAuthRefreshable,
                project: String,
                eventLoop: EventLoop) {
        self.httpClient = httpClient
        self.refreshableToken = refreshableToken
        self.project = project
        self.eventLoop = eventLoop

        self.requestEncoder = JSONEncoder.default
        self.responseDecoder = JSONDecoder.default
    }

    public func send<RequestModel: GoogleCloudModelEncodable, ResponseModel: GoogleCloudModelDecodable>(
        method: HTTPMethod,
        headers: HTTPHeaders = [:],
        path: String,
        queryItems: [URLQueryItem]? =  nil,
        body: RequestModel) -> EventLoopFuture<ResponseModel> {

        return withToken { token in
            let bodyData = try self.requestEncoder.encode(body)

            return try self
                ._send(method: method,
                       headers: headers,
                       path: path,
                       queryItems: queryItems,
                       body: bodyData,
                       token: token.accessToken)
                .map { data in
                    let responseModel = try self.responseDecoder.decode(ResponseModel.self, from: data)

                    return responseModel
                }
        }
    }

    private func _send(method: HTTPMethod,
                      headers: HTTPHeaders,
                      path: String,
                      queryItems: [URLQueryItem]?,
                      body: Data,
                      token: String) throws -> EventLoopFuture<Data> {

        var _headers: HTTPHeaders = ["Authorization": "Bearer \(token)",
                                     "Content-Type": "application/json"]
        headers.forEach { _headers.replaceOrAdd(name: $0.name, value: $0.value) }

        guard let url = URL(string: Constants.hostname) else {
            throw PubSubRequestError.failedToBuildURL
        }

        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw PubSubRequestError.failedToBuildURLComponents(url)
        }

        urlComponents.path += path

        urlComponents.queryItems = urlComponents.queryItems.flatMap { items in queryItems.flatMap { items + $0 } }

        guard let fullURL = urlComponents.url else {
            throw PubSubRequestError.failedToBuildURLFromPathQueryItems(path, queryItems)
        }

        let request = HTTPRequest(method: method, url: fullURL, headers: _headers, body: body)

        return httpClient.send(request: request).map { response in
            guard response.status == .ok, let data = response.body else {
                throw PubSubRequestError.noResponseData
            }

            return data
        }
    }
}
