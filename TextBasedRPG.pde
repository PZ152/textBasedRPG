import java.util.Arrays;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.*;

// ==========================================================
// Text-Based RPG
// ==========================================================
// Project Description:
// This is a text-based RPG game with turn-based combat, developed
// using Processing 4.3. The game features a low-tech fantasy
// environment with magical elements. Players can configure their
// abilities before battles, engage in automated turn-based combat, // receive post-battle rewards, and customize their ability loadout
// between battles. The game supports both PC and Android platforms.
//
// Core Features:
// - Ability Loadout Setup
// - Turn-Based Combat
// - Post-Battle Rewards
// - Customization
// - Game Saves
//
// Game Screens:
// - New Game Screen
// - Reward Screen
// - Customization Screen
// - Battle Screen
// - Story Screen
//
// Author: Pijus Zadeikis
// Project Start Date: June 6th, 2024
// ==========================================================

import processing.core.PApplet;

// ==========================================================
// MAIN CLASS
// ==========================================================
public class TextBasedRPG extends PApplet {
  GameScreenManager screenManager;
  public static Character player;
  static final int PLAYER_STARTING_HP = 100;
  static final int ENEMY_STARTING_HP = 100;

  public static void main(String[] args) {
    PApplet.main("TextBasedRPG");
  }

  public void settings() {
    size(1200, 1200); // Window size
  }

  public void setup() {
    screenManager = new GameScreenManager(this);
    screenManager.showScreen(new TitleScreen(this, screenManager));
  }

  public void draw() {
    screenManager.update();
    screenManager.draw();
  }

  public void keyPressed() {
    screenManager.keyPressed();
  }

  @Override public void keyReleased() {
    screenManager.keyReleased();
  }

  public void mouseWheel(MouseEvent event) {
    if (screenManager.getActiveScreen() instanceof BattleScreen) {((BattleScreen) screenManager.getActiveScreen()).mouseWheel(event);
    }
  }
}
// ==========================================================
// GAME SCREEN INTERFACE
// This interface defines the common methods that all game
// screens must implement: init(), update(), draw(), dispose(), //  and keyPressed().
// ==========================================================
interface GameScreen {
  void init();
  void update();
  void draw();
  void dispose();
  void keyPressed();
  void keyReleased();
}
// ==========================================================
// GAME SCREEN MANAGER CLASS
// The GameScreenManager class is responsible for managing the active screen, // handling transitions between screens, and delegating the update(), draw(), // and keyPressed() methods to the active screen.
// ==========================================================
class GameScreenManager {
  private PApplet applet;
  private GameScreen activeScreen;
  private GameDataManager dataManager;
  private Stack<GameScreen> screenStack = new Stack<>();

  public GameScreenManager(PApplet applet) {
    this.applet = applet;
    this.dataManager = new GameDataManager();
  }

  public void showScreen(GameScreen screen) {
    if (activeScreen != null) {
      screenStack.push(activeScreen);
    }
    activeScreen = screen;
    activeScreen.init();
  }

  public void pushScreen(GameScreen screen) {
    if (activeScreen != null) {
      screenStack.push(activeScreen);
    }
    activeScreen = screen;
    activeScreen.init();
  }

  public void popScreen() {
    if (!screenStack.isEmpty()) {
      activeScreen.dispose();
      activeScreen = screenStack.pop();
      activeScreen.init();
    } else {
      // No screens to pop, you may want to handle this case
    }
  }

  public void update() {
    if (activeScreen != null) {
      activeScreen.update();
    }
  }

  public void draw() {
    if (activeScreen != null) {
      activeScreen.draw();
    }
  }

  public void keyPressed() {
    if (activeScreen != null) {
      activeScreen.keyPressed();
    }
  }

  public void keyReleased() {
    if (activeScreen != null) {
      activeScreen.keyReleased();
    }
  }

  public GameScreen getActiveScreen() {
    return activeScreen;
  }

  public GameDataManager getDataManager() {
    return dataManager;
  }
}
// ==========================================================
// TITLE SCREEN CLASS
// This TitleScreen class implements the GameScreen interface
// and manages the title screen where players can select options
// such as starting a new game or entering a custom battle.
// It handles the user input to navigate through the options
// and to select an option
// ==========================================================
class TitleScreen implements GameScreen {
  private PApplet applet;
  private GameScreenManager screenManager;
  private String[] options = {
    "New Game", "Load Game", "Custom Battle"}
  ;
  private int selectedOption = 0;

  public TitleScreen(PApplet applet, GameScreenManager screenManager) {
    this.applet = applet;
    this.screenManager = screenManager;
  }

  @Override public void init() {
    // Initialization code for the title screen
  }

  @Override public void update() {
    // Update logic for the title screen
  }

  @Override public void draw() {
    applet.background(0);
    applet.fill(255);
    applet.textAlign(PApplet.CENTER, PApplet.CENTER);
    applet.textSize(32);
    applet.text("Title Screen", applet.width / 2, applet.height / 4);

    applet.textSize(24);
    for(int i = 0;
    i < options.length;
    i++) {
      if (i == selectedOption) {
        applet.fill(200, 200, 50); // Highlight selected option
      } else {
        applet.fill(255);
      }
      applet.text(options[i], applet.width / 2, applet.height / 2 + i * 30);
    }
  }

  @Override public void dispose() {
    // Cleanup code for the title screen
  }

  @Override public void keyPressed() {
    if (applet.keyCode == PApplet.UP) {
      selectedOption =(selectedOption - 1 + options.length) % options.length;
    }
    else if (applet.keyCode == PApplet.DOWN) {
      selectedOption =(selectedOption + 1) % options.length;
    }

    else if (applet.keyCode == PApplet.ENTER) {

      switch(selectedOption) {
        case 0: screenManager.showScreen(new NewGameScreen(applet, screenManager));
        break;
        case 2 : // Custom Battle option
        screenManager.showScreen(new CustomBattleScreen(applet, screenManager));
        break;
        // Add additional cases for other options if needed
      }
    }
  }

  @Override public void keyReleased() {
    // Implement logic if needed or leave empty
  }
}
// ==========================================================
// NEW GAME SCREEN CLASS
// This NewGameScreen class implements the GameScreen interface
//  and manages the screen where players can enter their name
//  before starting the game. It handles the user input for
// entering the name and initializes the player character with
// a set of default abilities.
// ==========================================================
class NewGameScreen implements GameScreen {
  private PApplet applet;
  private GameScreenManager screenManager;
  private String playerName = "";
  private final int MAX_NAME_LENGTH = 16;

  public NewGameScreen(PApplet applet, GameScreenManager screenManager) {
    this.applet = applet;
    this.screenManager = screenManager;
  }

  @Override public void init() {
    // Initialization code for the new game screen
  }

  @Override public void update() {
    // Update logic for the new game screen
  }

  @Override public void draw() {
    applet.background(0);
    applet.fill(255);
    applet.textAlign(PApplet.CENTER, PApplet.CENTER);
    applet.textSize(24);

    int centerX = applet.width / 2;
    int centerY = applet.height / 2;

    // Display text as per the provided example
    applet.text("====== Enter Player Name ======", centerX, centerY - 60);
    applet.text(playerName + "_", centerX, centerY - 30); // Display the current player name with a cursor
    applet.text("====== Press To Continue ======", centerX, centerY);

    applet.textAlign(PApplet.CENTER, PApplet.CENTER);
  }

  @Override public void dispose() {
    // Cleanup code for the new game screen
  }

  @Override public void keyPressed() {
    if (applet.key == PApplet.BACKSPACE) {
      handleBackspace();
    }
    else if (applet.keyCode == PApplet.ENTER) {
      handleEnter();
    } else {
      handleCharacterInput(applet.key);
    }
  }

  private void handleBackspace() {
    if (playerName.length() > 0) {
      playerName = playerName.substring(0, playerName.length() - 1);
    }
  }

  @Override public void keyReleased() {
    // Implement logic if needed or leave empty
  }

  private void handleEnter() {
    if (playerName.length() > 0) {
      // Initialize the player character here
      List<Ability> playerAbilities = new ArrayList<>();
      playerAbilities.add(new Attack("Basic Attack", 1, 1, "Physical", "", 0));
      playerAbilities.add(new Block("Shield Block", 1, 1, "Physical", "Fire", 2));
      playerAbilities.add(new Heal("Quick Heal", 1, 1, "", "", 2));
      playerAbilities.add(new ReverseHeal("Curse of Pain", 1, 1, "", "", 3));
      playerAbilities.add(new Absorb("Fire Absorb", 1, 1, "Fire", "", 2));
      playerAbilities.add(new Absorb("Phys Absorb", 1, 1, "Physical", "", 2));
      TextBasedRPG.player = new Character(playerName, TextBasedRPG.PLAYER_STARTING_HP, playerAbilities);

      screenManager.showScreen(new RewardScreen(applet, screenManager));
    }
  }

  private void handleCharacterInput(char key) {
    if (playerName.length() < MAX_NAME_LENGTH && isValidCharacter(key)) {
      playerName += key;
    }
  }

  private boolean isValidCharacter(char c) {
    return(c >= 'a' && c <= 'z') ||(c >= 'A' && c <= 'Z') ||(c >= '0' && c <= '9') || c == '-' || c == '_' || c == ' ';
  }
}
// ==========================================================
// REWARD SCREEN CLASS(Placeholder)
// ==========================================================
class RewardScreen implements GameScreen {
  private PApplet applet;
  private GameScreenManager screenManager;

  public RewardScreen(PApplet applet, GameScreenManager screenManager) {
    this.applet = applet;
    this.screenManager = screenManager;
  }

  @Override public void init() {
    // Initialization code for the reward screen
  }

  @Override public void update() {
    // Update logic for the reward screen
  }

  @Override public void draw() {
    applet.background(0);
    applet.fill(255);
    applet.textAlign(PApplet.CENTER, PApplet.CENTER);
    applet.textSize(24);
    applet.text("Reward Screen Placeholder", applet.width / 2, applet.height / 2 - 30);
    applet.text("Press ENTER to proceed to Customization", applet.width / 2, applet.height / 2);
  }

