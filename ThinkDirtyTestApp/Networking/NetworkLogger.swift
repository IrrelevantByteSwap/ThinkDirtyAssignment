import Foundation
import os.log

private let ReqresRequestHandledKey = "RequestHandledKey"
private let ReqresRequestTimeKey = "RequestTimeKey"

class NetworkLogger: URLProtocol, URLSessionDelegate {
    var dataTask: URLSessionDataTask?
    var newRequest: NSMutableURLRequest?
    static var sessionDelegate: URLSessionDelegate?
    static var allowUTF8Emoji: Bool = true
    static var logger: ReqresLogging = ReqresDefaultLogger()
    
    class func register() {
        URLProtocol.registerClass(self)
    }
    class func unregister() {
        URLProtocol.unregisterClass(self)
    }
    
    class func defaultSessionConfiguration() -> URLSessionConfiguration {
        let config = URLSessionConfiguration.default
        config.protocolClasses?.insert(NetworkLogger.self, at: 0)
        return config
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        guard property(forKey: ReqresRequestHandledKey, in: request) == nil && logger.logLevel != .none else {
            return false
        }
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        super.requestIsCacheEquivalent(a, to: b)
    }
    
    override func startLoading() {
        guard let req = (request as NSURLRequest).mutableCopy() as? NSMutableURLRequest, newRequest == nil else { return }
        
        newRequest = req
        
        URLProtocol.setProperty(true, forKey: ReqresRequestHandledKey, in: newRequest!)
        URLProtocol.setProperty(Date(), forKey: ReqresRequestTimeKey, in: newRequest!)
        
        let session = URLSession(configuration: .default, delegate: NetworkLogger.sessionDelegate ?? self, delegateQueue: nil)
        dataTask = session.dataTask(with: request) { [weak self] data, response, error in
            guard let `self` = self else { return }
            
            if let error = error {
                self.client?.urlProtocol(self, didFailWithError: error)
                self.logError(self.request, error: error as NSError)
                
                return
            }
            
            guard let response = response, let data = data else { return }
            
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowed)
            self.client?.urlProtocol(self, didLoad: data)
            self.client?.urlProtocolDidFinishLoading(self)
            self.logResponse(response, method: nil, data: data)
        }
        dataTask?.resume()
        
