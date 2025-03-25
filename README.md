This networking package uses the Builder concept to build out requests.  The requests are called Endpoints.

An Endpoint lets you build out any type of custom header that you would need. Lets you as a query, body.

It also alows for building the endpoint to be able to make a GraphQL query.

There is an async call that you can use to perform your requests.

Example:

```Swift
// MARK: - ViewModel
@MainActor
class ExampleViewModel: ObservableObject {
    private let networking: AsyncRequestProtocol
    
    @Published var data: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    init(networking: AsyncRequestProtocol = AsyncRequest()) {
        self.networking = networking
    }
    
    func fetchData() {
        isLoading = true
        errorMessage = nil

        // Use detached to avoid capturing self in a non-sendable context
        Task.detached(priority: .background) {
            await self.performRequest()
        }
    }
    
    private func performRequest() async {
        defer { Task { @MainActor in self.isLoading = false } }

        do {
            let result: ExampleResponse = try await networking.perform(endpoint: ExampleEndpoint(), decodeTo: ExampleResponse.self)
            Task { @MainActor in self.data = result.title }
        } catch {
            Task { @MainActor in self.errorMessage = error.localizedDescription }
        }
    }
}

// MARK: - Example Endpoint
struct ExampleEndpoint: Endpoint {
    func request() -> URLRequest? {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1") else { return nil }
        return URLRequest(url: url)
    }
}

// MARK: - Example Response Model
struct ExampleResponse: Codable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}
```
