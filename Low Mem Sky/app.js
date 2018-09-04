
window.onload = function () {
    canvas =
        document.getElementById("canvas");
    ctx = canvas.getContext("2d");

    setInterval(draw, 1000 / 60);

    for (var i = 0; i < 190; i++) {
        var newStar = new starClass();
        newStar.y = Math.random() * canvas.height;

        star.push(newStar)
    }
}


var speedOfSpawn = 2300;

setInterval(enemies, speedOfSpawn);

var spawnAmmoSpeed = 16000;
setInterval(ammoSpawn, spawnAmmoSpeed);

//Rectangle Code
function drawRect(topLeftX, topLeftY, width, height, color) {
    ctx.fillStyle = color; ctx.fillRect(topLeftX, topLeftY, width, height);
}
//Circle Code
function drawCircle(x, y, radius, color) {
    ctx.beginPath();
    ctx.fillStyle = color;
    ctx.arc(x, y, radius, 0, Math.PI * 2);
    ctx.fill();
    ctx.closePath();
}

var px = 150;
var py = 370;
var pw = 35;
var ph = 38;
var xv = 0;
var yv = 0;


var bullet = [];
var enemy = [];

var ammo = 15;
var ammoArray = [];

var lives = 3;
var score = 100;

var showWinScreen = false;
var showLoseScreen = false;
var showTitleScreen = false;
var showInstruction = true;

var enemiesToMake = 100;

function bulletClass() {
    this.x = px + pw / 2 - 2;
    this.y = py;

    this.velY = -2;

    this.move = function () {
        this.y += this.velY;
    }
    this.draw = function () {
        drawRect(this.x, this.y, 4, 4, "cyan");
    }
}

var enBullet = [];

function enBulletClass() {
    this.x = 10;
    this.y = 10;
    this.velX = 0;
    this.velY = 2;

    this.move = function () {
        this.x += this.velX;
        this.y += this.velY;
    }
    this.draw = function () {
        drawRect(this.x, this.y, 5, 6, "crimson");
    }
}

function ammoClass() {
    this.x = Math.random() * 310;
    this.y = -15;
    this.velX = 1 - Math.random() * 2;
    this.velY = 1.5;
    this.size = 15;

    this.move = function () {
        this.x += this.velX;
        this.y += this.velY;
        if (this.x + this.size >= 325 ||
            this.x <= 0) {
            this.velX *= -1;
        }
    }

    this.draw = function () {
        drawRect(this.x, this.y, this.size, this.size, "white");
    }
}

function ammoSpawn() {
    var newAmmo = new ammoClass();
    ammoArray.push(newAmmo);
}

var star = [];

function starClass() {
    this.x = Math.random() * 325;
    this.y = -5;
    this.velY = 0.5 + Math.random() * 1.5;
    this.radius = this.velY * 1.1;

    this.color = "white";

    this.move = function () {
        this.y += this.velY
    }
    this.draw = function () {
        drawRect(this.x, this.y, this.radius, this.radius, this.color);
    }
}

function enemyClass() {
    this.x = 5 + Math.random() * 300;
    this.y = 15;
    this.w = 20;
    this.h = 23;
    this.isDead = false;

    this.velY = 0.6 + Math.random() * 1.5;
    this.velX = 0.5 - Math.random() * 1;

    this.move = function () {
        this.y += this.velY;
        this.x += this.velX;
        if (this.x + this.w >= canvas.width && this.velX > 0 ||
            this.x <= 0 && this.velX < 0) {
            this.velX *= -1;
        }
    }

    this.draw = function () {

        ctx.beginPath();
        ctx.fillStyle = "crimson";
        ctx.moveTo(this.x, this.y);
        ctx.lineTo(this.x + this.w / 2, this.y + 3);
        ctx.lineTo(this.x + this.w, this.y)
        ctx.lineTo(this.x + this.w / 2, this.y + this.h);
        ctx.lineTo(this.x, this.y);
        ctx.fill();
        ctx.closePath();

        ctx.beginPath();
        ctx.fillStyle = "cyan";

        ctx.moveTo(this.x + this.w / 2 - 5, this.y + this.h / 2 - 2);
        ctx.lineTo(this.x + 15, this.y + this.h / 2 - 2);
        ctx.lineTo(this.x + this.w / 2, this.y + 16);
        ctx.lineTo(this.x + this.w / 2 - 5, this.y + this.h / 2 - 2);

        ctx.fill();
        ctx.closePath();


    }
}

