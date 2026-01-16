//
//  PostScreenViewModel.swift
//  PostsMedia
//
//  Created by Bruno Carvalho on 16/01/26.
//

import Foundation
import Combine
import Testing
import SwiftData
@testable import PostsMedia

@Suite("Post screen view model Tests", .serialized)
@MainActor
struct PostScreenViewModelTests {
    var vm: PostScreenViewModel
    var service: PostsDataService
    var context: ModelContext
    
    init() throws{
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockUrlProtocol.self]
        let mockSession = URLSession(configuration: config)
        self.service = PostsDataService(urlSession: mockSession)
        
        let dbConfig = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: SaveDataModel.self, configurations: dbConfig)
        self.context = ModelContext(container)
        
        self.vm = PostScreenViewModel(postService: service)
    }
    
    private func mockComments() -> [PostCommentModel]{
        let json = """
        [
          {
            "postId": 1,
            "id": 1,
            "name": "id labore ex et quam laborum",
            "email": "Eliseo@gardner.biz",
            "body": "laudantium enim quasi est quidem magnam voluptate ipsam eos\ntempora quo necessitatibus\ndolor quam autem quasi\nreiciendis et nam sapiente accusantium"
          },
          {
            "postId": 1,
            "id": 2,
            "name": "quo vero reiciendis velit similique earum",
            "email": "Jayne_Kuhic@sydney.com",
            "body": "est natus enim nihil est dolore omnis voluptatem numquam\net omnis occaecati quod ullam at\nvoluptatem error expedita pariatur\nnihil sint nostrum voluptatem reiciendis et"
          },
          {
            "postId": 1,
            "id": 3,
            "name": "odio adipisci rerum aut animi",
            "email": "Nikita@garfield.biz",
            "body": "quia molestiae reprehenderit quasi aspernatur\naut expedita occaecati aliquam eveniet laudantium\nomnis quibusdam delectus saepe quia accusamus maiores nam est\ncum et ducimus et vero voluptates excepturi deleniti ratione"
          },
          {
            "postId": 1,
            "id": 4,
            "name": "alias odio sit",
            "email": "Lew@alysha.tv",
            "body": "non et atque\noccaecati deserunt quas accusantium unde odit nobis qui voluptatem\nquia voluptas consequuntur itaque dolor\net qui rerum deleniti ut occaecati"
          },
          {
            "postId": 1,
            "id": 5,
            "name": "vero eaque aliquid doloribus et culpa",
            "email": "Hayden@althea.biz",
            "body": "harum non quasi et ratione\ntempore iure ex voluptates in ratione\nharum architecto fugit inventore cupiditate\nvoluptates magni quo et"
          },
          {
            "postId": 2,
            "id": 6,
            "name": "et fugit eligendi deleniti quidem qui sint nihil autem",
            "email": "Presley.Mueller@myrl.com",
            "body": "doloribus at sed quis culpa deserunt consectetur qui praesentium\naccusamus fugiat dicta\nvoluptatem rerum ut voluptate autem\nvoluptatem repellendus aspernatur dolorem in"
          },
          {
            "postId": 2,
            "id": 7,
            "name": "repellat consequatur praesentium vel minus molestias voluptatum",
            "email": "Dallas@ole.me",
            "body": "maiores sed dolores similique labore et inventore et\nquasi temporibus esse sunt id et\neos voluptatem aliquam\naliquid ratione corporis molestiae mollitia quia et magnam dolor"
          },
          {
            "postId": 2,
            "id": 8,
            "name": "et omnis dolorem",
            "email": "Mallory_Kunze@marie.org",
            "body": "ut voluptatem corrupti velit\nad voluptatem maiores\net nisi velit vero accusamus maiores\nvoluptates quia aliquid ullam eaque"
          },
          {
            "postId": 2,
            "id": 9,
            "name": "provident id voluptas",
            "email": "Meghan_Littel@rene.us",
            "body": "sapiente assumenda molestiae atque\nadipisci laborum distinctio aperiam et ab ut omnis\net occaecati aspernatur odit sit rem expedita\nquas enim ipsam minus"
          },
          {
            "postId": 2,
            "id": 10,
            "name": "eaque et deleniti atque tenetur ut quo ut",
            "email": "Carmen_Keeling@caroline.name",
            "body": "voluptate iusto quis nobis reprehenderit ipsum amet nulla\nquia quas dolores velit et non\naut quia necessitatibus\nnostrum quaerat nulla et accusamus nisi facilis"
          }
        ]
        """
        do {
            guard let commentsJson = json.data(using: .utf8) else { return [] }
            return try JSONDecoder().decode([PostCommentModel].self, from: commentsJson)
        } catch let error{
            print("Error: \(error)")
            return []
        }
    }
    private func mockJson() throws -> Data {
        guard let json = """
        [
              {
                "postId": 1,
                "id": 1,
                "name": "id labore ex et quam laborum",
                "email": "Eliseo@gardner.biz",
                "body": "laudantium enim quasi est quidem magnam voluptate ipsam eos\\ntempora quo necessitatibus\\ndolor quam autem quasi\\nreiciendis et nam sapiente accusantium"
              },
              {
                "postId": 1,
                "id": 2,
                "name": "quo vero reiciendis velit similique earum",
                "email": "Jayne_Kuhic@sydney.com",
                "body": "est natus enim nihil est dolore omnis voluptatem numquam\\net omnis occaecati quod ullam at\\nvoluptatem error expedita pariatur\\nnihil sint nostrum voluptatem reiciendis et"
              },
              {
                "postId": 1,
                "id": 3,
                "name": "odio adipisci rerum aut animi",
                "email": "Nikita@garfield.biz",
                "body": "quia molestiae reprehenderit quasi aspernatur\\naut expedita occaecati aliquam eveniet laudantium\\nomnis quibusdam delectus saepe quia accusamus maiores nam est\\ncum et ducimus et vero voluptates excepturi deleniti ratione"
              },
              {
                "postId": 1,
                "id": 4,
                "name": "alias odio sit",
                "email": "Lew@alysha.tv",
                "body": "non et atque\\noccaecati deserunt quas accusantium unde odit nobis qui voluptatem\\nquia voluptas consequuntur itaque dolor\\net qui rerum deleniti ut occaecati"
              },
              {
                "postId": 1,
                "id": 5,
                "name": "vero eaque aliquid doloribus et culpa",
                "email": "Hayden@althea.biz",
                "body": "harum non quasi et ratione\\ntempore iure ex voluptates in ratione\\nharum architecto fugit inventore cupiditate\\nvoluptates magni quo et"
              },
              {
                "postId": 2,
                "id": 6,
                "name": "et fugit eligendi deleniti quidem qui sint nihil autem",
                "email": "Presley.Mueller@myrl.com",
                "body": "doloribus at sed quis culpa deserunt consectetur qui praesentium\\naccusamus fugiat dicta\\nvoluptatem rerum ut voluptate autem\\nvoluptatem repellendus aspernatur dolorem in"
              },
              {
                "postId": 2,
                "id": 7,
                "name": "repellat consequatur praesentium vel minus molestias voluptatum",
                "email": "Dallas@ole.me",
                "body": "maiores sed dolores similique labore et inventore et\\nquasi temporibus esse sunt id et\\neos voluptatem aliquam\\naliquid ratione corporis molestiae mollitia quia et magnam dolor"
              },
              {
                "postId": 2,
                "id": 8,
                "name": "et omnis dolorem",
                "email": "Mallory_Kunze@marie.org",
                "body": "ut voluptatem corrupti velit\\nad voluptatem maiores\\net nisi velit vero accusamus maiores\\nvoluptates quia aliquid ullam eaque"
              },
              {
                "postId": 2,
                "id": 9,
                "name": "provident id voluptas",
                "email": "Meghan_Littel@rene.us",
                "body": "sapiente assumenda molestiae atque\\nadipisci laborum distinctio aperiam et ab ut omnis\\net occaecati aspernatur odit sit rem expedita\\nquas enim ipsam minus"
              },
              {
                "postId": 2,
                "id": 10,
                "name": "eaque et deleniti atque tenetur ut quo ut",
                "email": "Carmen_Keeling@caroline.name",
                "body": "voluptate iusto quis nobis reprehenderit ipsum amet nulla\\nquia quas dolores velit et non\\naut quia necessitatibus\\nnostrum quaerat nulla et accusamus nisi facilis"
              }
            ]
        """.data(using: .utf8)
        else { throw URLError(.cannotDecodeContentData) }
        
        return json
    }
    
    @Test("Should format string to share")
    func testShareTextLogic(){
        let post = PostHomePageModel(id: 1, username: "Bruno", userTag: "@dev", imageName: "img", post: .init(userId: 1, id: 1, title: "Title", body: "Completed Body"))
        let texto = vm.getTextToShare(post: post)
        
        #expect(texto.contains("Bruno"))
        #expect(texto.contains("Title"))
        #expect(texto.contains("Completed Body"))
    }
    
    @Test("Should published the comments")
    func testGetComments() async throws {
        MockUrlProtocol.requestHandler = { req in
            guard let url = req.url else { throw URLError(.badURL) }
            
            guard let response = HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
            else { throw URLError(.badServerResponse) }
            
            return (response, try mockJson())
        }
        
        vm.getComments(forPostId: 1)
        try await Task.sleep(nanoseconds: 100_000_000)
        
        #expect(vm.postComments.first?.postId == 1)
        #expect(vm.postComments.first?.id == 1)
        #expect(vm.postComments.first?.email == "Eliseo@gardner.biz")
        #expect(vm.postComments.count == 10)
        
    }
    
    @Test("Should save and remove from database")
    func testToggleSaver() throws {
        let post = PostHomePageModel(id: 50, username: "User", userTag: "@u", imageName: "img", post: .init(userId: 50, id: 50, title: "Title", body: "Body"))
        
        vm.setupDatabase(context: context, postId: 50)
        #expect(vm.isSaved == false)
        
        vm.toggleSaveStatus(post: post)
        #expect(vm.isSaved, "The flag should be true after saving")
        
        let descriptor = FetchDescriptor<SaveDataModel>(predicate: #Predicate{$0.id == 50})
        let itens = try context.fetch(descriptor)
        #expect(itens.count == 1, "Should had be 1 item in database")
        
        vm.toggleSaveStatus(post: post)
        #expect(vm.isSaved == false, "Thew flag should be false whenm remove itens from database")
        
        let itensRemoved = try context.fetch(descriptor)
        #expect(itensRemoved.isEmpty, "Should be not have items in database anymore")
    }
}
