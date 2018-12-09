/**
	State shown when the player loses!
	Code by Rob Kleffner, 2011
*/

src = "https://code.jquery.com/jquery-3.3.1.js"
integrity = "sha256-2Kok7MbOyxpgUVvAk/HJ2jigOSYS2auK4Pfzbm7uH60="
crossorigin = "anonymous"

Mario.LoseState = function () {
    this.drawManager = null;
    this.camera = null;
    this.gameOver = null;
    this.font = null;
    this.secondFont = null;
    this.wasKeyDown = false;
};

Mario.LoseState.prototype = new Enjine.GameState();

Mario.LoseState.prototype.Enter = function () {
    this.drawManager = new Enjine.DrawableManager();
    this.camera = new Enjine.Camera();

    this.gameOver = new Enjine.AnimatedSprite();
    this.gameOver.Image = Enjine.Resources.Images["gameOverGhost"];

    // this needs the src from google api to create a QR code from the invoice request
    // this.gameOver.Image = 
    this.gameOver.SetColumnCount(9);
    this.gameOver.SetRowCount(1);
    this.gameOver.AddNewSequence("turnLoop", 0, 0, 0, 8);
    this.gameOver.PlaySequence("turnLoop", true);
    this.gameOver.FramesPerSecond = 1 / 15;
    this.gameOver.X = 112;
    this.gameOver.Y = 68;

    this.font = Mario.SpriteCuts.CreateGreenFont();
    this.font.Strings[0] = {
        String: "Buy 1 life to recover your progress",
        X: 25,
        Y: 20
    };

    this.secondFont = Mario.SpriteCuts.CreateBlackFont();
    this.secondFont.Strings[0] = {
        String: "Or press S to start again",
        X: 60,
        Y: 180
    };
    this.drawManager.Add(this.font);
    this.drawManager.Add(this.secondFont);
    this.drawManager.Add(this.gameOver);
};

Mario.LoseState.prototype.Exit = function () {
    this.drawManager.Clear();
    delete this.drawManager;
    delete this.camera;
    delete this.gameOver;
    delete this.font;
    delete this.secondont;
};

Mario.LoseState.prototype.Update = function (delta) {
    this.drawManager.Update(delta);
    if (Enjine.KeyboardInput.IsKeyDown(Enjine.Keys.S)) {
        this.wasKeyDown = true;
    }
};

Mario.LoseState.prototype.Draw = function (context) {
    this.drawManager.Draw(context, this.camera);
};

Mario.LoseState.prototype.CheckForChange = function (context) {
    if (this.wasKeyDown && !Enjine.KeyboardInput.IsKeyDown(Enjine.Keys.S)) {
        context.ChangeState(new Mario.TitleState());
    }
};