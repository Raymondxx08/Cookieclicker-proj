int cookies = 0;  // Number of cookies
int upgradeCost = 100;  // Cost of the upgrade
float cookiesPerClick = 1;  // How many cookies we get per click
boolean upgradeActive = false;  // Whether upgrade is active
boolean gameWon = false;  // Whether the player has won

int targetCookies = 10000;  // Target cookies for the objective (10,000 cookies)

Cookie cookie;  // Cookie object
Upgrade upgrade;  // Upgrade object

Button resetButton;  // Reset button to restart the game
boolean isClickingCookie = false;  // To track if the cookie is being clicked and held

void setup() {
  size(800, 400);
  
  // Initialize cookie and upgrade objects
  cookie = new Cookie(200, 200, 100);  // Cookie located at (200, 200) with radius 100
  upgrade = new Upgrade(400, 150, 50, "Upgrade", upgradeCost);  // Upgrade at (400, 150)
  
  // Initialize reset button
  resetButton = new Button(width - 100, 30, 80, 30, "Reset");
}

void draw() {
  background(240);

  // Show number of cookies on screen
  fill(0);
  textSize(20);
  text("Cookies: " + cookies, 100, 30);
  
  // Show cookies per click
  textSize(16);
  text("Cookies per Click: " + cookiesPerClick, 100, 60);
  
  // Draw and update cookie behavior
  cookie.display();
  cookie.update();

  // Draw and update upgrade behavior
  upgrade.display();
  upgrade.update();

  // Show upgrade cost if it's not unlocked
  if (cookies < upgradeCost) {
    fill(0);
    textSize(15);
    text("Upgrade Cost: " + upgradeCost, 400, 220);
  }

  // Check if player has reached the 10K objective
  if (cookies >= targetCookies && !gameWon) {
    gameWon = true;  // Set gameWon to true
    displayWinMessage();  // Display the win message
  }

  // Draw and handle reset button only if player has won (reached 10k cookies)
  if (gameWon) {
    resetButton.display();  // Display reset button only after reaching 10k cookies
  }
}

// Function to display win message
void displayWinMessage() {
  fill(0, 255, 0);
  textSize(40);
  textAlign(CENTER, CENTER);
  text("YOU WIN!!!", width / 2, height / 2);
}

void mousePressed() {
  // If the game is won, don't allow any further clicks
  if (gameWon) {
    // If the reset button is clicked, reset the game
    if (resetButton.isClicked(mouseX, mouseY)) {
      resetGame();  // Call the reset function
    }
    return;  // Ignore further mouse presses if the game is won
  }

  // If the cookie is clicked, increment cookies by cookiesPerClick
  if (cookie.isClicked(mouseX, mouseY)) {
    cookies += cookiesPerClick;  // Increment on initial click
    isClickingCookie = true;  // Track that we are holding the cookie
  }

  // If the upgrade is clicked, purchase upgrade if enough cookies
  if (upgrade.isClicked(mouseX, mouseY) && cookies >= upgradeCost) {
    cookies -= upgradeCost;
    upgrade.activate();
  }
}

void mouseReleased() {
  // Deactivate upgrade when mouse is released
  upgrade.deactivate();
  
  // Stop adding cookies when the mouse is released
  isClickingCookie = false;
}

void mouseDragged() {
  // Allow for continuous cookie increase while holding the mouse down
  if (isClickingCookie) {
    if (cookie.isClicked(mouseX, mouseY)) {
      cookies += cookiesPerClick;  // Add cookies while holding the mouse down
    }
  }
}

// Function to reset the game progress
void resetGame() {
  cookies = 0;
  cookiesPerClick = 1;
  gameWon = false;
  upgradeCost = 100;
  upgrade.deactivate();  // Deactivate upgrade
}

// Cookie class - clickable object that gives cookies
class Cookie {
  float x, y, radius;

  Cookie(float x, float y, float radius) {
    this.x = x;
    this.y = y;
    this.radius = radius;
  }

  void display() {
    // Draw the cookie as a simple circle (no image)
    fill(255, 200, 0);  // Color for the cookie
    ellipse(x, y, radius * 2, radius * 2);  // Draw the circle (cookie)
  }

  void update() {
    // If the mouse is hovering over the cookie, highlight it
    if (dist(mouseX, mouseY, x, y) < radius) {
      fill(255, 220, 0, 150);  // Hover effect (semi-transparent)
      ellipse(x, y, radius * 2, radius * 2);  // Highlight the cookie on hover
    }
  }

  boolean isClicked(float mx, float my) {
    // Return true if the mouse is inside the cookie when clicked
    return dist(mx, my, x, y) < radius;
  }
}

// Upgrade class - clickable object that activates when clicked
class Upgrade {
  float x, y, size;
  String label;
  int cost;
  boolean active = false;
  int upgradeEffectDuration = 0;  // Timer for upgrade effects

  Upgrade(float x, float y, float size, String label, int cost) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.label = label;
    this.cost = cost;
  }

  void display() {
    // Display the upgrade button
    if (active) {
      fill(0, 255, 0);  // Active state (green)
    } else if (dist(mouseX, mouseY, x, y) < size / 2) {
      fill(255, 0, 0);  // Hover effect (red)
    } else {
      fill(200);  // Default state (grey)
    }
    ellipse(x, y, size, size);
    
    // Display label inside the circle
    fill(0);
    textSize(16);
    textAlign(CENTER, CENTER);
    text(label, x, y);
  }

  void update() {
    // If the mouse is pressed and held over the upgrade, activate it
    if (dist(mouseX, mouseY, x, y) < size / 2 && mousePressed) {
      active = true;
    }

    // Upgrade effect duration for extra features (e.g., particle effects, boosts)
    if (upgradeEffectDuration > 0) {
      upgradeEffectDuration--;
      // Increase cookies per click (upgrade effect)
      cookiesPerClick++;
    }
  }

  boolean isClicked(float mx, float my) {
    // Return true if the upgrade button is clicked
    return dist(mx, my, x, y) < size / 2;
  }

  void activate() {
    // Activate the upgrade - increase cookie points per click
    label = "Activated!";
    upgradeCost = 200;  // Update the cost for the next upgrade
    active = true;
    
    // Start an effect (temporary boost or visual effect)
    upgradeEffectDuration = 200;  // Effect lasts for 200 frames
  }

  void deactivate() {
    // Deactivate the upgrade when mouse is released
    if (active) {
      label = "Upgrade";
      active = false;
    }
  }
}

// Button class for the reset button
class Button {
  float x, y, w, h;
  String label;

  Button(float x, float y, float w, float h, String label) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
  }

  void display() {
    // Draw the button only if the game is won (cookies >= targetCookies)
    if (gameWon) {
      fill(200);
      rect(x, y, w, h, 10);  // Draw a rectangle for the button
      fill(0);
      textSize(16);
      textAlign(CENTER, CENTER);
      text(label, x + w / 2, y + h / 2);  // Draw the button label
    }
  }

  boolean isClicked(float mx, float my) {
    // Check if the mouse is clicked inside the button
    return mx > x && mx < x + w && my > y && my < y + h;
  }
}
