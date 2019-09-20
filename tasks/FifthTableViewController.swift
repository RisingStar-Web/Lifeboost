import UIKit
//import StoreKit

class FifthTableViewController:UITableViewController, UITextFieldDelegate, UIPopoverPresentationControllerDelegate
    //, SKProductsRequestDelegate
{
    
    
    struct My {
        static var cellSnapshot : UIView? = nil
        static var cellIsAnimating : Bool = false
        static var cellNeedToShow : Bool = false
    }
    struct Path {
        static var initialIndexPath : IndexPath? = nil
    }
    
    weak var selectColorViewController: SelectColorViewController?
    
    var imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
    
    @IBOutlet var textField1: UITextField!
    
    var longPress = UILongPressGestureRecognizer()
    var scroolingTOtop:Bool = false
    var yPosition:CGFloat = 0.0
    var bottomLineToScroll:CGFloat = 0
    var topLineToScroll:CGFloat = 0
    let Razdel:Int = 5
    var lastEditedColor  :Int = 5
    var task:String = ""
    
    var tasks:NSMutableDictionary = [:]
    var  listOfTasks:   NSMutableArray = [] // [Dictionary<String, Int, Int>]() // :
    var  subListOfTasks:NSMutableArray = []
    var activeTextField = UITextField()
    var scrollLocationInViewY: CGFloat = 0
    var height: CGFloat = 44.0
    var colorNumber:Int = 5 // color to set up
    var indexPathRowToChngeColor:Int = 0
    var takedCellPath:IndexPath =   IndexPath(row: 0, section: 0)
    var editedIndexPath:IndexPath =   IndexPath(row: 0, section: 0)
    //  let myBlue =  UIColor(red: 236.0/255.0, green: 246.0/255.0, blue: 249.0/255.0, alpha: 1.0).cgColor
    var timer : Timer?
    var isTimerRunning:  Bool = false
    
    //---------- localization
    let titleOK = NSLocalizedString("OK", comment: "OK")
    let titleBuyNow = NSLocalizedString("Buy Now!", comment: "Купить Сейчас!")
    let title4 = NSLocalizedString("Try and buy!", comment: "Попробуй и Купи!")
    let message4 = NSLocalizedString("buy the app and remove this message", comment:  "купить приложение и убрать напоминание")
    let title5 = NSLocalizedString("Later", comment: "Позже")
    let title6 = NSLocalizedString("Restore purchase", comment: "Восстановить Покупку")
   
    //__________________________
    func filterContent()  {
        self.subListOfTasks.removeAllObjects()
        
        for dictionary in self.listOfTasks {
            
            let tmpDictionary:NSDictionary = dictionary as! NSDictionary
            
            
            var tmpInt : Int = 0
            if    let tmpColorNumber:String =  tmpDictionary.object(forKey: "c") as? String
            {
                if
                    // let stateCodeString = tmpColorNumber as? String,
                    // let stateCode = Int(stateCodeString)
                    let stateCode = Int(tmpColorNumber)
                {
                    tmpInt = stateCode
                }
            } else  {
                let tmpColorNumber:Int = (tmpDictionary.value(forKey: "c") as? Int)!
                tmpInt = tmpColorNumber
                
            }
            
            if (tmpInt == Razdel) {
                self.subListOfTasks.add(dictionary)
                
                
            } //  if (tmpInt == Razdel)
            
            
        }
        
    }
    
    //-----------
    
    @objc func automaticScroll() {
        if (self.isTimerRunning == false) { return }
        
        let offset = tableView.contentOffset
        var  offsetY = offset.y
        if  (self.tableView.contentSize.height - self.tableView.frame.height > self.tableView.contentSize.height ) {
            stopTimer()
            return
        }
        
        if  (yPosition > bottomLineToScroll) {
            offsetY = offset.y + height } else   if   (yPosition < topLineToScroll)  {
            if  ( My.cellSnapshot != nil) {
                offsetY = offset.y - height
                //   height = self.tableView.visibleCells.last!.bounds.height
            } else {
                offsetY = offset.y - height
                //  _ = self.tableView.scrollsToTop
            }
        }
        
        if  (offsetY > (self.tableView.contentSize.height - self.tableView.frame.height)) {
            
            self.setUptoLast()
            self.longPress.isEnabled = false
            return
            
        }
        let newOffset = CGPoint(x: offset.x, y: offsetY)
        if (offsetY < 0 ) {
            if (My.cellSnapshot != nil) {
                var center2 = My.cellSnapshot!.center
                scrollLocationInViewY =  offsetY + topLayoutGuide.length  +  My.cellSnapshot!.frame.height
                center2.y = scrollLocationInViewY
                My.cellSnapshot!.center = center2
            }
            if  (My.cellSnapshot != nil) {
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    //  My.cellSnapshot!.center = (cell.center)
                    My.cellSnapshot!.transform = CGAffineTransform.identity
                    My.cellSnapshot!.alpha = 0.0
                    //cell.backgroundColor = UIColor.clear
                    //  cell.alpha = 1.0
                    
                    
                }, completion: { (finished) -> Void in
                    if finished {
                        Path.initialIndexPath = nil
                        if  (My.cellSnapshot != nil) {
                            My.cellSnapshot!.removeFromSuperview()
                        }
                        My.cellSnapshot = nil
                        
                    }
                })
            } // cell != nil
            stopTimer()
            self.savePlist()
            //  _ = self.tableView.scrollsToTop
            return
        } //  if (offsetY < 0 )
        
        // tableView.setContentOffset(newOffset, animated: false)
        
        
        
        if (My.cellSnapshot != nil) {
            
            
            
            
            
            if  (yPosition > bottomLineToScroll) {
                var center = My.cellSnapshot!.center
                center.y = center.y  +  height
                My.cellSnapshot!.center = center
            }
        }
        if   (yPosition < topLineToScroll)  {
            if (My.cellSnapshot != nil) {
                var center = My.cellSnapshot!.center
                center.y = center.y - height + (0.125 * height )
                My.cellSnapshot!.center = center
            }
            
            
        }
        tableView.setContentOffset(newOffset, animated: false)
    }//__________________________
    func startTimer()
    {
        if (!isTimerRunning) {
            
            timer = Timer.scheduledTimer(timeInterval: 0.47, target: self, selector: #selector(automaticScroll), userInfo: nil, repeats: true)
            self.isTimerRunning = true
        }
    }
    //__________________________
    
    func stopTimer()
    {
        if (isTimerRunning) {
            timer!.invalidate()
            timer = nil
            self.isTimerRunning = false
        }
    }
    //  _______________
    func scrollTable() {
        if self.isTimerRunning {
            
        } else {
            //     height = self.tableView.visibleCells.last!.bounds.height
            height = self.tableView.rowHeight
            self.startTimer()
        }
    }
    //_____________________________________
    /*
     func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
     if (gestureRecognizer is UIPanGestureRecognizer) {
     return true
     } else {
     return false
     }
     }
     
     */
    //____________________
    func animateCell(cellIndexPath:IndexPath) {
        let cell = tableView.cellForRow(at: cellIndexPath) as UITableViewCell?
        
        cell?.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animate(withDuration: 0.3, animations: {
            cell?.layer.transform = CATransform3DMakeScale(1.05, 1.05, 1)
        },completion: { finished in
            UIView.animate(withDuration: 0.1, animations: {
                cell?.layer.transform = CATransform3DMakeScale(1, 1, 1)
            })
        })
        
    }
    
    //_____________________________
    func setUptoFirst() {
       //print("setUptoFirst")
        self.scroolingTOtop = true
        self.stopTimer()
        if (Path.initialIndexPath  != nil) {
            
            self.subListOfTasks.exchangeObject(at: 0,  withObjectAt: Path.initialIndexPath!.row)
            let object1 = self.subListOfTasks[0]
            let object2 = self.subListOfTasks[Path.initialIndexPath!.row]
            //DispatchQueue.global(qos: .background).async {
            let index1 = self.listOfTasks.indexOfObjectIdentical(to:  object1)
            let index2 = self.listOfTasks.indexOfObjectIdentical(to:  object2)
            self.listOfTasks.exchangeObject(at: index1,  withObjectAt:index2)
            //}
            
            
            //  let dictionary:NSDictionary = self.subListOfTasks.object(at: indexPath.row) as! NSDictionary
            //self.listOfTasks.remove(dictionary)
            //self.subListOfTasks.removeObject(at: indexPath.row)
            //
            //
            //  Path.initialIndexPath =  IndexPath(row: 0, section: 0)
            // Убираем
            if  (My.cellSnapshot != nil) {
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    // My.cellSnapshot!.center =  My.cellSnapshot!.center
                    My.cellSnapshot!.transform = CGAffineTransform.identity
                    My.cellSnapshot!.alpha = 0.0
                    //cell.backgroundColor = UIColor.clear
                    //cell.alpha = 1.0
                    
                    
                }, completion: { (finished) -> Void in
                    if finished {
                        Path.initialIndexPath = nil
                        
                        if  (My.cellSnapshot != nil) {
                            My.cellSnapshot!.removeFromSuperview()
                        }
                        My.cellSnapshot = nil
                        
                    }
                })
            } // cell != nil
            // contentOffset will not change before the main runloop ends without queueing it, for iPad that is
            self.tableView.reloadData()
            let topPosition =   0 - (self.topLayoutGuide.length)
            DispatchQueue.main.async {
                let offset = CGPoint.init(x: 0, y: topPosition)
                
                self.tableView.setContentOffset(offset, animated: false)
                self.animateCell(cellIndexPath: IndexPath(item:0, section: 0))
                self.longPress.isEnabled = true
            }
            //  _ = self.tableView.scrollsToTop
        } // if (Path.initialIndexPath!.row != nil) {
        self.savePlist()
    }
    
    //_____________________________
    func  setUptoLast()  {
        self.subListOfTasks.exchangeObject(at: (self.subListOfTasks.count-1),  withObjectAt: Path.initialIndexPath!.row)
        let object1 = self.subListOfTasks[(self.subListOfTasks.count-1)]
        let object2 = self.subListOfTasks[Path.initialIndexPath!.row]
        //DispatchQueue.global(qos: .background).async {
        let index1 = self.listOfTasks.indexOfObjectIdentical(to:  object1)
        let index2 = self.listOfTasks.indexOfObjectIdentical(to:  object2)
        self.listOfTasks.exchangeObject(at: index1,  withObjectAt:index2)
        //__________
        
        if let cell = self.tableView.cellForRow(at: IndexPath(item:(self.subListOfTasks.count - 1), section: 0)) as UITableViewCell? {
            if (My.cellSnapshot != nil) {
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    My.cellSnapshot!.center = (cell.center)
                    My.cellSnapshot!.transform = CGAffineTransform.identity
                    My.cellSnapshot!.alpha = 0.0
                    cell.backgroundColor = UIColor.clear
                    cell.alpha = 1.0
                }, completion: { (finished) -> Void in
                    if finished {
                        Path.initialIndexPath = nil
                        if (My.cellSnapshot != nil) {
                            My.cellSnapshot!.removeFromSuperview()
                        }
                        My.cellSnapshot = nil
                    }
                })
            } //  if (My.cellSnapshot != nil) {
            
        }
        self.tableView.reloadData()
        
        DispatchQueue.main.async {
            
            self.tableView.scrollToRow(at: IndexPath(item:(self.subListOfTasks.count-1), section: 0), at: .bottom, animated: true)
            // self.animateCell(cellIndexPath: IndexPath(item:(self.listOfTasks.count-1), section: 0))
            
            self.longPress.isEnabled = true
        }
        
        self.savePlist()
        
    }
    
    //---------------------
    func snapshotOfCell(inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let cellSnapshot : UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 5.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.borderWidth = 1.0
        
        let dictionary:NSDictionary = self.subListOfTasks.object(at: takedCellPath.row) as! NSDictionary
        
        
        
        //  cgColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [(CGFloat(236.0/255.0)), (CGFloat(246.0/255.0)), (CGFloat(249.0/255.0)), 1.0])!
        // UIColor(red: 236.0/255.0, green: 246.0/255.0, blue: 249.0/255.0, alpha: 1.0).cgColor
        var cellSection = 5
        
        if    let tmpColorNumber:String =  dictionary.object(forKey: "c") as? String
        {
            if
                // let stateCodeString = tmpColorNumber as? String,
                // let stateCode = Int(stateCodeString)
                let stateCode = Int(tmpColorNumber)
            {
                cellSection = stateCode
            }
        } else  {
            let tmpColorNumber:Int = (dictionary.value(forKey: "c") as? Int)!
            cellSection = tmpColorNumber
            if cellSection == 0 {
                cellSection = 5
            }
        }
        
        switch (cellSection) {
        case 1:
            cellSnapshot.layer.shadowColor = UIColor.yellow.cgColor
            cellSnapshot.layer.borderColor = UIColor.yellow.cgColor
            break
        case 2:
            //  cellSnapshot.layer.shadowColor = UIColor.blue.cgColor
            // UIColor(red: 236.0/255.0, green: 246.0/255.0, blue: 249.0/255.0, alpha: 1.0).cgColor
            cellSnapshot.layer.borderWidth = 0.5
            cellSnapshot.layer.shadowColor =  UIColor.blue.cgColor
            cellSnapshot.layer.borderColor =   UIColor.blue.cgColor
            break
        case 3:
            cellSnapshot.layer.shadowColor = UIColor.gray.cgColor
            cellSnapshot.layer.borderColor = UIColor.gray.cgColor
            
            break
        case 4:
            cellSnapshot.layer.shadowColor = UIColor.green.cgColor
            cellSnapshot.layer.borderColor  = UIColor.green.cgColor
            break
        case 5:
            cellSnapshot.layer.shadowColor = UIColor.magenta.cgColor
            cellSnapshot.layer.borderColor = UIColor.magenta.cgColor
            break
        default:
            cellSnapshot.layer.shadowColor = UIColor.yellow.cgColor
            cellSnapshot.layer.borderColor = UIColor.yellow.cgColor
        }
        
        
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
    }
    
    //_____________________________________
    
    @objc func longPressGestureRecognized(_ gestureRecognizer: UIGestureRecognizer) {
        if (self.subListOfTasks.count < 2 ){  return }
        let longPress =  gestureRecognizer as! UILongPressGestureRecognizer
        let state = longPress.state
        let locationInView = longPress.location(in: self.tableView)
        yPosition  =  locationInView.y
        
        
        
        if self.tableView.indexPath(for: self.tableView.visibleCells.last!) != nil{
            
            
            
            height = self.tableView.visibleCells.last!.bounds.height
            
            let statusBarHeight  =  topLayoutGuide.length
            bottomLineToScroll = self.tableView.contentOffset.y + self.tableView.frame.height - height - statusBarHeight - 5
            
            
            topLineToScroll =    self.tableView.contentOffset.y + height
        }
        //------------
        var indexPath = takedCellPath
        if let tmpIndexPath =  self.tableView.indexPathForRow(at: locationInView) {
            
            indexPath = tmpIndexPath
            takedCellPath = tmpIndexPath
            
            switch state {
            case .began:
                
                self.stopTimer()
                if (My.cellSnapshot != nil) {
                    My.cellSnapshot!.removeFromSuperview()
                    My.cellSnapshot = nil
                }
                Path.initialIndexPath = indexPath
                let cell = tableView.cellForRow(at: indexPath) as UITableViewCell?
                cell!.backgroundColor =  UIColor(red: 246.0/255.0, green: 246.0/255.0, blue: 246.0/255.0, alpha: 1.0)
                My.cellSnapshot  = snapshotOfCell(inputView: cell!)
                var center = cell?.center
                My.cellSnapshot!.center = center!
                My.cellSnapshot!.alpha = 0.0
                self.tableView.addSubview(My.cellSnapshot!)
                
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    center?.y = locationInView.y
                    My.cellIsAnimating = true
                    My.cellSnapshot!.center = center!
                    My.cellSnapshot!.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                    My.cellSnapshot!.alpha = 0.98
                    cell?.alpha = 0.0
                }, completion: { (finished) -> Void in
                    if finished {
                        My.cellIsAnimating = false
                        if My.cellNeedToShow {
                            My.cellNeedToShow = false
                            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                                cell?.alpha = 1
                            })
                        } else {
                            cell?.isHidden = true
                        }
                    }
                })
                // }
                
                //  let indexPathToReload = IndexPath(item: indexPath.row, section: 0)
                //     tableView.reloadRows(at: [indexPathToReload], with: .none )
                
                // tableView.reloadData()
                // self.tableView.scrollToRow(at: topVisibleIndexPath, at: .none, animated: true)
                
                
            case .changed:
                
                
                if My.cellSnapshot == nil { return }
                let statusBarHeight  =  topLayoutGuide.length
                let coordinatesOfStausBar =  tableView.contentOffset.y  + statusBarHeight
                let   bottomBarHeight = self.tabBarController?.tabBar.frame.height
                if  (locationInView.y > (self.tableView.contentOffset.y + self.tableView.frame.height -  bottomBarHeight!)) {
                    
                    self.setUptoLast()
                    self.longPress.isEnabled = false
                    return
                    
                }
                
                if (yPosition < coordinatesOfStausBar)  {
                    self.setUptoFirst()
                    gestureRecognizer.isEnabled = false
                    
                    return
                }
                else if ((yPosition > bottomLineToScroll) || (yPosition < topLineToScroll))  {
                    
                    
                    if (indexPath.row != 0) {
                        
                        self.scrollTable()
                        // * return
                    } else {
                        
                        stopTimer()
                        
                    } //  if (indexPath.row != 0)
                    
                }
                
                
                
                
                if ( My.cellSnapshot != nil) {
                    var center = My.cellSnapshot!.center
                    if !(yPosition < topLineToScroll) {
                        
                        center.y = locationInView.y
                        My.cellSnapshot!.center = center
                    }
                    
                }
                
                
                
                if  (indexPath != Path.initialIndexPath)   {
                    if ( Path.initialIndexPath != nil)  {
                        self.subListOfTasks.exchangeObject(at: indexPath.row,  withObjectAt: Path.initialIndexPath!.row)
                        tableView.reloadData()
                        let object1 = self.subListOfTasks[indexPath.row]
                        let object2 = self.subListOfTasks[Path.initialIndexPath!.row]
                        //DispatchQueue.global(qos: .background).async {
                        let index1 = self.listOfTasks.indexOfObjectIdentical(to:  object1)
                        let index2 = self.listOfTasks.indexOfObjectIdentical(to:  object2)
                        self.listOfTasks.exchangeObject(at: index1,  withObjectAt:index2)
                        
                        
                        
                        /*
                         tableView.beginUpdates()
                         tableView.reloadRows(at:  tableView.indexPathsForVisibleRows!, with: .fade)
                         tableView.endUpdates()
                         */
                        
                        
                        /*
                         var indexPathToReload = IndexPath(item: Path.initialIndexPath!.row, section: 0)
                         tableView.reloadRows(at: [indexPathToReload], with: .fade )
                         
                         
                         indexPathToReload = IndexPath(item: indexPath.row, section: 0)
                         tableView.reloadRows(at: [indexPathToReload], with:  .fade  )
                         */
                        
                        
                        
                        
                        
                        
                        
                        
                        Path.initialIndexPath = indexPath
                        
                    }
                }
                
            default:
                self.stopTimer()
                if (Path.initialIndexPath != nil) {
                    if let cell = tableView.cellForRow(at: Path.initialIndexPath!) as UITableViewCell?  {
                        let cellToAnnimatePath = Path.initialIndexPath!
                        if My.cellIsAnimating {
                            My.cellNeedToShow = true
                        } else {
                            cell.isHidden = false
                            cell.alpha = 0.0
                        }
                        
                        if  (My.cellSnapshot != nil) {
                            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                                My.cellSnapshot!.center = (cell.center)
                                My.cellSnapshot!.transform = CGAffineTransform.identity
                                My.cellSnapshot!.alpha = 0.0
                                cell.backgroundColor = UIColor.clear
                                cell.alpha = 1.0
                                
                                
                            }, completion: { (finished) -> Void in
                                if finished {
                                    Path.initialIndexPath = nil
                                    
                                    if  (My.cellSnapshot != nil) {
                                        My.cellSnapshot!.removeFromSuperview()
                                    }
                                    My.cellSnapshot = nil
                                    
                                }
                            })
                        } // cell != nil
                        
                        self.animateCell(cellIndexPath: cellToAnnimatePath)
                    }// if let cell = tableView.cellForRow(at: Path.initialIndexPath!) as UITableViewCell!
                    //let topPosition =   0 - (self.topLayoutGuide.length)
                    if (scroolingTOtop)
                    {
                        DispatchQueue.main.async {
                            Path.initialIndexPath = nil
                            if  (My.cellSnapshot != nil) {
                                My.cellSnapshot!.removeFromSuperview()
                            }
                            My.cellSnapshot = nil
                            let topindexPath = IndexPath(row: 0, section: 0)
                            self.tableView.scrollToRow(at: topindexPath, at: .top, animated: true)
                            self.scroolingTOtop = false
                        }
                        
                    }
                    
                    
                    
                } // != nil
                //  savePlist()
                
                Path.initialIndexPath = nil
                
                if  (My.cellSnapshot != nil) {
                    My.cellSnapshot!.removeFromSuperview()
                }
                My.cellSnapshot = nil
                
                self.savePlist()
                //case .ended:   break
                // case .cancelled:  break
                // case .failed:  break
                
                
            } // END SWITCH STATE
            
            
        } else {
            self.stopTimer()
            
            
            
            //the point didn't map back to a cell! Maybe it was on the header or footer?
            //Handle this case differently.
            if  (locationInView.y > self.tableView.contentSize.height ) {
                self.setUptoLast()
                self.longPress.isEnabled = false
                
                return
            }
            
            
            
            
            if ((locationInView.y > 30) || (locationInView.y < height)) {
                
                
                
                
                if ((takedCellPath.row ==  (subListOfTasks.count - 1))||(takedCellPath.row ==  0)) {
                    let cell = self.tableView.cellForRow(at: takedCellPath) as UITableViewCell?
                    if My.cellIsAnimating {
                        My.cellNeedToShow = true
                    } else {
                        cell?.isHidden = false
                        cell?.alpha = 0.0
                    }
                    tableView.reloadData()
                    
                    if (My.cellSnapshot != nil) {
                        UIView.animate(withDuration: 0.25, animations: { () -> Void in
                            My.cellSnapshot!.center = (cell?.center)!
                            My.cellSnapshot!.transform = CGAffineTransform.identity
                            My.cellSnapshot!.alpha = 0.0
                            cell?.backgroundColor = UIColor.clear
                            cell?.alpha = 1.0
                        }, completion: { (finished) -> Void in
                            if finished {
                                Path.initialIndexPath = nil
                                if (My.cellSnapshot != nil) {
                                    My.cellSnapshot!.removeFromSuperview()
                                }
                                My.cellSnapshot = nil
                                
                            }
                        })
                    } //  if (My.cellSnapshot != nil) {
                }
                
                self.savePlist()
            } //  if (locationInView.y > 30)
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       //print("1 viewDidLoad")
        
        self.automaticallyAdjustsScrollViewInsets = false;
        tableView.contentInset = UIEdgeInsets.zero
        tableView.scrollIndicatorInsets = UIEdgeInsets.zero
        //   tableView.contentOffset = CGPointMake(0.0, 0.0)
        
        
        if #available(iOS 11.0, *) {
            // Running iOS 11 OR NEWER
            
        } else {
            // Earlier version of iOS
            self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
            
        }
        
        
        
        
        
        //  imageView.frame(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.image   = UIImage(named: "listenter5")
        
        imageView.transform  = imageView.transform.inverted()
        //   imageView.transform  = imageView.transform.rotated(by: CGFloat(Double.pi / 2))
        // UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        
        
        //let newImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        
        // you will probably want to set the font (remember to use Dynamic Type!)
        //  labelEnter.font = UIFont.preferredFont(forTextStyle: .footnote)
        
        // and set the text color too - remember good contrast
        //  labelEnter.textColor =  UIColor(red: 254.0/255.0, green: 248.0/255.0, blue: 236.0/255.0, alpha: 1.0)
        // UIColor.yellow
        //.yellow
        
        // may not be necessary (e.g., if the width & height match the superview)
        // if you do need to center, CGPointMake has been deprecated, so use this
        // label.center = CGPoint(x: 160, y: 284)
        
        // this changed in Swift 3 (much better, no?)
        // labelEnter.textAlignment = .center
        
        //  labelEnter.text = "▶"
        
        
        
        
        
        
        
        
        textField1.leftView = imageView
        textField1.leftViewMode = .always
        
        //  self.tableView.tableHeaderView?.frame.height = 44.0
        
        
        self.tableView.tableHeaderView = textField1
        textField1.delegate = self
        // youTextFiled.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        
        
        
        if #available(iOS 11.0, *) {
            // Running iOS 11 OR NEWER
            let  guide: UILayoutGuide = self.tableView.safeAreaLayoutGuide
            textField1.translatesAutoresizingMaskIntoConstraints = false
            
            
            
            textField1.leftAnchor.constraint(equalTo: guide.leftAnchor).isActive = true
            textField1.rightAnchor.constraint(equalTo: guide.rightAnchor).isActive = true
            
        }
        
        self.tableView.tableHeaderView?.layoutIfNeeded()
        self.tableView.keyboardDismissMode = .onDrag
        longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized(_:)))
        self.tableView.addGestureRecognizer(longPress)
    }
    
    
    //_________________________________________
    
    func animateTable() {
        
        self.tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            
            index += 1
        }
    }
    
    //_________________________________________
    
    func savePlist() {
       //print("2 savePlist")
        let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let destPath = (dir as NSString).appendingPathComponent("tasks.plist")
        self.tasks.write(toFile: destPath, atomically: true)
    }
    //_________________________________________
    
    func saveNewTask() {
        if (self.task == "")  {
            return
        }
        let Prioritet = self.listOfTasks.count + 1
        self.colorNumber = 5
        let dictionary:NSDictionary = ["t" : self.task, "c" : self.colorNumber, "p" : Prioritet]
        self.subListOfTasks.insert(dictionary, at: 0)
        self.listOfTasks.insert(dictionary, at: 0)
        let indexPath =  NSIndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.fade)
        savePlist()
        
        
        /*
        // проверка на   на "бай"
        if (!KUPLEN){
            //let tasks = NSLocalizedString("tasks", comment: "tasks")
            if (self.task.lowercased().range(of:"tasks")  != nil) {
                // self.BuyButtonPressed(self)
                let  alert = UIAlertController(title: title4, message: message4, preferredStyle: UIAlertControllerStyle.alert)
                
                
                
                let dismiss = UIAlertAction(title: title5, style: UIAlertActionStyle.default, handler: nil)
                
               
                
                let restoreAction  = UIAlertAction(title: title6, style: UIAlertActionStyle.default) { _ in
                    //self.BuyButtonPressed(self)
                    if (self.PaymentsCanBeProcessed()) {
                        //print("Restoration")
                        SKPaymentQueue.default().restoreCompletedTransactions()
                        
                    }
                    
                }
                let buyAction  = UIAlertAction(title: titleBuyNow, style: UIAlertActionStyle.default) { _ in
                    self.BuyButtonPressed(self)
                }
                alert.addAction(dismiss)
                alert.addAction(restoreAction)
                alert.addAction(buyAction)
                self.present(alert, animated: true, completion: nil)
                
                
            }
            
            ChisloZagruzok()
        } //  if (!KUPLEN){
        */
    }
    
    //_________________________________________
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! tableCell
        cell.cellTextField.isEnabled = true
        cell.cellTextField.delegate = self
        
        cell.cellTextField.isUserInteractionEnabled = true
        
    }
    //__________________________________
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! tableCell
        //let dictionary:NSDictionary = self.listOfTasks.object(at: indexPath.row) as! NSDictionary
        let dictionary:NSDictionary = self.subListOfTasks.object(at: indexPath.row) as! NSDictionary
        
        var cellContent: String = ""
        if let  cellContent2:String = dictionary.object(forKey: "t") as? String {
            cellContent  = cellContent2
        }
        cell.cellTextField.text  = cellContent
        cell.cellTextField.delegate = self
        cell.cellButton.setImage(UIImage(named: "applelist5"), for: .normal)
        var cellSection = 5
        
        if    let tmpColorNumber:String =  dictionary.object(forKey: "c") as? String
        {
            if
                // let stateCodeString = tmpColorNumber as? String,
                // let stateCode = Int(stateCodeString)
                let stateCode = Int(tmpColorNumber)
            {
                cellSection = stateCode
            }
        } else  {
            let tmpColorNumber:Int = (dictionary.value(forKey: "c") as? Int)!
            cellSection = tmpColorNumber
            if cellSection == 0 {
                cellSection = 5
            }
        }
        
        switch (cellSection) {
        case 1:
            // cell.cellImage.image = UIImage(named:"applelist2")
            cell.cellButton.setImage(UIImage(named: "applelist1"), for: .normal)
            
        case 2:
            // cell.cellImage.image = UIImage(named:"applelist2")
            cell.cellButton.setImage(UIImage(named: "applelist2"), for: .normal)
            break
        case 3:
            //  cell.cellImage.image = UIImage(named:"applelist3")
            cell.cellButton.setImage(UIImage(named: "applelist3"), for: .normal)
            break
        case 4:
            //  cell.cellImage.image = UIImage(named:"applelist4")
            cell.cellButton.setImage(UIImage(named: "applelist4"), for: .normal)
            break
        case 5:
            // cell.cellImage.image = UIImage(named:"applelist5")
            cell.cellButton.setImage(UIImage(named: "applelist5"), for: .normal)
            break
            
        case 6:
            // cell.cellImage.image = UIImage(named:"applelist1")
            cell.cellButton.setImage(UIImage(named: "listenter1"), for: .normal)
            break
        case 7:
            // cell.cellImage.image = UIImage(named:"applelist2")
            cell.cellButton.setImage(UIImage(named: "listenter2"), for: .normal)
            break
        case 8:
            //  cell.cellImage.image = UIImage(named:"applelist3")
            cell.cellButton.setImage(UIImage(named: "listenter3"), for: .normal)
            break
        case 9:
            //  cell.cellImage.image = UIImage(named:"applelist4")
            cell.cellButton.setImage(UIImage(named: "listenter4"), for: .normal)
            break
        case 10:
            // cell.cellImage.image = UIImage(named:"applelist5")
            cell.cellButton.setImage(UIImage(named: "listenter5"), for: .normal)
            break
        default:
            // cell.cellImage.image = UIImage(named:"applelist1")
            cell.cellButton.setImage(UIImage(named: "applelist5"), for: .normal)
        }
        
        
        
        
        // let bgColorView = UIView()
        // bgColorView.backgroundColor = UIColor.red
        // cell.selectedBackgroundView = bgColorView
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    /*
     override func tableView(_ tableView: UITableView,
     editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle  {
     
     return .none // UITableViewCellEditingStyleNone
     }
     
     override func tableView(_ tableView: UITableView,
     shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
     
     return false
     }
     */
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // Delete the row from the data source
            let dictionary:NSDictionary = self.subListOfTasks.object(at: indexPath.row) as! NSDictionary
            
            self.tableView.beginUpdates()
            self.listOfTasks.remove(dictionary)
            self.subListOfTasks.removeObject(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.endUpdates()
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        // сохранение
        let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let destPath = (dir as NSString).appendingPathComponent("tasks.plist")
        self.tasks.write(toFile: destPath, atomically: true)
    }
    
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle
    {
        return .none
    }
    
    //___________________
    
    @IBAction func appleButtonPressed(_ sender: AnyObject) {
        
        guard let cell = sender.superview??.superview as? tableCell else {
               self.editedIndexPath =   IndexPath(row: 0, section: 0)
            return // or fatalError() or whatever
        }
        // self.tableView.contentView
        //  let indexPath = sender.indexPath(for: cell)
        let indexPath = self.tableView.indexPath(for: cell)
        
        self.editedIndexPath = indexPath!
        self.myTextFieldShouldReturn(textField: cell.cellTextField)
        
        guard let button = sender  as? UIButton else {
            return // or fatalError() or whatever
        }
        let dictionary:NSDictionary = self.subListOfTasks.object(at:  indexPath!.row) as! NSDictionary
        self.colorNumber = 5
        guard let tmpColorNumber =  dictionary.object(forKey: "c") else {
            return // or fatalError() or whatever
        }
        
        if
            
            let stateCodeString = tmpColorNumber as? String,
            let stateCode = Int(stateCodeString)
        {
            // do something with your stateCode
            self.colorNumber = stateCode
        }
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idSelectColor") as? SelectColorViewController
        controller?.colorNumber = self.colorNumber
        
        controller?.preferredContentSize = CGSize(width: 300, height: 49)
        
        controller?.modalPresentationStyle = UIModalPresentationStyle.popover
        
        let popController = controller?.popoverPresentationController
        popController?.permittedArrowDirections = .any
        
        
        
        popController?.delegate = self
        popController?.sourceView   = button
        
        popController?.sourceRect =  button.bounds
        
        self.present(controller!, animated: true, completion: nil)
        
        
        
        indexPathRowToChngeColor = indexPath!.row
        
       //print("Function: \(#function), line: \(#line) indexPathRowToChngeColor = \(indexPathRowToChngeColor)")
        
        
    }
    
    
    
    //___________________
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
    //___________________
    
    
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        selectColorViewController = popoverPresentationController.presentedViewController as? SelectColorViewController
        self.colorNumber = (selectColorViewController?.colorNumber)!
        //print("popoverPresentationControllerDidDismissPopover self.colorNumber self.colorNumber=\(self.colorNumber)")
        var dictionary = NSMutableDictionary()
        let tmpDictionary:NSDictionary = self.subListOfTasks.object(at: indexPathRowToChngeColor)  as!  NSDictionary
        dictionary = tmpDictionary.mutableCopy() as! NSMutableDictionary
        let TmpKey: String = "c"
        let TmpValue: String = String(self.colorNumber)
        if TmpKey != "" && TmpValue != "" {
           //print("test 1391")
            dictionary[TmpKey] = TmpValue
            
        }
 //self.subListOfTasks[indexPathRowToChngeColor]  = dictionary
 self.updateTask(row: indexPathRowToChngeColor, updetedTask:"", updatedImageNumber: self.colorNumber)
       // let indexPath = IndexPath(item: indexPathRowToChngeColor, section: 0)
        // tableView.reloadRows(at: [indexPath], with: .left)
        self.filterContent()
        tableView.reloadData()
         //self.savePlist()
    }
    
    
    //___________________
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
        //print("188 moveRowAt")
        // let itemToMove = self.subListOfTasks[fromIndexPath.row]
        //print(itemToMove)
        //print("_____1_____", self.listOfHistory)
        self.tableView.beginUpdates()
        self.subListOfTasks.exchangeObject(at: to.row,  withObjectAt: fromIndexPath.row)
        self.tableView.endUpdates()
        self.tableView.reloadData()
        
        let object1 = self.subListOfTasks[to.row]
        let object2 = self.subListOfTasks[fromIndexPath.row]
        //DispatchQueue.global(qos: .background).async {
        let index1 = self.listOfTasks.indexOfObjectIdentical(to:  object1)
        let index2 = self.listOfTasks.indexOfObjectIdentical(to:  object2)
        self.listOfTasks.exchangeObject(at: index1,  withObjectAt:index2)
        
        
        // сохранение
        let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let destPath = (dir as NSString).appendingPathComponent("tasks.plist")
        self.tasks.write(toFile: destPath, atomically: true)
        
        
        // self.listOfTasks.exchangeObject(at: to.row,  withObjectAt: fromIndexPath.row)
        
        
    }
    
    
    //_________________________________________
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //_________________________________________
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       //print("1 viewWillDisappear")
        savePlist()
    }
    
    
    //_________________________________________
    
    override func viewDidAppear(_ animated: Bool) {
       //print("1 viewDidAppear")
        let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let destPath = (dir as NSString).appendingPathComponent("tasks.plist")
        let dict = NSMutableDictionary(contentsOfFile: destPath)
        self.tasks = dict!
        self.listOfTasks = self.tasks.object(forKey: "tasks") as! NSMutableArray
        filterContent()
        tableView.reloadData()
        
        /*
        //_____________________
        if (!self.KUPLEN) {
            if let tmpString = UserDefaults.standard.string(forKey:"KupitIliVosstanovit"){
                self.KupitIliVosstanovit = tmpString
            }
            
            
            if ( KupitIliVosstanovit == "KUPLEN") {
                self.KUPLEN = true
                return
            }
            
            if (KupitIliVosstanovit == "KupitIliVosstanovit") {
                self.BuyButtonPressed(self)
            } else  {
                self.ChisloZagruzok()
            } // (KupitIliVosstanovit == "KupitIliVosstanovit")
        } //  if (!KUPLEN) {
 */
    }
    
    //_________________________________________
    
    override func viewWillAppear(_ animated: Bool) {
        //print("1 viewWillAppear")
        super.viewWillAppear(true)
        let backgroundImage = UIImage(named: "apple")
        let imageView = UIImageView(image: backgroundImage)
         imageView.alpha = 0.2
        
        self.tableView.backgroundView = imageView
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        imageView.contentMode = .scaleAspectFit
        let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let destPath = (dir as NSString).appendingPathComponent("tasks.plist")
        let dict = NSMutableDictionary(contentsOfFile: destPath)
        self.tasks = dict!
        self.listOfTasks = self.tasks.object(forKey: "tasks") as! NSMutableArray
        filterContent()
        tableView.reloadData()
        
        if (My.cellSnapshot != nil) {
            My.cellSnapshot!.removeFromSuperview()
            My.cellSnapshot = nil
        }
    }
    
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        // return listOfTasks.count
        return subListOfTasks.count
    }
    
    
    // UITextField Delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
       //print("textFieldDidBeginEditing")
        
        self.lastEditedColor = self.colorNumber
    }
    
    //___________________________________________
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       //print("1208 textFieldDidEndEditing")
        guard let  cell = textField.superview?.superview as? tableCell  else {
            return  // or fatalError() or whatever
        }
        guard let indexPathToReload = self.tableView.indexPath(for: cell) else {
            return  // or fatalError() or whatever
        }
        
        
        self.task = textField.text!
        if (textField == self.textField1) {
            saveNewTask()
            textField.text =  ""
        }
        else {
           //print("1 (#line)  textField = \(String(describing: textField.text))")
            
        }
        
       //print("2   1111 textFieldDidEndEditing self.lastEditedColor= \(self.lastEditedColor)")
        
        
        //let object1 = self.subListOfTasks[indexPathToReload.row]
        //let index1 = self.listOfTasks.indexOfObjectIdentical(to: object1)
       //print("1232  index1 = \(index1)")
        
        
        self.updateTask(row:  indexPathToReload.row, updetedTask: self.task, updatedImageNumber: self.lastEditedColor)
        
        
       //print("2 1229 ")
        
        self.tableView.reloadRows(at: [indexPathToReload], with: .middle  )
       //print("2 1232  ")
    }
    
    //___________________________________________
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
       //print("1 textFieldShouldEndEditing")
        if #available(iOS 8.2, *) {
            textField.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        } else {
            textField.font = UIFont.systemFont(ofSize: 17.0)
        }
        return true;
    }
    //___________________________________________
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
       //print("1 textFieldShouldClear")
        return true;
    }
    //___________________________________________
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
       //print("1 textFieldShouldBeginEditing START")
        if #available(iOS 8.2, *) {
            textField.font = UIFont.systemFont(ofSize: 19, weight: UIFont.Weight.medium)
        } else {
            // Fallback on earlier versions
            textField.font = UIFont.boldSystemFont(ofSize: 19.0)
        }
        
        
        guard let  cell = textField.superview?.superview as? tableCell  else {
               self.editedIndexPath =   IndexPath(row: 0, section: 0)
            return true // or fatalError() or whatever
        }
       //print("1 textFieldShouldBeginEditing \(#line)")
        if let indexPath = self.tableView.indexPath(for: cell)    {
           //print("1 textFieldShouldBeginEditing \(#line)")
            self.editedIndexPath = indexPath
           //print("1 textFieldShouldBeginEditing \(#line)")
            cell.cellButton.setImage(UIImage(named: "listenter5"), for: .normal)
            self.colorNumber = 5
           //print("1 textFieldShouldBeginEditing \(#line)")
            
            
        }
        
        
        
        
        return true
    }
    
    //____________________________
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    //___________________________________
    func updateTask(row:Int, updetedTask:String,  updatedImageNumber: Int)  {
       //print("updateTask")
        let object1 = self.subListOfTasks[row]
        let index1 = self.listOfTasks.indexOfObjectIdentical(to: object1)
       //print("index1 = \(index1)")
        
        var dictionary = NSMutableDictionary()
        var dictionary2 = NSMutableDictionary()
        
        
        let tmpDictionary:NSDictionary  =  self.subListOfTasks.object(at: row) as!  NSDictionary
        
        
       //print("1331 tmpDictionary = \(tmpDictionary)")
        
        let tmpDictionary2:NSDictionary  =  self.listOfTasks.object(at: index1) as!  NSDictionary
        
        
        
       //print("2 1571 tmpDictionary = \(tmpDictionary)  ")
       //print("2 1332 tmpDictionary2 = \(tmpDictionary2)  ")
       //print("1203 updateTask updatedImageNumber= \(updatedImageNumber)")
        
        dictionary = tmpDictionary.mutableCopy() as! NSMutableDictionary
        
        dictionary2 =  tmpDictionary2.mutableCopy() as! NSMutableDictionary
        
        if (updetedTask != "")   {
            //print("_ 1568")
            let TmpKey: String = "t"
            let TmpValue: String = updetedTask
            if TmpKey != "" && TmpValue != "" {
                dictionary[TmpKey] = TmpValue
                dictionary2[TmpKey] = TmpValue
            }
            self.subListOfTasks[row]  = dictionary
            self.listOfTasks[index1]  = dictionary
            let indexPath = IndexPath(item: row, section: 0)
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        if ((updatedImageNumber > 0)&&(updatedImageNumber <  11))  {
            let TmpKey: String = "c"
            let TmpValue: String = String(updatedImageNumber)
            if TmpKey != "" && TmpValue != "" {
                dictionary[TmpKey] = TmpValue
                dictionary2[TmpKey] = TmpValue
            }
            self.subListOfTasks[row]  = dictionary
            self.listOfTasks[index1]  = dictionary
            
        }
        ////print("self.listOfTasks[\(row)] = \(self.listOfTasks[row])  ")
        
        savePlist()
    }
    
    //___________________________________
    func myTextFieldShouldReturn(textField: UITextField)  {
        textField.resignFirstResponder()
    
         self.task = textField.text!
        //print("1585 self.task = \(self.task)")
         if (textField == self.textField1) {
         saveNewTask()
         textField.text =  ""
         }
         
         self.updateTask(row: editedIndexPath.row, updetedTask:self.task, updatedImageNumber: self.colorNumber)
      
        self.animateCell(cellIndexPath: editedIndexPath)
    }
    //___________________________________
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        if (textField == self.textField1) {
            self.myTextFieldShouldReturn(textField: self.textField1)
        } else {
            self.myTextFieldShouldReturn(textField: textField)
        }
        return true
    }
    //___________________________________

    
    
} // The End