  @Override public void dispose() {
    // Cleanup code for the reward screen
  }

  @Override public void keyReleased() {
    // Implement logic if needed or leave empty
  }

  @Override public void keyPressed() {
    if (applet.keyCode == PApplet.ENTER) {
      screenManager.showScreen(new CustomizationScreen(applet, screenManager));
    }
  }
}
// ==========================================================
// CUSTOMIZATION SCREEN CLASS(Placeholder)
// ==========================================================
class CustomizationScreen implements GameScreen {
  private PApplet applet;
  private GameScreenManager screenManager;

  public CustomizationScreen(PApplet applet, GameScreenManager screenManager) {
    this.applet = applet;
    this.screenManager = screenManager;
  }

  @Override public void init() {
    // Initialization code for the customization screen
  }

  @Override public void update() {
    // Update logic for the customization screen
  }

  @Override public void draw() {
    applet.background(0);
    applet.fill(255);
    applet.textAlign(PApplet.CENTER, PApplet.CENTER);
    applet.textSize(24);
    applet.text("Customization Screen Placeholder", applet.width / 2, applet.height / 2 - 30);
    applet.text("Press ENTER to proceed to Battle", applet.width / 2, applet.height / 2);
  }

  @Override public void dispose() {
    // Cleanup code for the customization screen
  }

  @Override public void keyReleased() {
    // Implement logic if needed or leave empty
  }

  @Override public void keyPressed() {
    if (applet.keyCode == PApplet.ENTER) {
      // Uncomment and implement the BattleScreen initialization when ready
      // screenManager.showScreen(new BattleScreen(applet, screenManager));
    }
  }
}
// ==========================================================
// BATTLE SCREEN CLASS
// Implements the GameScreen interface and manages the screen
// where the battles take place. It handles the user input for
// progressing through turns, updates the battle log, and
// manages scrolling through the log.
// ==========================================================
class BattleScreen implements GameScreen {
  private PApplet applet;
  private GameScreenManager screenManager;
  private Character player;
  private Character enemy;
  private boolean turnProcessed = false;
  private StringBuilder battleLog;
  private int logOffset; // Offset for scrolling the log
  private int logHeight; // Total height of the log
  private int visibleLogHeight; // Height of the visible log area
  private int instructionsHeight; // Height of the instructions text
  private int lineHeight;
  private int maxLines;
  private String[] lines;

  public BattleScreen(PApplet applet, GameScreenManager screenManager, Character enemy) {
    this.applet = applet;
    this.screenManager = screenManager;
    this.player = screenManager.getDataManager().getPlayer();
    this.enemy = enemy;
    this.logOffset = 0;
    this.lineHeight = 20; // Height of each line
    this.instructionsHeight = 50; // Height of the instructions area
    this.visibleLogHeight = applet.height - instructionsHeight - 20; // 20 pixels for top padding
    this.maxLines =((applet.height - 40) / this.lineHeight); // Calculate how many lines fit on the screen

    if (this.player == null) {
      System.out.println("Error: Player character is null.");
    }
    if (this.enemy == null) {
      System.out.println("Error: Enemy character is null.");
    }
  }

  @Override public void init() {
    // Ensure the battleLog is initialized
    battleLog = new StringBuilder();

    // Additional debug statements
    System.out.println("BattleScreen initialized");
    if (player != null) {
      System.out.println("Player: " + player.name + ", Health: " + player.health);
    } else {
      System.out.println("Error: Player character is null during init.");
    }
    if (enemy != null) {
      System.out.println("Enemy: " + enemy.name + ", Health: " + enemy.health);
    } else {
      System.out.println("Error: Enemy character is null during init.");
    }
  }

  @Override public void update() {
    // Process a turn if the spacebar was pressed

    if (turnProcessed) {
      turnProcessed = false;

      // Battle logic
      BattleManager battleManager = new BattleManager(Arrays.asList(player, enemy), battleLog);
      battleManager.collectEffects();
      battleManager.resolveActions();
      player.updateCooldowns();
      enemy.updateCooldowns();

      // Log the battle outcome
      battleLog.append(player.name + " HP = " + player.health + " | " + enemy.name + " HP = " + enemy.health + "\n");
      battleLog.append("------------------------------------------------------------------------------------\n"); // Add the divider here
      lines = battleLog.toString().split("\n");
      logHeight = calculateLogHeight();

      // Check for battle end conditions
      if (player.health <= 0 || enemy.health <= 0) {
        battleLog.append("Battle ended!\n");
        if (player.health <= 0) {
          battleLog.append("You have been defeated.\n");
        } else {
          battleLog.append("You have defeated the " + enemy.name + ".\n");
        }
        battleLog.append("---------------------\n"); // Add the divider here
        lines = battleLog.toString().split("\n");
        logHeight = calculateLogHeight();
      }
      // Scroll to the bottom
      logOffset = PApplet.max(0, logHeight - visibleLogHeight);
    }
  }

  @Override public void draw() {
    applet.background(0);
    applet.fill(255);
    applet.textSize(16);
    applet.textAlign(PApplet.LEFT, PApplet.TOP);

    // Split content into lines
    lines = battleLog.toString().split("\n");

    // Draw the lines with scrolling effect
    int y = 20 - logOffset; // Start with padding
    for(int i = 0;
    i < lines.length; i++) {
      if (y >= 20 && y <= visibleLogHeight + 20) {
        // Ensure we only draw visible lines
        applet.text(lines[i], 20, y);
      }
      y += lineHeight;
    }
    // Instructions to proceed to the next turn
    applet.textAlign(PApplet.LEFT, PApplet.BOTTOM);
    applet.text("Press SPACE to advance to the next turn.", 20, applet.height - 20);
  }

  @Override public void dispose() {
    // Cleanup code for the battle screen
  }

  @Override public void keyPressed() {
    // Handle spacebar press to process the next turn
    if (applet.key == ' ') {
      turnProcessed = true;
    }
    else if (applet.keyCode == PApplet.UP) {
      // Scroll up
      logOffset -= lineHeight;
      logOffset = PApplet.constrain(logOffset, 0, PApplet.max(0, logHeight - visibleLogHeight));
    }
    else if (applet.keyCode == PApplet.DOWN) {
      // Scroll down
      logOffset += lineHeight;
      logOffset = PApplet.constrain(logOffset, 0, PApplet.max(0, logHeight - visibleLogHeight));
    }
  }

  @Override public void keyReleased() {
    // Implement logic if needed or leave empty
  }

  public void mouseWheel(MouseEvent event) {
    float e = event.getCount();
    logOffset += e * lineHeight; // Adjust scroll speed if needed
    logOffset = PApplet.constrain(logOffset, 0, PApplet.max(0, logHeight - visibleLogHeight));
  }

  private int calculateLogHeight() {
    return lines.length * lineHeight;
  }
}
// ==========================================================
// ABILITY CLASS
// Ability(String name, int power, int weight, String primaryType, String secondaryType, int cooldown)
// defines common properties and methods for all abilities.
// Subclasses must implement the output(), generateMessage(), and clone() methods.
// ==========================================================
abstract class Ability {
  String classType;
  String name;
  int power;
  int weight;
  String primaryType;
  String secondaryType;
  boolean isDisabled;
  int cooldown;
  int currentCooldown;

  Ability(String name, int power, int weight, String primaryType, String secondaryType, int cooldown) {
    this.name = name;
    this.power = power;
    this.weight = weight;
    this.primaryType = primaryType;
    this.secondaryType = secondaryType;
    this.isDisabled = false;
    this.cooldown = cooldown;
    this.currentCooldown = 0;
  }

  boolean canUse() {
    return !isDisabled && currentCooldown == 0;
  }

  void resetCooldown() {
    this.currentCooldown = cooldown;
  }

  void decrementCooldown() {
    if (currentCooldown > 0) {
      currentCooldown--;
      System.out.println(name + " cooldown: " + currentCooldown);
    }
  }
  abstract ArrayList<Effect> output();
  abstract String generateMessage(String casterName, int chance);
  public abstract Ability clone();
}
// ==========================================================
// ATTACK CLASS(INHERITS ABILITY)
// ==========================================================
class Attack extends Ability {

  Attack(String name, int power, int weight, String primaryType, String secondaryType, int cooldown) {
    super(name, power, weight, primaryType, secondaryType, cooldown);
    classType = "Attack";
  }

  @Override ArrayList<Effect> output() {
    ArrayList<Effect> effects = new ArrayList<Effect>();
    effects.add(new Effect(primaryType.toLowerCase() + "Damage", power, 0)); // Ensure lowercase and correct format
    if (!secondaryType.isEmpty()) {
      effects.add(new Effect(secondaryType.toLowerCase() + "Damage", power, 0)); // Include secondary type if present
    }
    return effects;
  }

  @Override String generateMessage(String casterName, int chance) {
    String message = casterName + " attacks with " + name + " for " + power + " " + primaryType.toLowerCase() + " damage";
    if (!secondaryType.isEmpty()) {
      message += " and " + power + " " + secondaryType.toLowerCase() + " damage";
    }
    message += "(Power Level " + power + " | " + chance + "% Chance)";
    return message;
  }

  @Override public Attack clone() {
    return new Attack(this.name, this.power, this.weight, this.primaryType, this.secondaryType, this.cooldown);
  }
}
// ==========================================================
// BLOCK CLASS(INHERITS ABILITY)
// ==========================================================
class Block extends Ability {

  Block(String name, int power, int weight, String primaryType, String secondaryType, int cooldown) {
    super(name, power, weight, primaryType, secondaryType, cooldown);
    classType = "Block";
  }

  @Override ArrayList<Effect> output() {
    ArrayList<Effect> effects = new ArrayList<Effect>();
    if (!primaryType.isEmpty()) {
      effects.add(new Effect(primaryType.toLowerCase() + "Blocked", power, 0));
    }
    if (!secondaryType.isEmpty()) {
      effects.add(new Effect(secondaryType.toLowerCase() + "Blocked", power, 0));
    }
    return effects;
  }

