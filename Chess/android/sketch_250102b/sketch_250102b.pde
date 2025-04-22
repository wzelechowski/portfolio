import processing.data.XML; 

ArrayList<Pole> poles = new ArrayList<>();
ArrayList<Piece> pieces = new ArrayList<>();
PImage boardImg;
int margin = 50;
Chessboard chessboard;
Piece selectedPiece = null;
boolean whiteTurn = true;
boolean gameOver = false;
XML xml;

void setup() {
  size(displayWidth, displayHeight);
  boardImg = loadImage("chessboard.png");
  chessboard = initializeChessboard();
}

void draw() {
  background(25);
  chessboard.display();
  
  if (gameOver) {
    textSize(50);
    fill(255);
    textAlign(CENTER, CENTER);
    String message = whiteTurn ? "Koniec gry! Czarni wygrali!" : "Koniec gry! Biali wygrali!";
    text(message, width / 2, height / 6);
    
    fill(0, 255, 0); 
    rect(width / 2 - 150, height / 4, 300, 80);
    
    fill(255);
    textSize(40);
    text("Zagraj ponownie", width / 2, height / 4 + 40);
  }
}

Chessboard initializeChessboard() {
  ArrayList<Pole> poles = new ArrayList<>();
  ArrayList<Piece> pieces = new ArrayList<>();
  
  for (int row = 0; row < 8; row++) {
    for (int col = 0; col < 8; col++) {
      poles.add(new Pole(row, col));
    }
  }

  createPieces(pieces);

  int boardWidth = 8 * 100 + 2 * margin;
  int boardHeight = 8 * 100 + 2 * margin;
  
    int marginX = (width - 800) / 2;
  int marginY = (height - 800) / 2;

  return new Chessboard(boardImg, marginX, marginY, boardWidth, boardHeight, pieces, poles);
}

void createPieces(ArrayList<Piece> pieces) {
  xml = loadXML("pieces.xml");

  if (xml == null) {
    return;
  }

  XML[] pawns = xml.getChildren("pawn");
XML[] rooks = xml.getChildren("rook");
  XML[] knights = xml.getChildren("knight");
  XML[] bishops = xml.getChildren("bishop");
  XML[] queens = xml.getChildren("queen");
  XML[] kings = xml.getChildren("king");

  XML[][] allPieces = {pawns, rooks, knights, bishops, queens, kings};

  for (XML[] piecesList : allPieces) {
    for (int i = 0; i < piecesList.length; i++) {
      XML pieceElement = piecesList[i];

      String col = pieceElement.getString("color");
      int x = pieceElement.getInt("x");
      int y = pieceElement.getInt("y");
      String imageName = pieceElement.getString("image");

      boolean isWhite = col.equals("white");

      Piece newPiece;
      if (pieceElement.getName().equals("pawn")) {
        println(imageName);
        newPiece = new Pawn(loadImage(imageName), x, y, new Pole(x, y), isWhite);
      } else if (pieceElement.getName().equals("rook")) {
        newPiece = new Rook(loadImage(imageName), x, y, new Pole(x, y), isWhite);
      } else if (pieceElement.getName().equals("knight")) {
        newPiece = new Knight(loadImage(imageName), x, y, new Pole(x, y), isWhite);
      } else if (pieceElement.getName().equals("bishop")) {
        newPiece = new Bishop(loadImage(imageName), x, y, new Pole(x, y), isWhite);
      } else if (pieceElement.getName().equals("queen")) {
        newPiece = new Queen(loadImage(imageName), x, y, new Pole(x, y), isWhite);
      } else if (pieceElement.getName().equals("king")) {
        newPiece = new King(loadImage(imageName), x, y, new Pole(x, y), isWhite);
      } else {
        continue;
      }

      pieces.add(newPiece);
    }
  }
}


void mousePressed() {
  if(gameOver) {
      if (mouseX >= width / 2 - 150 && mouseX <= width / 2 + 150 &&
          mouseY >= height / 4 && mouseY <= height / 4 + 80) {
          gameOver = false;
          whiteTurn = true; 
          chessboard = initializeChessboard();
    }
  }
  if (selectedPiece == null) {
    for (Piece piece : chessboard.pieces) {
      if (piece.isClicked(mouseX, mouseY) && piece.isWhite() == whiteTurn) {
        selectedPiece = piece;
        break;
      }
    }
  } else {
    int targetX = (mouseX - (width - 800) / 2) / 100;
    int targetY = (mouseY - (height - 800) / 2) / 100;

    
    if (targetX >= 0 && targetX < 8 && targetY >= 0 && targetY < 8) {
      if (selectedPiece.canMoveTo(targetX, targetY) && chessboard.isMoveLegal(selectedPiece, targetX, targetY)) {
        selectedPiece.moveTo(targetX, targetY);

        whiteTurn = !whiteTurn;
      }
    }
    if (selectedPiece instanceof Pawn) {
      ((Pawn) selectedPiece).promote();
    }
    selectedPiece = null;
    gameOver = chessboard.isCheckmate(whiteTurn);
  }
}

