local restart = RegisterMod("Restart on Controller", 1)
-- "Settings"

-- The amount of frames to wait before restarting the run
-- Default is about the time it takes to restart on keyboard.
-- Default: 30
local framesBeforeRestart = 30;

-- Possible values for Buttons on the controller.
-- See below for actual settings on which buttons need to be pressed.
-- Pseudo Enum for Controller-Buttons

local Controller = {
  DPAD_LEFT = 0,
  DPAD_RIGHT = 1,
  DPAD_UP = 2,
  DPAD_DOWN = 3,
  KEY_A = 4,
  KEY_B = 5,
  KEY_X = 6,
  KEY_Y = 7,
  KEY_LB = 8,
  KEY_LT = 9,
  KEY_LSTICK_DOWN = 10,
  KEY_RB = 11,
  KEY_RT = 12,
  KEY_RSTICK_DOWN = 13,
  KEY_SELECT = 14,
  KEY_START = 15};

-- The two buttons to be held down on the controller.
-- If useButtons is true, possible values are Controller.DPAD_LEFT through Controller.KEY_START (see below).
-- Otherwise, possible values are ButtonAction.ACTION_LEFT through ButtonAction.ACTION_MENUTAB.
--ButtonAction.ACTION_MENU* values are not recommended.
--For the ButtonAction enumeration see  https://moddingofisaac.com/docs/group__enums.html#gafa717ac273a5a382f7c01ef7afba1ee7 or <BindingOfIsaacInstallDir>\tools\LuaDocs\group__enums.html#gafa717ac273a5a382f7c01ef7afba1ee7
local useButtons = true;
local button1 = Controller.KEY_RT;
local button2 = Controller.KEY_LT;

-- "Code"

-- Save how many frames both buttons have been pressed for.
local frames = 0;

-- Run on every game update and check whether the buttons are pressed and whether we need to restart
function restart:postUpdate()
  -- Get the player and the controller Index
  local player = Isaac.GetPlayer(0);
  local cindex = player.ControllerIndex;
  -- If the player is on a controller ( 0 is keyboard, 1 - 4 Xbox Controller 1 to 4 
  if cindex > 0 then

    -- Check whether the buttons are currently pressed
    local itemPressed;
    local dropPressed;
    if useButtons then
      itemPressed = Input.IsButtonPressed(button1, cindex);
      dropPressed = Input.IsButtonPressed(button2, cindex);
    else
      itemPressed = Input.IsActionPressed(button1, cindex);
      dropPressed = Input.IsActionPressed(button2, cindex);
    end
    
    -- If both buttons are pressed
    if itemPressed and dropPressed then
      
      -- Count the frames
      frames = frames + 1;
      -- If the threshold before Restart was reached
      if frames >= framesBeforeRestart then
        -- Restart
        Isaac.ExecuteCommand("restart");
      else
        Isaac.ConsoleOutput(tostring(framesBeforeRestart - frames) .. " frames before restart.");
      end
      -- Count was increased, exit function
      return;
    end
  end
  -- If any of the conditions was not met, reset frame count
  frames = 0;
  --Isaac.ConsoleOutput("restart on controller working.");
end
restart:AddCallback(ModCallbacks.MC_POST_UPDATE, restart.postUpdate)

-- Reset frame count on leaving run
---[[
function restart:preGameExit(shouldSave)
  frames = 0;
  --Isaac.ConsoleOutput("pregameexit");
end
restart:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, restart.preGameExit)
--]]

-- Reset frame count on starting run
---[[
function restart:postGameStart(fromSave)
  frames = 0;
  --Isaac.ConsoleOutput("postgamestarted");
end
restart:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, restart.postGameStart)
--]]