  @Override String generateMessage(String casterName, int chance) {
    String message = casterName + " uses " + name + " to block";
    if (!primaryType.isEmpty()) {
      message += " " + primaryType.toLowerCase();
    }
    if (!secondaryType.isEmpty()) {
      message += " and " + secondaryType.toLowerCase();
    }
    message += " with a strength of " + power + " damage.";

    message += "(Power Level " + power + " | " + chance + "% Chance)";
    return message;
  }

  @Override public Block clone() {
    return new Block(this.name, this.power, this.weight, this.primaryType, this.secondaryType, this.cooldown);
  }
}
// ==========================================================
// HEAL CLASS(INHERITS ABILITY)
// ==========================================================
class Heal extends Ability {

  Heal(String name, int power, int weight, String primaryType, String secondaryType, int cooldown) {
    super(name, power, weight, primaryType, secondaryType, cooldown);
    classType = "Heal";
  }

  @Override ArrayList<Effect> output() {
    ArrayList<Effect> effects = new ArrayList<Effect>();
   effects.add(new Effect("heal", power, 0));
    return effects;
  }

  @Override String generateMessage(String casterName, int chance) {
    return casterName + " uses " + name + " to recover " + power + " HP.(Power Level " + power + " | " + chance + "% Chance)";
  }

  @Override public Heal clone() {
    return new Heal(this.name, this.power, this.weight, this.primaryType, this.secondaryType, this.cooldown);
  }
}
// ==========================================================
// REVERSE HEAL CLASS(INHERITS ABILITY)
// ==========================================================
class ReverseHeal extends Ability {

  ReverseHeal(String name, int power, int weight, String primaryType, String secondaryType, int cooldown) {
    super(name, power, weight, primaryType, secondaryType, cooldown);
    classType = "ReverseHeal";
  }

  @Override ArrayList<Effect> output() {
    ArrayList<Effect> effects = new ArrayList<Effect>();
    effects.add(new Effect("reverseHeal", power, 0));
    return effects;
  }

  @Override String generateMessage(String casterName, int chance) {
    return casterName + " uses " + name + " to reverse up to " + power + " of the target's healing.(Power Level " + power + " | " + chance + "% Chance)";
  }

  @Override public ReverseHeal clone() {
    return new ReverseHeal(this.name, this.power, this.weight, this.primaryType, this.secondaryType, this.cooldown);
  }
}
// ==========================================================
// ABSORB CLASS(INHERITS ABILITY)
// ==========================================================
class Absorb extends Ability {

  Absorb(String name, int power, int weight, String primaryType, String secondaryType, int cooldown) {
    super(name, power, weight, primaryType, secondaryType, cooldown);
    classType = "Absorb";
  }

  @Override ArrayList<Effect> output() {
    ArrayList<Effect> effects = new ArrayList<Effect>();
    if (!primaryType.isEmpty()) {
      effects.add(new Effect(primaryType.toLowerCase() + "Absorbed", power, 0));
    }
    if (!secondaryType.isEmpty()) {
      effects.add(new Effect(secondaryType.toLowerCase() + "Absorbed", power, 0));
    }
    return effects;
  }

  @Override String generateMessage(String casterName, int chance) {
    String message = casterName + "'s " + name + " can absorb " + power + " ";
    if (!primaryType.isEmpty()) {
      message += " " + primaryType.toLowerCase();
    }
    if (!secondaryType.isEmpty()) {
      message += " and " + secondaryType.toLowerCase();
    }
    message +=" damage.";
    message += "(Power Level " + power + " | " + chance + "% Chance)";
    return message;
  }

  @Override public Absorb clone() {
    return new Absorb(this.name, this.power, this.weight, this.primaryType, this.secondaryType, this.cooldown);
  }
}

// ==========================================================
// DAMAGE OVER TIME SKILL CLASS(INHERITS ABILITY)
// Applies a DoT that does (power/4)+1 damage , for (power +2) turns
// ==========================================================
class DoTskill extends Ability {

    DoTskill(String name, int power, int weight, String primaryType, String secondaryType, int cooldown) {
        super(name, power, weight, primaryType, secondaryType, cooldown);
        classType = "DoTskill";
    }

  @Override ArrayList<Effect> output() {
    ArrayList<Effect> effects = new ArrayList<Effect>();
        effects.add(new Effect(primaryType.toLowerCase() + "DoT", (power/4)+1, power + 2)); //Applies a DoT that does (power/4)+1 damage , for (power +2) turns
        return effects;
    }

    @Override
    String generateMessage(String casterName, int chance) {
        String message = casterName + " attacks with " + name;
        message += " and applies " + int((power/4)+1) + " " + primaryType.toLowerCase() + " damage over " + (power + 2) + " turns.";
        message += " (Power Level " + power + " | " + chance + "% Chance)";
        return message;
    }

    @Override
    public DoTskill clone() {
        return new DoTskill(this.name, this.power, this.weight, this.primaryType, this.secondaryType, this.cooldown);
    }

}
// ==========================================================
// CHARACTER CLASS
// represents a game character with health, abilities, status effects, 
// resistances, and other attributes. It provides methods to choose an action,
// add effects to its active effects list, consolidating that list and removing 0 value damage numbers
// ==========================================================
class Character {
  String name;
  int health;
  List<Ability> abilities;
  List<Effect> effects;
  Map<String, Integer> flatResistances;
  Map<String, Integer> percentResistances;
  Map<String, Integer> bonusDamage;
  Map<String, Integer> blockEffects;
  Map<String, Integer> absorbEffects;
  int baseCritChance;
  private static final Random random = new Random();

  Character(String name, int health, List<Ability> abilities) {
    this.name = name;
    this.health = health;
    this.abilities = abilities;
    this.effects = new ArrayList<>();
    this.flatResistances = new HashMap<>();
    this.percentResistances = new HashMap<>();
    this.bonusDamage = new HashMap<>();
    this.blockEffects = new HashMap<>();
    this.absorbEffects = new HashMap<>();
    this.baseCritChance = 10; // Example base crit chance(10%)

    // Initialize resistances, bonus damage, block effects, and absorb effects to 0
    initializeResistancesAndBonuses();
    
  }


  private void initializeResistancesAndBonuses() {
    String[] damageTypes = {
      "physical", "fire", "water", "earth", "wind", "verdant", "poison", "ice", "lightning", "force", "necrotic", "radiant", "shadow", "psychic", "arcane", "holy", "dark", "temporal", "void", "astral", "celestial"}
    ;
    for(String type : damageTypes) {
      flatResistances.put(type, 0);
      percentResistances.put(type, 0);
      bonusDamage.put(type, 0);
      blockEffects.put(type, 0);
      absorbEffects.put(type, 0);
    }
  }

  Ability chooseAction() {
    int totalWeight = 0;
    List<Ability> availableAbilities = new ArrayList<>();

    for(Ability ability : abilities) {
      if (ability.canUse()) {
        availableAbilities.add(ability);
        totalWeight += ability.weight;
      }
    }
    if (availableAbilities.isEmpty()) {
      return null; // No available action
    }
    int randomNumber = random.nextInt(totalWeight);
    int cumulativeWeight = 0;

    for(Ability ability : availableAbilities) {
      cumulativeWeight += ability.weight;
      if (randomNumber < cumulativeWeight) {
        return ability;
      }
    }
    return availableAbilities.get(availableAbilities.size() - 1); // Fallback
  }

  void updateCooldowns() {
    for(Ability ability : abilities) {
      ability.decrementCooldown();
    }
  }
  // Method to add an effect to the character's effect list

  void addEffect(Effect effect) {
    effects.add(effect);
  }
  // Get effects for processing

  public List<Effect> getEffects() {
    return new ArrayList<>(effects);
  }
  // Method to update the effects list
  public void updateEffects(List<Effect> newEffects) {
    this.effects = new ArrayList<>(newEffects);
  }

  public void consolidateEffects() {
    removeZeroMagnitudeDamageEffects();

    Map<String, Integer> consolidatedEffects = new HashMap<>();
    for(Effect effect : effects) {
      consolidatedEffects.merge(effect.type, effect.magnitude, Integer::sum);
    }
    effects.clear();
    for(Map.Entry<String, Integer> entry : consolidatedEffects.entrySet()) {
      effects.add(new Effect(entry.getKey(), entry.getValue(), 0)); // Assuming duration is not important here
    }
  }

  public void removeZeroMagnitudeDamageEffects() {
    Iterator<Effect> iterator = effects.iterator();
    while(iterator.hasNext()) {
      Effect effect = iterator.next();
      if (effect.type.endsWith("Damage") && effect.magnitude == 0) {
        iterator.remove();
      }
    }
  }
  // Clear effects after processing

  void clearEffects() {
    effects.clear();
  }
}
// ==========================================================
// EFFECT CLASS
// epresents an effect that can be applied to a character, //  such as damage, healing, or status effects. It has a type, magnitude, and duration.
// ==========================================================
class Effect {
  public String type;
  public int magnitude;
  public int duration;

  public Effect(String type, int magnitude, int duration) {
    this.type = type;
    this.magnitude = magnitude;
    this.duration = duration;
  }

  public String toString() {
    return ("Effect {" + "type='" + type + '|' + ", magnitude=" + magnitude );
    
  }
}
// ==========================================================
// EFFECT PROCESSOR CLASS
// Handles effect resolution and application based on priority.
// ==========================================================
class EffectProcessor {
  // Constructor(No longer needs a character)

  public void EffectProcessor() {
    // Empty constructor
  }
  // Step One: Process Blocked Damage

  private void stepOne(Character character) {
    List<Effect> effects = character.getEffects();

    // Debug statement to check initial effects
    System.out.println("Initial effects: " + effects +character.name);

    List<Effect> updatedEffects = new ArrayList<>(effects);

    for(Effect effect : effects) {
      String effectType = effect.type;
      if (effectType.endsWith("Damage")) {
        String damageType = effectType.replace("Damage", "Blocked");
       

        for(Effect e: effects) {
          if (e.type.equals(damageType)) {
            int typeBlocked = e.magnitude;
             System.out.println("matching block found");
            if (typeBlocked > 0) {
              int oldTypeDamage = effect.magnitude;
              effect.magnitude = Math.max(0, oldTypeDamage - typeBlocked);
              int typeBlockedActual = oldTypeDamage - effect.magnitude;
              e.magnitude = typeBlocked - typeBlockedActual;

              updatedEffects.set(updatedEffects.indexOf(effect), effect);
              updatedEffects.set(updatedEffects.indexOf(e), e);

              // Log the amount of damage blocked
              System.out.println(character.name + " blocked " + typeBlockedActual + " " + effectType.replace("Damage", "") + " damage.");
            }
          }
        }
      }
    }
    // Debug statement to check updated effects
    System.out.println("Updated effects after stepOne: " + updatedEffects);

    character.updateEffects(updatedEffects);
  }
  // Step Two: Process Absorbed Damage

