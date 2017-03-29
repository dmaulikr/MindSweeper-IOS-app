// Model for game

import UIKit

enum TileType {
    case NumberTile
    case FlagTile
    case CoverTile
    case MineTile
}

struct TileAttributes {
    let row: Int
    let column: Int
    var tiles: [TileType]
    var numLocalMines: Int
}

private var percentageOfMines: UInt32 = 5

class MineSweeperModel: NSObject {

    private var rows = 0
    private var columns = 0
    private var numMines = 0
    
    var tiles = [[TileAttributes]]()
    
    func startGameWith(rows: Int, columns: Int) -> [[TileAttributes]]{
        self.rows = rows
        self.columns = columns
        if rows > 5 && columns > 5{
            percentageOfMines = 10
        }else if rows > 10 && columns > 5{
            percentageOfMines = 15
        }
        for row in 0..<rows {
            var tileRow = [TileAttributes]() // Create a one-dimensional array
            for column in 0..<columns {
                tileRow.append(createTile(row: row, column: column)) // Create either a NumberTile or a MineTile.
                tileRow[column].tiles.append(.CoverTile)             // Cover it with a CoverTile.
            }
            tiles.append(tileRow)  // add the one-dimensional array into another array as an element.
        }
        
        for i in 0..<rows {
            for j in 0..<columns {
                tiles[i][j].numLocalMines = minesInNeighborhood(row: i, column: j, maxRow: rows-1, maxColumn: columns-1)
            }
        }
        return tiles
    }
    
    func createTile(row: Int, column: Int) -> TileAttributes {
        let aMine = arc4random_uniform(99) + 1
        if aMine <= percentageOfMines { // how often do we create a mine?
            return TileAttributes(row: row, column: column, tiles: [.MineTile], numLocalMines: 0)
        }
        else {
            return TileAttributes(row: row, column: column, tiles: [.NumberTile], numLocalMines: 0)
        }

    }
    
    func actionTiles() -> [[TileAttributes]] {
        return tiles 
    }
    
    func minesInNeighborhood(row: Int, column: Int, maxRow: Int, maxColumn: Int) -> Int {
        // check local neighborhood of the tile (the 8 tiles touching it) couting
        // the number of mines in the neighborhood and returning that number
        var numMines = 0;
        if column != 0, case .MineTile = tiles[row][column-1].tiles[0]{
            numMines += 1
        }
        if row != 0 && column != 0, case .MineTile = tiles[row-1][column-1].tiles[0]{
            numMines += 1
        }
        if row != 0, case .MineTile = tiles[row-1][column].tiles[0]{
            numMines += 1
        }
        if row != 0 && column != maxColumn, case .MineTile = tiles[row-1][column+1].tiles[0]{
            numMines += 1
        }
        if column != maxColumn, case .MineTile = tiles[row][column+1].tiles[0]{
            numMines += 1
        }
        if row != maxRow && column != maxColumn, case .MineTile = tiles[row+1][column+1].tiles[0]{
            numMines += 1
        }
        if row != maxRow, case .MineTile = tiles[row+1][column].tiles[0]{
            numMines += 1
        }
        if row != maxRow && column != 0, case .MineTile = tiles[row+1][column-1].tiles[0]{
            numMines += 1
        }
        return  numMines
    }
}
