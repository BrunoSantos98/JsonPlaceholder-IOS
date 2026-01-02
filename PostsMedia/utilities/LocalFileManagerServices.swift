//
//  LocalFileManagerServices.swift
//  PostsMedia
//
//  Created by Bruno Carvalho on 31/12/25.
//

import Foundation
import SwiftUI

class LocalFileManagerServices {
    static let instance = LocalFileManagerServices()
    private let imageFolderName = "JsonPlaceholderImages"
    
    private init() {
        createFolderIfNeeded()
    }
    
    //MARK: Folders Functions
    private func createFolderIfNeeded(){
        guard let path = getImageFolderPath() else{ return }
        
        if !FileManager.default.fileExists(atPath: path.path()) {
            do{
                try FileManager
                    .default
                    .createDirectory(atPath: path.path(), withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("Error when try to create a folder: \(error)")
            }
        }
    }
    
    private func deleteFolder(){
        guard let path = getImageFolderPath() else{ return }
        
        do{
            try FileManager
                .default
                .removeItem(atPath: path.path())
        }catch let error{
            print("Error when try to delete folder: \(error)")
        }
    }
    
    private func getImageFolderPath() -> URL? {
        guard
            let path = FileManager
                .default
                .urls(for: .documentDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent(imageFolderName) else{
            print("Error when try to get the path")
            return nil
        }
        
        return path
    }
    
    //MARK: Image Section
    func saveImage(image: UIImage, name: String) -> String{
        guard
            let data = image.pngData(),
            let path = getImageFolderPath()?
                .appendingPathComponent("\(name).png")
        else{
            return "Error when try to save image"
        }
        
        do{
            try data.write(to: path)
        }catch let error{
            return "Error when try to save image: \(error)"
        }
        
        return "Image saved successfully"
    }
    
    func deleteImage(imageName: String) -> String{
        guard
            let path = getImageFolderPath()?.path(),
            FileManager.default.fileExists(atPath: "\(path)/\(imageName)") else{
            return "Image not found"
        }
        
        do{
            try FileManager.default.removeItem(atPath: "\(path)/\(imageName)")
        } catch let error{
            return "Error when try to delete image: \(error)"
        }
        
        return "Successfully deleted"
    }
    
    func getImage(imageName: String) -> UIImage?{
        guard
            let path = getImageFolderPath()?.appendingPathComponent("\(imageName).png").path(),
            FileManager.default.fileExists(atPath: path) else{
            print("Error when try to get image")
            return nil
        }
        
        return UIImage(contentsOfFile: path)
    }
    
    func loadImage(imageName: String) -> UIImage{
        guard
            let image = getImage(imageName: imageName)
        else {
            return UIImage(systemName: "person.circle.fill") ?? UIImage()
        }
        
        return image
    }
}
