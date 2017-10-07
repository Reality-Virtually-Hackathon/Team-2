//
//  ConnectivityManager.swift
//  WorkspaceAR
//
//  Created by Joe Crotchett on 10/7/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol ConnectivityManagerDelegate {
    
    // Called when a peer has changed it's connection status
    func connectedDevicesChanged(manager : ConnectivityManager,
                                 connectedDevices: [String])
    
    // Called when data has been recieved from a peer
    func dataReceived(manager: ConnectivityManager,
                      data: Data)
}

class ConnectivityManager : NSObject {
    let ServiceType = "MIT-ar-demo-service"
    let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    var advertiser: MCNearbyServiceAdvertiser?
    var browser: MCNearbyServiceBrowser?
    var delegate : ConnectivityManagerDelegate?
    
    lazy var session : MCSession = {
        let session = MCSession(peer: self.myPeerId,
                                securityIdentity: nil,
                                encryptionPreference: .none)
        session.delegate = self
        return session
    }()
    
    deinit {
        if let advertiser = advertiser {
            advertiser.stopAdvertisingPeer()
        }
        
        if let browser = browser {
            browser.stopBrowsingForPeers()
        }
    }
    
    // Act as the host
    func startAdvertising() {
        advertiser = MCNearbyServiceAdvertiser(peer: myPeerId,
                                               discoveryInfo: nil,
                                               serviceType: ServiceType)
        if let advertiser = advertiser {
            advertiser.delegate = self
            advertiser.startAdvertisingPeer()
        }
    }
    
    // Act as the client
    func startBrowsing() {
        browser = MCNearbyServiceBrowser(peer: myPeerId,
                                         serviceType: ServiceType)
        if let browser = browser {
            browser.delegate = self
            browser.startBrowsingForPeers()
        }
    }
    
    // Broadcast data to all peers
    func sendTestString() {
        if session.connectedPeers.count > 0 {
            do {
                try self.session.send("test string".data(using: .utf8)!,
                                      toPeers: session.connectedPeers,
                                      with: .reliable)
            }
            catch let error {
                print("%@", "Error for sending: \(error)")
            }
        }
    }
}

//MARK: MCNearbyServiceAdvertiserDelegate

extension ConnectivityManager: MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didNotStartAdvertisingPeer error: Error) {
        print("%@", "didNotStartAdvertisingPeer: \(error)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didReceiveInvitationFromPeer peerID: MCPeerID,
                    withContext context: Data?,
                    invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("%@", "didReceiveInvitationFromPeer \(peerID)")
        invitationHandler(true, self.session)
    }
}

//MARK: MCNearbyServiceBrowserDelegate

extension ConnectivityManager : MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser,
                 didNotStartBrowsingForPeers error: Error) {
        print("%@", "didNotStartBrowsingForPeers: \(error)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser,
                 foundPeer peerID: MCPeerID,
                 withDiscoveryInfo info: [String : String]?) {
        print("%@", "foundPeer: \(peerID)")
        print("%@", "invitePeer: \(peerID)")
        browser.invitePeer(peerID,
                           to: self.session,
                           withContext: nil,
                           timeout: 10)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser,
                 lostPeer peerID: MCPeerID) {
        print("%@", "lostPeer: \(peerID)")
    }
}

//MARK: MCSessionDelegate

extension ConnectivityManager : MCSessionDelegate {
    
    func session(_ session: MCSession,
                 peer peerID: MCPeerID,
                 didChange state: MCSessionState) {
        print("%@", "peer \(peerID) didChangeState: \(state)")
        self.delegate?.connectedDevicesChanged(manager: self,
                                               connectedDevices: session.connectedPeers.map{$0.displayName})
    }
    
    func session(_ session: MCSession,
                 didReceive data: Data,
                 fromPeer peerID: MCPeerID) {
        print("%@", "didReceiveData: \(data)")
        if let message = String(data: data,
                                encoding: .utf8) {
            self.delegate?.dataReceived(manager: self,
                                        data: message.data(using: .utf8)!)
        }
    }
    
    func session(_ session:
                 MCSession, didReceive stream:
                 InputStream, withName streamName:
                 String, fromPeer peerID: MCPeerID) {
        assert(true, "not impelemented")
    }
    
    func session(_ session: MCSession,
                 didStartReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID,
                 with progress: Progress) {
        assert(true, "not impelemented")
    }
    
    func session(_ session: MCSession,
                 didFinishReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID,
                 at localURL: URL?,
                 withError error: Error?) {
        assert(true, "not impelemented")
    }
}