        logRequest(newRequest! as URLRequest)
    }
    
    override func stopLoading() {
        dataTask?.cancel()
    }
    
    // MARK: - Logging
    
    static func formatError(_ request: URLRequest, error: NSError) -> String {
        var s = ""
        
        if NetworkLogger.allowUTF8Emoji {
            s += "⚠️ "
        }
        if let method = request.httpMethod {
            s += "\(method) "
        }
        if let url = request.url?.absoluteString {
            s += "\(url) "
        }
        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            s += "\n" + formatHeaders(headers as [String: AnyObject])
        }
        s += "\nBody: \(formatBody(request.httpBodyData))"
        s += "ERROR: \(error.localizedDescription)"
        if let reason = error.localizedFailureReason {
            s += "\nReason: \(reason)"
        }
        if let suggestion = error.localizedRecoverySuggestion {
            s += "\nSuggestion: \(suggestion)"
        }
        return s
    }
    
    func logError(_ request: URLRequest, error: NSError) {
        let s = NetworkLogger.formatError(request, error: error)
        NetworkLogger.logger.logError(s)
    }
    
    /// Format request to pretty printed string
    static func formatRequest(_ request: URLRequest, level: LogLevel) -> String {
        var s = ""
        if NetworkLogger.allowUTF8Emoji {
            s += "⬆️ "
        }
        if let method = request.httpMethod {
            s += "\(method) "
        }
        if let url = request.url?.absoluteString {
            s += "'\(url)' "
        }
        if level == .verbose {
            if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
                s += "\n" + formatHeaders(headers as [String: AnyObject])
            }
            s += "\nBody: \(formatBody(request.httpBodyData))"
        }
        return s
    }
    
    func logRequest(_ request: URLRequest) {
        
        let s = NetworkLogger.formatRequest(request, level: NetworkLogger.logger.logLevel)
        
        if NetworkLogger.logger.logLevel == .verbose {
            NetworkLogger.logger.logVerbose(s)
        } else {
            NetworkLogger.logger.logLight(s)
        }
    }
    
    /// Format response to pretty printed string
    static func formatResponse(_ response: URLResponse, request: URLRequest?, method: String?, data: Data? = nil, level: LogLevel) -> String {
        var s = ""
        
        if NetworkLogger.allowUTF8Emoji {
            s += "⬇️ "
        }
        if let method = method {
            s += "\(method)"
        } else if let method = request?.httpMethod {
            s += "\(method) "
        }
        if let url = response.url?.absoluteString {
            s += "'\(url)' "
        }
        if let httpResponse = response as? HTTPURLResponse {
            s += "("
            if NetworkLogger.allowUTF8Emoji {
                let iconNumber = Int(floor(Double(httpResponse.statusCode) / 100.0))
                if let iconString = statusIcons[iconNumber] {
                    s += "\(iconString) "
                }
            }
            s += "\(httpResponse.statusCode)"
            if let statusString = statusStrings[httpResponse.statusCode] {
                s += " \(statusString)"
            }
            s += ")"
            if let startDate = request.flatMap({ URLProtocol.property(forKey: ReqresRequestTimeKey, in: $0) }) as? Date {
                let difference = fabs(startDate.timeIntervalSinceNow)
                s += String(format: " [time: %.5f s]", difference)
            }
        }
        if level == .verbose {
            
            if let headers = (response as? HTTPURLResponse)?.allHeaderFields as? [String: AnyObject], !headers.isEmpty {
                s += "\n" + formatHeaders(headers)
            }
            
            s += "\nBody: \(formatBody(data))"
        }
        return s
    }
    
    func logResponse(_ response: URLResponse, method: String?, data: Data? = nil) {
        
        let s = NetworkLogger.formatResponse(response, request: newRequest as URLRequest?, method: method, data: data, level: NetworkLogger.logger.logLevel)
        
        if NetworkLogger.logger.logLevel == .verbose {
            NetworkLogger.logger.logVerbose(s)
        } else {
            NetworkLogger.logger.logLight(s)
        }
    }
    
    /// Format headers dictionary to pretty printed string
    static func formatHeaders(_ headers: [String: AnyObject]) -> String {
        var s = "Headers: [\n"
        for (key, value) in headers {
            s += "\t\(key) : \(value)\n"
        }
        s += "]"
        return s
    }
    
    @available(*, deprecated, message: "Use Reqres.formatHeaders() instead")
    func logHeaders(_ headers: [String: AnyObject]) -> String {
        NetworkLogger.formatHeaders(headers)
    }
    
    /// Format data from body to pretty printed string
    static func formatBody(_ body: Data?) -> String {
        if let body = body {
            if let json = try? JSONSerialization.jsonObject(with: body, options: .mutableContainers),
               let pretty = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
               let string = String(data: pretty, encoding: String.Encoding.utf8) {
                return string
            } else if let string = String(data: body, encoding: String.Encoding.utf8) {
                return string
            } else {
                return body.description
            }
        } else {
            return "nil"
        }
    }
    
    @available(*, deprecated, message: "Use Reqres.formatBody() instead")
    func bodyString(_ body: Data?) -> String {
        NetworkLogger.formatBody(body)
    }
}

private let statusIcons = [
    1: "ℹ️",
    2: "✅",
    3: "⤴️",
    4: "⛔️",
    5: "❌",
]

