//
//  ImageLoaderDemo.swift
//  Exercises
//
//  Created by Jaydeep Joshi on 03/05/22.
//

import SwiftUI

struct Photo: Decodable, Identifiable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let url: String
    let downloadUrl: String
}

class RemoteFetcher<T> {
    let url: String
    let converter: (Data) throws -> T

    init(_ url: String, converter: @escaping (Data) throws -> T) {
        self.url = url
        self.converter = converter
    }

    func fetch() async -> Result<T, Error> {
        do {
            let (data, _) = try await URLSession.shared.data(from: URL(string: url)!)
            let fetched = try converter(data)
            return .success(fetched)
        } catch {
            return .failure(error)
        }
    }
}

@MainActor class PhotoListVM: ObservableObject {
    @Published var photoListResult: Result<[Photo], Error>?
    private let fetcher = RemoteFetcher("https://picsum.photos/v2/list") { data -> [Photo] in
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode([Photo].self, from: data)
    }

    func fetchPhotoList() async {
        photoListResult = await fetcher.fetch()
    }
}

@MainActor class PhotoDetailVM: ObservableObject {
    @Published var imageResult: Result<UIImage, Error>?
    let photo: Photo
    private let fetcher: RemoteFetcher<UIImage>

    init(_ photo: Photo) {
        self.photo = photo
        self.fetcher = RemoteFetcher(photo.downloadUrl) { data in
            if let image = UIImage(data: data) {
                return image
            }
            throw NSError(domain: "nil image", code: 0)
        }
    }

    func fetchImage() async {
        imageResult = await fetcher.fetch()
    }
}

struct ImageLoaderDemo: View {
    @StateObject var vm = PhotoListVM()

    var body: some View {
        NavigationView {
            switch vm.photoListResult {
            case .none:
                ProgressView()
            case .some(.success(let photos)):
                successView(photos)
            case .some(.failure(let error)):
                Text(error.localizedDescription)
            }
        }.task {
            await vm.fetchPhotoList()
        }
    }

    @ViewBuilder private func successView(_ photos: [Photo]) -> some View {
        List(photos) { photo in
            NavigationLink {
                PhotoView(vm: PhotoDetailVM(photo))
            } label: {
                Text(photo.author)
            }
        }
    }
}

struct PhotoView: View {
    @ObservedObject var vm: PhotoDetailVM

    var body: some View {
        Group {
            switch vm.imageResult {
            case .none:
                Image(systemName: "person.fill")
                    .resizable()
                    .aspectRatio(CGFloat(vm.photo.width) / CGFloat(vm.photo.height), contentMode: .fit)
                    .redacted(reason: .placeholder)
            case .some(.success(let image)):
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            case .some(.failure(let error)):
                Text(error.localizedDescription)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await vm.fetchImage()
        }
    }
}

struct ImageLoaderDemo_Previews: PreviewProvider {
    static var previews: some View {
        ImageLoaderDemo()
    }
}
