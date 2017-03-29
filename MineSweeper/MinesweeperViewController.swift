// game view controller

import UIKit


class MinesweeperViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var inputErrorMessageLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var numRowsTextField: UITextField!
    @IBOutlet weak var numColumnsTextField: UITextField!

    var numberOfRows = 0
    var numberOfColumns = 0
    let maxNumberOfRows = 15
    let maxNumberOfColumns = 10
    let gapBetweenTiles = 2.0
    var mineModel = MineSweeperModel()
    var widthOfATile = 0.0
    var coverMatrix = [[UIView]]()
    var tagToIndex = [index]()
    var tileMatrix = [[UIView]]()
    
    struct index {
        let row: Int
        let column: Int
    }
    
    func makeButton(x: Double, y: Double, widthHeight: Double) -> UIButton {
        let button = UIButton(type: .roundedRect)
        button.frame = CGRect(x: x, y: y, width: widthHeight, height: widthHeight)
        button.backgroundColor = UIColor.orange
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        return button
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.alpha = 0
        numRowsTextField.delegate = self
        numColumnsTextField.delegate = self
        inputErrorMessageLabel.textColor = UIColor.orange
        
    }

    
    func updateTiles(tiles: [[TileAttributes]]) {
        let frame = view.frame
        widthOfATile = (Double(frame.size.width) - 2 * gapBetweenTiles) / (Double(numberOfColumns) + gapBetweenTiles)
        var i = 0
        var j = 0
        var tag = 0
        for row in tiles {
            let y = (widthOfATile + gapBetweenTiles) * Double(row[0].row) + 40.0
            j = 0
            var rowMatrix = [UIView]()
            var trowMatrix = [UIView]()
            for column in row {
                let x = (widthOfATile + gapBetweenTiles) * Double(column.column) + gapBetweenTiles
                if column.tiles[0] == TileType.MineTile {
                    let mineView = MineView(frame: CGRect(x: x, y: y, width: widthOfATile, height: widthOfATile))
                    mineView.backgroundColor = UIColor.white
                    mineView.layer.shadowColor = UIColor.black.cgColor
                    mineView.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
                    mineView.layer.shadowRadius = 5
                    mineView.layer.shadowOpacity = 1.0
                    view.addSubview(mineView)
                    trowMatrix.append(mineView)
                } else {
                    //let numberView = NumberView(frame:CGRect(x: x, y: y, width: widthOfATile, height: widthOfATile))
                    let numberView = makeButton(x: x, y: y, widthHeight: widthOfATile)
                    numberView.backgroundColor = UIColor.white
                    numberView.layer.shadowColor = UIColor.black.cgColor
                    numberView.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
                    numberView.layer.shadowRadius = 5
                    numberView.layer.shadowOpacity = 1.0
                    numberView.setTitle(String(column.numLocalMines), for: .normal)
                    numberView.tag = -1
                    view.addSubview(numberView)
                    trowMatrix.append(numberView)
                }
                let button = makeButton(x: x, y: y, widthHeight: widthOfATile)
                button.layer.shadowColor = UIColor.black.cgColor
                button.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
                button.layer.shadowRadius = 5
                button.layer.shadowOpacity = 1.0
                button.tag = tag
                tagToIndex.append(index(row: i, column: j))
                tag += 1
                view.addSubview(button)
                rowMatrix.append(button)
                j += 1
            
            }
            i += 1
            coverMatrix.append(rowMatrix)
            tileMatrix.append(trowMatrix)
        }
    }
    

    
    @IBAction func didTapStartButton(_ sender: UIButton) {
        print("Did tap the start button.")
        sender.isEnabled = false
        let tiles = mineModel.startGameWith(rows: numberOfRows, columns: numberOfColumns)
        updateTiles(tiles: tiles)
        
    }
    
    func zerosInNeighborhood(row: Int, column: Int) {
        // check local neighborhood of the tile (the 8 tiles touching it) counting
        // the number of mines in the neighborhood and returning that number
        var ZeroQ = [TileAttributes]()
        ZeroQ.append(mineModel.tiles[row][column])
        while(!ZeroQ.isEmpty){
            let currentTile = ZeroQ.removeFirst()
            let i = currentTile.row
            let j = currentTile.column
            if j != 0 && mineModel.tiles[i][j-1].numLocalMines == 0 && mineModel.tiles[i][j-1].tiles.count > 1{
                coverMatrix[i][j-1].removeFromSuperview()
                ZeroQ.append(mineModel.tiles[i][j-1])
                mineModel.tiles[i][j-1].tiles.removeLast()
            }
            if i != 0 && j != 0 && mineModel.tiles[i-1][j-1].numLocalMines == 0 && mineModel.tiles[i-1][j-1].tiles.count > 1 {
                coverMatrix[i-1][j-1].removeFromSuperview()
                ZeroQ.append(mineModel.tiles[i-1][j-1])
                mineModel.tiles[i-1][j-1].tiles.removeLast()
            }
            if i != 0 && mineModel.tiles[i-1][j].numLocalMines == 0 && mineModel.tiles[i-1][j].tiles.count > 1{
                coverMatrix[i-1][j].removeFromSuperview()
                ZeroQ.append(mineModel.tiles[i-1][j])
                mineModel.tiles[i-1][j].tiles.removeLast()
            }
            if i != 0 && j != (numberOfColumns-1) && mineModel.tiles[i-1][j+1].numLocalMines == 0 && mineModel.tiles[i-1][j+1].tiles.count > 1{
                coverMatrix[i-1][j+1].removeFromSuperview()
                ZeroQ.append(mineModel.tiles[i-1][j+1])
                mineModel.tiles[i-1][j+1].tiles.removeLast()
            }
            if j != (numberOfColumns-1) && mineModel.tiles[i][j+1].numLocalMines == 0 && mineModel.tiles[i][j+1].tiles.count > 1{
                coverMatrix[i][j+1].removeFromSuperview()
                ZeroQ.append(mineModel.tiles[i][j+1])
                mineModel.tiles[i][j+1].tiles.removeLast()
            }
            if i != (numberOfRows-1) && j != (numberOfColumns-1) && mineModel.tiles[i+1][j+1].numLocalMines == 0 && mineModel.tiles[i+1][j+1].tiles.count > 1{
                coverMatrix[i+1][j+1].removeFromSuperview()
                ZeroQ.append(mineModel.tiles[i+1][j+1])
                mineModel.tiles[i+1][j+1].tiles.removeLast()
                
            }
            if i != (numberOfRows-1) && mineModel.tiles[i+1][j].numLocalMines == 0 && mineModel.tiles[i+1][j].tiles.count > 1{
                coverMatrix[i+1][j].removeFromSuperview()
                ZeroQ.append(mineModel.tiles[i+1][j])
                mineModel.tiles[i+1][j].tiles.removeLast()
            }
            if i != (numberOfRows-1) && j != 0 && mineModel.tiles[i+1][j-1].numLocalMines == 0 && mineModel.tiles[i+1][j-1].tiles.count > 1{
                coverMatrix[i+1][j-1].removeFromSuperview()
                ZeroQ.append(mineModel.tiles[i+1][j-1])
                mineModel.tiles[i+1][j-1].tiles.removeLast()
            }
        }
    }
    
    func revealAllTiles(){
        for i in 0..<numberOfRows{
            for j in 0..<numberOfColumns{
                if (mineModel.tiles[i][j].tiles.count > 1){
                    coverMatrix[i][j].removeFromSuperview()
                }
            }
        }
    }
    
    func hasWon() -> Bool{
        for i in 0..<numberOfRows{
            for j in 0..<numberOfColumns{
                if (mineModel.tiles[i][j].tiles[0] == TileType.NumberTile && mineModel.tiles[i][j].tiles.count > 1){
                    return false
                }
            }
        }
        return true
    }
    
    
    func gameOver(messege: String){
        // reveal all tiles
        // show messege and reset button
        // show messgebutton
        revealAllTiles()
        
        let alertController = UIAlertController(title: messege, message: "Hit OK to reset", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            let x = self.view.bounds.width - 100
            let y = self.view.bounds.height - 100
            let resetButton = self.makeButton(x: Double(x), y: Double(y), widthHeight: 100)
            resetButton.setTitle("Reset", for: .normal)
            resetButton.tag = -2
            self.view.addSubview(resetButton)
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { action in
            // clear out the number and mine tiles
            for i in 0..<self.numberOfRows{
                for j in 0..<self.numberOfColumns{
                    self.tileMatrix[i][j].removeFromSuperview()
                }
            }
            // reset the data structures and mine model
            self.mineModel = MineSweeperModel()
            self.coverMatrix = [[UIView]]()
            self.tagToIndex = [index]()
            self.tileMatrix = [[UIView]]()
            // reveal the text fields for rows and columns
            self.numRowsTextField.isEnabled = true
            self.numColumnsTextField.isEnabled = true
            self.numRowsTextField.alpha = 1
            self.numColumnsTextField.alpha = 1
            self.startButton.isEnabled = true
            self.startButton.alpha = 0
           
            
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true) {
            // ...
        }
    }
    
    
    func didTapButton(_ button: UIButton) {
        if button.tag >= 0{
            let index = tagToIndex[button.tag]
            let i = index.row
            let j = index.column
            if mineModel.tiles[i][j].tiles[0] == TileType.MineTile{
                // player clicked on the mine, game over
                gameOver(messege: "You Lose")
                // show messege and reset button
                // player clicked on the mine, game over
            }else if mineModel.tiles[i][j].tiles[0] == TileType.NumberTile{
                button.removeFromSuperview()
                if (mineModel.tiles[i][j].tiles.count > 1){
                    mineModel.tiles[i][j].tiles.removeLast()
                }
                // check to see if it is a 0 tile or not
                if mineModel.tiles[i][j].numLocalMines == 0{
                    // reveal all tiles in 0 neighborhood
                    zerosInNeighborhood(row: i, column: j)
                }else{
                    if(hasWon()){
                        gameOver(messege: "You Win!")
                    }
                }
            }
        } else if button.tag == -2{
            button.isHidden = true
            gameOver(messege: "Hit OK to reset the game")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// TextField delegates
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        inputErrorMessageLabel.text = ""
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        inputErrorMessageLabel.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
        if let text = numRowsTextField.text, let value = Int(text) {
            if value > maxNumberOfRows {
                inputErrorMessageLabel.text = "Rows should be less than \(maxNumberOfRows). Try again."
                return false
            }
            numberOfRows = value
        }
        
        if let text = numColumnsTextField.text, let value = Int(text) {
            if value > maxNumberOfColumns {
                inputErrorMessageLabel.text = "Columns should be less than \(maxNumberOfColumns). Try again."
                return false
            }
            numberOfColumns = value
        }

        textField.resignFirstResponder()
        print("Rows = \(numberOfRows) columns = \(numberOfColumns)")
        if numberOfRows > 0 && numberOfColumns > 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.numRowsTextField.alpha = 0.0
                self.numColumnsTextField.alpha = 0.0
            }, completion: { _ in
                UIView.animate(withDuration: 0.5, animations: {
                    self.startButton.alpha = 1.0
                }, completion: { _ in })
            })
        }
        numRowsTextField.isEnabled = false
        numColumnsTextField.isEnabled = false
        return true
    }
}
