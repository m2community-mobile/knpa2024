//
//  TcpSocket.swift
//  CosoptTransformSymposium2019
//
//  Created by m2comm on 25/03/2019.
//  Copyright © 2019 m2community. All rights reserved.
//

import Foundation

class TcpSocket: NSObject, StreamDelegate {
    
    
    var host:String?
    var port:Int?
    var inputStream: InputStream?
    var outputStream: OutputStream?
    
    func connect(host: String, port: Int) {
        
        self.host = host
        self.port = port
        
        Stream.getStreamsToHost(withName:host, port : port, inputStream: &inputStream, outputStream: &outputStream)
        
        if inputStream != nil && outputStream != nil {
            // Set delegate
            inputStream!.delegate = self
            outputStream!.delegate = self
            
            // Schedule
            
            inputStream!.schedule(in: .main, forMode: RunLoop.Mode.default)
            outputStream!.schedule(in: .main, forMode: RunLoop.Mode.default)
            
            print("Start open()")
            
            // Open!
            inputStream!.open()
            outputStream!.open()
        }
    }
    
    func send(data: Data) -> Int {
        let bytesWritten = data.withUnsafeBytes { outputStream?.write($0, maxLength: data.count) }
        return bytesWritten!
    }
    
    //    func send(data: String) -> Int {
    //        let bytesWritten = outputStream?.write(data, maxLength:data.characters.count)
    //        return bytesWritten!
    //    }
    
    func recv(buffersize: Int) -> Data {
        var buffer = [UInt8](repeating :0, count : buffersize)
        
        let bytesRead = inputStream?.read(&buffer, maxLength: buffersize)
        var dropCount = buffersize - bytesRead!
        if dropCount < 0 {
            dropCount = 0
        }
        let chunk = buffer.dropLast(dropCount)
        return Data(chunk)
    }
    
    func disconnect() {
        inputStream?.close()
        outputStream?.close()
    }
    
    func stream(_ stream: Stream, handle eventCode: Stream.Event) {
        
        print("event:\(eventCode)")
        
        if stream === inputStream {
            switch eventCode {
            case Stream.Event.errorOccurred:
                print("inputStream:ErrorOccurred")
            case Stream.Event.openCompleted:
                print("inputStream:OpenCompleted")
            case Stream.Event.hasBytesAvailable:
                print("inputStream:HasBytesAvailable")   
            default:
                break
            }
        }
        else if stream === outputStream {
            switch eventCode {
            case Stream.Event.errorOccurred:
                print("outputStream:ErrorOccurred")
            case Stream.Event.openCompleted:
                print("outputStream:OpenCompleted")
            case Stream.Event.hasSpaceAvailable:
                print("outputStream:HasSpaceAvailable")
                
                
            default:
                break
            }
        }
    }
    
}
