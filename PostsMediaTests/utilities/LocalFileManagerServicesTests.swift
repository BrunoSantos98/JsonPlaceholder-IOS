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
        let uniqueName = UUID().uuidString
        guard let testImage = UIImage(systemName: testImageName) else { throw Err.imageNotFound }
        let responseSave = service.saveImage(image: testImage, name: uniqueName)
        
        #expect(responseSave == "Image saved successfully")
    }
    
    @Test("Should overwrite saved image")
    func overwriteImageTest() async throws {
        let heartName = UUID().uuidString
        guard let heartImage = UIImage(systemName: testImageName) else { throw Err.imageNotFound }
        _ = service.saveImage(image: heartImage, name: heartName)
        
        let secondImageName = "star.fill"
        guard let starImage = UIImage(systemName: secondImageName) else { throw Err.imageNotFound }
        let _ = service.saveImage(image: starImage, name: heartName)
        
        let retrivedStarImage = service.getImage(imageName: heartName)?.pngData()
        
        #expect(retrivedStarImage != heartImage.pngData())
    }
    
    @Test("Should get saved image")
    func getImageTest() async throws {
        let uniqueName = UUID().uuidString
        guard let testImage = UIImage(systemName: testImageName) else { throw Err.imageNotFound }
        _ = service.saveImage(image: testImage, name: uniqueName)
        let retrievedImage = service.getImage(imageName: uniqueName)
        
        #expect(retrievedImage != nil)
    }
    
    @Test("Should delete saved image")
    func deleteImageTest() async throws {
        let uniqueName = UUID().uuidString
        guard let testImage = UIImage(systemName: testImageName) else { throw Err.imageNotFound }
        _ = service.saveImage(image: testImage, name: uniqueName)
        
        let response = service.deleteImage(imageName: uniqueName)
        let deletedImage = service.getImage(imageName: uniqueName)
        
        #expect(response == "Successfully deleted")
        #expect(deletedImage == nil)
    }
    
    @Test("Should return error when not found image")
    func tryDeleteNonExistentImageTest() async throws {
        let response = service.deleteImage(imageName: "notFoundImage")
        
        #expect(response == "Image not found")
    }
    
    @Test("Should load image")
    func loadImageTest() async throws {
        let uniqueName = UUID().uuidString
        guard let testImage = UIImage(systemName: testImageName) else { throw Err.imageNotFound }
        _ = service.saveImage(image: testImage, name: uniqueName)
        
        let savedImage = service.loadImage(imageName: uniqueName)
        let inexistentImage = service.loadImage(imageName: "notAnImage").pngData()
        
        #expect(savedImage.pngData()?.count == testImage.pngData()?.count)
        #expect(inexistentImage != savedImage.pngData())
    }
    
    @Test("Should write multiple data concurrent")
    func concurrentWritesTest() async throws {
        guard let testImage = UIImage(systemName: testImageName) else { throw Err.imageNotFound }
        
        await withTaskGroup(of: Void.self) { group in
            for i in 0..<50{
                group.addTask {
                    let result = service.saveImage(image: testImage, name: "Concurrents_\(i+1)")
                    
                    #expect(result == "Image saved successfully")
                }
            }
        }
        
        for i in 0..<50{
            let savedImage = service.getImage(imageName: "Concurrents_\(i+1)")
            #expect(savedImage != nil)
        }
    }
    
    @Test("Should be fast to read images", .timeLimit(.minutes(1)))
    func performanceReadingTest() async throws {
        guard let testImage = UIImage(systemName: testImageName) else { throw Err.imageNotFound }
        let clock = ContinuousClock()
        
        let measureTimeToSave = clock.measure {
            for i in 0..<100{
                _ = service.saveImage(image: testImage, name: "Perf_\(i)")
            }
        }
        
        let measureTimeToGet = clock.measure {
            for i in 0..<100{
                let savedImage = service.loadImage(imageName: "Perf_\(i)")
                #expect(savedImage.pngData()?.count == testImage.pngData()?.count)
            }
        }
        
        #expect(measureTimeToSave + measureTimeToGet < .seconds(3))
    }
}