  private void stepTwo(Character character) {
    List<Effect> effects = character.getEffects();

    // Create a new list to store updated effects
    List<Effect> updatedEffects = new ArrayList<>(effects);

    for(Effect effect : effects) {
      String effectType = effect.type;
      if (effectType.endsWith("Damage")) {
        String damageType = effectType.replace("Damage", "Absorbed");

        for(Effect e: effects) {
          if (e.type.equals(damageType)) {
            int typeAbsorbed = e.magnitude;

            if (typeAbsorbed > 0) {
              int oldTypeDamage = effect.magnitude;
              effect.magnitude = Math.max(0, oldTypeDamage - typeAbsorbed);
              int typeAbsorbedActual = oldTypeDamage - effect.magnitude;
              e.magnitude = typeAbsorbed - typeAbsorbedActual;

              // Update the effect in the updatedEffects list
              updatedEffects.set(updatedEffects.indexOf(effect), effect);
              updatedEffects.set(updatedEffects.indexOf(e), e);

              // Check if there is an existing heal effect
              boolean healEffectFound = false;
              for(Effect healEffect : effects) {
                if (healEffect.type.equals("heal")) {
                  healEffect.magnitude += typeAbsorbedActual;
                  updatedEffects.set(updatedEffects.indexOf(healEffect), healEffect);
                  healEffectFound = true;
                  break;
                }
              }
              // If no heal effect found, add a new one
              if (!healEffectFound) {
                Effect healEffect = new Effect("heal", typeAbsorbedActual, 0);
                updatedEffects.add(healEffect);
              }
              // Log the amount of damage absorbed
              System.out.println(character.name + " absorbed " + typeAbsorbedActual + " " + effectType.replace("Damage", "") + " damage and healed for " + typeAbsorbedActual + ".");
            }
          }
        }
      }
    }
    // Update the character's effects with the modified effects
    character.updateEffects(updatedEffects);
  }
  // Step Three: Handle Heals and Reverse Heals

  private void stepThree(Character character) {
    List<Effect> effects = character.getEffects();

    // Create a new list to store updated effects
    List<Effect> updatedEffects = new ArrayList<>(effects);

    int reverseHeal = 0;
    for(Effect effect : effects) {
      if (effect.type.equals("reverseHeal")) {
        reverseHeal += effect.magnitude;
        effect.magnitude = 0;
        updatedEffects.set(updatedEffects.indexOf(effect), effect);
      }
    }
    if (reverseHeal > 0) {
      for(Effect effect : effects) {
        if (effect.type.equals("heal")) {
          int oldHeal = effect.magnitude;
          effect.magnitude = Math.max(0, oldHeal - reverseHeal);
          int healingReversedActual = oldHeal - effect.magnitude;
          reverseHeal -= healingReversedActual;

          // Add a voidDamage effect
          Effect voidDamageEffect = new Effect("voidDamage", healingReversedActual, 0);
          updatedEffects.add(voidDamageEffect);

          if (healingReversedActual > 0) {
            // Log and process the new voidDamage
            System.out.println(character.name + " had " + healingReversedActual + " healing reversed.");
            stepOne(character);
            stepTwo(character);
          }
          updatedEffects.set(updatedEffects.indexOf(effect), effect);
        }
      }
    }
    // Update the character's effects with the modified effects
    character.updateEffects(updatedEffects);
  }
  // Step Four: Reset Leftover Blocked and Absorbed Values

  private void stepFour(Character character) {
    List<Effect> effects = character.getEffects();
    effects.removeIf(e -> e.type.endsWith("Blocked") || e.type.endsWith("Absorbed"));
    character.updateEffects(effects);
  }
  // Step Five: Placeholder for Future Expansion

  private void stepFive(Character character) {
    // Currently does nothing but reserved for future improvements
  }
  // Run method to execute all steps for a specific character

  public void run(Character character) {
    List<Effect> effects = character.getEffects();
    System.out.println("effectProcessor.run(): " + effects + character.name);

    stepOne(character);
    stepTwo(character);
    stepThree(character);
    stepFour(character);
    stepFive(character);
  }
  // Public methods to process global player and enemy

  public void processPlayer(Character player) {
    run(player);
  }

  public void processEnemy(Character enemy) {
    run(enemy);
  }
}
// ==========================================================
// BATTLE MANAGER CLASS
// Manages the turn-based battle logic, including action collection and delegation to EffectProcessor.
// ==========================================================
class BattleManager {
  private List<Character> characters;
  private StringBuilder battleLog;
  private Character player;
  private Character enemy;
  private EffectProcessor effectProcessor;

  public BattleManager(List<Character> characters, StringBuilder battleLog) {
    this.characters = characters;
    this.battleLog = battleLog;

    // Assuming the first character is the player and the second is the enemy
    this.player = characters.get(0);
    this.enemy = characters.get(1);

    this.effectProcessor = new EffectProcessor();
  }

  public void collectEffects() {
    // Step 1: Both characters choose an ability
    Ability playerAbility = player.chooseAction();
    Ability enemyAbility = enemy.chooseAction();
    int playerChance = calculateChance(player, playerAbility);
    int enemyChance = calculateChance(enemy, enemyAbility);

    Random random = new Random();
    boolean printPlayerAbilityFirst = random.nextBoolean();

    if (printPlayerAbilityFirst) {
      battleLog.append(playerAbility.generateMessage(player.name, playerChance)).append("\n");
      battleLog.append(enemyAbility.generateMessage(enemy.name, enemyChance)).append("\n");
    } else {
      battleLog.append(enemyAbility.generateMessage(enemy.name, enemyChance)).append("\n");
      battleLog.append(playerAbility.generateMessage(player.name, playerChance)).append("\n");
    }
    // Step 2: Get the output effects of each chosen ability
    ArrayList<Effect> playerEffects = playerAbility.output();
    ArrayList<Effect> enemyEffects = enemyAbility.output();

    // Step 3: Add self-targeted effects to each character's list of effects
    applySelfEffects(player, playerEffects); // Apply player's self-effects to the player
    applySelfEffects(enemy, enemyEffects);   // Apply enemy's self-effects to the enemy

    // Step 4: Add opponent-targeted effects to each character's list of effects
    applyOpponentEffects(player, enemyEffects); // Apply enemy's effects to the player
    applyOpponentEffects(enemy, playerEffects); // Apply player's effects to the enemy

    // Reset Cooldowns for player and enemy ability
    playerAbility.resetCooldown();
    enemyAbility.resetCooldown();

    List<Effect> effects2 = player.getEffects();
    System.out.println("Initial player effects after collection: " + effects2);
    List<Effect> effects3 = enemy.getEffects();
    System.out.println("Initial enemy effects after collection: " + effects3);
  }

  // Helper method to apply self-targeted effects to a character
  private void applySelfEffects(Character character, ArrayList<Effect> effects) {
    for (Effect effect : effects) {
    String effectType = effect.type;
    int magnitude = effect.magnitude;

    if (effectType.equals("heal") || effectType.endsWith("Blocked") || effectType.endsWith("Absorbed")) {
      character.addEffect(new Effect(effectType, magnitude, 0));
    }
    }
  }
  

  private int calculateChance(Character character, Ability ability) {
    int totalWeight = 0;
    for(Ability a : character.abilities) {
      if (a.canUse()) {
        totalWeight += a.weight;
      }
    }
    return(int)((ability.weight /(double) totalWeight) * 100);
  }
  // Helper method to apply opponent-targeted effects to a character
    private void applyOpponentEffects(Character character, ArrayList<Effect> effects) {
      for (Effect effect : effects) {
        String effectType = effect.type;
        int magnitude = effect.magnitude;

        if (effectType.endsWith("Damage") || effectType.equals("reverseHeal")) {
          character.addEffect(new Effect(effectType, magnitude, 0));
        }
      }
    }

  //Helper method that runs the EffectProcessor for each character and applys the results

  public void resolveActions() {
    // Process all effects using EffectProcessor
    effectProcessor.run(player);
    effectProcessor.run(enemy);

    // Process effects for both player and enemy
    applyAndLogDamageAndHeal(player);
    applyAndLogDamageAndHeal(enemy);

  }
  // Helper method to apply damage and healing effects and log it, for one character

  private void applyAndLogDamageAndHeal(Character character) {
    character.consolidateEffects();
    List<Effect> effects = character.getEffects();

    // Debug statement to check initial effects before processing damage
    System.out.println(character.name + " Effects before applying damage: " + effects);

    for(Effect effect : effects) {
      String effectType = effect.type;
      int magnitude = effect.magnitude;

      // Check if the effect is a type of damage
      if (effectType.endsWith("Damage")) {
        int actualDamage = calculateDamage(character, effectType, magnitude);
        character.health -= actualDamage;
        logEffect(character, effectType, actualDamage);
      }
      if (effectType == "heal") {
        character.health += effect.magnitude;
        logEffect(character, effectType, effect.magnitude);
      }
    }
    character.clearEffects(); // Clear effects after processing
  }
  // Helper method to calculate damage factoring in resistances

  private int calculateDamage(Character character, String effectType, int magnitude) {
    String damageType = effectType.replace("Damage", "").toLowerCase();
    int flatResistance = character.flatResistances.getOrDefault(damageType, 0);
    int percentResistance = character.percentResistances.getOrDefault(damageType, 0);

    int reducedByFlat = magnitude - flatResistance;
    int finalDamage = reducedByFlat *(100 - percentResistance) / 100;

    return Math.max(finalDamage, 0); // Ensure damage is not negative
  }
  // Helper method to log damage

