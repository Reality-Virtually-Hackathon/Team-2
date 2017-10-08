/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Popover view controller for choosing virtual objects to place in the AR scene.
*/

import UIKit

// MARK: - ObjectCell

class ObjectCell: UITableViewCell {
    static let reuseIdentifier = "ObjectCell"
    
    @IBOutlet weak var objectTitleLabel: UILabel!
    @IBOutlet weak var objectImageView: UIImageView!
        
    var modelName = "" {
        didSet {
            objectTitleLabel.text = modelName.capitalized
            objectImageView.image = UIImage(named: modelName)
        }
    }
}

class ObjectCellSub: UITableViewCell {
    static let reuseIdentifier = "ObjectCellSub"
    
    @IBOutlet weak var objectTitleLabel: UILabel!
    @IBOutlet weak var objectImageView: UIImageView!
    
    var titleText = ""{
        didSet {
            objectTitleLabel.text = titleText.capitalized
        }
    }
    var imageName = "" {
        didSet {
            objectImageView.image = UIImage(named: imageName)
        }
    }
}

// MARK: - VirtualObjectSelectionViewControllerDelegate

/// A protocol for reporting which objects have been selected.
protocol VirtualObjectSelectionViewControllerDelegate: class {
    func virtualObjectSelectionViewController(_ selectionViewController: VirtualObjectSelectionViewController, didSelectObject: SharedARObjectDescriptor)
    func virtualObjectSelectionViewController(_ selectionViewController: VirtualObjectSelectionViewController, didDeselectObject: SharedARObjectDescriptor)
}

/// A custom table view controller to allow users to select `VirtualObject`s for placement in the scene.
class VirtualObjectSelectionViewController: UITableViewController {
    
    /// The collection of `VirtualObject`s to select from.
    var sharedObjectDescriptors = [SharedARObjectDescriptor]()
    
    /// The rows of the currently selected `VirtualObject`s.
    var selectedVirtualObjectRows = IndexSet()
    
    var objectSelector = UISegmentedControl()
    
    weak var delegate: VirtualObjectSelectionViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        tableView.separatorEffect = UIVibrancyEffect(blurEffect: UIBlurEffect(style: .light))
        objectSelector.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30)
        objectSelector.insertSegment(withTitle: "Learn", at: 0, animated: false)
        objectSelector.insertSegment(withTitle: "Play", at: 1, animated: false)
        objectSelector.insertSegment(withTitle: "Build", at: 2, animated: false)
        self.tableView.tableHeaderView = objectSelector
        objectSelector.selectedSegmentIndex = DataManager.shared().lastSelectedObjectSet
        objectSelector.tintColor = UIColor.black
        objectSelector.addTarget(self, action: #selector(newObjectSetClicked(sender:)), for: .valueChanged)
    }
    
    @objc func newObjectSetClicked(sender: UISegmentedControl){
        let newValue = sender.selectedSegmentIndex
        switch newValue {
        case 0:
            sharedObjectDescriptors = DataManager.shared().solarSystemObjects
        case 1:
            sharedObjectDescriptors = DataManager.shared().chessObjects
        case 2:
            sharedObjectDescriptors = DataManager.shared().constructionObjects
        default:
            sharedObjectDescriptors = DataManager.shared().solarSystemObjects
        }
        DataManager.shared().lastSelectedObjectSet = newValue
        tableView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        preferredContentSize = CGSize(width: 300, height: tableView.contentSize.height)
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let maxWidth = self.view.frame.width - 60
        let font = UIFont(name: "Avenir-Book", size: 16)
        let objectRep = sharedObjectDescriptors[indexPath.row]
        var text = ""
        if objectRep.description != ""{
            text = "\(objectRep.name) - \(objectRep.description)"
        }else{
            text = "\(objectRep.name)"
        }
        
        let label = UILabel()
        label.font = font
        label.text = text
        label.numberOfLines = 0
        let size = label.sizeThatFits(CGSize(width: maxWidth, height: .greatestFiniteMagnitude))
        
        return size.height + 10
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = sharedObjectDescriptors[indexPath.row]
        
        // Check if the current row is already selected, then deselect it.
        if selectedVirtualObjectRows.contains(indexPath.row) {
            delegate?.virtualObjectSelectionViewController(self, didDeselectObject: object)
        } else {
            delegate?.virtualObjectSelectionViewController(self, didSelectObject: object)
        }

        dismiss(animated: true, completion: nil)
    }
        
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sharedObjectDescriptors.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ObjectCellSub.reuseIdentifier, for: indexPath) as? ObjectCellSub else {
            fatalError("Expected `\(ObjectCell.self)` type for reuseIdentifier \(ObjectCell.reuseIdentifier). Check the configuration in Main.storyboard.")
        }
        let objectRep = sharedObjectDescriptors[indexPath.row]
        var text = ""
        if objectRep.description != ""{
            text = "\(objectRep.name) - \(objectRep.description)"
        }else{
            text = "\(objectRep.name)"
        }
        
        cell.titleText = text
        cell.imageName = objectRep.modelName

        if selectedVirtualObjectRows.contains(indexPath.row) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
    }
    
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = .clear
    }
}
