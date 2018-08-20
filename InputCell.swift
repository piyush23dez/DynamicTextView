
import UIKit


extension UITableViewCell {
    /// Search up the view hierarchy of the table view cell to find the containing table view
    var tableView: UITableView? {
        get {
            var table: UIView? = superview
            while !(table is UITableView) && table != nil {
                table = table?.superview
            }
            return table as? UITableView
        }
    }
}


class InputCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var input: UITextView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    /// Custom setter so we can initialise the height of the text view
    var textString: String {
        get {
            return input.text
        }
        set {
            input.text = newValue
            textViewDidChange(input)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Disable scrolling inside the text view so we enlarge to fitted size
        input.isScrollEnabled = false
        input.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            input.becomeFirstResponder()
        } else {
            input.resignFirstResponder()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = textView.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude))
        
        // Resize the cell only when cell's size is changed
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            tableView?.beginUpdates()
            tableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
            
            if let thisIndexPath = tableView?.indexPath(for: self) {
                tableView?.scrollToRow(at: thisIndexPath, at: .bottom, animated: false)
            }
        }
    }
}
