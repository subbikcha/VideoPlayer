#if DEBUG
import Foundation

final class StubURLProtocol: URLProtocol {

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        let json = Self.popularVideosJSON
        let data = json.data(using: .utf8)!
        let response = HTTPURLResponse(
            url: request.url!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: ["Content-Type": "application/json"]
        )!

        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: data)
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}

extension StubURLProtocol {

    static let popularVideosJSON = """
    {
      "page": 1,
      "per_page": 15,
      "total_results": 3,
      "videos": [
        {
          "id": 1093662,
          "width": 1920,
          "height": 1080,
          "url": "https://www.pexels.com/video/water-crashing-over-the-rocks-1093662/",
          "image": "https://images.pexels.com/videos/1093662/free-video-1093662.jpg?fit=crop&w=1200&h=630&auto=compress&cs=tinysrgb",
          "duration": 8,
          "user": {
            "id": 417939,
            "name": "Peter Fowler",
            "url": "https://www.pexels.com/@peter-fowler-417939"
          },
          "video_files": [
            {
              "id": 37101,
              "quality": "hd",
              "file_type": "video/mp4",
              "width": 1920,
              "height": 1080,
              "link": "https://player.vimeo.com/external/269971860.hd.mp4"
            },
            {
              "id": 37102,
              "quality": "sd",
              "file_type": "video/mp4",
              "width": 640,
              "height": 360,
              "link": "https://player.vimeo.com/external/269971860.sd.mp4"
            }
          ],
          "video_pictures": []
        },
        {
          "id": 2499611,
          "width": 1080,
          "height": 1920,
          "url": "https://www.pexels.com/video/2499611/",
          "image": "https://images.pexels.com/videos/2499611/free-video-2499611.jpg?fit=crop&w=1200&h=630&auto=compress&cs=tinysrgb",
          "duration": 22,
          "user": {
            "id": 680589,
            "name": "Joey Farina",
            "url": "https://www.pexels.com/@joey"
          },
          "video_files": [
            {
              "id": 125004,
              "quality": "hd",
              "file_type": "video/mp4",
              "width": 1080,
              "height": 1920,
              "link": "https://player.vimeo.com/external/342571552.hd.mp4"
            },
            {
              "id": 125005,
              "quality": "sd",
              "file_type": "video/mp4",
              "width": 540,
              "height": 960,
              "link": "https://player.vimeo.com/external/342571552.sd.mp4"
            }
          ],
          "video_pictures": []
        },
        {
          "id": 856973,
          "width": 1920,
          "height": 1080,
          "url": "https://www.pexels.com/video/aerial-view-of-city-856973/",
          "image": "https://images.pexels.com/videos/856973/free-video-856973.jpg?fit=crop&w=1200&h=630&auto=compress&cs=tinysrgb",
          "duration": 67,
          "user": {
            "id": 2659,
            "name": "Ruvim Miksanskiy",
            "url": "https://www.pexels.com/@digitech"
          },
          "video_files": [
            {
              "id": 58649,
              "quality": "hd",
              "file_type": "video/mp4",
              "width": 1920,
              "height": 1080,
              "link": "https://player.vimeo.com/external/259462860.hd.mp4"
            },
            {
              "id": 58650,
              "quality": "sd",
              "file_type": "video/mp4",
              "width": 640,
              "height": 360,
              "link": "https://player.vimeo.com/external/259462860.sd.mp4"
            }
          ],
          "video_pictures": []
        }
      ]
    }
    """
}
#endif