abstract class Piece {
  protected int x, y;
  protected PImage img;
  protected boolean white;
  protected float pieceSize = 100; 
  protected Pole pole;

  Piece(PImage img, int x, int y, Pole pole, boolean white) {
    this.img = img;
    this.x = x;
    this.y = y;
    this.pole = pole;
    this.white = white;
  }

boolean isClicked(int mx, int my) {
  float pieceX = x * pieceSize + (width - 800) / 2;
  float pieceY = y * pieceSize + (height - 800) / 2;
  return (mx >= pieceX && mx <= pieceX + pieceSize && my >= pieceY && my <= pieceY + pieceSize);
}


  abstract boolean canMoveTo(int targetX, int targetY);

  void moveTo(int targetX, int targetY) {
    for (Piece p : chessboard.pieces) {
      if (p.x == targetX && p.y == targetY && p.white != this.white) {
        chessboard.pieces.remove(p);
        break;
      }
    }

    this.x = targetX;
    this.y = targetY;
    this.pole = new Pole(targetX, targetY);
  }

  void display() {
    image(img, x * pieceSize + (width - 800)/2, y * pieceSize + (height - 800) / 2, pieceSize, pieceSize);
  }

  boolean isWhite() {
    return this.white;
  }
}

class Pawn extends Piece {
  public Pawn(PImage img, int x, int y, Pole position, boolean white) {
    super(img, x, y, position, white);
  }

  @Override
  boolean canMoveTo(int targetX, int targetY) {
    int direction = white ? -1 : 1;

    if (targetX == this.x && targetY == this.y + direction) {
        for (Piece p : chessboard.pieces) {
            if (p.x == targetX && p.y == targetY) {
                return false;
            }
        }
        return true;
    }

    if ((this.white && this.y == 6) || (!this.white && this.y == 1)) {
        if (targetX == this.x && targetY == this.y + 2 * direction) {
            for (Piece p : chessboard.pieces) {
                if ((p.x == targetX && p.y == targetY) || (p.x == this.x && p.y == this.y + direction)) {
                    return false;
                }
            }
            return true;
        }
    }

    if (Math.abs(targetX - this.x) == 1 && targetY == this.y + direction) {
      for (Piece p : chessboard.pieces) {
        if (p.x == targetX && p.y == targetY && p.white != this.white) {
          return true;
        }
      }
    }

    return false;
  }

void promote() {
  if ((this.white && this.y == 0) || (!this.white && this.y == 7)) {
    XML[] queens = xml.getChildren("queen");

    String imageName = null;
    
    for (XML queen : queens) {
      if (queen.getString("color").equals(this.white ? "white" : "black")) {
        imageName = queen.getString("image");
        break;
      }
    }
    
    if (imageName != null) {
      promoteTo(new Queen(loadImage(imageName), this.x, this.y, new Pole(this.x, this.y), this.white));
    }
  }
}

void promoteTo(Piece newPiece) {
  int index = chessboard.pieces.indexOf(this);
  if (index != -1) {
    chessboard.pieces.remove(index);
  }

  newPiece.x = this.x;
  newPiece.y = this.y;
  chessboard.pieces.add(newPiece);
}
}

class Rook extends Piece {
  public Rook(PImage img, int x, int y, Pole position, boolean white) {
    super(img, x, y, position, white);
  }

  @Override
  boolean canMoveTo(int targetX, int targetY) {
    for (Piece p : chessboard.pieces) {
      if (p.x == targetX && p.y == targetY && p.white == this.white) {
        return false;
      }
    }

    if (targetY == this.y && targetX != this.x) {
      int step = (targetX > this.x) ? 1 : -1;
      for (int i = this.x + step; i != targetX; i += step) {
        for (Piece p : chessboard.pieces) {
          if (p.x == i && p.y == this.y) {
            return false;
          }
        }
      }
      return true;
    }

    if (targetX == this.x && targetY != this.y) {
      int step = (targetY > this.y) ? 1 : -1;
      for (int i = this.y + step; i != targetY; i += step) {
        for (Piece p : chessboard.pieces) {
          if (p.y == i && p.x == this.x) {
            return false;
          }
        }
      }
      return true;
    }

    return false;
  }
}