  private void logEffect(Character character, String effectType, int magnitude) {
    String[] damagePhrases = {
      " was hit with ", " endured ", " suffered ", " sustained ", " received ", " absorbed ", " was struck by ", " took " }
    ;

    String[] healPhrases = {
      " regains ", " recovers ", " restores ", " is rejuvenated by ", " mends and gains ", " is healed for ", "'s wounds close, restoring ", "'s health improves by " }
    ;

    StringBuilder message = new StringBuilder();
    message.append(character.name);

    Random random = new Random();

    if (effectType.equals("heal")) {
      int phraseIndex = random.nextInt(healPhrases.length);
      message.append(healPhrases[phraseIndex]).append(magnitude).append(" HP.");
    } else {
      String damageType = effectType.replace("Damage", "");
      int phraseIndex = random.nextInt(damagePhrases.length);
      message.append(damagePhrases[phraseIndex]).append(magnitude).append(" ").append(damageType).append(" damage.");
    }
    battleLog.append(message).append("\n");
  }
}
// ==========================================================
// CUSTOM BATTLE SCREEN CLASS
// Implements the GameScreen interface and manages the screen
// where players can set up a custom battle. It allows setting
// player and enemy names, health, and abilities, and transitions
// to the battle screen once setup is complete.
// ==========================================================

class CustomBattleScreen implements GameScreen {
  private PApplet applet;
  private GameScreenManager screenManager;
  private String playerName;
  private String enemyName;
  private int playerHealth;
  private int enemyHealth;
  private List<Ability> playerAbilities;
  private List<Ability> enemyAbilities;
  private int selectedOption = 0;
  private String[] options = {
    "Player Name", "Enemy Name", "Player Health", "Enemy Health", "Player Abilities", "Enemy Abilities", "Pre-made Battles", "Load Custom Battle", "Save Custom Battle", "START BATTLE" }
  ;
  private boolean inputMode = false;
  private String currentInput = "";
  private int inputTarget = -1; // 0: player name, 1: enemy name
  private int cursorPosition = 0;
  private boolean fastEditMode = false;
  private long keyPressTime;
  private long lastBlinkTime = 0;
  private boolean cursorVisible = true;

  private String[] playerNames = {
    "Chaz", "RareRootBeer", "Ranger", "Smitefiter", "Roger", "Greg", "Jenny", "Carl", "Dave", "Molly", "Phil", "Hank", "Adventurer2002", "Gary", "Sue", "Tom", "Fred", "Tara", "Joe", "Jill", "Mike", "Sara", "Paul", "Beth", "Tortellini", "Emma", "Luke", "Nora", "Mark", "Dana", "Erik", "Kate", "Neal", "Meg", "Jack", "Ava", "Kyle", "Bob", "Josh", "Mia", "Todd", "Leo", "Matt", "Lily", "Tikka Masala", "Elle", "Bald", "Hope", "Kent", "Tess", "Zane", "Bree", "Dean", "Rose", "Finn", "Isla", "Troy", "Eve", "Drew", "Lara", "Cliff", "Gwen", "Trey", "Nina", "Reid", "Ivy", "Ross", "Captain Underpants", "Dane", "Joy", "Liam", "June", "Chad", "Mara", "Seth", "Bob", "Jace", "Tia", "Joel", "Kay", "Mark", "Zoe", "Liam", "Tara", "Ray", "Tess", "Sam", "Lee", "Max", "Ivy", "Ben", "Amy", "Jay", "Joy", "Ian", "Fay", "Alec", "Jax", "Rhys", "Quinn"}
  ;

  private String[] enemyNames = {
    "Joff Bozes", "Durial321", "Shadowbane", "Bartender", "Grimhowl", "Bloodspike", "Nightterror", "Ironjaw", "Deathstrike", "Blackthorn", "Frostbite", "Dark Druid", "Shadowstalker", "Deathbringer", "Bloodreaver", "Slapdaddy", "Bonecrusher", "Ironfist", "Nightshade", "Venomblade", "Darkstorm", "Bloodshadow", "Doomclaw", "Grimfang", "Skullsplitter", "Frostclaw", "Deathshroud", "Nightfiend", "Venomspike", "Cynthia the Demon", "Doomhammer", "Osmanbold", "Shadowclaw", "Deathfang", "Bloodcrusher", "Froststrike", "Skullcrusher", "Ironclaw", "Nightreaver", "Darkreaper", "Bloodshroud", "Doomshadow", "Grimspike", "Deathshade", "Froststorm", "Venomhowl", "Skullstrike", "Darkhowl", "Bloodreaver", "Nightstrike", "Doomfang", "Monster Mama Mia", "Deathblade", "Venomclaw", "Lasanga Creature", "Skullstorm", "Frostshadow", "Nightcrusher", "Bloodfang", "Toilet of Doom", "Grimreaver", "Deathstrike", "Venomfang", "Ironshade", "Skullreaver", "Doomshade", "Nightshadow", "Bloodstorm", "Darkcrusher", "Grimfang", "Deathstorm", "Venomstrike", "Ironfang", "Skullshade", "Frostreaver", "Nightshade", "Bloodshadow", "Darkfang", "Grimstrike", "Deathreaver", "Venomstorm", "Ironstrike", "Skullfang", "Doomreaver", "Nightfang", "Bloodstrike", "Darkreaver", "Grimstorm", "Deathfang", "Venomshade", "Ironreaver", "Skullstorm", "Frostfang", "Nightstorm", "Bloodstrike", "Darkreaper", "Grimclaw", "Deathstorm", "Venomstorm", "Ironfang"}
  ;

  public CustomBattleScreen(PApplet applet, GameScreenManager screenManager) {
    this.applet = applet;
    this.screenManager = screenManager;
    GameDataManager dataManager = screenManager.getDataManager();

    // Load existing player and enemy data if available
    if (dataManager.getPlayer() != null) {
      this.playerName = dataManager.getPlayer().name;
      this.playerHealth = dataManager.getPlayer().health;
      this.playerAbilities = dataManager.getPlayer().abilities;
    } else {
      this.playerName = playerNames[0];
      this.playerHealth = 100;
      this.playerAbilities = new ArrayList<>();
    }
    if (dataManager.getEnemy() != null) {
      this.enemyName = dataManager.getEnemy().name;
      this.enemyHealth = dataManager.getEnemy().health;
      this.enemyAbilities = dataManager.getEnemy().abilities;
    } else {
      this.enemyName = enemyNames[0];
      this.enemyHealth = 100;
      this.enemyAbilities = new ArrayList<>();
    }
    preAssignAbilities();
  }

  private void preAssignAbilities() {
    if (playerAbilities.isEmpty()) {
      // Initialize abilities
      playerAbilities.add(new Attack("Physical Attack", 4, 200, "Physical", "", 0));
      playerAbilities.add(new Attack("Fire Attack", 4, 200, "Fire", "", 10));
      playerAbilities.add(new Attack("Physical and Fire Attack", 4, 200, "Physical", "Fire", 10));
      playerAbilities.add(new Block("Physical Block", 4, 100, "Physical", "", 10));
      playerAbilities.add(new Block("Fire Block", 4, 100, "Fire", "", 10));
      playerAbilities.add(new Block("Physical and Fire Block", 4, 100, "Physical", "Fire", 10));
      playerAbilities.add(new Absorb("Physical Absorb", 4, 100, "Physical", "", 10));
      playerAbilities.add(new Absorb("Fire Absorb", 4, 100, "Fire", "", 10));
      playerAbilities.add(new Absorb("Physical and Fire Absorb", 4, 100, "Physical", "Fire", 10));
      playerAbilities.add(new Heal("Heal", 8, 100, "", "", 10));
      playerAbilities.add(new ReverseHeal("Reverse Heal", 12, 100, "", "", 10));

      for(Ability ability : playerAbilities) {
        enemyAbilities.add(ability.clone());
      }
    }
  }

  @Override public void init() {
    // Initialization code
  }

  @Override public void update() {
    if (fastEditMode &&(System.currentTimeMillis() - keyPressTime) > 2000) {
      handleFastEdit();
    }
    if (inputMode && System.currentTimeMillis() - lastBlinkTime > 500) {
      cursorVisible = !cursorVisible;
      lastBlinkTime = System.currentTimeMillis();
    }
  }

