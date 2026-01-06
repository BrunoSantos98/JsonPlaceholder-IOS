//
//  LocalFileManagerServicesTests.swift
//  PostsMedia
//
//  Created by Bruno Carvalho on 06/01/26.
//

import Testing
import SwiftUI
@testable import PostsMedia

@Suite("LocalFileManager Test Cases")
private struct LocalFileManagerServicesTests {
    
    let service = LocalFileManagerServices.instance
    let testImageName = "heart.fill"
    
    enum Err: Error{
        case imageNotFound
    }
    
    init(){
        _ = service.deleteImage(imageName: testImageName)
    }
    
    @Test("Should save image successfully")
    func saveImageTest() async throws {
        guard let testImage = UIImage(systemName: testImageName) else { throw Err.imageNotFound }
        let responseSave = service.saveImage(image: testImage, name: testImageName)
        
        #expect(responseSave == "Image saved successfully")
    }
    
    @Test("Should get saved image")
    func getImageTest() async throws {
        guard let testImage = UIImage(systemName: testImageName) else { throw Err.imageNotFound }
        _ = service.saveImage(image: testImage, name: testImageName)
        let retrievedImage = service.getImage(imageName: testImageName)
        
        #expect(retrievedImage != nil)
    }
    
    @Test("Should delete saved image")
    func deleteImageTest() async throws {
        guard let testImage = UIImage(systemName: testImageName) else { throw Err.imageNotFound }
        _ = service.saveImage(image: testImage, name: testImageName)
        let response = service.deleteImage(imageName: testImageName)
        
        #expect(response == "Successfully deleted")
        
        let deletedImage = service.getImage(imageName: testImageName)
        #expect(deletedImage == nil)
    }
    
    @Test("Should load image")
    func loadImageTest() async throws {
        guard let testImage = UIImage(systemName: testImageName) else { throw Err.imageNotFound }
        _ = service.saveImage(image: testImage, name: testImageName)
        let savedImage = service.loadImage(imageName: testImageName).pngData()
        let inexistentImage = service.loadImage(imageName: "notAnImage").pngData()

        #expect(savedImage != inexistentImage)
    }
}
