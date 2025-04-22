class Chessboard {
    constructor(pieces, poles, img, moves) {
        this.pieces = pieces;
        this.poles = poles;
        this.img = img;
        this.moves = moves;
        this.counter = 0;
    }

    draw() {
        if(this.img) {
            let imgSize = this.img;
            imgSize.resize(400, 400);
            push();
                translate(3*windowWidth/5, windowHeight/6)
                image(imgSize, 0, 0);

            pop();
            for(let i = 0; i < this.pieces.length; i++) {
                this.pieces[i].draw();
            }
        }
    }

    moveNext() {
        if(this.counter < this.moves.length) {
            const move = this.moves[this.counter];
            for(let i = 0; i < this.pieces.length; i++) {
                if(this.pieces[i].calcueOffset(this.pieces[i].pole.offset) === move.oldOffset && this.pieces[i].pole.value === move.oldValue) {
                    this.pieces[i].move(move.newOffset, move.newValue);
                }
            }
            this.counter++;
        }
    }

    movePrev() {
        if(this.counter > 0) {
            const move = this.moves[this.counter-1];
            for(let i = 0; i < this.pieces.length; i++) {
                if(this.pieces[i].calcueOffset(this.pieces[i].pole.offset) === move.newOffset && (this.pieces[i].pole.value) === move.newValue) {
                    this.pieces[i].move(move.oldOffset, move.oldValue);
                }
            }
            this.counter--;
        }  
    }
}

class Piece {
    constructor(name, pole, img, moves) {
        this.name = name;
        this.pole = pole;
        this.img = img;
        this.moves = moves;
    }

    offsetts = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];

    calcueOffset(offset) {
        if(typeof offset === 'string') {
            return this.offsetts.findIndex(of => of === offset);
        } else {
            return offset;
        }
    }

    move(offset, value) {
        this.pole.offset = offset;
        this.pole.value = value;
        draw();
    }
    
    backToOffset(offset) {
        return this.offsetts[offset];
    }

    draw() {
        if (this.img) {
            let imgSize = this.img;
            imgSize.resize(50, 50);
            let offset;
            if (typeof this.pole.offset === 'number') {
                offset = this.pole.offset;
    } else {
                offset = this.calcueOffset(this.pole.offset);
            }
            const x = offset * 50;
            const y = (8 - (this.pole.value)) * 50;

            image(imgSize, 3*windowWidth/5 + x, windowHeight/6 + y);
        }
    }
}

class Pole {
    constructor(offset, value) {
        this.offset = offset;
        this.value = parseInt(value);
    }   
}

class Move {
    constructor(data) {
        this.data = data;
        this.oldOffset = null;
        this.oldValue = null;
        this.newOffset = null;
        this.newValue = null;
        this.offsetts = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];
        this.calcueOffset(data);
    }

    calcueOffset(data) {
        this.oldOffset = this.offsetts.findIndex(char => char === data.oldPosition[0]);
        this.newOffset = this.offsetts.findIndex(char => char === data.newPosition[0]);
        this.oldValue = parseInt(data.oldPosition[1]);
        this.newValue = parseInt(data.newPosition[1]);
    }


}

const queue = [
    // Białe figury
    { name: 'LightRook', position: "a1" },
    { name: 'LightKnight', position: "b1" },
    { name: 'LightBishop', position: "c1" },
    { name: 'LightQueen', position: "d1" },
    { name: 'LightKing', position: "e1" },
    { name: 'LightBishop', position: "f1" },
    { name: 'LightKnight', position: "g1" },
    { name: 'LightRook', position: "h1" },
    { name: 'LightPawn', position: "a2" },
    { name: 'LightPawn', position: "b2" },
    { name: 'LightPawn', position: "c2" },
    { name: 'LightPawn', position: "d2" },
    { name: 'LightPawn', position: "e2" },
    { name: 'LightPawn', position: "f2" },
    { name: 'LightPawn', position: "g2" },
    { name: 'LightPawn', position: "h2" },
    // Czarne figury
    { name: 'DarkRook', position: "a8" },
    { name: 'DarkKnight', position: "b8" },
    { name: 'DarkBishop', position: "c8" },
    { name: 'DarkQueen', position: "d8" },
    { name: 'DarkKing', position: "e8" },
    { name: 'DarkBishop', position: "f8" },
    { name: 'DarkKnight', position: "g8" },
    { name: 'DarkRook', position: "h8" },
    { name: 'DarkPawn', position: "a7" },
    { name: 'DarkPawn', position: "b7" },
    { name: 'DarkPawn', position: "c7" },
    { name: 'DarkPawn', position: "d7" },
    { name: 'DarkPawn', position: "e7" },
    { name: 'DarkPawn', position: "f7" },
    { name: 'DarkPawn', position: "g7" },
    { name: 'DarkPawn', position: "h7" },
  ];