class Knight extends Piece {
  public Knight(PImage img, int x, int y, Pole position, boolean white) {
    super(img, x, y, position, white);
  }

  @Override
  boolean canMoveTo(int targetX, int targetY) {
    int dx = Math.abs(targetX - this.x);
    int dy = Math.abs(targetY - this.y);

    if ((dx == 2 && dy == 1) || (dx == 1 && dy == 2)) {
      for (Piece p : chessboard.pieces) {
        if (p.x == targetX && p.y == targetY && p.white == this.white) {
          return false;
        }
      }
      return true;
    }
    return false;
  }
}

class Bishop extends Piece {
  public Bishop(PImage img, int x, int y, Pole position, boolean white) {
    super(img, x, y, position, white);
  }

  @Override
  boolean canMoveTo(int targetX, int targetY) {
    if (Math.abs(targetX - this.x) != Math.abs(targetY - this.y)) {
      return false;
    }

    int dx = (targetX > this.x) ? 1 : -1;
    int dy = (targetY > this.y) ? 1 : -1;

    int x = this.x + dx;
    int y = this.y + dy;

    while (x != targetX || y != targetY) {
      for (Piece p : chessboard.pieces) {
        if (p.x == x && p.y == y) {
          return false;
        }
      }
      x += dx;
      y += dy;
    }

    for (Piece p : chessboard.pieces) {
      if (p.x == targetX && p.y == targetY) {
        return p.white != this.white;
      }
    }

    return true;
  }
}

class Queen extends Piece {
  public Queen(PImage img, int x, int y, Pole position, boolean white) {
    super(img, x, y, position, white);
  }

  @Override
  boolean canMoveTo(int targetX, int targetY) {
    for (Piece p : chessboard.pieces) {
      if (p.x == targetX && p.y == targetY && p.white == this.white) {
        return false;
      }
    }

    if (targetX == this.x && targetY != this.y) {
      int step = (targetY > this.y) ? 1 : -1;
      for (int i = this.y + step; i != targetY; i += step) {
        if (isPieceAt(this.x, i)) return false;
      }
      return true;
    }

    if (targetY == this.y && targetX != this.x) {
      int step = (targetX > this.x) ? 1 : -1;
      for (int i = this.x + step; i != targetX; i += step) {
        if (isPieceAt(i, this.y)) return false;
      }
      return true;
    }

    if (Math.abs(targetX - this.x) == Math.abs(targetY - this.y)) {
      int dx = (targetX > this.x) ? 1 : -1;
      int dy = (targetY > this.y) ? 1 : -1;

      int x = this.x + dx;
      int y = this.y + dy;

      while (x != targetX && y != targetY) {
        if (isPieceAt(x, y)) return false;
        x += dx;
        y += dy;
      }
      return true;
    }

    return false;
  }

  private boolean isPieceAt(int x, int y) {
    for (Piece p : chessboard.pieces) {
      if (p.x == x && p.y == y) {
        return true;
      }
    }
    return false;
  }
}

class King extends Piece {
  public King(PImage img, int x, int y, Pole position, boolean white) {
    super(img, x, y, position, white);
  }

  @Override
  boolean canMoveTo(int targetX, int targetY) {
    if (Math.abs(targetX - this.x) <= 1 && Math.abs(targetY - this.y) <= 1) {
      for (Piece p : chessboard.pieces) {
        if (p.x == targetX && p.y == targetY && p.white == this.white) {
          return false; 
        }
      }
      return true;
    }
    return false;
  }
}




class Chessboard {
  PImage boardImg;
  int x, y, width, height;
  ArrayList<Piece> pieces;
  ArrayList<Pole> poles;
  King whiteKing, blackKing;

  Chessboard(PImage boardImg, int x, int y, int width, int height, ArrayList<Piece> pieces, ArrayList<Pole> poles) {
    this.boardImg = boardImg;
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.pieces = pieces;
    this.poles = poles;

    // Inicjalizowanie królów
    for (Piece piece : pieces) {
      if (piece instanceof King) {
        if (piece.isWhite()) {
          whiteKing = (King) piece;
        } else {
          blackKing = (King) piece;
        }
      }
    }
  }

  public void display() {
    PImage imgSize = boardImg;
    imgSize.resize(800, 800);
    image(imgSize, x, y);

    for (Piece piece : pieces) {
      piece.display();
    }
  }