var debris = [];

function debrisClass() {
    this.x = 10;
    this.y = 10;
    this.velX = 3 - Math.random() * 6;
    this.velY = 4 - Math.random() * 6;
    this.cyclesLeft = 20 + Math.random() * 60;

    this.ang = Math.random() * 6.283;
    this.circle = true;

    var colorPicker = Math.random();

    if (colorPicker <= 0.5) {
        this.color = "red";
    }
    if (colorPicker > 0.5) {
        this.color = "orange";
    }

    this.move = function () {
        this.cyclesLeft--;
        if (this.circle) {
            this.x += Math.cos(this.ang) * this.velX;
            this.y += Math.sin(this.ang) * this.velY;
        }
        if (this.circle == false) {
            this.x += this.velX;
            this.y += this.velY;
        }
    }
    this.draw = function () {
        if (this.cyclesLeft > 0) {
            drawRect(this.x, this.y, this.cyclesLeft / 15, this.cyclesLeft / 15, this.color);
        }
    }
}

function fireOn() {
    if (ammo >= 1) {
        var newBullet = new bulletClass();

        bullet.push(newBullet);
        ammo--;
    }
}

document.addEventListener("keydown", keyDown);

document.addEventListener("keyup", keyUp);

var movingLeft = false;
var movingRight = false;
var shooting = false;

function keyDown(e) {
    if (e.keyCode == "37") {
        xv = -3;
        e.preventDefault();
        restart();
    }
    if (e.keyCode == "38") {
        fireOn();
        e.preventDefault();
        restart();
    }
    if (e.keyCode == "39") {
        xv = 3;
        e.preventDefault();
        restart();
    }
}

function keyUp(e) {
    if (e.keyCode == "37") {
        xv = 0;
        e.preventDefault();
        restart();
    }
    if (e.keyCode == "39") {
        xv = 0;
        e.preventDefault();
        restart();
    }
}

function moveLeft() {
    xv = -3;
}
function moveRight() {
    xv = 3;
}
function clearMove() {
    xv = 0;
}

var difficulty = 1;

function enemies() {
    if (enemiesToMake > 0) {
        for (var i = 0; i < difficulty; i++) {
            var newEnemy = new enemyClass();
            enemy.push(newEnemy);
            enemiesToMake--;
        }
    }
}

function checkCollision() {
    for (var e = 0; e < enemy.length; e++) {
        for (var b = 0; b < bullet.length; b++) {

            if (bullet[b].x + 4 >= enemy[e].x &&
                bullet[b].x <= enemy[e].x + enemy[e].w &&
                bullet[b].y <= enemy[e].y + enemy[e].h &&
                bullet[b].y + 4 >= enemy[e].y) {

                for (var d = 0; d < 85; d++) {
                    var newDebris = new debrisClass();
                    newDebris.x = enemy[e].x;
                    newDebris.y = enemy[e].y;

                    if (Math.random() >= 0.6) {
                        newDebris.color = "grey";
                    }

                    debris.push(newDebris);
                } enemy[e].isDead = true;
                enemy.splice(e, 1);
                bullet.splice(b, 1);
                score--;
            }
        }
    }

    for (var bu = 0; bu < bullet.length; bu++) {
        for (var a = 0; a < ammoArray.length; a++) {

            if (bullet[bu].x + 4 >= ammoArray[a].x &&
                bullet[bu].x <= ammoArray[a].x + ammoArray[a].size &&
                bullet[bu].y <= ammoArray[a].y + ammoArray[a].size &&
                bullet[bu].y + 4 >= ammoArray[a].y) {

                for (var deb = 0; deb < 10; deb++) {
                    var newDeb = new debrisClass();
                    newDeb.x = ammoArray[a].x;
                    newDeb.y = ammoArray[a].y;
                    newDeb.color = "white";

                    debris.push(newDeb);
                }
                ammo += 10;
                ammoArray.splice(a, 1);
                bullet.splice(bu, 1);
            }
        }
    }
}

