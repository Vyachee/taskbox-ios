//
//  Cams.swift
//  TestApp1
//
//  Created by Vyacheslav on 14.05.2021.
//

import SwiftUI
import AVKit
import MobileVLCKit
import SwiftUIPager

struct Cams: View {
    
    var camsList: [Cam]
    @ObservedObject var page: Page = .first()
    
    var body: some View {
        
        Pager(page: page,
              data: camsList,
              id: \.id,
              content: { item in
                HStack {
                    NavigationLink(
                        destination: CameraDetail(camera: item),
                        label: {
                            VlcPlayerDemo(url: item.cam_MStream!)
                                .frame(width: 350, height: 200)
                                .cornerRadius(10)
                                .padding()
                        })
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
              })
            .alignment(.start)  
            .frame(height: 200)
        
    }
}

struct CamView: View {
    
    var body: some View {
        Text("test")
    }
    
}

class PlayerUIView: UIView, VLCMediaPlayerDelegate {
    private let mediaPlayer = VLCMediaPlayer()
    @State var link: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let url = URL(string: link)!
        
        mediaPlayer.media = VLCMedia(url: url)
        mediaPlayer.delegate = self
        mediaPlayer.drawable = self
        mediaPlayer.play()
    }
    
    init(frame: CGRect, link: String, isPreview: Bool = true) {
        super.init(frame: frame)
        self.link = link
        
        if let url = URL(string: link) {
            print("init success")
            print("link: \(link)")
            
            mediaPlayer.media = VLCMedia(url: url)
            mediaPlayer.delegate = self
            mediaPlayer.drawable = self
            mediaPlayer.play()
            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
//
//                вызов этого метода даст exception, если потока нет, но отследить его никак
//                self.mediaPlayer.saveVideoSnapshot(
//                    at: "test",
//                    withWidth: 32,
//                    andHeight: 32
//                )
//                self.mediaPlayer.stop()
//
//            }
            
            if(isPreview) {
                mediaPlayer.pause()
            }
            
        }   else {
            print("error")
            print("link: \(link)")
        }
        
    }
    
    public func reinit(link: String) {
        if let url = URL(string: link) {
            mediaPlayer.media = VLCMedia(url: url)
            mediaPlayer.delegate = self
            mediaPlayer.drawable = self
            mediaPlayer.play()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

struct VlcPlayerDemo: UIViewRepresentable{
    
    var url: String
    var isPreview: Bool = true
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<VlcPlayerDemo>) {
        
    }	
    
    func makeUIView(context: Context) -> UIView {
        return PlayerUIView(frame: .zero, link: url, isPreview: isPreview)
    }
}

struct Cams_Previews: PreviewProvider {
    static var previews: some View {
        Cams(camsList: [Cam]())
    }
}