  public boolean isKingInCheck(boolean isWhite) {
    King king = isWhite ? whiteKing : blackKing;
    for (Piece p : pieces) {
      if (p.isWhite() != isWhite) {
        if (p.canMoveTo(king.x, king.y)) {
          return true;
        }
      }
    }
    return false;
  }

public boolean isMoveLegal(Piece piece, int targetX, int targetY) {
  int originalX = piece.x;
  int originalY = piece.y;
  Piece capturedPiece = null;

  for (Piece p : pieces) {
    if (p.x == targetX && p.y == targetY && p.isWhite() != piece.isWhite()) {
      capturedPiece = p;
      break;
    }
  }

  piece.moveTo(targetX, targetY);
  if (capturedPiece != null) pieces.remove(capturedPiece);

  boolean isWhite = piece.isWhite();
  boolean check = isKingInCheck(isWhite);

  piece.moveTo(originalX, originalY);
  if (capturedPiece != null) pieces.add(capturedPiece);

  return !check;
}

  
boolean isCheckmate(boolean isWhiteTurn) {
  King king = getKing(isWhiteTurn);
  if (king == null) {
  return false;
  }
  
  if (!isKingInCheck(king)) {
  return false;
  }
  
  for (Piece piece : new ArrayList<>(pieces)) {
    if (piece.isWhite() == isWhiteTurn) {
      if (piece instanceof Bishop) {
      for (int i = 1; i < 8; i++) {
        int[] directions = {-1, 1};
        for (int dirX : directions) {
          for (int dirY : directions) {
            int targetX = piece.x + i * dirX;
            int targetY = piece.y + i * dirY;
            if (targetX >= 0 && targetX < 8 && targetY >= 0 && targetY < 8) {
              if (piece.canMoveTo(targetX, targetY)) {
              int originalX = piece.x;
              int originalY = piece.y;
              Piece capturedPiece = getPieceAt(targetX, targetY);
              
              piece.moveTo(targetX, targetY);
              if (capturedPiece != null) pieces.remove(capturedPiece);
              
              if (!isKingInCheck(king)) {
                println("  Legalny ruch znaleziony: (" + targetX + ", " + targetY + ")");
                piece.moveTo(originalX, originalY);
                if (capturedPiece != null) pieces.add(capturedPiece);
                return false;
              }
              
              piece.moveTo(originalX, originalY);
              if (capturedPiece != null) pieces.add(capturedPiece);
              }
            }
          }
        }
      }
      } else {
      for (int targetX = 0; targetX < 8; targetX++) {
        for (int targetY = 0; targetY < 8; targetY++) {
          if (piece.canMoveTo(targetX, targetY)) {
            int originalX = piece.x;
            int originalY = piece.y;
            Piece capturedPiece = getPieceAt(targetX, targetY);
            
            piece.moveTo(targetX, targetY);
            if (capturedPiece != null) pieces.remove(capturedPiece);
            
            if (!isKingInCheck(king)) {
              piece.moveTo(originalX, originalY);
              if (capturedPiece != null) pieces.add(capturedPiece);
              return false;
            }
            
            piece.moveTo(originalX, originalY);
            if (capturedPiece != null) pieces.add(capturedPiece);
            }
          }
        }
      }
    }
  }

  return true;
}


Piece getPieceAt(int x, int y) {
    for (Piece p : pieces) {
        if (p.x == x && p.y == y) {
            return p;
        }
    }
    return null;
}


King getKing(boolean isWhiteTurn) {
  for (Piece piece : pieces) {
    if (piece instanceof King && piece.isWhite() == isWhiteTurn) {
      return (King) piece;
    }
  }
  return null;
}

boolean isKingInCheck(King king) {
  for (Piece piece : pieces) {
    if (piece.isWhite() != king.isWhite()) {
      if (piece.canMoveTo(king.x, king.y)) {
        return true;
      }
    }
  }
  return false;
}

boolean canMoveOutOfCheck(King king) {
  for (Piece piece : pieces) {
    if (piece.isWhite() == king.isWhite()) {
      for (int targetX = 0; targetX < 8; targetX++) {
        for (int targetY = 0; targetY < 8; targetY++) {
          if (piece.canMoveTo(targetX, targetY)) {
            int originalX = piece.x;
            int originalY = piece.y;
            piece.moveTo(targetX, targetY);
            
            if (!isKingInCheck(king)) {
              piece.moveTo(originalX, originalY);
              return true;
            }
            
            piece.moveTo(originalX, originalY);
          }
        }
      }
    }
  }
  return false; 
}

}


class Pole {
  int x, y;

  Pole(int x, int y) {
    this.x = x;
    this.y = y;
  }
} 