function checkEnemyPast() {
    for (var i = 0; i < enemy.length; i++) {
        if (enemy[i].y >= canvas.height) {
            enemy[i].isDead = true;
            enemy.splice(i, 1);
            lives--;
            score--;

        }
        if (enemy[i].x + enemy[i].w >= px &&
            enemy[i].x <= px + pw &&
            enemy[i].y + enemy[i].h >= py &&
            enemy[i].y <= py + ph) {
            for (var d = 0; d < 10; d++) {
                var newDebris = new debrisClass();
                newDebris.x = enemy[i].x;
                newDebris.y = enemy[i].y;
                if (Math.random() >= 0.5) {
                    newDebris.color = "grey";
                }

                debris.push(newDebris);
            }
            enemy[i].isDead = true;
            enemy.splice(i, 1);
            lives--;
            score--;

        }
    }

    for (var a = 0; a < ammoArray.length; a++) {
        if (ammoArray[a].x + ammoArray[a].size >= px &&
            ammoArray[a].x <= px + pw &&
            ammoArray[a].y + ammoArray[a].size >= py &&
            ammoArray[a].y <= py + ph) {

            for (var deb = 0; deb < 5; deb++) {
                var newDeb = new debrisClass();
                newDeb.x = ammoArray[a].x;
                newDeb.y = ammoArray[a].y;
                newDeb.color = "white";

                debris.push(newDeb);
            }

            ammo += 10;
            ammoArray.splice(a, 1);

        }
    }
}

document.addEventListener("click", restart);

function restart() {
    if (showWinScreen || showLoseScreen || showTitleScreen) {
        showWinScreen = false;
        showLoseScreen = false;
        showTitleScreen = false;
        score = 100;
        lives = 3;
        enemy.splice(0, enemy.length);
        ammo = 15;
        ammoArray.splice(0, ammoArray.length);
        difficulty = 1;
        enemiesToMake = 100;
        bullet.splice(0, bullet.length);
        debris.splice(0, debris.length);
        enBullet.splice(0, enBullet.length);

        py = 370;
        yv = 0;
        playerDead = false;

    }
    startGame();
}
function startGame() {
    if (showInstruction) {
        showInstruction = false;
        showTitleScreen = true;
    }
}

var playerDead = false;
var module = 0;
var posY = 430;

