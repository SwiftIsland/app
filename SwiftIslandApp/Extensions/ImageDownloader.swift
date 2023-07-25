//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import UIKit

struct LazyImage<I: View>: View {
    let content: I?
    let url: URL

    init(url: URL, @ViewBuilder content: (Image) -> I) {
        self.url = url

        if let cachedImage = ImageCache.getImage(forURL: url) {
            self.content = content(Image(uiImage: cachedImage))
        } else {
            self.content = nil
        }
    }

    var body: some View {
        if let content {
            content
        } else {
            AsyncImage(url: url) { image in
                image
                    .onAppear {
                        ImageCache.cacheImage(forURL: url, image: image)
                    }
            } placeholder: {
                ProgressView()
            }
        }
    }
}

class ImageCache {
    private static var cache: [URL: UIImage] = [:]

    static func getImage(forURL url: URL) -> UIImage? {
        dump(cache)

        return cache[safe: url]?.value
    }

    static func cacheImage(forURL url: URL, image: UIImage) {
        cache[url] = image
    }

    static func reset() {
//        cache = [:]
    }

    @MainActor
    static func cacheImage(forURL url: URL, image: Image) {
        let renderer = ImageRenderer(content: image)
        if let uiImage = renderer.uiImage {
            ImageCache.cacheImage(forURL: url, image: uiImage)
        }
    }
}
