//
//  ApplicationsListViewController.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 03/08/2021.
//

import UIKit
import ACSSmartCardIO
import CoreBluetooth
import SmartCardIO

class ApplicationsListViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Variables
    var presenter: ApplicationsListPresenterProtocol!
    var iCardStateMonitorListenerDelegate: ICardStateMonitorListenerDelegate!
    private var searchController: UISearchController?
    
    let manager = BluetoothSmartCard.shared.manager
    let factory = BluetoothSmartCard.shared.factory
    let cardStateMonitor = CardStateMonitor.shared
    let bluetoothManager = CBCentralManager(delegate: nil, queue: nil)
    
    private let sectionInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    private let numberOfItemsPerRow: CGFloat = 2
    private let spacingBetweenCells: CGFloat = 10
    
    private var isGrid = false
    
    var card: Card!
    var mifareDesfireHelper: MiFareDesfireHelper!
    var applicationWebViewController: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        presenter.viewDidLoad()
        setupCollectionView()
        getCardUID()
        iCardStateMonitorListenerDelegate = ICardStateMonitorListenerDelegate({ }, { [weak self] in
            DispatchQueue.main.async {
                self?.presenter.performBack()
                self?.presenter.performHideLoading()
                guard let searchController = self?.searchController else { return }
                searchController.dismiss(animated: true, completion: nil)
            }
        })
        BluetoothManager.getInstance().iCardStateMonitorListener = iCardStateMonitorListenerDelegate
    }
}

// MARK: - Helpers
extension ApplicationsListViewController {
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "ApplicationsListHeaderCollectionViewCell", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.register(UINib(nibName: "ApplicationItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        collectionView.showsVerticalScrollIndicator = false
    }
    
    private func getCardUID() {
        let bluetoothManager = BluetoothManager.getInstance()
        let cardChannel = bluetoothManager.getChardChannel()
        if cardChannel != nil {
            let card = cardChannel!.card
            let mifareDesfireHelper = MiFareDesfireHelper(card: card, mifareNFCCardManager: ApduCommandExecuter())
            mifareDesfireHelper.getUid { [weak self] response, error in
                if let error = error {
                    print("Failed to get card uid:", error)
                    return
                }
                print("Card UUID:", MifareUtils.toHexString(buffer: response!.responseData))
                let cardUID = MifareUtils.toHexString(buffer: response!.responseData).removeWhitespace()
                self?.presenter.getApplicationsList(withCardUID: cardUID)
            }
        }
    }
    
    private func setupSearchController() {
        // Create the search controller and specify that it should present its results in this same view
        searchController = UISearchController(searchResultsController: nil)
        
        // Set any properties (in this case, don't hide the nav bar and don't show the emoji keyboard option)
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.searchBar.keyboardType = UIKeyboardType.asciiCapable
        
        // Properties for search bar.
        searchController?.searchBar.backgroundColor = .clear
        searchController?.searchBar.backgroundImage = UIImage()
        searchController?.searchBar.isTranslucent = true
        searchController?.searchBar.placeholder = "search_applications".localized()
        searchController?.searchBar.tintColor = DesignSystem.Colors.text3.color
        
        // Properties for SearchTextField.
        let textFieldInsideUISearchBar = searchController?.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.backgroundColor = DesignSystem.Colors.backgroundPrimary.color
        textFieldInsideUISearchBar?.cornerRadius = 10
        textFieldInsideUISearchBar?.font = DesignSystem.Typography.paragraphSmall.font
        textFieldInsideUISearchBar?.placeHolderColor = DesignSystem.Colors.placeholderPrimary.color
        textFieldInsideUISearchBar?.textColor = DesignSystem.Colors.textPrimary.color
        textFieldInsideUISearchBar?.clearButtonMode = .whileEditing
        
        // Make this class the delegate and present the search
        self.searchController?.searchBar.delegate = self
    }
}

// MARK: - UICollectionViewDataSource
extension ApplicationsListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! ApplicationsListHeaderCollectionViewCell
        header.delegate = self
        return header
    }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.applicationsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ApplicationItemCollectionViewCell
        cell.index = indexPath.item
        cell.delegate = self
        presenter.configureApplicationItemCell(cell, atIndex: indexPath.item, isGrid: isGrid)
        return cell
    }
}

// MARK: - SkeletonCollectionViewDelegate
extension ApplicationsListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectApplication(atIndex: indexPath.item)
    }
}

// MARK: - UICollectionViewDataSource
extension ApplicationsListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: collectionView.frame.size.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isGrid {
            let totalSpacing: CGFloat = (2 * sectionInsets.left) + ((numberOfItemsPerRow - 1) * spacingBetweenCells)
            let width = (collectionView.frame.size.width - totalSpacing) / numberOfItemsPerRow
            return .init(width: width, height: 90)
        } else {
            return .init(width: collectionView.frame.size.width, height: 143)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return isGrid ? spacingBetweenCells : 17
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return isGrid ? spacingBetweenCells : 17
    }
}

// MARK: - ApplicationsListHeaderCollectionViewCellDelegate
extension ApplicationsListViewController: ApplicationsListHeaderCollectionViewCellDelegate {
    
    func applicationsListHeaderCollectionViewCellBackButtonPressed() {
        presenter.performBack()
        guard let searchController = searchController else { return }
        searchController.dismiss(animated: true, completion: nil)
    }
    
    func applicationsListHeaderCollectionViewCellSearchButtonPressed() {
        setupSearchController()
        guard let searchController = searchController else { return }
        present(searchController, animated: true, completion: nil)
    }

    func applicationsListHeaderCollectionViewCellSortButtonPressed() {
        isGrid.toggle()
        collectionView.reloadData()
    }
}

// MARK: - UISearchBarDelegate
extension ApplicationsListViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        presenter.updateIsSearching(true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        presenter.updateIsSearching(false)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        presenter.updateIsSearching(false)
        searchBar.text = ""
        presenter.searchApplications(withSearchText: "")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text else { return }
        if !searchText.isEmpty {
            presenter.updateIsSearching(true)
            presenter.searchApplications(withSearchText: searchText)
        } else {
            presenter.updateIsSearching(false)
            presenter.searchApplications(withSearchText: searchText)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.updateIsSearching(!searchText.isEmpty)
        presenter.searchApplications(withSearchText: searchText)
    }
}

// MARK: - ApplicationItemCollectionViewCellDelegate
extension ApplicationsListViewController: ApplicationItemCollectionViewCellDelegate {
    
    func didEditApplication(atIndex index: Int) {
        presenter.didEditApplication(atIndex: index, card: card, mifareDesfireHelper: mifareDesfireHelper)
    }
}