function draw() {

    drawRect(0, 0, canvas.width, canvas.height, "black");


    if (score == 0) {
        yv = -1.5;
    }
    if (py <= -ph) {
        showWinScreen = true;
    }
    if (lives == 0) {
        for (var i = 0; i < 500; i++) {
            var newDebris = new debrisClass();
            newDebris.x = px + pw / 2;
            newDebris.y = py + ph / 2;
            newDebris.cyclesLeft = 50 + Math.random() * 50;

            newDebris.velX = 3 - Math.random() * 6;

            newDebris.velY = 3 - Math.random() * 6;
            var color = Math.random()

            if (color >= 0.85) {
                newDebris.color = "green";
            }
            if (color <= 0.2) {
                newDebris.color = "grey";
            }

            debris.push(newDebris);
        }
        playerDead = true;
        lives--;
    }

    if (playerDead &&
        debris.length <= 5) {
        showLoseScreen = true;
    }


    if (score < 7) {
        difficulty = 2;
    }

    if (score <= 0) {
        for (var i = 0; i < enemy.length; i++) {
            var newDebris = new debrisClass();
            newDebris.x = enemy[i].x;
            newDebris.y = enemy[i].y;
            newDebris.isCircle = true;

            debris.push(newDebris);
            enemy.splice(i, 1);
        }
    }

    module++;

    if (module % 2 == 0) {
        var newStar = new starClass();
        star.push(newStar);
    }

    for (var i = 0; i < star.length; i++) {
        star[i].move();
        star[i].draw();
    }




    if (showInstruction) {
        posY -= 0.5;
        ctx.save();
        ctx.fillStyle = "gold";
        ctx.font = "20px arial";
        ctx.textAlign = "center";

        ctx.fillText("Welcome to a Bitcoin Invasion, ", canvas.width / 2, posY);
        ctx.fillText("Full of explosions and particles!", canvas.width / 2, posY + 25);

        ctx.font = "25px arial";
        ctx.fillText("Your Goal: ", canvas.width / 2, posY + 105);
        ctx.font = "20px arial";
        ctx.fillText("You need to defend your ship", canvas.width / 2, posY + 135);
        ctx.fillText("and do not let the FUD pass.", canvas.width / 2, posY + 160);
        ctx.fillText("If you are hit by the FUD, or", canvas.width / 2, posY + 185);
        ctx.fillText("let the FUD pass you,", canvas.width / 2, posY + 210);
        ctx.fillText("then you lose one of your lives,", canvas.width / 2, posY + 235);
        ctx.fillText("lose all lives and you die, you win", canvas.width / 2, posY + 260);
        ctx.fillText("by killing all of the FUD enemies.", canvas.width / 2, posY + 285);

        ctx.font = "25px arial";
        ctx.fillText("Ammo: ", canvas.width / 2, posY + 340);
        ctx.font = "20px arial";
        ctx.fillText("In order to fire your cannon, you", canvas.width / 2, posY + 370);
        ctx.fillText("need to have ammo, you", canvas.width / 2, posY + 390);
        ctx.fillText("get ammo by shooting or catching", canvas.width / 2, posY + 410);
        ctx.fillText("one of the white ammo crates.", canvas.width / 2, posY + 430);

        ctx.font = "25px arial";
        ctx.fillText("Controls: ", canvas.width / 2, posY + 485);
        ctx.font = "20px arial";
        ctx.fillText("To control your spaceship, you can", canvas.width / 2, posY + 515);
        ctx.fillText("either use your keyboard's arrow", canvas.width / 2, posY + 540);
        ctx.fillText("keys, or the default buttons under", canvas.width / 2, posY + 565);
        ctx.fillText("the game, on your keyboard,", canvas.width / 2, posY + 590);
        ctx.fillText("the up arrow key is used to shoot.", canvas.width / 2, posY + 615);

        ctx.font = "40px arial";
        ctx.fillText("Good Luck", canvas.width / 2, posY + 680);

        ctx.font = "20px arial";
        ctx.fillText("Click To Continue", canvas.width / 2, posY + 740);



        return;
    }




    if (showTitleScreen) {
        ctx.fillStyle = "cyan";
        ctx.font = "25px Arial";
        ctx.fillText("Crypto Invasion", canvas.width / 2, canvas.height / 2);

        ctx.fillStyle = "white";
        ctx.font = "12px Arial";
        ctx.fillText("Game By Satoshi's Game", canvas.width / 2, canvas.height - 15);


        ctx.fillStyle = "crimson";
        ctx.font = "20px Arial";
        ctx.fillText("Click To Play", canvas.width / 2, canvas.height / 2 + 80);
        return;
    }

    if (showWinScreen) {
        ctx.fillStyle = "cyan";
        ctx.font = "40px Arial";
        ctx.fillText("You Won!", canvas.width / 2, canvas.height / 2);

        ctx.fillStyle = "white";
        ctx.font = "12px Arial";
        ctx.fillText("Game By Satoshi's Games", canvas.width / 2, canvas.height - 15);

        ctx.fillStyle = "white"
        ctx.font = "10px Arial";
        ctx.fillText("Press An Arrow Key Or Click Restart", canvas.width / 2, canvas.height / 2 + 80);



        return;
    }

    if (showLoseScreen) {
        ctx.fillStyle = "crimson";
        ctx.font = "40px Arial";
        ctx.fillText("Game Over!", canvas.width / 2, canvas.height / 2 + 40);

        ctx.fillStyle = "cyan";
        ctx.font = "12px Arial";
        ctx.fillText("Game By Satoshi's Games", canvas.width / 2, canvas.height - 15);

        ctx.fillStyle = "white";
        ctx.font = "10px Arial";
        ctx.fillText("Press An Arrow Key Or Click To Restart", canvas.width / 2, canvas.height / 2 + 80);



        return;
    }

    for (var i = 0; i < star.length; i++) {
        if (star[i].y >= canvas.height) {
            star.splice(i, 1);
        }
    }

    for (var i = 0; i < ammoArray.length; i++) {
        ammoArray[i].move();
        ammoArray[i].draw();
    }

    px += xv;
    py += yv;

    if (px + pw >= canvas.width) {
        px = canvas.width - pw;
    }
    if (px <= 0) {
        px = 0;
    }

    for (var i = 0; i < bullet.length; i++) {
        bullet[i].move();
        bullet[i].draw();
    }

    for (var i = 0; i < enemy.length; i++) {
        if (enemy[i].x + enemy[i].w / 2 >= px &&
            enemy[i].x + enemy[i].w / 2 <= px + pw &&
            enBullet.length < enemy.length &&
            enemy[i].y <= canvas.height / 2) {
            if (Math.random() * 5 >= 4.5) {
                var newBullet = new enBulletClass();
                newBullet.x = enemy[i].x + enemy[i].w / 2;
                newBullet.y = enemy[i].y + enemy[i].h;
                newBullet.velY = 2.5;

                enBullet.push(newBullet);

            }
        }
    }

    for (var i = 0; i < enBullet.length; i++) {
        if (enBullet[i].y > canvas.height) {
            enBullet.splice(i, 1);
        }
    }

    for (var i = 0; i < enBullet.length; i++) {
        enBullet[i].move();
        enBullet[i].draw();
    }

    for (var i = 0; i < enBullet.length; i++) {
        if (enBullet[i].x + 4 >= px &&
            enBullet[i].x <= px + pw &&
            enBullet[i].y + 4 >= py &&
            enBullet[i].y <= py + ph) {

            lives--;


            for (var d = 0; d < 15; d++) {
                var newDebris = new debrisClass();
                newDebris.x = enBullet[i].x;
                newDebris.y = enBullet[i].y;
                newDebris.cyclesLeft = 10 + Math.random() * 45;


                if (Math.random() >= 0.65) {
                    newDebris.color = "green";
                }
                debris.push(newDebris);
            }
            enBullet.splice(i, 1);
        }
    }


    //drawRect(px, py, pw, ph, "green");

    if (playerDead == false) {
        ctx.beginPath();
        ctx.fillStyle = "#23B465";
        ctx.moveTo(px, py + ph);
        ctx.lineTo(px + pw / 2, py + ph - 7);
        ctx.lineTo(px + pw, py + ph);
        ctx.lineTo(px + pw / 2, py);
        ctx.lineTo(px, py + ph);
        ctx.fill();
        ctx.closePath();

        ctx.beginPath();
        ctx.fillStyle = "lightblue";
        ctx.lineWidth = 1;
        //ctx.rect(px + pw/2 -5, py + 15, 10, 5);
        ctx.moveTo(px + pw / 2 - 8, py + 20);
        ctx.lineTo(px + pw / 2 + 8, py + 20);
        ctx.lineTo(px + pw / 2, py + 7);
        ctx.lineTo(px + pw / 2 - 8, py + 20);
        ctx.fill();
        ctx.stroke();
        ctx.closePath();
    }


    for (var i = 0; i < enemy.length; i++) {
        if (enemy[i].isDead == false) {
            enemy[i].move();
            enemy[i].draw();
        }
        if (enemy[i].isDead) {
            enemy[i].y = -500;
            enemy[i].x = -500;
        }
    }

    if (lives == 3) {
        for (var i = 0; i < 5; i++) {
            var newSpark = new debrisClass();
            newSpark.x = px + pw / 2 - 1;
            newSpark.y = py + ph - 7;
            newSpark.velX = 0.5 - Math.random();
            newSpark.velY = 1;
            newSpark.color = "#2222ff";
            newSpark.cyclesLeft = 10 + Math.random() * 20;
            newSpark.circle = false;

            debris.push(newSpark);
        }
    }

    if (lives == 2) {

        for (var i = 0; i < 2; i++) {
            var newSpark = new debrisClass();
            newSpark.x = (5 + px) + (Math.random() * (pw - 10));
            newSpark.y = py + ph - 5;
            newSpark.velY = 1;
            newSpark.velX = 1 - Math.random() * 2;
            newSpark.cyclesLeft = 10 + Math.random() * 50;
            newSpark.color = "grey";
            newSpark.circle = false;

            debris.push(newSpark);
        }
    }


    if (lives == 1) {
        for (var i = 0; i < 2; i++) {
            var newSpark = new debrisClass();
            newSpark.x = (px + 5) + (Math.random() * (pw - 10));
            newSpark.y = py + ph - 5;
            newSpark.velY = 1;
            newSpark.velX = 1 - Math.random() * 2;
            newSpark.cyclesLeft = 10 + Math.random() * 50;
            newSpark.circle = false;
            if (Math.random() >= 0.6) {
                newSpark.color = "grey";
            }

            debris.push(newSpark);
        }
    }


    for (var i = 0; i < debris.length; i++) {
        if (debris[i].cyclesLeft <= 0) {
            debris.splice(i, 1);
        }
    }
    for (var i = 0; i < star.length; i++) {
        if (star[i].y > canvas.height) {
            star.splice(i, 1);
        }
    }
    for (var i = 0; i < bullet.length; i++) {
        if (bullet[i].y <= 10) {
            bullet.splice(i, 1);
        }
    }


    checkCollision();

    checkEnemyPast();

    for (var i = 0; i < debris.length; i++) {
        debris[i].move();
        debris[i].draw();
    }

    drawRect(0, 0, canvas.width, 30, "white");

    if (lives == 3) {
        for (var i = 0; i < 12; i += 4) {
            ctx.beginPath();
            ctx.fillStyle = "green";
            ctx.strokeStyle = "black";
            ctx.lineWidth = "2";
            ctx.rect(10 + 5 * i, 5, 15, 15);
            ctx.stroke();
            ctx.fill();
            ctx.closePath();
        }
    }

    if (lives == 2) {
        for (var i = 0; i < 8; i += 4) {
            ctx.beginPath();
            ctx.fillStyle = "green";
            ctx.strokeStyle = "black";
            ctx.lineWidth = "2";
            ctx.rect(10 + 5 * i, 5, 15, 15);
            ctx.stroke();
            ctx.fill();
            ctx.closePath();
        }
    }

    if (lives == 1) {
        for (i = 0; i < 4; i += 4) {
            ctx.beginPath();
            ctx.fillStyle = "green";
            ctx.strokeStyle = "black";
            ctx.lineWidth = "2";
            ctx.rect(10 + 5 * i, 5, 15, 15);
            ctx.stroke();
            ctx.fill();
            ctx.closePath();
        }
    }

    ctx.fillStyle = "black";
    ctx.font = "20px sans-serif";
    ctx.fillText("Ammo: " + ammo, canvas.width / 2, 20)

    ctx.beginPath();
    ctx.fillStyle = "red";
    ctx.lineWidth = "1.5";
    ctx.rect(canvas.width - 70, 5, 15, 15);
    ctx.fill();
    ctx.stroke();
    ctx.closePath();

    ctx.fillStyle = "black";
    ctx.fillText(": " + score, canvas.width - 35, 20);

    /*
    var debug = document.getElementById("debug");
    debug.innerHTML = "star: " + star.length + " " + "bullet: " + bullet.length + " " + "debris: " + debris.length + " " + "Enemies: " + enemiesToMake + " " + "enBullets: " + enBullet.length;
    */
}