  @Override public void draw() {
    int fontSize = 24; // Set your desired font size here
    PFont font = applet.createFont("Consolas", fontSize);
    applet.textFont(font, fontSize);

    float textHeight = applet.textAscent() + applet.textDescent();
    float lineHeight = textHeight + 10; // Add some padding between lines

    applet.background(0);
    applet.fill(255);
    applet.textAlign(PApplet.CENTER, PApplet.CENTER);

    // Draw title box
    applet.textSize(fontSize);
    applet.fill(255, 255, 255);
    applet.text("+-----------                     -----------+", applet.width / 2, ((applet.height / 2) - 300));
    applet.fill(255, 0, 255);
    applet.text("[Custom Battle Setup]", applet.width / 2,((applet.height / 2) - 300));

    // Draw options
    applet.textSize(fontSize);
    for(int i = 0;
    i < options.length + 3;
    i++) {
      applet.fill(255); // White color for the walls
        applet.text("|                                           |", applet.width / 2, ((applet.height / 2) - 270) + i * lineHeight);
    }
    for(int i = 0;
    i < options.length;
    i++) {
      applet.fill(255); // Reset fill color to white for the options
      applet.textAlign(PApplet.CENTER, PApplet.CENTER); // Reset text alignment

      if (i == selectedOption) {
        if (i == 9) {
          // Skip a line for START BATTLE
          applet.fill(255, 0, 255); // Pink color for boxes
          applet.text("[   ]", applet.width / 2 -(fontSize * 10),((applet.height / 2) - 240) + 30 +(i * lineHeight));
          applet.fill(0, 255, 0); // Green for the X
          applet.text("X", applet.width / 2 -(fontSize * 10),((applet.height / 2) - 240) + 30 +(i * lineHeight));
          applet.fill(255); // White color for text
        }
        else if (i < 6) {
          applet.fill(255, 0, 255); // Pink color for boxes
          applet.text("[   ]", applet.width / 2 -(fontSize * 10),((applet.height / 2) - 240) + i * lineHeight);
          applet.fill(255); // White color for text
        } else {
          applet.fill(255, 0, 255); // Pink color for boxes
          applet.text("[   ]", applet.width / 2 -(fontSize * 10),((applet.height / 2) - 240) + i * lineHeight);
          applet.fill(0, 255, 0); // Green for the X
          applet.text("X", applet.width / 2 -(fontSize * 10),((applet.height / 2) - 240) + i * lineHeight);
          applet.fill(255); // White color for text
        }
        if (i < 4) {
          applet.fill(0, 255, 0); // Green color for "Set"
          applet.text("Set", applet.width / 2 -(fontSize * 10),((applet.height / 2) - 240) + i * lineHeight);
          applet.fill(255); // White color for rest of the text
          applet.text(options[i] + ": ", applet.width / 2,((applet.height / 2) - 240) + i * lineHeight);

          // Display the value correctly
          if (inputMode &&(inputTarget == i)) {
            applet.fill(0, 255, 0); // Green color for input text
            float textX = applet.width / 2 +(fontSize * 7.5);
            float textY =((applet.height / 2) - 240) + i * lineHeight;
            String beforeCursor = currentInput.substring(0, cursorPosition);
            String afterCursor = currentInput.substring(cursorPosition);

            applet.text(beforeCursor +(cursorVisible ? "_" : "") + afterCursor, textX, textY);
          } else {
            if (!inputMode) {
              applet.fill(0, 255, 0); // Green color for variable values selected
              applet.text(getOptionValue(i), applet.width / 2 +(fontSize * 7.5),((applet.height / 2) - 240) + i * lineHeight);
            }
          }
        }
        else if (i == 4 || i == 5) {
          applet.fill(0, 255, 0); // Green for "Edit"
          applet.text("Edit", applet.width / 2 -(fontSize * 10),((applet.height / 2) - 240) + i * lineHeight);
          applet.fill(0, 255, 0); // Green color for rest of the text
          applet.text(options[i], applet.width / 2,((applet.height / 2) - 240) + i * lineHeight);
        }
        else if (i == 9) {
          applet.fill(255, 0, 0); // Red
          applet.text(options[i], applet.width / 2,((applet.height / 2) - 240) + 30 +(i * lineHeight));
        } else {
          applet.fill(0, 255, 0); // Green color for other options
          applet.text(options[i], applet.width / 2,((applet.height / 2) - 240) + i * lineHeight);
        }
      } else {
        if (i == 9) {
          // Skip a line for START BATTLE
          applet.fill(255, 0, 255); // Pink color for boxes
          applet.text("[   ]", applet.width / 2 -(fontSize * 10),((applet.height / 2) - 240) + 30 +(i * lineHeight));
          applet.fill(255); // White color for text
        } else {
          applet.fill(255, 0, 255); // Pink color for boxes
          applet.text("[   ]", applet.width / 2 -(fontSize * 10),((applet.height / 2) - 240) + i * lineHeight);
          applet.fill(255); // White color for text
        }
        if (i < 4) {
          applet.text(options[i] + ": ", applet.width / 2,((applet.height / 2) - 240) + i * lineHeight);
          applet.fill(255, 0, 255); // Pink color for variable values
          if (!(inputMode &&(inputTarget == i))) {
            applet.text(getOptionValue(i), applet.width / 2 +(fontSize * 7.5),((applet.height / 2) - 240) + i * lineHeight);
          }
        }
        else if (i == 9) {
          // Skip a line before START BATTLE
          applet.fill(255, 255, 255); // White
          applet.text(options[i], applet.width / 2,((applet.height / 2) - 240) + 30 +(i * lineHeight));
        } else {
          applet.text(options[i], applet.width / 2,((applet.height / 2) - 240) + i * lineHeight);
        }
      }
    }
    // Draw instructions box directly below the options
    applet.textSize(fontSize);
    applet.fill(255);
    applet.textAlign(PApplet.CENTER, PApplet.TOP);
    float instructionsY =((applet.height / 2) - 240) +(options.length + 1) * lineHeight;
    applet.text("|-------------------------------------------|", applet.width / 2, instructionsY);
    applet.text("|       (UP, DOWN) change selection         |", applet.width / 2, instructionsY + lineHeight * 0.67f);
    applet.text("|    (LEFT, RIGHT, ENTER) edit, select      |", applet.width / 2, instructionsY + lineHeight * 1.34f);
    applet.text("|   (BACKSPACE) return to title screen      |", applet.width / 2, instructionsY + lineHeight * 2.01f);
    applet.text("\\___________________________________________/", applet.width / 2, instructionsY + lineHeight * 2.68f);

    // Draw the input value in green and avoid drawing it twice

    if (inputMode) {
      // applet.fill(0, 255, 0); // Green color for input text
      //float textX = applet.width / 2 +(fontSize * 6);
      // float textY =((applet.height / 2) - 240) + selectedOption * lineHeight;
      //applet.textAlign(PApplet.LEFT, PApplet.CENTER); // Ensure centered alignment
      //applet.text(currentInput +(cursorVisible ? "_" : ""), textX, textY);
    }
  }

  private String getOptionValue(int index) {

    switch(index) {
      case 0: return inputMode && inputTarget == 0 ? currentInput : playerName;
      case 1: return inputMode && inputTarget == 1 ? currentInput : enemyName;
      case 2: return String.valueOf(playerHealth);
      case 3: return String.valueOf(enemyHealth);
      default: return "";
    }
  }

  @Override public void dispose() {
    // Cleanup code
  }

  @Override public void keyPressed() {

    if (inputMode) {
      handleInput();
    } else {
      if (applet.keyCode == PApplet.UP) {
        saveCurrentInput();
        selectedOption =(selectedOption - 1 + options.length) % options.length;
      }
      else if (applet.keyCode == PApplet.DOWN) {
        saveCurrentInput();
        selectedOption =(selectedOption + 1) % options.length;
      }
      else if (applet.keyCode == PApplet.RIGHT) {
        keyPressTime = System.currentTimeMillis();
        fastEditMode = true;
        handleRightArrow();
      }
      else if (applet.keyCode == PApplet.LEFT) {
        keyPressTime = System.currentTimeMillis();
        fastEditMode = true;
        handleLeftArrow();
      }
      else if (applet.keyCode == PApplet.ENTER) {
        handleEnter();
      }
      else if (applet.keyCode == PApplet.BACKSPACE) {
        fastEditMode = false;
        handleBackspace();
      }
    }
  }

  @Override public void keyReleased() {
    fastEditMode = false;
  }

  private void saveCurrentInput() {

    if (inputMode) {
      inputMode = false;
      try {

        switch(inputTarget) {
          case 0: playerName = currentInput.isEmpty() ? playerNames[0] : currentInput;
          break;
          case 1: enemyName = currentInput.isEmpty() ? enemyNames[0] : currentInput;
          break;
          case 2: playerHealth = currentInput.isEmpty() ? 100 : Math.min(9999, Math.max(0, Integer.parseInt(currentInput)));
          break;
          case 3: enemyHealth = currentInput.isEmpty() ? 100 : Math.min(9999, Math.max(0, Integer.parseInt(currentInput)));
          break;
        }
      }

      catch(NumberFormatException e) {
        if (inputTarget == 2) {
          playerHealth = 100;
        }
        else if (inputTarget == 3) {
          enemyHealth = 100;
        }
      }
      currentInput = "";
      inputTarget = -1;
    }
  }

  private void handleRightArrow() {
    if (selectedOption == 0) {
      cyclePlayerName(true);
    }
    else if (selectedOption == 1) {
      cycleEnemyName(true);
    }
    else if (selectedOption == 2) {
      playerHealth++;
    }
    else if (selectedOption == 3) {
      enemyHealth++;
    }
  }

  private void handleLeftArrow() {
    if (selectedOption == 0) {
      cyclePlayerName(false);
    }
    else if (selectedOption == 1) {
      cycleEnemyName(false);
    }
    else if (selectedOption == 2) {
      playerHealth--;
    }
    else if (selectedOption == 3) {
      enemyHealth--;
    }
  }

  private void handleEnter() {
    GameDataManager dataManager = screenManager.getDataManager();
    dataManager.setPlayer(new Character(playerName, playerHealth, playerAbilities));
    dataManager.setEnemy(new Character(enemyName, enemyHealth, enemyAbilities));

    switch(selectedOption) {
      case 0: inputMode = true;
      inputTarget = selectedOption;
      currentInput = "";
      cursorPosition = 0;
      break;
      case 1: inputMode = true;
      inputTarget = selectedOption;
      currentInput = "";
      cursorPosition = 0;
      break;
      case 2: inputMode = true;
      inputTarget = selectedOption;
      currentInput = "";
      cursorPosition = 0;
      break;
      case 3: inputMode = true;
      inputTarget = selectedOption;
      currentInput = "";
      cursorPosition = 0;
      break;
      case 4: screenManager.showScreen(new AbilitySelectionScreen(applet, screenManager, "Player", playerAbilities));
      break;
      case 5: screenManager.showScreen(new AbilitySelectionScreen(applet, screenManager, "Enemy", enemyAbilities));
      break;
      case 9: startCustomBattle();
      break;
    }
  }

  private void handleBackspace() {

    if (inputMode) {
      if (cursorPosition > 0) {
        currentInput = currentInput.substring(0, cursorPosition - 1) + currentInput.substring(cursorPosition);
        cursorPosition--;
      }
    }
  }

