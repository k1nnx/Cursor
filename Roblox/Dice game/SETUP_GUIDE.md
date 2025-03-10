# Dice Game Setup Guide

This guide will help you set up the Kingdom Come: Deliverance dice game in Roblox Studio.

## Step 1: Create the Module Scripts in ReplicatedStorage

1. In Roblox Studio, open the place where you want to add the dice game.

2. In the Explorer window, right-click on **ReplicatedStorage** and create the following ModuleScripts:

   a. Create a ModuleScript named "Dice"
   - Copy the contents of `Dice.lua` into it
   
   b. Create a ModuleScript named "DiceUI"
   - Copy the contents of `DiceUI.lua` into it
   
   c. Create a ModuleScript named "DiceGameClient"
   - Copy the contents of `DiceGameClient.lua` into it

## Step 2: Create the Client Script in StarterPlayerScripts

1. In the Explorer window, expand **StarterPlayer** and then **StarterPlayerScripts**

2. Right-click on **StarterPlayerScripts** and select **Insert Object > LocalScript**

3. Name this LocalScript "DiceGameClientRunner"

4. Copy the contents of `DiceGameClientRunner.lua` into this LocalScript

## Step 3: Create the Server Script in ServerScriptService

1. In the Explorer window, right-click on **ServerScriptService** and select **Insert Object > Script**

2. Name this Script "GameInit"

3. Copy the contents of `GameInit.lua` into this Script

## Step 4: Test the Game

1. Make sure all scripts are in their correct locations:
   - In ReplicatedStorage:
     - Dice (ModuleScript)
     - DiceUI (ModuleScript)
     - DiceGameClient (ModuleScript)
   - In StarterPlayerScripts:
     - DiceGameClientRunner (LocalScript)
   - In ServerScriptService:
     - GameInit (Script)

2. Click the Play button in Roblox Studio to test the game.

3. You should see:
   - A welcome message
   - A wooden table in the workspace
   - An NPC called "Dice Master"

4. Click on the Dice Master NPC to start a game.

## Troubleshooting

If you encounter any issues:

1. **Scripts not loading**: Make sure all scripts are in their correct locations and named exactly as specified.

2. **Missing modules error**: Check that all three ModuleScripts are in ReplicatedStorage.

3. **NPC or table not appearing**: Verify that the GameInit script in ServerScriptService is running.

4. **Game not starting**: Make sure the DiceGameClientRunner script is in StarterPlayerScripts.

5. **Script errors**: Check the Output window in Roblox Studio for any error messages.

## Customization

You can customize various aspects of the game:

- Change the winning score in DiceGameClient.lua (default is 2000)
- Modify the appearance of the dice and table in DiceUI.lua
- Add special dice types with different probabilities
- Implement additional features like betting or special abilities

Refer to the README.md file for more information about the game mechanics and customization options. 