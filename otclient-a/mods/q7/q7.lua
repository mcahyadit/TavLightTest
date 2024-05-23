--[[
  Added extra something, if you want to check only the assignment, comment everthing between
  --[extraFunAdditionsBegin
  --extraFunAdditionsEnd
]]

local q7Button = nil
local q7Window = nil
local mBtn
local speed = 5

-- Animation Bounds
local marginL = 16
local marginR = 10
local marginT = 32
local marginB = 40
local xMin
local xMax
local yMin
local yMax

local extraFunSign = 1
local extraFunBool = 1

function init()
  q7Button = modules.client_topmenu.addRightToggleButton('q7Button', tr('Q7'), '/q7/q7', closing)
  q7Button:setOn(false)

  q7Window = g_ui.displayUI('q7')
  q7Window:setVisible(false)

  allTabs = q7Window:recursiveGetChildById('allTabs')
  allTabs:setContentWidget(q7Window:getChildById('optionsTabContent'))

  mBtn = q7Window:getChildById('tanaba')
  mBtn.onClick = function() btnClickTrigger() end

end

function terminate()
  q7Button:destroy()
  q7Window:destroy()
end

function moveConstly()
  --Update Bounds for moveBtn
  xMin = marginL + q7Window:getX()
  xMax = -marginR + q7Window:getX() + q7Window:getSize().width - mBtn:getSize().width
  yMin = marginT + q7Window:getY()
  yMax = -marginB + q7Window:getY() + q7Window:getSize().height - mBtn:getSize().height
  --Update Bounds for moveBtn

  print("Pos: ")
  print(mBtn:getX())
  print(mBtn:getY())

  local tmpX = 1
  local tmpY = 0

  --[extraFunAdditionsBegin
  tmpX = extraFunBool
  tmpY = (1 - extraFunBool)
  --extraFunAdditionsEnd

  moveBtn(speed * tmpX, speed * tmpY, false, false)

  --Turn off loop if window is hidden
  if q7Window:isVisible() then
    scheduleEvent(moveConstly, 20)
  end
end

function closing()
  if q7Button:isOn() then
    q7Window:setVisible(false)
    q7Button:setOn(false)
  else
    q7Window:setVisible(true)
    q7Button:setOn(true)

    --Turn loop back on
    moveConstly()
  end
end

function onMiniWindowClose()
  q7Button:setOn(false)
end

function haveFun()
  --[extraFunAdditionsBegin
  extraFunSign = math.random(-1,1)
  if extraFunSign == 0 then
    extraFunSign = 1
  end
  extraFunSign = extraFunSign / math.abs(extraFunSign)
  speed = math.abs(speed) * extraFunSign

  extraFunBool = math.floor(math.random(0, 1))
  --extraFunAdditionsEnd
end

function btnClickTrigger()
  local tmpX = xMin
  local tmpY = getRandomY()

  if speed > 0 then
    tmpX = xMin
  else
    tmpX = xMax
  end

  --[extraFunAdditionsBegin
  haveFun()
  if extraFunBool == 1 then
    if speed > 0 then
      tmpX = xMin
    else
      tmpX = xMax
    end
    tmpY = getRandomY()
  else
    tmpX = getRandomX()
    if speed > 0 then
      tmpY = yMin
    else
      tmpY = yMax
    end
  end
  --extraFunAdditionsEnd

  moveBtn(tmpX, tmpY, true, true)
end

function getRandomY()
  --Get random number, reroll number if too close
  local tmp1 = mBtn:getY()
  local tmp2 = tmp1
  while math.abs(tmp1 - tmp2) < 1.5 * mBtn:getSize().height do
    tmp2 = math.random(yMin, yMax)
  end

  return tmp2
end

function getRandomX()
  --Get random number, reroll number if too close
  local tmp1 = mBtn:getX()
  local tmp2 = tmp1
  while math.abs(tmp1 - tmp2) < 1.5 * mBtn:getSize().width do
    tmp2 = math.random(xMin, xMax)
  end

  return tmp2
end

function moveBtn(xDelta, yDelta, xForce, yForce)
  --Set Delta
  local x
  if xForce then
    x = xDelta
  else
    x = mBtn:getX() + xDelta
  end

  local y
  if yForce then
    y = yDelta
  else
    y = mBtn:getY() + yDelta
  end

  --Move from Bounds
  local tmp = getRandomY() --extra line for assignment

  if x > xMax then
    y = tmp --extra line for assignment
    mBtn:setX(xMin)
  else
    if x < xMin then
      y = tmp --extra line for assignment
      mBtn:setX(xMax)
    else
      mBtn:setX(x)
    end
  end

  if y > yMax then
    mBtn:setY(yMin)
  else
    if y < yMin then
      mBtn:setY(yMax)
    else
      mBtn:setY(y)
    end
  end

  --[extraFunAdditionsBegin
  if mBtn:getX() ~= x or mBtn:getY() ~= y then
    haveFun()
    if extraFunBool == 0 then
      mBtn:setX(getRandomX())
    else
      mBtn:setY(getRandomY())
    end
  end
  --extraFunAdditionsEnd

  --[[
    By setting the Bounds first and then checking if
      the position went out of bounds will allow
      xyDelta to have signed number that doubles as direction
    This coupled with getting the values of the parent
      should be more versatile and applicable to other iterations
  ]]

end