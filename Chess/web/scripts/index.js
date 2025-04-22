class OpeningImg {
  constructor(img, x, y, imgText) {
      this.img = img;
      this.x = x;
      this.y = y;
      this.imgText = imgText;
  }

  draw() {
      if (this.img) {
        textSize(20);
        fill(239, 239, 239);
        text(this.imgText, this.x + windowWidth/15, this.y - windowHeight/20)
        image(this.img, this.x, this.y);
      }
    }

  contains(x, y) {
    return x >= this.x && x <= this.x + this.img.width &&
          y >= this.y && y <= this.y + this.img.height;
  }
}


let openings = [
  'Obrona Sycylijska', 'Obrona Francuska', 'Obrona Caro-Kann', 
  'Partia Włoska', 'Gambit Królewski', 'Gambit Hetmański',
];

let images = [];
let openingImages = [];
let start = true;
let opacity = 1;
let vanish = false;

function preload() {
  for (let i = 0; i < openings.length; i++) {
    images[i] = loadImage(`../assets/debut${i + 1}.png`);
  }
}

function setup() {
  createCanvas(windowWidth, windowHeight);
}

function draw() {
  background(25);
  textFont('Arial');
  textAlign(CENTER, CENTER);
  textSize(56);
  if (start) {
    fill(239, 239, 239, opacity * 255);
    text("Witaj w Książce Debiutowej", width / 2, height / 2);
    if(vanish) opacity -= 0.02;

    if (opacity <= -0.2) {
      vanish = false;
      start = false;
      createOpeningImages();
    }
  } else {
    for(let openImg of openingImages) {
      openImg.draw();
    }
    noLoop();
  }
}

function mousePressed() {
  if (start) {
    vanish = true;
  } else {
    for(let openingImage of openingImages) {
      if(openingImage.contains(mouseX, mouseY)) {
        let url = `${window.location.origin}/${openingImage.imgText.toLowerCase().replace(/ /g, '-')}.html`;
        window.location.href = url;
      }
    }
  }
}

function createOpeningImages() {
  openingImages = [];
  const cols = 3;
  const rows = 3;

  const imgWidth = int((windowWidth / 5) - (windowWidth / 15));
  const imgHeight = int((windowWidth / 5) - (windowWidth / 15));

  for (let i = 0; i < openings.length; i++) {
    const col = (i % cols) + 1;
    const row = Math.floor(i / rows) + 1;
    
    let imgSize = images[i];
    imgSize.resize(imgWidth, imgHeight)

    const openImg = new OpeningImg(imgSize, col * (windowWidth / 5), row * (windowHeight / 5) + (row * windowHeight/5) - windowHeight/4, openings[i]);
    openingImages.push(openImg);
  }
}