let fields = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];
let pieces = []
let poles = []
let desc;
let title;
let chessboard;

let moves = [];
let counter = 0;
let nextButtonRect;
let prevButtonRect;

function preload() {
    const url = window.location.href;
    const fileName = url.split('/').pop(); 
    console.log(fileName)
    const openingName = fileName.replace('.html', '');
    loadOpening(openingName);
    for(let i = 0; i < queue.length; i++) {
        const pole = new Pole(queue[i].position[0], queue[i].position[1]);
        let move;
        moves.forEach(m => {
            if(m.oldOffset === pole.offset && m.oldValue === pole.value) {
                move = m;
            } 
        });
        pieces.push(new Piece(queue[i].name, pole, loadImage(`../assets/${queue[i].name}.png`), move));
    }
    loadPoles();
    chessboard = new Chessboard(pieces, poles, loadImage('../assets/chessboard.png'), moves);
}

async function loadPoles() {
    const response = await fetch('openings/chessboard-data.json');
    const data = await response.json();
    const polesData = data.poles;
    for(let i = 0; i < polesData.length; i++) {
        poles[i] = new Pole(polesData[i][0], polesData[i][1])
    }
}

async function loadOpening(openingName) {
    const response = await fetch(`openings/${openingName}.json`);
    const data = await response.json();
    const movesData = data.moves;
    for(let i = 0; i < movesData.length; i++) {
        moves[i] = new Move(movesData[i]);
    }
    nextButtonRect = { x: width - 200, y: height - 60, w: 150, h: 40 };
    prevButtonRect = { x: 50, y: height - 60, w: 150, h: 40 };
    desc = data.desc;
    title = data.title;
}
  

function setup() {
    createCanvas(windowWidth, windowHeight);
}

function draw() {
    background(25);
  
    chessboard.draw();
  
    const buttonY = windowHeight / 6 + 400 + 20;
    const buttonWidth = 150;
    const buttonHeight = 40;
  
    nextButtonRect.x = 3 * windowWidth / 5 + 250;
    nextButtonRect.y = buttonY;
    nextButtonRect.w = buttonWidth;
    nextButtonRect.h = buttonHeight;
  
    prevButtonRect.x = 3* windowWidth / 5; 
    prevButtonRect.y = buttonY;
    prevButtonRect.w = buttonWidth;
    prevButtonRect.h = buttonHeight;
  
    if (
      mouseX > nextButtonRect.x &&
      mouseX < nextButtonRect.x + nextButtonRect.w &&
      mouseY > nextButtonRect.y &&
      mouseY < nextButtonRect.y + nextButtonRect.h
    ) {
      fill(100);
    } else {
      fill(50);
    }
    rect(nextButtonRect.x, nextButtonRect.y, nextButtonRect.w, nextButtonRect.h, 10);
    fill(255);
    textSize(18);
    textAlign(CENTER, CENTER);
    text('Next', nextButtonRect.x + nextButtonRect.w / 2, nextButtonRect.y + nextButtonRect.h / 2);
  
    if (
      mouseX > prevButtonRect.x &&
      mouseX < prevButtonRect.x + prevButtonRect.w &&
      mouseY > prevButtonRect.y &&
      mouseY < prevButtonRect.y + prevButtonRect.h
    ) {
      fill(100);
    } else {
      fill(50);
    }
    rect(prevButtonRect.x, prevButtonRect.y, prevButtonRect.w, prevButtonRect.h, 10);
    fill(255);
    textSize(18);
    textAlign(CENTER, CENTER);
    text('Prev', prevButtonRect.x + prevButtonRect.w / 2, prevButtonRect.y + prevButtonRect.h / 2);
    drawDesc();
  }

  function drawDesc() {
    fill(150);
    rect(windowWidth / 20, windowHeight / 6, 8 * windowWidth / 20, 500, 20);

    fill(0);
    textAlign(CENTER);
    textSize(32);
    text(title, windowWidth / 4, windowHeight / 4);

    textSize(16);
    
    textWrap(WORD);
    
    text(desc, windowWidth / 20, windowHeight / 5, 8 * windowWidth / 20, 400); 
}
  
  function mousePressed() {
    if (
      mouseX > nextButtonRect.x &&
      mouseX < nextButtonRect.x + nextButtonRect.w &&
      mouseY > nextButtonRect.y &&
      mouseY < nextButtonRect.y + nextButtonRect.h
    ) {
      chessboard.moveNext();
      
    }
  
    if (
      mouseX > prevButtonRect.x &&
      mouseX < prevButtonRect.x + prevButtonRect.w &&
      mouseY > prevButtonRect.y &&
      mouseY < prevButtonRect.y + nextButtonRect.h
    ) {
        chessboard.movePrev();
    }
  }
  
