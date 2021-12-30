//
//  ApduEnums.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 29/07/2021.
//

import Foundation

class ApduEnums {
    
    enum Cla: UInt8 {
        case CompliantCmd0x = 0x00;
        case AppCompliantCmdAx = 0xA0;
        case ProprietaryCla8x = 0x80;
        case ProprietaryCla9x = 0x90;
        case ReservedForPts = 0xFF; // Protocol Type Selelction
    }
    
    enum ClaXx : UInt8 {
        case NoSmOrNoSmIndication = 0x00
        case ProprietarySmFormat = 0x01
        case SecureMessageNoHeaderSM = 0x10
        case SecureMessage1p6 = 0x11
    }
    
    enum Ins: UInt8 {
        case EraseBinary = 0x0E;
        case ManageChannel = 0x70;
        case GetChallenge = 0x84;
        case InternalAuthenticate = 0x88;
        //case SelectFile = 0xA4;
        case ReadRecords = 0xB2;
        case GetResponse = 0xC0;
        case Envelope = 0xC2;
        case WriteBinary = 0xD0;
        case WriteRecord = 0xD2;
        case DeleteApplication = 0xDA;
        case FormatPICC = 0xFC;
        case UpdateData = 0xDC;
        case AppendRecord = 0xE2;
        
        case GetData = 0xCB;
        case LoadKeys = 0x82;
        //case ExternalAuthenticate = 0x82;
        case GeneralAuthenticate = 0x86;
        case Verify = 0x20;
        case ReadBinary = 0xB0;
        case UpdateBinary = 0xD6;
        
        case GetVersion = 0x60;
        case ContinueAF = 0xAF;
        case ListApplications = 0x6A;
        case CreateApplication = 0xCA;
        case GetKeySettings = 0x45;
        case GetKeyVersion = 0x64;
        case GetFileIDs = 0x6F;
        case DeleteFile = 0xDF;
        case CreateFile = 0xCD;
        case SelectApplication = 0x5A;
        case GetCardUID = 0x51;
        case GetAuthenticationChallenge = 0x1A; // 0A -> DES, 1A -> 3DES, AA -> AES
        case ReadData = 0xBD;
        case WriteData = 0x3D;
    }
    
    enum GetDataDataType: UInt8 {
        case Uid = 0x00;
        case HistoricalBytes = 0x01; // Returned data excludes CRC
    }
    
    enum GeneralAuthenticateKeyType: UInt8 {
        case MifareKeyA = 0x60;
        case PicoTagPassKeyB = 0x61;
    }
    
    enum GeneralAuthenticateVersionNumber: UInt8 {
        case VersionOne = 0x01;
    }

    enum LoadKeysKeyType: UInt8 {
        case CardKey = 0x00;
        //case ReaderKey = 0x80;
        case Mask = 0x80;
    }

    enum LoadKeysTransmissionType: UInt8 {
        case Plain = 0x00;
        //case Secured = 0x40;
        case Volatile = 0x20;
        case Mask = 0x40;
    }

    enum LoadKeysStorageType: UInt8 {
        case Volatile = 0x00;
        //case NonVolatile = 0x20;
        case Mask = 0x20;
    }
}
