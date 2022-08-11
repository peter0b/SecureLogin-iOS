//
//  ICardStateMonitorListenerDelegate.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 02/08/2021.
//

import Foundation

// Note: This protocol is used in `ScanBadgeViewController` to detect if card is inserted or removed.
protocol CardStateMonitorStateDelegate: AnyObject {
    func cardStateMonitorCardInserted()
    func cardStateMonitorCardRemoved()
}

class ICardStateMonitorListenerDelegate: ICardStateMonitorListener {
    
    typealias CardConnected = () -> Void
    typealias CardDisconnected = () -> Void
    private var cardConnected: CardConnected
    private var cardDisconnected: CardDisconnected
    
    init(_ cardConnected: @escaping CardConnected, _ cardDisconnected: @escaping CardDisconnected) {
        self.cardConnected = cardConnected
        self.cardDisconnected = cardDisconnected
    }
    
    func onCardInserted() {
        cardConnected()
    }
    
    func onCardRemoved() {
        cardDisconnected()
    }
}