  private void handleInput() {
    if (applet.keyCode == PApplet.ENTER) {
      saveCurrentInput();
    }
    else if (applet.keyCode == PApplet.BACKSPACE) {
      handleBackspace();
    }
    else if (applet.keyCode == PApplet.UP) {
      saveCurrentInput();
      selectedOption =(selectedOption - 1 + options.length) % options.length;
    }
    else if (applet.keyCode == PApplet.DOWN) {
      saveCurrentInput();
      selectedOption =(selectedOption + 1) % options.length;
    }
    else if (applet.keyCode == PApplet.LEFT) {
      if (cursorPosition > 0) {
        cursorPosition--;
      }
    }
    else if (applet.keyCode == PApplet.RIGHT) {
      if (cursorPosition < currentInput.length()) {
        cursorPosition++;
      }
    }
    else if (inputTarget == 2 || inputTarget == 3) {
      // Only allow numerical input for health
      if (applet.key >= '0' && applet.key <= '9') {
        if (currentInput.length() < 16) {
          currentInput = currentInput.substring(0, cursorPosition) + applet.key + currentInput.substring(cursorPosition);
          cursorPosition++;
        }
      }
    }
    else if ((applet.key >= 'a' && applet.key <= 'z') ||(applet.key >= 'A' && applet.key <= 'Z') ||(applet.key >= '0' && applet.key <= '9') || applet.key == ' ' || applet.key == '-' || applet.key == '_') {
      // Allow alphanumeric and specific special characters for names
      if (currentInput.length() < 16) {
        currentInput = currentInput.substring(0, cursorPosition) + applet.key + currentInput.substring(cursorPosition);
        cursorPosition++;
      }
    }
  }

  private void cyclePlayerName(boolean forward) {
    int index = Arrays.asList(playerNames).indexOf(playerName);

    if (forward) {
      index =(index + 1) % playerNames.length;
    } else {
      index =(index - 1 + playerNames.length) % playerNames.length;
    }
    playerName = playerNames[index];
  }

  private void cycleEnemyName(boolean forward) {
    int index = Arrays.asList(enemyNames).indexOf(enemyName);

    if (forward) {
      index =(index + 1) % enemyNames.length;
    } else {
      index =(index - 1 + enemyNames.length) % enemyNames.length;
    }
    enemyName = enemyNames[index];
  }

  private void handleFastEdit() {
    if (selectedOption == 2) {
      playerHealth += 10;
    }
    else if (selectedOption == 3) {
      enemyHealth += 10;
    }
  }

  private void startCustomBattle() {
    // Initialize player and enemy characters with updated attributes
    Character player = new Character(playerName, playerHealth, playerAbilities);
    Character enemy = new Character(enemyName, enemyHealth, enemyAbilities);

    // Save the characters in the data manager
    GameDataManager dataManager = screenManager.getDataManager();
    dataManager.setPlayer(player);
    dataManager.setEnemy(enemy);

    // Transition to the battle screen with updated characters
    screenManager.pushScreen(new BattleScreen(applet, screenManager, enemy));
  }
}
// ==========================================================
// ABILITY SELECTION SCREEN CLASS
// Manages the screen where players can edit abilities for a specified entity(player or enemy).
// Handles ability creation, editing, and removal, with enhanced debugging and refactoring for readability.
// ==========================================================

class AbilitySelectionScreen implements GameScreen {
  private PApplet applet;
  private GameScreenManager screenManager;
  private int selectedRow;
  private int selectedCol;
  private boolean isEditing;
  private boolean ctrlPressed;
  private String entityName;
  private List<Ability> abilities;
  private String currentInput;
  private long cursorBlinkStart;
  private boolean cursorVisible;
  private static final int CURSOR_BLINK_INTERVAL = 500;
  private String[] typeOptions;
  private int typeIndex;
  private static final int MAX_VALUE = 9999;
  private boolean settingAllValues;
  private String allValueInput;
  private boolean confirmDeletion;
  private int fontSize = 18;

  // Constructor
  public AbilitySelectionScreen(PApplet applet, GameScreenManager screenManager, String entityName, List<Ability> abilities) {
    this.applet = applet;
    this.screenManager = screenManager;
    this.entityName = entityName;
    this.abilities = new ArrayList<>(abilities); // Create a copy of the abilities list
    this.selectedRow = 0;
    this.selectedCol = 0;
    this.isEditing = false;
    this.ctrlPressed = false;
    this.currentInput = "";
    this.cursorBlinkStart = System.currentTimeMillis();
    this.cursorVisible = true;
    this.typeOptions = new String[] {
      "Physical", "Fire", "Water", "Earth", "Wind", "Verdant", "Poison", "Ice", "Lightning", "Force", "Necrotic", "Radiant", "Shadow", "Psychic", "Arcane", "Holy", "Dark", "Temporal", "Void", "Astral", "Celestial", ""}
    ;
    this.typeIndex = 0;
    this.settingAllValues = false;
    this.allValueInput = "";
    this.confirmDeletion = false;
  }

  @Override public void init() {
    // Initialization code for the ability selection screen
    debugLog("AbilitySelectionScreen initialized for entity: " + entityName);
  }

  @Override public void update() {
    // Update logic for the ability selection screen
    handleCursorBlink();
  }

  @Override public void draw() {
    applet.background(0);
    applet.fill(255);
    applet.textAlign(PApplet.CENTER, PApplet.CENTER);
    applet.textSize(24);
    applet.text("Customize Abilities - " + entityName, applet.width / 2, 30);
    drawAbilityTable();

    if (confirmDeletion) {
      drawConfirmationScreen();
    }
  }

  @Override public void dispose() {
    // Cleanup code for the ability selection screen
    debugLog("Disposing AbilitySelectionScreen for entity: " + entityName);
  }

  @Override public void keyPressed() {

    if (confirmDeletion) {
      handleConfirmationKeyPress();
    }

    else if (settingAllValues) {
      handleSetAllValuesKeyPressed();
    } else {
      handleKeyPress();
    }
  }

  @Override public void keyReleased() {
    if (applet.keyCode == PApplet.CONTROL) {
      ctrlPressed = false;
    }
  }
  // Handle cursor blinking

  private void handleCursorBlink() {
    if (System.currentTimeMillis() - cursorBlinkStart > CURSOR_BLINK_INTERVAL) {
      cursorVisible = !cursorVisible;
      cursorBlinkStart = System.currentTimeMillis();
    }
  }
  // Draw the ability table

  private void drawAbilityTable() {
    applet.textAlign(PApplet.CENTER, PApplet.TOP); // Center text alignment
    applet.textSize(fontSize);
    int rowHeight = fontSize * 2; // Row height relative to font size

    int[] colWidths = {17 * fontSize, 6 * fontSize, 6 * fontSize, 6 * fontSize, 4 * fontSize, 4 * fontSize, 4 * fontSize}; // Column widths relative to font size
    int totalWidth = 0;
    for(int width : colWidths) {
      totalWidth += width;
    }
    int startX =(applet.width - totalWidth) / 2;
    int totalHeight =(abilities.size() + 2) * rowHeight; // Total height of the table including header and footer
    int startY =(applet.height - totalHeight) / 2;

    drawTableHeader(startX, startY - rowHeight, colWidths);

    for(int i = 0;
    i < abilities.size();
    i++) {
      Ability ability = abilities.get(i);
      int y = startY + i * rowHeight;
      drawAbilityRow(ability, i, startX, y, colWidths);
    }
    drawTableFooter((applet.width/2), startY + abilities.size() * rowHeight, colWidths);
  }
  // Draw the table header
  private void drawTableHeader(int startX, int y, int[] colWidths) {
    String[] headers = {
      "ABILITY NAME", "CLASS", "TYPE 1", "TYPE 2", "WEIGHT", "POWER", "CD"}
    ;
    int colX = startX;
    for(int col = 0;
    col < headers.length;
    col++) {
      applet.fill(255, 255, 0); // Header color: yellow
      applet.text(headers[col], colX + colWidths[col] / 2, y); // Center text within column
      colX += colWidths[col];
    }
  }
  // Draw the table footer
  private void drawTableFooter(int startX, int y, int[] colWidths) {
    applet.fill(255, 255, 0); // Footer color: yellow
    applet.textAlign(PApplet.CENTER, PApplet.TOP); // Center text alignment for footer
    applet.text("=".repeat(colWidths.length * 10), startX, y); // Adjust starting position
    applet.text("(UP, DOWN, LEFT, RIGHT) change selection", startX, y + colWidths[0] / 10); // Adjust starting position
    applet.text("(CTRL +(UP, DOWN, LEFT, RIGHT)) edit value", startX, y + (fontSize * 2)+ colWidths[0] / 10); // Adjust starting position
    applet.text("(ENTER) edit value, select option", startX, y + (fontSize * 4) + colWidths[0] / 10);
    applet.text("[F1]: Set All Weights, [F2]: Set All Powers", startX, y + (fontSize * 6) + colWidths[0] / 10);
    applet.text("[F3]: Add Ability, [F4]: Remove Ability", startX, y + (fontSize * 8) + colWidths[0] / 10);
    applet.text("[F5]: Save and Return to Setup", startX, y + (fontSize * 10) + colWidths[0] / 10);
  }
  // Draw a single ability row
  private void drawAbilityRow(Ability ability, int row, int startX, int y, int[] colWidths) {
    String[] fields = {
      ability.name, ability.classType, ability.primaryType, ability.secondaryType, String.valueOf(ability.weight), String.valueOf(ability.power), String.valueOf(ability.cooldown) }
    ;
    int colX = startX;
    for(int col = 0;
    col < fields.length;
    col++) {
      if (row == selectedRow && col == selectedCol) {
        if (isEditing || ctrlPressed &&(col == 2 || col == 3 || col == 4 || col == 5 || col == 6)) {
          applet.fill(255, 0, 255); // Editing mode or control key pressed: pink
        } else {
          applet.fill(0, 255, 0); // Highlighted: green
        }
      } else {
        applet.fill(255); // Default color: white
      }
      if (row == selectedRow && col == selectedCol && isEditing) {
        if (col == 2 || col == 3) {
          drawField(fields[col], colX + colWidths[col] / 2, y, colWidths[col]);
        } else {
          drawEditableField(fields[col], colX + colWidths[col] / 2, y, colWidths[col]);
        }
      } else {
        drawField(fields[col], colX + colWidths[col] / 2, y, colWidths[col]);
      }
      colX += colWidths[col];
      drawVerticalLine(colX, y);
    }
  }
  // Draw a field

  private void drawField(String text, int x, int y, int width) {
    applet.text(text, x, y);
  }
  // Draw an editable field with a cursor

