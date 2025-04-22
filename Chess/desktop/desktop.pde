import processing.svg.*;

ArrayList<Pole> poles = new ArrayList<>();
ArrayList<Piece> pieces = new ArrayList<>();
PImage boardImg;
int margin = 50;
Chessboard chessboard;
Piece selectedPiece = null;
boolean whiteTurn = true;
boolean gameOver = false;
boolean setupMode = true;

void setup() {
  fullScreen();
  boardImg = loadImage("chessboard.png");
  chessboard = initializeChessboard();
}

void draw() {
  background(25);
  chessboard.display();
  if (setupMode) {
     strokeWeight(0);
     fill(0, 255, 0);
    rect(360, height - 150, 180, 50);
    fill(0);
    textSize(20);
    text("Start gry", 420, height - 118);
    
  strokeWeight(5);
  if(whiteTurn) stroke(0, 255, 0);
  fill(255);
  rect(280, height - 150, 50, 50);
  stroke(255);
  
  if(!whiteTurn) stroke (0, 255, 0);
  fill(0);
  rect(560, height - 150, 50, 50);
  stroke(255);
    
    displayAvailablePieces();
  }
  
  if (gameOver) {
    textSize(50);
    fill(255);
    textAlign(CENTER, CENTER);
    String message = whiteTurn ? "Koniec gry! Czarni wygrali!" : "Koniec gry! Biali wygrali!";
    text(message, 3 * width / 4, height / 3);

    fill(0, 255, 0); 
    rect(3 * width / 4 - 100, height / 2, 200, 50);
    
    fill(255);
    textSize(20);
    text("Zagraj ponownie", 3 * width / 4, height / 2 + 25);
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

  return new Chessboard(boardImg, margin, margin, boardWidth, boardHeight, pieces, poles);
}

void createPieces(ArrayList<Piece> pieces) {
  pieces.add(new Pawn(loadShape("LightPawn.svg"), 0, 6, new Pole(6, 0), true));
  pieces.add(new Pawn(loadShape("LightPawn.svg"), 1, 6, new Pole(6, 1), true));
  pieces.add(new Pawn(loadShape("LightPawn.svg"), 2, 6, new Pole(6, 2), true));
  pieces.add(new Pawn(loadShape("LightPawn.svg"), 3, 6, new Pole(6, 3), true));
  pieces.add(new Pawn(loadShape("LightPawn.svg"), 4, 6, new Pole(6, 4), true));
  pieces.add(new Pawn(loadShape("LightPawn.svg"), 5, 6, new Pole(6, 5), true));
  pieces.add(new Pawn(loadShape("LightPawn.svg"), 6, 6, new Pole(6, 6), true));
  pieces.add(new Pawn(loadShape("LightPawn.svg"), 7, 6, new Pole(6, 7), true));

  pieces.add(new Pawn(loadShape("DarkPawn.svg"), 0, 1, new Pole(1, 0), false));
  pieces.add(new Pawn(loadShape("DarkPawn.svg"), 1, 1, new Pole(1, 1), false));
  pieces.add(new Pawn(loadShape("DarkPawn.svg"), 2, 1, new Pole(1, 2), false));
  pieces.add(new Pawn(loadShape("DarkPawn.svg"), 3, 1, new Pole(1, 3), false));
  pieces.add(new Pawn(loadShape("DarkPawn.svg"), 4, 1, new Pole(1, 4), false));
  pieces.add(new Pawn(loadShape("DarkPawn.svg"), 5, 1, new Pole(1, 5), false));
  pieces.add(new Pawn(loadShape("DarkPawn.svg"), 6, 1, new Pole(1, 6), false));
  pieces.add(new Pawn(loadShape("DarkPawn.svg"), 7, 1, new Pole(1, 7), false));

  pieces.add(new Rook(loadShape("LightRook.svg"), 0, 7, new Pole(7, 0), true));
  pieces.add(new Rook(loadShape("LightRook.svg"), 7, 7, new Pole(7, 7), true));

  pieces.add(new Rook(loadShape("DarkRook.svg"), 0, 0, new Pole(0, 0), false));
  pieces.add(new Rook(loadShape("DarkRook.svg"), 7, 0, new Pole(0, 7), false));

  pieces.add(new Knight(loadShape("LightKnight.svg"), 1, 7, new Pole(7, 1), true));
  pieces.add(new Knight(loadShape("LightKnight.svg"), 6, 7, new Pole(7, 6), true));

  pieces.add(new Knight(loadShape("DarkKnight.svg"), 1, 0, new Pole(0, 1), false));
  pieces.add(new Knight(loadShape("DarkKnight.svg"), 6, 0, new Pole(0, 6), false));

  pieces.add(new Bishop(loadShape("LightBishop.svg"), 2, 7, new Pole(7, 2), true));
  pieces.add(new Bishop(loadShape("LightBishop.svg"), 5, 7, new Pole(7, 5), true));

  pieces.add(new Bishop(loadShape("DarkBishop.svg"), 2, 0, new Pole(0, 2), false));
  pieces.add(new Bishop(loadShape("DarkBishop.svg"), 5, 0, new Pole(0, 5), false));

  pieces.add(new Queen(loadShape("LightQueen.svg"), 3, 7, new Pole(7, 3), true));

  pieces.add(new Queen(loadShape("DarkQueen.svg"), 3, 0, new Pole(0, 3), false));

  pieces.add(new King(loadShape("LightKing.svg"), 4, 7, new Pole(7, 4), true));

  pieces.add(new King(loadShape("DarkKing.svg"), 4, 0, new Pole(0, 4), false));
}

void mousePressed() {
  if(gameOver) {
      if (mouseX >= 3 * width / 4 - 150 && mouseX <= 3 * width / 4 + 150 &&
        mouseY >= height / 2 && mouseY <= height / 2 + 80) {
          gameOver = false;
          whiteTurn = true;
          setupMode = true;
          chessboard = initializeChessboard();
    }
  }
  if (setupMode) {
    if (mouseX >= 360 && mouseX <= 540 && mouseY >= height - 150 && mouseY <= height - 100) {
      setupMode = false;
    }
    if (mouseButton == RIGHT) {
      for (int i = chessboard.pieces.size() - 1; i >= 0; i--) {
        Piece piece = chessboard.pieces.get(i);
        if (piece.isClicked(mouseX, mouseY) && !(piece instanceof King)) {
          chessboard.pieces.remove(i);
          return;
        }
      }
    }
    
    for (Piece piece : chessboard.pieces) {
      if (piece.isClicked(mouseX, mouseY)) {
        selectedPiece = piece;
        break;
      }
          if (mouseX >= 360 && mouseX <= 540 && mouseY >= height - 150 && mouseY <= height - 100) {
      setupMode = false;
    }
    
    if (mouseX >= 280 && mouseX <= 330 && mouseY >= height - 150 && mouseY <= height - 100) {
      whiteTurn = true;
    }
    
    if (mouseX >= 560 && mouseX <= 610 && mouseY >= height - 150 && mouseY <= height - 100) {
      whiteTurn = false;
    }
      
    }
  } else if (!gameOver) {
    if (selectedPiece == null) {
      for (Piece piece : chessboard.pieces) {
        if (piece.isClicked(mouseX, mouseY) && piece.isWhite() == whiteTurn) {
          selectedPiece = piece;
          break;
        }
      }
    } else {
      int targetX = (mouseX - margin) / 100;
      int targetY = (mouseY - margin) / 100;

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
}

void displayAvailablePieces() {
  for (Piece piece : pieces) {
    piece.display();
  }
}

void mouseDragged() {
  if (setupMode && selectedPiece != null) {
    selectedPiece.x = (mouseX - margin) / 100;
    selectedPiece.y = (mouseY - margin) / 100;
  }
}

abstract class Piece {
  protected int x, y;
  protected PShape img;
  protected boolean white;
  protected float pieceSize = 100; 
  protected Pole pole;

  Piece(PShape img, int x, int y, Pole pole, boolean white) {
    this.img = img;
    this.x = x;
    this.y = y;
    this.pole = pole;
    this.white = white;
  }

  boolean isClicked(int mx, int my) {
    int pieceX = margin + x * 100;
    int pieceY = margin + y * 100;
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
    shape(img, x * pieceSize + margin, y * pieceSize + margin, pieceSize, pieceSize);
  }

  boolean isWhite() {
    return this.white;
  }
}

class Pawn extends Piece {
  public Pawn(PShape img, int x, int y, Pole position, boolean white) {
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
      println("XD");
      promoteTo(new Queen(loadShape(this.white ? "LightQueen.svg" : "DarkQueen.svg"), this.x, this.y, new Pole(x, y) , this.white));
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
  public Rook(PShape img, int x, int y, Pole position, boolean white) {
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
  public Knight(PShape img, int x, int y, Pole position, boolean white) {
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
  public Bishop(PShape img, int x, int y, Pole position, boolean white) {
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
  public Queen(PShape img, int x, int y, Pole position, boolean white) {
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
  public King(PShape img, int x, int y, Pole position, boolean white) {
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