private let statusStrings = [
    // 1xx (Informational)
    100: "Continue",
    101: "Switching Protocols",
    102: "Processing",
    
    // 2xx (Success)
    200: "OK",
    201: "Created",
    202: "Accepted",
    203: "Non-Authoritative Information",
    204: "No Content",
    205: "Reset Content",
    206: "Partial Content",
    207: "Multi-Status",
    208: "Already Reported",
    226: "IM Used",
    
    // 3xx (Redirection)
    300: "Multiple Choices",
    301: "Moved Permanently",
    302: "Found",
    303: "See Other",
    304: "Not Modified",
    305: "Use Proxy",
    306: "Switch Proxy",
    307: "Temporary Redirect",
    308: "Permanent Redirect",
    
    // 4xx (Client Error)
    400: "Bad Request",
    401: "Unauthorized",
    402: "Payment Required",
    403: "Forbidden",
    404: "Not Found",
    405: "Method Not Allowed",
    406: "Not Acceptable",
    407: "Proxy Authentication Required",
    408: "Request Timeout",
    409: "Conflict",
    410: "Gone",
    411: "Length Required",
    412: "Precondition Failed",
    413: "Request Entity Too Large",
    414: "Request-URI Too Long",
    415: "Unsupported Media Type",
    416: "Requested Range Not Satisfiable",
    417: "Expectation Failed",
    418: "I'm a teapot",
    420: "Enhance Your Calm",
    422: "Unprocessable Entity",
    423: "Locked",
    424: "Method Failure",
    425: "Unordered Collection",
    426: "Upgrade Required",
    428: "Precondition Required",
    429: "Too Many Requests",
    431: "Request Header Fields Too Large",
    451: "Unavailable For Legal Reasons",
    
    // 5xx (Server Error)
    500: "Internal Server Error",
    501: "Not Implemented",
    502: "Bad Gateway",
    503: "Service Unavailable",
    504: "Gateway Timeout",
    505: "HTTP Version Not Supported",
    506: "Variant Also Negotiates",
    507: "Insufficient Storage",
    508: "Loop Detected",
    509: "Bandwidth Limit Exceeded",
    510: "Not Extended",
    511: "Network Authentication Required",
]

class ReqresDefaultLogger: ReqresLogging {
    
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "YYYY-MM-dd HH:mm:ss.SSS"
        return df
    }()
    
    var logLevel: LogLevel = .verbose
    
    init() {
        
    }
    
    func logVerbose(_ message: String) {
        logMessage(message)
    }
    
    func logLight(_ message: String) {
        logMessage(message)
    }
    
    func logError(_ message: String) {
        logMessage(message)
    }
    
    private func logMessage(_ message: String) {
        print("[" + dateFormatter.string(from: Date()) + "] " + message)
    }
}

class ReqresDefaultNSLogger: ReqresLogging {
    
    var logLevel: LogLevel = .verbose
    
    // It is not advised to wrap os_log, but we are basically wrapping it here anyway, so it should not matter
    private enum MessageType {
        case debug, error
    }
    
    private func logMessage(_ message: String, type: MessageType) {
        let osLogType: OSLogType = type == .debug ? .info : .error
        let networkingLogger = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "-", category: "Networking")
        os_log("%{private}@", log: networkingLogger, type: osLogType, message)
    }
    
    init() {
        
    }
    
    func logVerbose(_ message: String) {
        logMessage(message, type: .debug)
    }
    
    func logLight(_ message: String) {
        logMessage(message, type: .debug)
    }
    
    func logError(_ message: String) {
        logMessage(message, type: .error)
    }
}

enum LogLevel {
    case none
    case light
    case verbose
}

protocol ReqresLogging {
    var logLevel: LogLevel { get set }
    
    func logVerbose(_ message: String)
    func logLight(_ message: String)
    func logError(_ message: String)
}

extension URLRequest {
    var httpBodyData: Data? {

        guard let stream = httpBodyStream else {
            return httpBody
        }

        let data = NSMutableData()
        stream.open()
        let bufferSize = 4_096
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        while stream.hasBytesAvailable {
            let bytesRead = stream.read(buffer, maxLength: bufferSize)
            if bytesRead > 0 {
                let readData = Data(bytes: UnsafePointer<UInt8>(buffer), count: bytesRead)
                data.append(readData)
            } else if bytesRead < 0 {
                print("error occured while reading HTTPBodyStream: \(bytesRead)")
            } else {
                break
            }
        }
        stream.close()
        return data as Data
    }
}