  private void drawEditableField(String text, int x, int y, int width) {
    applet.text(currentInput +(cursorVisible ? "_" : ""), x, y);
  }
  // Draw a vertical line

  private void drawVerticalLine(int x, int y) {
    applet.stroke(255, 255, 0);
    applet.line(x, y, x, y + 30);
    applet.noStroke();
  }
  // Draw the confirmation screen for deleting an ability

  private void drawConfirmationScreen() {
    applet.fill(255, 0, 0);
    applet.textAlign(PApplet.CENTER, PApplet.CENTER);
    applet.textSize(24);
    applet.text("Confirm Deletion?(Y/N)", applet.width / 2, applet.height / 2);
  }
  // Handle key press events

  private void handleKeyPress() {
    if (applet.keyCode == PApplet.CONTROL) {
      ctrlPressed = true;
    }
    if (isEditing && selectedCol != 2 && selectedCol != 3) {
      handleEditingKeyPressed();
    } else {
      switch(applet.keyCode) {
        case PApplet.UP: if ((ctrlPressed &&(selectedCol == 2 || selectedCol == 3 || selectedCol == 4 || selectedCol == 5 || selectedCol == 6)) ||(isEditing &&(selectedCol == 2 || selectedCol == 3))) {
          cycleFieldValue(true);
        } else {
          selectedRow =(selectedRow - 1 + abilities.size()) % abilities.size();
          debugLog("Selected row: " + selectedRow);
        }
        break;
        case PApplet.DOWN: if ((ctrlPressed &&(selectedCol == 2 || selectedCol == 3 || selectedCol == 4 || selectedCol == 5 || selectedCol == 6)) ||(isEditing &&(selectedCol == 2 || selectedCol == 3))) {
          cycleFieldValue(false);
        } else {
          selectedRow =(selectedRow + 1) % abilities.size();
          debugLog("Selected row: " + selectedRow);
        }
        break;
        case PApplet.LEFT: if ((ctrlPressed &&(selectedCol == 2 || selectedCol == 3 || selectedCol == 4 || selectedCol == 5 || selectedCol == 6)) ||(isEditing &&(selectedCol == 2 || selectedCol == 3))) {
          cycleFieldValue(false);
        } else {
          selectedCol =(selectedCol - 1 + 7) % 7;
          debugLog("Selected column: " + selectedCol);
        }
        break;
        case PApplet.RIGHT: if ((ctrlPressed &&(selectedCol == 2 || selectedCol == 3 || selectedCol == 4 || selectedCol == 5 || selectedCol == 6)) ||(isEditing &&(selectedCol == 2 || selectedCol == 3))) {
          cycleFieldValue(true);
        } else {
          selectedCol =(selectedCol + 1) % 7;
          debugLog("Selected column: " + selectedCol);
        }
        break;
        case PApplet.ENTER: if (selectedCol != 1) {
          isEditing = !isEditing;
          currentInput = "";
        }
        break;
        case 112: // F1 key code
        settingAllValues = true;
        allValueInput = "";
        selectedCol = 4; // Set the column to weight
        debugLog("Setting all weights.");
        break;
        case 113: // F2 key code
        settingAllValues = true;
        allValueInput = "";
        selectedCol = 5; // Set the column to power
        debugLog("Setting all power levels.");
        break;
        case 114: // F3 key code
        createNewAbility();
        break;
        case 115: // F4 key code
        confirmDeletion = true;
        break;
        case 116: // F5 key code
        commitAndReturn();
        break;
        default: break;
      }
    }
  }
  // Handle cycling through field values

  private void cycleFieldValue(boolean forward) {
    Ability ability = abilities.get(selectedRow);

    switch(selectedCol) {
      case 2: ability.primaryType = cycleType(ability.primaryType, forward);
      break;
      case 3: ability.secondaryType = cycleType(ability.secondaryType, forward);
      break;
      case 4: ability.weight = cycleNumber(ability.weight, forward);
      break;
      case 5: ability.power = cycleNumber(ability.power, forward);
      break;
      case 6: ability.cooldown = cycleNumber(ability.cooldown, forward);
      break;
      default: break;
    }
  }
  // Cycle through type options

  private String cycleType(String currentType, boolean forward) {
    int index = findTypeIndex(currentType);

    if (forward) {
      index =(index + 1) % typeOptions.length;
    } else {
      index =(index - 1 + typeOptions.length) % typeOptions.length;
    }
    return typeOptions[index];
  }
  // Find the index of the current type in the typeOptions array

  private int findTypeIndex(String type) {
    for(int i = 0;
    i < typeOptions.length;
    i++) {
      if (typeOptions[i].equals(type)) {
        return i;
      }
    }
    return -1; // Default to an invalid index
  }
  // Cycle through numbers for weight and power

  private int cycleNumber(int currentNumber, boolean forward) {
    int step = selectedCol == 4 ? 10 : 1; // Step for cycling weight by 10 and other numbers by 1

    if (forward) {
      return Math.min(currentNumber + step, MAX_VALUE);
    } else {
      return Math.max(currentNumber - step, 0);
    }
  }
  // Handle key presses for confirmation screen

  private void handleConfirmationKeyPress() {
    if (applet.key == 'Y' || applet.key == 'y') {
      removeAbility();
      confirmDeletion = false;
    }
    else if (applet.key == 'N' || applet.key == 'n') {
      confirmDeletion = false;
    }
  }
  // Handle key presses for editing mode

  private void handleEditingKeyPressed() {
    if (applet.key == PApplet.ENTER) {
      saveCurrentInput();
    }
    else if (applet.key == PApplet.BACKSPACE) {
      handleBackspace();
    } else {
      handleCharacterInput(applet.key);
    }
  }
  // Handle key presses for setting all values

  private void handleSetAllValuesKeyPressed() {
    if (applet.key == PApplet.ENTER) {
      applyAllValues();
      settingAllValues = false;
    }
    else if (applet.key == PApplet.BACKSPACE) {
      handleAllValueBackspace();
    } else {
      handleAllValueCharacterInput(applet.key);
    }
  }
  // Save the current input to the selected ability attribute

  private void saveCurrentInput() {
    Ability ability = abilities.get(selectedRow);

    switch(selectedCol) {
      case 0: ability.name = currentInput.length() <= 36 ? currentInput : ability.name;
      break;
      case 4: ability.weight = isValidNumber(currentInput, ability.weight);
      break;
      case 5: ability.power = isValidNumber(currentInput, ability.power);
      break;
      case 6: ability.cooldown = isValidNumber(currentInput, ability.cooldown);
      break;
      default: break;
    }
    isEditing = false;
    debugLog("Saved input: " + currentInput + " to ability: " + ability.name);
  }
  // Create a new ability

  private void createNewAbility() {
    abilities.add(new Attack("New Ability", 0, 0, "", "", 0));
    debugLog("Created new ability.");
  }
  // Remove the selected ability

  private void removeAbility() {
    if (!abilities.isEmpty()) {
      abilities.remove(selectedRow);
      selectedRow = Math.max(0, selectedRow - 1);
      debugLog("Removed ability at row: " + selectedRow);
    }
  }
  // Commit the ability list and go back to the custom battle setup screen

  private void commitAndReturn() {
    screenManager.getDataManager().setAbilities(entityName, abilities);
    screenManager.showScreen(new CustomBattleScreen(applet, screenManager));
    debugLog("Committed abilities and returned to custom battle setup screen.");
  }
  // Apply all values to abilities

  private void applyAllValues() {
    int value = parseInt(allValueInput, 0);
    for(Ability ability : abilities) {
      if (selectedCol == 4) {
        ability.weight = value;
      }
      else if (selectedCol == 5) {
        ability.power = value;
      }
    }
    debugLog("Applied value: " + value + " to all abilities.");
  }
  // Handle backspace input

  private void handleBackspace() {
    if (!currentInput.isEmpty()) {
      currentInput = currentInput.substring(0, currentInput.length() - 1);
    }
  }
  // Handle character input

  private void handleCharacterInput(char key) {
    if (isValidCharacter(key)) {
      currentInput += key;
    }
  }
  // Handle backspace for setting all values

  private void handleAllValueBackspace() {
    if (!allValueInput.isEmpty()) {
      allValueInput = allValueInput.substring(0, allValueInput.length() - 1);
    }
  }
  // Handle character input for setting all values

  private void handleAllValueCharacterInput(char key) {
    if (isValidCharacter(key)) {
      allValueInput += key;
    }
  }
  // Validate if a character is acceptable

  private boolean isValidCharacter(char c) {
    return(c >= 'a' && c <= 'z') ||(c >= 'A' && c <= 'Z') ||(c >= '0' && c <= '9') || c == ' ' || c == '-';
  }
  // Validate number input with a fallback value

  private int isValidNumber(String input, int fallback) {
    try {
      int value = Integer.parseInt(input);
      return Math.min(value, MAX_VALUE);
    }

    catch(NumberFormatException e) {
      debugLog("Invalid number format: " + input);
      return fallback;
    }
  }
  // Parse integer with a fallback value

  private int parseInt(String value, int fallback) {
    try {
      return Integer.parseInt(value);
    }

    catch(NumberFormatException e) {
      debugLog("Invalid number format: " + value);
      return fallback;
    }
  }
  // Debug logging

  private void debugLog(String message) {
    System.out.println("[DEBUG] " + message);
  }
}
// ==========================================================
// GAME DATA MANAGER CLASS
// Manages the game data for player and enemy characters, // including storing and retrieving character details.
// ==========================================================
class GameDataManager {
  private Character player;
  private Character enemy;
  private Map<String, List<Ability>> abilitiesMap;

  public GameDataManager() {
    abilitiesMap = new HashMap<>();
  }

  public Character getPlayer() {
    return player;
  }

  public void setPlayer(Character player) {
    this.player = player;
  }

  public Character getEnemy() {
    return enemy;
  }

  public void setEnemy(Character enemy) {
    this.enemy = enemy;
  }

  public List<Ability> getAbilities(String entityName) {
    return abilitiesMap.get(entityName);
  }
  public void setAbilities(String entityName, List<Ability> abilities) {
    abilitiesMap.put(entityName, abilities);
  }
}
