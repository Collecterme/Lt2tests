local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Встроенные данные о предметах (оставлены пустыми)
local ShopItemsData = [[
(XYZ = 346.30, 3.70, 34.61; ItemName = Wire; StoreName = WoodRUs),
(XYZ = 345.66, 3.70, 34.61; ItemName = Wire; StoreName = WoodRUs),
(XYZ = 345.15, 3.70, 34.61; ItemName = Wire; StoreName = WoodRUs),
(XYZ = 344.70, 3.70, 34.61; ItemName = Wire; StoreName = WoodRUs),
(XYZ = 346.22, 3.70, 32.50; ItemName = Wire; StoreName = WoodRUs),
(XYZ = 345.70, 3.70, 32.50; ItemName = Wire; StoreName = WoodRUs),
(XYZ = 345.18, 3.69, 32.50; ItemName = Wire; StoreName = WoodRUs),
(XYZ = 344.70, 3.69, 32.50; ItemName = Wire; StoreName = WoodRUs),
(XYZ = 346.33, 3.85, 38.73; ItemName = Button0; StoreName = WoodRUs),
(XYZ = 345.10, 3.87, 38.81; ItemName = Button0; StoreName = WoodRUs),
(XYZ = 346.47, 3.85, 40.80; ItemName = Button0; StoreName = WoodRUs),
(XYZ = 345.10, 3.87, 41.02; ItemName = Button0; StoreName = WoodRUs),
(XYZ = 346.55, 3.85, 43.82; ItemName = Lever0; StoreName = WoodRUs),
(XYZ = 345.11, 3.87, 44.39; ItemName = Lever0; StoreName = WoodRUs),
(XYZ = 345.11, 3.88, 46.66; ItemName = Lever0; StoreName = WoodRUs),
(XYZ = 346.33, 3.85, 46.14; ItemName = Lever0; StoreName = WoodRUs),
(XYZ = 345.20, 6.30, 50.50; ItemName = SilverAxe; StoreName = WoodRUs),
(XYZ = 345.30, 3.50, 50.40; ItemName = SilverAxe; StoreName = WoodRUs),
(XYZ = 345.10, 6.70, 46.21; ItemName = PressurePlate; StoreName = WoodRUs),
(XYZ = 346.26, 6.70, 46.19; ItemName = PressurePlate; StoreName = WoodRUs),
(XYZ = 345.78, 7.56, 33.31; ItemName = ChopSaw; StoreName = WoodRUs),
(XYZ = 328.50, 1.20, 21.78; ItemName = Wedge8; StoreName = WoodRUs),
(XYZ = 329.70, 1.20, 21.78; ItemName = Wedge8_Thin; StoreName = WoodRUs),
(XYZ = 331.90, 1.20, 21.78; ItemName = Wedge9; StoreName = WoodRUs),
(XYZ = 333.10, 1.20, 21.78; ItemName = Wedge9_Thin; StoreName = WoodRUs),
(XYZ = 335.90, 1.18, 21.78; ItemName = Wedge10; StoreName = WoodRUs),
(XYZ = 337.10, 1.18, 21.78; ItemName = Wedge10_Thin; StoreName = WoodRUs),
(XYZ = 333.70, 3.97, 21.38; ItemName = Wedge7; StoreName = WoodRUs),
(XYZ = 334.90, 3.98, 21.38; ItemName = Wedge7_Thin; StoreName = WoodRUs),
(XYZ = 330.30, 3.96, 21.38; ItemName = Wedge6; StoreName = WoodRUs),
(XYZ = 331.50, 3.96, 21.38; ItemName = Wedge6_Thin; StoreName = WoodRUs),
(XYZ = 327.10, 3.98, 21.38; ItemName = Wedge5; StoreName = WoodRUs),
(XYZ = 328.10, 3.98, 21.38; ItemName = Wedge5_Thin; StoreName = WoodRUs),
(XYZ = 327.15, 6.80, 21.60; ItemName = Wedge1; StoreName = WoodRUs),
(XYZ = 328.10, 6.75, 21.40; ItemName = Wedge1_Thin; StoreName = WoodRUs),
(XYZ = 330.30, 6.75, 21.34; ItemName = Wedge2; StoreName = WoodRUs),
(XYZ = 331.30, 6.75, 21.40; ItemName = Wedge2_Thin; StoreName = WoodRUs),
(XYZ = 333.50, 6.75, 21.40; ItemName = Wedge3; StoreName = WoodRUs),
(XYZ = 334.70, 6.75, 21.20; ItemName = Wedge3_Thin; StoreName = WoodRUs),
(XYZ = 337.10, 6.75, 21.40; ItemName = Wedge4; StoreName = WoodRUs),
(XYZ = 338.10, 6.77, 21.20; ItemName = Wedge4_Thin; StoreName = WoodRUs),
(XYZ = 314.40, 6.78, 21.30; ItemName = Ladder1; StoreName = WoodRUs),
(XYZ = 316.20, 6.80, 21.30; ItemName = Post; StoreName = WoodRUs),
(XYZ = 310.30, 6.78, 21.40; ItemName = Stair1; StoreName = WoodRUs),
(XYZ = 312.10, 6.77, 21.40; ItemName = Stair2; StoreName = WoodRUs),
(XYZ = 312.00, 1.17, 22.09; ItemName = Door1; StoreName = WoodRUs),
(XYZ = 313.76, 1.16, 22.01; ItemName = Door2; StoreName = WoodRUs),
(XYZ = 315.60, 1.16, 22.10; ItemName = Door3; StoreName = WoodRUs),
(XYZ = 301.70, 1.19, 22.20; ItemName = Table1; StoreName = WoodRUs),
(XYZ = 303.50, 1.19, 22.20; ItemName = Table2; StoreName = WoodRUs),
(XYZ = 304.90, 1.19, 22.00; ItemName = Chair1; StoreName = WoodRUs),
(XYZ = 301.40, 3.99, 21.77; ItemName = Floor1Tiny; StoreName = WoodRUs),
(XYZ = 303.00, 4.00, 21.50; ItemName = Floor1Small; StoreName = WoodRUs),
(XYZ = 304.60, 4.00, 21.50; ItemName = Floor1; StoreName = WoodRUs),
(XYZ = 306.20, 4.00, 21.50; ItemName = Floor1Large; StoreName = WoodRUs),
(XYZ = 301.20, 6.79, 21.57; ItemName = Floor2Tiny; StoreName = WoodRUs),
(XYZ = 303.00, 6.79, 21.10; ItemName = Floor2Small; StoreName = WoodRUs),
(XYZ = 294.60, 6.79, 21.50; ItemName = Wall1Tall; StoreName = WoodRUs),
(XYZ = 296.20, 6.78, 21.50; ItemName = Wall1TallThin; StoreName = WoodRUs),
(XYZ = 297.82, 6.78, 21.48; ItemName = Wall1TallCorner; StoreName = WoodRUs),
(XYZ = 294.60, 4.00, 21.50; ItemName = Wall1; StoreName = WoodRUs),
(XYZ = 296.20, 3.99, 21.50; ItemName = Wall1Thin; StoreName = WoodRUs),
(XYZ = 297.80, 3.99, 21.50; ItemName = Wall1Corner; StoreName = WoodRUs),
(XYZ = 294.60, 1.15, 21.50; ItemName = Wall1Short; StoreName = WoodRUs),
(XYZ = 296.20, 1.15, 21.50; ItemName = Wall1ShortThin; StoreName = WoodRUs),
(XYZ = 297.80, 1.15, 21.50; ItemName = Wall1ShortCorner; StoreName = WoodRUs),
(XYZ = 285.06, 6.78, 21.26; ItemName = Wall2Tall; StoreName = WoodRUs),
(XYZ = 286.60, 6.79, 21.30; ItemName = Wall2TallThin; StoreName = WoodRUs),
(XYZ = 288.11, 6.79, 21.25; ItemName = Wall2TallCorner; StoreName = WoodRUs),
(XYZ = 276.60, 6.79, 21.50; ItemName = Wall3Tall; StoreName = WoodRUs),
(XYZ = 278.08, 6.78, 21.55; ItemName = Wall3TallThin; StoreName = WoodRUs),
(XYZ = 279.80, 6.79, 21.50; ItemName = Wall3TallCorner; StoreName = WoodRUs),
(XYZ = 276.60, 3.99, 21.50; ItemName = Wall3; StoreName = WoodRUs),
(XYZ = 278.20, 3.99, 21.50; ItemName = Wall3Thin; StoreName = WoodRUs),
(XYZ = 279.80, 3.97, 21.50; ItemName = Wall3Corner; StoreName = WoodRUs),
(XYZ = 285.02, 3.97, 21.29; ItemName = Wall2; StoreName = WoodRUs),
(XYZ = 288.20, 3.95, 21.30; ItemName = Wall2Corner; StoreName = WoodRUs),
(XYZ = 285.00, 1.15, 21.30; ItemName = Wall2Short; StoreName = WoodRUs),
(XYZ = 286.60, 1.15, 21.30; ItemName = Wall2ShortThin; StoreName = WoodRUs),
(XYZ = 288.20, 1.15, 21.30; ItemName = Wall2ShortCorner; StoreName = WoodRUs),
(XYZ = 286.60, 4.00, 21.30; ItemName = Wall2Thin; StoreName = WoodRUs),
(XYZ = 288.12, 7.58, 39.37; ItemName = WorkLight; StoreName = WoodRUs),
(XYZ = 287.77, 6.39, 39.49; ItemName = WorkLight; StoreName = WoodRUs),
(XYZ = 290.47, 6.35, 39.82; ItemName = WorkLight; StoreName = WoodRUs),
(XYZ = 286.68, 7.35, 42.17; ItemName = Sawmill; StoreName = WoodRUs),
(XYZ = 294.33, 7.85, 39.23; ItemName = UtilityTruck; StoreName = WoodRUs),
(XYZ = 287.26, 3.55, 39.23; ItemName = WorkLight; StoreName = WoodRUs),
(XYZ = 293.26, 7.35, 42.14; ItemName = Sawmill; StoreName = WoodRUs),
(XYZ = 316.70, 7.59, 39.00; ItemName = Sawmill3; StoreName = WoodRUs),
(XYZ = 316.23, 7.40, 42.23; ItemName = Sawmill2; StoreName = WoodRUs),
(XYZ = 325.76, 7.56, 38.80; ItemName = Sawmill4L; StoreName = WoodRUs),
(XYZ = 326.80, 3.57, 42.20; ItemName = BagOfSand; StoreName = WoodRUs),
(XYZ = 324.00, 7.56, 42.01; ItemName = Sawmill4; StoreName = WoodRUs),
(XYZ = 316.70, 3.49, 57.09; ItemName = Axe3; StoreName = WoodRUs),
(XYZ = 316.80, 4.49, 56.97; ItemName = Axe3; StoreName = WoodRUs),
(XYZ = 297.30, 3.45, 57.30; ItemName = Axe2; StoreName = WoodRUs),
(XYZ = 297.30, 3.48, 60.50; ItemName = Axe1; StoreName = WoodRUs),
(XYZ = 297.50, 4.41, 57.30; ItemName = Axe2; StoreName = WoodRUs),
(XYZ = 297.30, 4.47, 60.29; ItemName = Axe1; StoreName = WoodRUs),
(XYZ = 285.14, 3.45, 60.52; ItemName = BasicHatchet; StoreName = WoodRUs),
(XYZ = 284.38, 6.25, 60.08; ItemName = BasicHatchet; StoreName = WoodRUs),
(XYZ = 286.10, 6.25, 56.93; ItemName = BasicHatchet; StoreName = WoodRUs),
(XYZ = 295.94, 6.76, 93.53; ItemName = TightTurnConveyor; StoreName = WoodRUs),
(XYZ = 292.56, 6.76, 93.61; ItemName = TightTurnConveyor; StoreName = WoodRUs),
(XYZ = 287.78, 6.80, 93.50; ItemName = TiltConveyor; StoreName = WoodRUs),
(XYZ = 284.43, 6.79, 93.50; ItemName = TiltConveyor; StoreName = WoodRUs),
(XYZ = 295.41, 3.97, 93.50; ItemName = StraightConveyor; StoreName = WoodRUs),
(XYZ = 291.91, 4.00, 93.36; ItemName = StraightConveyor; StoreName = WoodRUs),
(XYZ = 288.43, 4.00, 93.50; ItemName = ConveyorFunnel; StoreName = WoodRUs),
(XYZ = 276.84, 6.79, 93.72; ItemName = StraightSwitchConveyorLeft; StoreName = WoodRUs),
(XYZ = 273.43, 6.79, 93.83; ItemName = StraightSwitchConveyorRight; StoreName = WoodRUs),
(XYZ = 265.67, 6.75, 93.40; ItemName = LogSweeper; StoreName = WoodRUs),
(XYZ = 268.84, 6.76, 93.42; ItemName = ConveyorSwitch; StoreName = WoodRUs),
(XYZ = 264.42, 3.99, 93.65; ItemName = TightTurnConveyorSupports; StoreName = WoodRUs),
(XYZ = 267.88, 4.00, 93.49; ItemName = ConveyorSupports; StoreName = WoodRUs),
(XYZ = 271.08, 4.00, 93.49; ItemName = ConveyorSupports; StoreName = WoodRUs),
(XYZ = 288.81, 3.45, 56.96; ItemName = BasicHatchet; StoreName = WoodRUs),
(XYZ = 285.31, 3.50, 56.90; ItemName = BasicHatchet; StoreName = WoodRUs),
(XYZ = 285.90, 4.49, 56.92; ItemName = BasicHatchet; StoreName = WoodRUs),
(XYZ = 528.80, 1.80, -1449.10; ItemName = SmallTrailer; StoreName = CarStore),
(XYZ = 527.32, 1.80, -1439.38; ItemName = Trailer2; StoreName = CarStore),
(XYZ = 515.91, 2.29, -1423.60; ItemName = UtilityTruck2; StoreName = CarStore),
(XYZ = 500.15, 2.30, -1424.24; ItemName = Pickup1; StoreName = CarStore),
(XYZ = 464.01, 7.60, -1752.58; ItemName = Seat_Armchair; StoreName = FurnitureStore),
(XYZ = 464.41, 7.60, -1756.13; ItemName = Seat_Armchair; StoreName = FurnitureStore),
(XYZ = 464.84, 7.60, -1759.79; ItemName = Seat_Armchair; StoreName = FurnitureStore),
(XYZ = 465.57, 1.60, -1752.54; ItemName = Seat_Armchair; StoreName = FurnitureStore),
(XYZ = 465.61, 1.60, -1755.83; ItemName = Seat_Armchair; StoreName = FurnitureStore),
(XYZ = 465.44, 1.60, -1759.19; ItemName = Seat_Armchair; StoreName = FurnitureStore),
(XYZ = 464.20, 7.60, -1763.66; ItemName = Seat_Loveseat; StoreName = FurnitureStore),
(XYZ = 464.14, 7.60, -1767.85; ItemName = Seat_Loveseat; StoreName = FurnitureStore),
(XYZ = 464.20, 1.60, -1763.46; ItemName = Seat_Loveseat; StoreName = FurnitureStore),
(XYZ = 464.14, 1.60, -1766.85; ItemName = Seat_Loveseat; StoreName = FurnitureStore),
(XYZ = 463.92, 1.60, -1770.11; ItemName = Seat_Loveseat; StoreName = FurnitureStore),
(XYZ = 464.14, 1.60, -1774.50; ItemName = Seat_Couch; StoreName = FurnitureStore),
(XYZ = 464.37, 1.60, -1777.95; ItemName = Seat_Couch; StoreName = FurnitureStore),
(XYZ = 464.24, 1.60, -1781.16; ItemName = Seat_Couch; StoreName = FurnitureStore),
(XYZ = 463.54, 7.60, -1774.90; ItemName = Seat_Couch; StoreName = FurnitureStore),
(XYZ = 463.84, 7.60, -1779.16; ItemName = Seat_Couch; StoreName = FurnitureStore),
(XYZ = 474.20, 0.30, -1787.20; ItemName = Model; StoreName = FurnitureStore),
(XYZ = 463.91, 1.39, -1798.08; ItemName = Lamp1; StoreName = FurnitureStore),
(XYZ = 465.35, 1.39, -1798.24; ItemName = Lamp1; StoreName = FurnitureStore),
(XYZ = 466.70, 1.39, -1798.10; ItemName = Lamp1; StoreName = FurnitureStore),
(XYZ = 463.87, 2.09, -1795.37; ItemName = FloorLamp1; StoreName = FurnitureStore),
(XYZ = 465.27, 2.09, -1795.37; ItemName = FloorLamp1; StoreName = FurnitureStore),
(XYZ = 466.70, 2.09, -1795.30; ItemName = FloorLamp1; StoreName = FurnitureStore),
(XYZ = 465.40, 1.10, -1806.00; ItemName = WallLight1; StoreName = FurnitureStore),
(XYZ = 465.28, 1.10, -1807.84; ItemName = WallLight1; StoreName = FurnitureStore),
(XYZ = 466.80, 1.10, -1805.80; ItemName = WallLight1; StoreName = FurnitureStore),
(XYZ = 467.00, 1.09, -1807.80; ItemName = WallLight1; StoreName = FurnitureStore),
(XYZ = 465.20, 1.10, -1811.60; ItemName = WallLight2; StoreName = FurnitureStore),
(XYZ = 465.00, 1.10, -1813.60; ItemName = WallLight2; StoreName = FurnitureStore),
(XYZ = 466.80, 1.10, -1811.40; ItemName = WallLight2; StoreName = FurnitureStore),
(XYZ = 466.80, 1.10, -1813.60; ItemName = WallLight2; StoreName = FurnitureStore),
(XYZ = 477.64, 2.76, -1825.27; ItemName = LightBulb; StoreName = FurnitureStore),
(XYZ = 494.90, 4.20, -1823.10; ItemName = GlassDoor1; StoreName = FurnitureStore),
(XYZ = 495.30, 4.20, -1823.10; ItemName = GlassDoor1; StoreName = FurnitureStore),
(XYZ = 495.70, 4.18, -1823.10; ItemName = GlassDoor1; StoreName = FurnitureStore),
(XYZ = 498.90, 0.65, -1820.11; ItemName = GlassPane1; StoreName = FurnitureStore),
(XYZ = 499.29, 0.66, -1820.10; ItemName = GlassPane1; StoreName = FurnitureStore),
(XYZ = 499.63, 0.66, -1820.09; ItemName = GlassPane1; StoreName = FurnitureStore),
(XYZ = 500.10, 0.65, -1820.11; ItemName = GlassPane1; StoreName = FurnitureStore),
(XYZ = 500.89, 1.20, -1820.60; ItemName = GlassPane2; StoreName = FurnitureStore),
(XYZ = 501.68, 1.20, -1820.60; ItemName = GlassPane2; StoreName = FurnitureStore),
(XYZ = 502.09, 1.20, -1820.60; ItemName = GlassPane2; StoreName = FurnitureStore),
(XYZ = 501.30, 1.20, -1820.60; ItemName = GlassPane2; StoreName = FurnitureStore),
(XYZ = 503.32, 2.45, -1821.60; ItemName = GlassPane3; StoreName = FurnitureStore),
(XYZ = 504.10, 2.20, -1821.60; ItemName = GlassPane3; StoreName = FurnitureStore),
(XYZ = 503.38, 2.10, -1821.70; ItemName = GlassPane3; StoreName = FurnitureStore),
(XYZ = 504.27, 2.17, -1821.60; ItemName = GlassPane3; StoreName = FurnitureStore),
(XYZ = 504.92, 4.17, -1823.60; ItemName = GlassPane4; StoreName = FurnitureStore),
(XYZ = 505.29, 4.19, -1823.60; ItemName = GlassPane4; StoreName = FurnitureStore),
(XYZ = 505.69, 4.19, -1823.60; ItemName = GlassPane4; StoreName = FurnitureStore),
(XYZ = 506.29, 4.15, -1823.69; ItemName = GlassPane4; StoreName = FurnitureStore),
(XYZ = 551.83, 7.58, -1812.77; ItemName = Bed1; StoreName = FurnitureStore),
(XYZ = 551.83, 7.59, -1808.17; ItemName = Bed1; StoreName = FurnitureStore),
(XYZ = 551.83, 7.59, -1801.47; ItemName = Bed2; StoreName = FurnitureStore),
(XYZ = 551.81, 7.59, -1796.15; ItemName = Bed2; StoreName = FurnitureStore),
(XYZ = 551.83, 1.59, -1801.57; ItemName = Bed1; StoreName = FurnitureStore),
(XYZ = 551.83, 1.60, -1796.47; ItemName = Bed2; StoreName = FurnitureStore),
(XYZ = 549.83, 7.10, -1779.29; ItemName = Toilet; StoreName = FurnitureStore),
(XYZ = 549.43, 7.09, -1781.69; ItemName = Toilet; StoreName = FurnitureStore),
(XYZ = 552.43, 1.10, -1778.49; ItemName = Toilet; StoreName = FurnitureStore),
(XYZ = 549.43, 1.10, -1781.49; ItemName = Toilet; StoreName = FurnitureStore),
(XYZ = 549.63, 1.10, -1778.89; ItemName = Toilet; StoreName = FurnitureStore),
(XYZ = 552.43, 1.10, -1781.49; ItemName = Toilet; StoreName = FurnitureStore),
(XYZ = 551.63, 7.09, -1781.49; ItemName = Toilet; StoreName = FurnitureStore),
(XYZ = 553.63, 7.10, -1781.89; ItemName = Toilet; StoreName = FurnitureStore),
(XYZ = 551.83, 7.10, -1778.89; ItemName = Toilet; StoreName = FurnitureStore),
(XYZ = 549.80, 8.30, -1770.20; ItemName = Refridgerator; StoreName = FurnitureStore),
(XYZ = 553.66, 8.29, -1770.15; ItemName = Refridgerator; StoreName = FurnitureStore),
(XYZ = 553.70, 7.77, -1764.44; ItemName = Stove; StoreName = FurnitureStore),
(XYZ = 549.75, 7.77, -1763.72; ItemName = Stove; StoreName = FurnitureStore),
(XYZ = 549.40, 2.30, -1770.00; ItemName = Refridgerator; StoreName = FurnitureStore),
(XYZ = 549.21, 1.79, -1763.62; ItemName = Stove; StoreName = FurnitureStore),
(XYZ = 553.73, 2.30, -1769.94; ItemName = Refridgerator; StoreName = FurnitureStore),
(XYZ = 553.27, 1.77, -1764.15; ItemName = Stove; StoreName = FurnitureStore),
(XYZ = 552.43, 1.40, -1753.12; ItemName = Dishwasher; StoreName = FurnitureStore),
(XYZ = 548.40, 1.40, -1753.27; ItemName = Dishwasher; StoreName = FurnitureStore),
(XYZ = 553.43, 7.40, -1753.12; ItemName = Dishwasher; StoreName = FurnitureStore),
(XYZ = 549.40, 7.40, -1753.27; ItemName = Dishwasher; StoreName = FurnitureStore),
(XYZ = 535.30, 3.19, -1712.80; ItemName = CounterTop1Sink; StoreName = FurnitureStore),
(XYZ = 532.97, 3.19, -1712.62; ItemName = CounterTop1; StoreName = FurnitureStore),
(XYZ = 531.30, 3.19, -1712.80; ItemName = CounterTop1Thin; StoreName = FurnitureStore),
(XYZ = 529.30, 3.19, -1712.80; ItemName = Cabinet1CornerWide; StoreName = FurnitureStore),
(XYZ = 527.30, 3.18, -1712.80; ItemName = Cabinet1CornerTight; StoreName = FurnitureStore),
(XYZ = 525.30, 3.18, -1712.80; ItemName = Cabinet1; StoreName = FurnitureStore),
(XYZ = 523.31, 3.17, -1712.80; ItemName = Cabinet1Thin; StoreName = FurnitureStore),
(XYZ = 505.40, 1.09, -1766.69; ItemName = IcicleWireCandy; StoreName = FurnitureStore),
(XYZ = 505.39, 1.07, -1767.58; ItemName = IcicleWireCandy; StoreName = FurnitureStore),
(XYZ = 505.42, 1.07, -1768.57; ItemName = IcicleWireCandy; StoreName = FurnitureStore),
(XYZ = 505.50, 1.08, -1770.60; ItemName = IcicleWireHalloween; StoreName = FurnitureStore),
(XYZ = 505.50, 1.08, -1771.80; ItemName = IcicleWireHalloween; StoreName = FurnitureStore),
(XYZ = 505.50, 1.08, -1772.80; ItemName = IcicleWireHalloween; StoreName = FurnitureStore),
(XYZ = 506.50, 1.89, -1776.39; ItemName = IcicleWireAmber; StoreName = FurnitureStore),
(XYZ = 506.50, 1.90, -1777.19; ItemName = IcicleWireAmber; StoreName = FurnitureStore),
(XYZ = 506.50, 1.90, -1777.99; ItemName = IcicleWireAmber; StoreName = FurnitureStore),
(XYZ = 506.50, 1.90, -1778.79; ItemName = IcicleWireAmber; StoreName = FurnitureStore),
(XYZ = 506.50, 1.90, -1779.59; ItemName = IcicleWireAmber; StoreName = FurnitureStore),
(XYZ = 506.58, 1.88, -1780.22; ItemName = IcicleWireBlue; StoreName = FurnitureStore),
(XYZ = 506.50, 1.89, -1781.40; ItemName = IcicleWireBlue; StoreName = FurnitureStore),
(XYZ = 506.63, 1.89, -1782.57; ItemName = IcicleWireGreen; StoreName = FurnitureStore),
(XYZ = 506.50, 1.89, -1783.40; ItemName = IcicleWireGreen; StoreName = FurnitureStore),
(XYZ = 506.50, 1.89, -1784.40; ItemName = IcicleWireRed; StoreName = FurnitureStore),
(XYZ = 506.50, 1.89, -1785.20; ItemName = IcicleWireRed; StoreName = FurnitureStore),
(XYZ = 507.69, 1.19, -1790.51; ItemName = FireworkLauncher; StoreName = FurnitureStore),
(XYZ = 507.76, 1.19, -1793.82; ItemName = FireworkLauncher; StoreName = FurnitureStore),
(XYZ = 510.24, 1.19, -1790.00; ItemName = FireworkLauncher; StoreName = FurnitureStore),
(XYZ = 510.30, 1.19, -1794.73; ItemName = FireworkLauncher; StoreName = FurnitureStore),
(XYZ = 510.37, 1.20, -1792.29; ItemName = FireworkLauncher; StoreName = FurnitureStore),
(XYZ = 270.59, 8.20, -2528.80; ItemName = CanOfWorms; StoreName = ShackShop),
(XYZ = 258.32, 8.59, -2533.76; ItemName = Dynamite; StoreName = ShackShop),
(XYZ = 257.57, 8.59, -2535.93; ItemName = Dynamite; StoreName = ShackShop),
(XYZ = 4580.40, 6.70, -767.00; ItemName = NeonWireRed; StoreName = LogicShop),
(XYZ = 4580.40, 6.70, -767.60; ItemName = NeonWireRed; StoreName = LogicShop),
(XYZ = 4580.40, 6.70, -768.20; ItemName = NeonWireRed; StoreName = LogicShop),
(XYZ = 4580.40, 6.70, -768.80; ItemName = NeonWireRed; StoreName = LogicShop),
(XYZ = 4578.40, 6.70, -767.00; ItemName = NeonWireOrange; StoreName = LogicShop),
(XYZ = 4578.40, 6.70, -767.60; ItemName = NeonWireOrange; StoreName = LogicShop),
(XYZ = 4578.40, 6.70, -768.20; ItemName = NeonWireOrange; StoreName = LogicShop),
(XYZ = 4578.40, 6.70, -768.80; ItemName = NeonWireOrange; StoreName = LogicShop),
(XYZ = 4576.40, 6.70, -767.00; ItemName = NeonWireYellow; StoreName = LogicShop),
(XYZ = 4576.40, 6.70, -767.60; ItemName = NeonWireYellow; StoreName = LogicShop),
(XYZ = 4576.40, 6.70, -768.69; ItemName = NeonWireYellow; StoreName = LogicShop),
(XYZ = 4576.40, 6.70, -768.20; ItemName = NeonWireYellow; StoreName = LogicShop),
(XYZ = 4574.40, 6.70, -767.00; ItemName = NeonWireGreen; StoreName = LogicShop),
(XYZ = 4574.40, 6.70, -767.60; ItemName = NeonWireGreen; StoreName = LogicShop),
(XYZ = 4574.40, 6.70, -768.20; ItemName = NeonWireGreen; StoreName = LogicShop),
(XYZ = 4574.40, 6.70, -768.80; ItemName = NeonWireGreen; StoreName = LogicShop),
(XYZ = 4572.40, 6.70, -767.00; ItemName = NeonWireCyan; StoreName = LogicShop),
(XYZ = 4572.40, 6.70, -767.60; ItemName = NeonWireCyan; StoreName = LogicShop),
(XYZ = 4572.40, 6.70, -768.20; ItemName = NeonWireCyan; StoreName = LogicShop),
(XYZ = 4572.40, 6.70, -768.80; ItemName = NeonWireCyan; StoreName = LogicShop),
(XYZ = 4570.40, 6.70, -767.00; ItemName = NeonWireBlue; StoreName = LogicShop),
(XYZ = 4570.40, 6.70, -767.60; ItemName = NeonWireBlue; StoreName = LogicShop),
(XYZ = 4570.40, 6.70, -768.20; ItemName = NeonWireBlue; StoreName = LogicShop),
(XYZ = 4570.40, 6.70, -768.80; ItemName = NeonWireBlue; StoreName = LogicShop),
(XYZ = 4568.40, 6.70, -767.00; ItemName = NeonWireViolet; StoreName = LogicShop),
(XYZ = 4568.40, 6.70, -767.60; ItemName = NeonWireViolet; StoreName = LogicShop),
(XYZ = 4568.40, 6.70, -768.20; ItemName = NeonWireViolet; StoreName = LogicShop),
(XYZ = 4568.40, 6.70, -768.80; ItemName = NeonWireViolet; StoreName = LogicShop),
(XYZ = 4566.40, 6.70, -767.00; ItemName = NeonWireWhite; StoreName = LogicShop),
(XYZ = 4566.40, 6.70, -767.60; ItemName = NeonWireWhite; StoreName = LogicShop),
(XYZ = 4566.40, 6.70, -768.20; ItemName = NeonWireWhite; StoreName = LogicShop),
(XYZ = 4566.40, 6.70, -768.80; ItemName = NeonWireWhite; StoreName = LogicShop),
(XYZ = 4554.24, 6.90, -772.79; ItemName = GateNOT; StoreName = LogicShop),
(XYZ = 4554.24, 6.90, -778.79; ItemName = GateNOT; StoreName = LogicShop),
(XYZ = 4554.24, 6.90, -781.79; ItemName = GateNOT; StoreName = LogicShop),
(XYZ = 4554.24, 6.90, -775.79; ItemName = GateNOT; StoreName = LogicShop),
(XYZ = 4554.24, 6.89, -791.79; ItemName = GateAND; StoreName = LogicShop),
(XYZ = 4554.24, 6.90, -800.79; ItemName = GateAND; StoreName = LogicShop),
(XYZ = 4554.24, 6.90, -797.79; ItemName = GateAND; StoreName = LogicShop),
(XYZ = 4554.24, 6.90, -794.79; ItemName = GateAND; StoreName = LogicShop),
(XYZ = 4554.24, 6.90, -819.79; ItemName = GateOR; StoreName = LogicShop),
(XYZ = 4554.24, 6.90, -810.79; ItemName = GateOR; StoreName = LogicShop),
(XYZ = 4554.24, 6.90, -816.79; ItemName = GateOR; StoreName = LogicShop),
(XYZ = 4554.24, 6.90, -813.79; ItemName = GateOR; StoreName = LogicShop),
(XYZ = 4554.24, 6.90, -838.79; ItemName = GateXOR; StoreName = LogicShop),
(XYZ = 4554.24, 6.90, -829.79; ItemName = GateXOR; StoreName = LogicShop),
(XYZ = 4554.24, 6.90, -835.79; ItemName = GateXOR; StoreName = LogicShop),
(XYZ = 4554.24, 6.90, -832.79; ItemName = GateXOR; StoreName = LogicShop),
(XYZ = 4601.14, 6.90, -847.49; ItemName = WoodChecker; StoreName = LogicShop),
(XYZ = 4604.14, 6.90, -847.49; ItemName = WoodChecker; StoreName = LogicShop),
(XYZ = 4607.14, 6.90, -847.49; ItemName = WoodChecker; StoreName = LogicShop),
(XYZ = 4610.14, 6.90, -847.49; ItemName = WoodChecker; StoreName = LogicShop),
(XYZ = 4613.14, 6.90, -847.49; ItemName = WoodChecker; StoreName = LogicShop),
(XYZ = 4616.14, 6.90, -847.49; ItemName = WoodChecker; StoreName = LogicShop),
(XYZ = 4632.14, 6.90, -847.49; ItemName = Laser; StoreName = LogicShop),
(XYZ = 4647.54, 6.90, -847.49; ItemName = LaserReceiver; StoreName = LogicShop),
(XYZ = 4635.14, 6.89, -847.49; ItemName = Laser; StoreName = LogicShop),
(XYZ = 4644.54, 6.90, -847.49; ItemName = LaserReceiver; StoreName = LogicShop),
(XYZ = 4638.14, 6.89, -847.49; ItemName = Laser; StoreName = LogicShop),
(XYZ = 4641.54, 6.90, -847.49; ItemName = LaserReceiver; StoreName = LogicShop),
(XYZ = 4665.44, 6.89, -793.19; ItemName = Lever0; StoreName = LogicShop),
(XYZ = 4665.44, 6.89, -790.19; ItemName = Lever0; StoreName = LogicShop),
(XYZ = 4665.44, 6.89, -787.19; ItemName = Lever0; StoreName = LogicShop),
(XYZ = 4665.44, 6.90, -781.19; ItemName = Lever0; StoreName = LogicShop),
(XYZ = 4659.94, 6.89, -776.89; ItemName = Button0; StoreName = LogicShop),
(XYZ = 4662.94, 6.89, -776.89; ItemName = Button0; StoreName = LogicShop),
(XYZ = 4656.94, 6.89, -776.89; ItemName = Button0; StoreName = LogicShop),
(XYZ = 4653.94, 6.90, -776.89; ItemName = Button0; StoreName = LogicShop),
(XYZ = 4636.54, 6.69, -776.19; ItemName = Wire; StoreName = LogicShop),
(XYZ = 4636.54, 6.70, -776.79; ItemName = Wire; StoreName = LogicShop),
(XYZ = 4636.54, 6.70, -777.39; ItemName = Wire; StoreName = LogicShop),
(XYZ = 4634.54, 6.69, -776.19; ItemName = Wire; StoreName = LogicShop),
(XYZ = 4634.54, 6.70, -776.79; ItemName = Wire; StoreName = LogicShop),
(XYZ = 4634.55, 6.70, -777.39; ItemName = Wire; StoreName = LogicShop),
(XYZ = 4632.54, 6.69, -776.19; ItemName = Wire; StoreName = LogicShop),
(XYZ = 4632.54, 6.70, -776.79; ItemName = Wire; StoreName = LogicShop),
(XYZ = 4632.54, 6.70, -777.39; ItemName = Wire; StoreName = LogicShop),
(XYZ = 4597.94, 6.87, -819.29; ItemName = SignalSustain; StoreName = LogicShop),
(XYZ = 4594.94, 6.87, -819.29; ItemName = SignalSustain; StoreName = LogicShop),
(XYZ = 4591.94, 6.88, -819.29; ItemName = SignalSustain; StoreName = LogicShop),
(XYZ = 4588.94, 6.89, -819.29; ItemName = SignalSustain; StoreName = LogicShop),
(XYZ = 4585.94, 6.89, -819.29; ItemName = SignalSustain; StoreName = LogicShop),
(XYZ = 4582.94, 6.90, -815.09; ItemName = SignalDelay; StoreName = LogicShop),
(XYZ = 4582.94, 6.89, -819.29; ItemName = SignalSustain; StoreName = LogicShop),
(XYZ = 4585.94, 6.90, -815.09; ItemName = SignalDelay; StoreName = LogicShop),
(XYZ = 4597.94, 6.90, -815.09; ItemName = SignalDelay; StoreName = LogicShop),
(XYZ = 4594.94, 6.90, -815.09; ItemName = SignalDelay; StoreName = LogicShop),
(XYZ = 4591.94, 6.90, -815.09; ItemName = SignalDelay; StoreName = LogicShop),
(XYZ = 4585.09, 6.90, -847.49; ItemName = ClockSwitch; StoreName = LogicShop),
(XYZ = 4570.48, 6.90, -847.49; ItemName = ClockSwitch; StoreName = LogicShop),
(XYZ = 4582.08, 6.90, -847.49; ItemName = ClockSwitch; StoreName = LogicShop),
(XYZ = 4573.28, 6.90, -847.49; ItemName = ClockSwitch; StoreName = LogicShop),
(XYZ = 4579.08, 6.90, -847.49; ItemName = ClockSwitch; StoreName = LogicShop),
(XYZ = 4576.08, 6.90, -847.49; ItemName = ClockSwitch; StoreName = LogicShop),
(XYZ = 4665.44, 6.90, -838.19; ItemName = PressurePlate; StoreName = LogicShop),
(XYZ = 4665.44, 6.90, -823.19; ItemName = PressurePlate; StoreName = LogicShop),
(XYZ = 4665.44, 6.90, -826.19; ItemName = PressurePlate; StoreName = LogicShop),
(XYZ = 4665.44, 6.90, -835.19; ItemName = PressurePlate; StoreName = LogicShop),
(XYZ = 4665.44, 6.90, -829.19; ItemName = PressurePlate; StoreName = LogicShop),
(XYZ = 4665.44, 6.90, -832.19; ItemName = PressurePlate; StoreName = LogicShop),
(XYZ = 4637.85, 6.90, -804.39; ItemName = Hatch; StoreName = LogicShop),
(XYZ = 4637.84, 6.89, -819.39; ItemName = Hatch; StoreName = LogicShop),
(XYZ = 4637.84, 6.89, -807.39; ItemName = Hatch; StoreName = LogicShop),
(XYZ = 4637.84, 6.90, -816.39; ItemName = Hatch; StoreName = LogicShop),
(XYZ = 4637.84, 6.89, -810.39; ItemName = Hatch; StoreName = LogicShop),
(XYZ = 4637.84, 6.90, -813.39; ItemName = Hatch; StoreName = LogicShop),
(XYZ = 4588.94, 6.90, -815.09; ItemName = SignalDelay; StoreName = LogicShop),
(XYZ = 5264.40, -167.80, 744.80; ItemName = Painting3; StoreName = FineArt),
(XYZ = 5263.41, -166.50, 745.70; ItemName = Painting2; StoreName = FineArt),
(XYZ = 5261.59, -166.11, 747.20; ItemName = Painting6; StoreName = FineArt),
(XYZ = 5259.60, -167.70, 749.45; ItemName = Painting8; StoreName = FineArt),
(XYZ = 5252.75, -165.78, 744.80; ItemName = Painting7; StoreName = FineArt),
(XYZ = 5250.00, -167.00, 747.20; ItemName = Painting9; StoreName = FineArt),
(XYZ = 5251.80, -165.70, 749.59; ItemName = Painting1; StoreName = FineArt)
]]

-- Функция для парсинга данных
local function ParseShopItems(data)
    local items = {}
    for line in data:gmatch("[^\r\n]+") do
        if line:find("XYZ =") then
            local x, y, z, itemName, storeName = line:match("XYZ =%s*(.-),%s*(.-),%s*(.-);%s*ItemName =%s*(.-);%s*StoreName =%s*(.-)%)")
            if x and y and z and itemName and storeName then
                table.insert(items, {
                    position = Vector3.new(tonumber(x), tonumber(y), tonumber(z)),
                    itemName = itemName,
                    storeName = storeName:gsub(",$", "")
                })
            end
        end
    end
    return items
end

-- Функция для создания экземпляров с свойствами
local function Create(instanceType, properties)
    local instance = Instance.new(instanceType)
    for property, value in pairs(properties) do
        instance[property] = value
    end
    return instance
end

-- Парсим данные (если они есть)
local ShopItems = {}
if ShopItemsData and ShopItemsData ~= "" then
    ShopItems = ParseShopItems(ShopItemsData)
end

-- ID магазинов
local storeIDs = {
    WoodRUs = -1,
    CarStore = -1,
    FurnitureStore = -1,
    ShackShop = -1,
    LogicStore = -1,
    FineArt = -1
}

-- Функции телепортации
local ClientIsDragging = ReplicatedStorage:WaitForChild("Interaction"):WaitForChild("ClientIsDragging")

local function instantTeleportItem(item, targetPos)
    if not item or not item.Parent then return false end
    
    local mainPart = item:FindFirstChild("Main") or item:FindFirstChildWhichIsA("BasePart")
    if not mainPart then return false end

    for i = 1, 3 do
        ClientIsDragging:FireServer(item)
        mainPart.CFrame = CFrame.new(targetPos)
        task.wait(0.1)
    end

    return true
end

local function smoothTeleportItem(item, targetPos)
    if not item or not item.Parent then return false end
    
    local mainPart = item:FindFirstChild("Main") or item:FindFirstChildWhichIsA("BasePart")
    if not mainPart then return false end

    ClientIsDragging:FireServer(item)
    task.wait(0.1)

    local tweenInfo = TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(mainPart, tweenInfo, {CFrame = CFrame.new(targetPos)})

    local connection
    connection = RunService.Heartbeat:Connect(function()
        ClientIsDragging:FireServer(item)
    end)

    tween:Play()
    tween.Completed:Wait()
    connection:Disconnect()

    if item.Parent then
        mainPart.CFrame = CFrame.new(targetPos)
        ClientIsDragging:FireServer(item)
    end

    return true
end

-- Создаем основной GUI
local function CreateMainGUI()
    -- Удаляем старый GUI если существует
    local coreGui = game:GetService("CoreGui")
    local playerGui = Player:WaitForChild("PlayerGui")
    
    if coreGui:FindFirstChild("AutoBuyGUI") then coreGui.AutoBuyGUI:Destroy() end
    if playerGui:FindFirstChild("AutoBuyGUI") then playerGui.AutoBuyGUI:Destroy() end

    -- Создаем ScreenGui
    local ScreenGui = Create("ScreenGui", {
        Name = "AutoBuyGUI",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        ResetOnSpawn = false
    })

    -- Пытаемся разместить в CoreGui, если не получится - в PlayerGui
    local success, _ = pcall(function() ScreenGui.Parent = coreGui end)
    if not success then ScreenGui.Parent = playerGui end

    -- Основной фрейм
    local MainFrame = Create("Frame", {
        Size = UDim2.new(0, 300, 0, 350),
        Position = UDim2.new(0.5, -150, 0.5, -175),
        BackgroundColor3 = Color3.fromRGB(45, 45, 55),
        BackgroundTransparency = 0.15,
        Active = true,
        Draggable = true,
        Parent = ScreenGui
    })

    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = MainFrame})

    -- Заголовок
    Create("TextLabel", {
        Text = "Auto Buy",
        Font = Enum.Font.SourceSansBold,
        TextSize = 18,
        TextColor3 = Color3.new(1, 1, 1),
        Size = UDim2.new(1, -10, 0, 30),
        Position = UDim2.new(0, 5, 0, 5),
        BackgroundTransparency = 1,
        Parent = MainFrame
    })

    -- Кнопка выбора магазина
    local StoreSelection = Create("TextButton", {
        Name = "StoreSelection",
        Text = "Выберите магазин",
        Font = Enum.Font.SourceSansSemibold,
        TextSize = 16,
        TextColor3 = Color3.new(1, 1, 1),
        Size = UDim2.new(0.9, 0, 0, 35),
        Position = UDim2.new(0.05, 0, 0.1, 0),
        BackgroundColor3 = Color3.fromRGB(70, 120, 200),
        AutoButtonColor = true,
        Parent = MainFrame
    })

    Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = StoreSelection})

    -- Кнопка выбора предмета
    local ItemSelection = Create("TextButton", {
        Name = "ItemSelection",
        Text = "Выберите предмет",
        Font = Enum.Font.SourceSansSemibold,
        TextSize = 16,
        TextColor3 = Color3.new(1, 1, 1),
        Size = UDim2.new(0.9, 0, 0, 35),
        Position = UDim2.new(0.05, 0, 0.25, 0),
        BackgroundColor3 = Color3.fromRGB(70, 120, 200),
        AutoButtonColor = true,
        Parent = MainFrame
    })

    Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = ItemSelection})

    -- Поле ввода количества
    local QuantityInput = Create("TextBox", {
        Name = "QuantityInput",
        Text = "1",
        Font = Enum.Font.SourceSans,
        TextSize = 16,
        TextColor3 = Color3.new(0, 0, 0),
        Size = UDim2.new(0.9, 0, 0, 30),
        Position = UDim2.new(0.05, 0, 0.4, 0),
        BackgroundColor3 = Color3.new(1, 1, 1),
        PlaceholderText = "Количество",
        Parent = MainFrame
    })

    Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = QuantityInput})

    -- Кнопка начала покупки
    local StartButton = Create("TextButton", {
        Name = "StartButton",
        Text = "Начать покупку",
        Font = Enum.Font.SourceSansSemibold,
        TextSize = 16,
        TextColor3 = Color3.new(1, 1, 1),
        Size = UDim2.new(0.9, 0, 0, 35),
        Position = UDim2.new(0.05, 0, 0.55, 0),
        BackgroundColor3 = Color3.fromRGB(80, 160, 90),
        AutoButtonColor = true,
        Parent = MainFrame
    })

    Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = StartButton})

    -- Кнопка остановки
    local StopButton = Create("TextButton", {
        Name = "StopButton",
        Text = "Остановить",
        Font = Enum.Font.SourceSansSemibold,
        TextSize = 16,
        TextColor3 = Color3.new(1, 1, 1),
        Size = UDim2.new(0.9, 0, 0, 35),
        Position = UDim2.new(0.05, 0, 0.7, 0),
        BackgroundColor3 = Color3.fromRGB(200, 80, 80),
        AutoButtonColor = true,
        Parent = MainFrame
    })

    Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = StopButton})

    -- Статус
    local StatusLabel = Create("TextLabel", {
        Name = "StatusLabel",
        Text = "Готов к работе",
        Font = Enum.Font.SourceSans,
        TextSize = 14,
        TextColor3 = Color3.new(0.9, 0.9, 0.9),
        Size = UDim2.new(0.9, 0, 0, 20),
        Position = UDim2.new(0.05, 0, 0.85, 0),
        BackgroundTransparency = 1,
        Parent = MainFrame
    })

    -- Прогресс
    local ProgressLabel = Create("TextLabel", {
        Name = "ProgressLabel",
        Text = "Куплено: 0/0",
        Font = Enum.Font.SourceSans,
        TextSize = 14,
        TextColor3 = Color3.new(0.9, 0.9, 0.9),
        Size = UDim2.new(0.9, 0, 0, 20),
        Position = UDim2.new(0.05, 0, 0.9, 0),
        BackgroundTransparency = 1,
        Parent = MainFrame
    })

    -- Список магазинов (изначально скрыт)
    local StoreList = Create("ScrollingFrame", {
        Name = "StoreList",
        Size = UDim2.new(0.9, 0, 0, 0),
        Position = UDim2.new(0.05, 0, 0.1, 35),
        BackgroundColor3 = Color3.fromRGB(60, 60, 70),
        ScrollBarThickness = 5,
        Visible = false,
        Parent = MainFrame
    })

    Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = StoreList})

    -- Список предметов (изначально скрыт)
    local ItemList = Create("ScrollingFrame", {
        Name = "ItemList",
        Size = UDim2.new(0.9, 0, 0, 0),
        Position = UDim2.new(0.05, 0, 0.25, 35),
        BackgroundColor3 = Color3.fromRGB(60, 60, 70),
        ScrollBarThickness = 5,
        Visible = false,
        Parent = MainFrame
    })

    Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = ItemList})

    -- UIListLayout для списков
    local function CreateListLayout(parent)
        Create("UIListLayout", {
            Padding = UDim.new(0, 5),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = parent
        })
        
        Create("UIPadding", {
            PaddingTop = UDim.new(0, 5),
            PaddingLeft = UDim.new(0, 5),
            PaddingRight = UDim.new(0, 5),
            Parent = parent
        })
    end

    CreateListLayout(StoreList)
    CreateListLayout(ItemList)

    return {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        StoreSelection = StoreSelection,
        ItemSelection = ItemSelection,
        QuantityInput = QuantityInput,
        StartButton = StartButton,
        StopButton = StopButton,
        StatusLabel = StatusLabel,
        ProgressLabel = ProgressLabel,
        StoreList = StoreList,
        ItemList = ItemList
    }
end

-- Создаем маркеры для предметов
local function CreateItemMarkers(items)
    local autobuyFolder = Create("Folder", {
        Name = "autobuy",
        Parent = Workspace
    })

    local itemMarkers = {}
    
    for i, item in ipairs(items) do
        local itemName = item.itemName
        local storeName = item.storeName
        local position = item.position
        
        local markerKey = itemName .. "_" .. storeName .. "_" .. i
        
        local marker = Create("Part", {
            Name = markerKey,
            Position = position,
            Size = Vector3.new(0.2, 0.2, 0.2),
            Shape = Enum.PartType.Ball,
            Anchored = true,
            CanCollide = false,
            Transparency = 0.7,
            Color = Color3.fromRGB(0, 255, 0),
            Parent = Create("Folder", {
                Name = itemName,
                Parent = autobuyFolder
            })
        })
        
        itemMarkers[markerKey] = {
            marker = marker,
            storeName = storeName,
            position = position,
            itemName = itemName
        }
    end
    
    return itemMarkers
end

-- Переменные состояния
local selectedStore = nil
local selectedItem = nil
local isBuying = false
local stopRequested = false
local purchasedCount = 0
local totalToPurchase = 0

-- Функции обновления интерфейса
local function updateStatus(text, color)
    GUI.StatusLabel.Text = text
    GUI.StatusLabel.TextColor3 = color or Color3.new(0.9, 0.9, 0.9)
end

local function updateProgress()
    GUI.ProgressLabel.Text = string.format("Куплено: %d/%d", purchasedCount, totalToPurchase)
end

local function toggleStoreList(show)
    if show then
        GUI.StoreList.Visible = true
        local tween = TweenService:Create(
            GUI.StoreList,
            TweenInfo.new(0.3),
            {Size = UDim2.new(0.9, 0, 0, math.min(200, GUI.StoreList.AbsoluteContentSize.Y)}
        )
        tween:Play()
    else
        local tween = TweenService:Create(
            GUI.StoreList,
            TweenInfo.new(0.3),
            {Size = UDim2.new(0.9, 0, 0, 0)}
        )
        tween.Completed:Connect(function()
            GUI.StoreList.Visible = false
        end)
        tween:Play()
    end
end

local function toggleItemList(show)
    if show then
        GUI.ItemList.Visible = true
        local tween = TweenService:Create(
            GUI.ItemList,
            TweenInfo.new(0.3),
            {Size = UDim2.new(0.9, 0, 0, math.min(200, GUI.ItemList.AbsoluteContentSize.Y)}
        )
        tween:Play()
    else
        local tween = TweenService:Create(
            GUI.ItemList,
            TweenInfo.new(0.3),
            {Size = UDim2.new(0.9, 0, 0, 0)}
        )
        tween.Completed:Connect(function()
            GUI.ItemList.Visible = false
        end)
        tween:Play()
    end
end

-- Заполнение списка магазинов
local function populateStoreList()
    GUI.StoreList:ClearAllChildren()
    
    local stores = {}
    for _, data in pairs(ItemMarkers) do
        if not table.find(stores, data.storeName) then
            table.insert(stores, data.storeName)
        end
    end
    
    table.sort(stores)
    
    local allButton = Create("TextButton", {
        Text = "Все магазины",
        Size = UDim2.new(1, -10, 0, 30),
        Position = UDim2.new(0, 5, 0, 5),
        BackgroundColor3 = Color3.fromRGB(80, 80, 100),
        Parent = GUI.StoreList
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = allButton})
    
    allButton.MouseButton1Click:Connect(function()
        selectedStore = "All"
        GUI.StoreSelection.Text = "Все магазины"
        toggleStoreList(false)
    end)
    
    local yOffset = 40
    for _, storeName in ipairs(stores) do
        local button = Create("TextButton", {
            Text = storeName,
            Size = UDim2.new(1, -10, 0, 30),
            Position = UDim2.new(0, 5, 0, yOffset),
            BackgroundColor3 = Color3.fromRGB(80, 80, 100),
            Parent = GUI.StoreList
        })
        
        Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = button})
        
        button.MouseButton1Click:Connect(function()
            selectedStore = storeName
            GUI.StoreSelection.Text = storeName
            toggleStoreList(false)
        end)
        
        yOffset = yOffset + 35
    end
    
    GUI.StoreList.CanvasSize = UDim2.new(0, 0, 0, yOffset + 5)
end

-- Заполнение списка предметов
local function populateItemList()
    GUI.ItemList:ClearAllChildren()
    
    if not selectedStore then return end
    
    local items = {}
    for _, data in pairs(ItemMarkers) do
        if (selectedStore == "All" or data.storeName == selectedStore) and not table.find(items, data.itemName) then
            table.insert(items, data.itemName)
        end
    end
    
    table.sort(items)
    
    local yOffset = 5
    for _, itemName in ipairs(items) do
        local button = Create("TextButton", {
            Text = itemName,
            Size = UDim2.new(1, -10, 0, 30),
            Position = UDim2.new(0, 5, 0, yOffset),
            BackgroundColor3 = Color3.fromRGB(80, 80, 100),
            Parent = GUI.ItemList
        })
        
        Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = button})
        
        button.MouseButton1Click:Connect(function()
            selectedItem = itemName
            GUI.ItemSelection.Text = itemName
            toggleItemList(false)
        end)
        
        yOffset = yOffset + 35
    end
    
    GUI.ItemList.CanvasSize = UDim2.new(0, 0, 0, yOffset + 5)
end

-- Функции для покупки
local function getCounterPosition(storeName)
    local counters = {
        WoodRUs = Workspace.Stores.WoodRUs.Counter,
        CarStore = Workspace.Stores.CarStore.Counter,
        FurnitureStore = Workspace.Stores.FurnitureStore.Counter,
        ShackShop = Workspace.Stores.ShackShop.Counter,
        LogicStore = Workspace.Stores.LogicStore.Counter,
        FineArt = Workspace.Stores.FineArt.Counter
    }
    
    return counters[storeName] and counters[storeName].Position + Vector3.new(0, 3, 0)
end

local function getPurchaseFunction(storeName)
    local npcData = {
        WoodRUs = {
            Character = Workspace:WaitForChild("Stores"):WaitForChild("WoodRUs"):WaitForChild("Thom"),
            Name = "Thom",
            Dialog = Workspace:WaitForChild("Stores"):WaitForChild("WoodRUs"):WaitForChild("Thom"):WaitForChild("Dialog")
        },
        CarStore = {
            Character = Workspace:WaitForChild("Stores"):WaitForChild("CarStore"):WaitForChild("Jenny"),
            Name = "Jenny",
            Dialog = Workspace:WaitForChild("Stores"):WaitForChild("CarStore"):WaitForChild("Jenny"):WaitForChild("Dialog")
        },
        FurnitureStore = {
            Character = Workspace:WaitForChild("Stores"):WaitForChild("FurnitureStore"):WaitForChild("Corey"),
            Name = "Corey",
            Dialog = Workspace:WaitForChild("Stores"):WaitForChild("FurnitureStore"):WaitForChild("Corey"):WaitForChild("Dialog")
        },
        ShackShop = {
            Character = Workspace:WaitForChild("Stores"):WaitForChild("ShackShop"):WaitForChild("Bob"),
            Name = "Bob",
            Dialog = Workspace:WaitForChild("Stores"):WaitForChild("ShackShop"):WaitForChild("Bob"):WaitForChild("Dialog")
        },
        LogicStore = {
            Character = Workspace:WaitForChild("Stores"):WaitForChild("LogicStore"):WaitForChild("Lincoln"),
            Name = "Lincoln",
            Dialog = Workspace:WaitForChild("Stores"):WaitForChild("LogicStore"):WaitForChild("Lincoln"):WaitForChild("Dialog")
        },
        FineArt = {
            Character = Workspace:WaitForChild("Stores"):WaitForChild("FineArt"):WaitForChild("Timothy"),
            Name = "Timothy",
            Dialog = Workspace:WaitForChild("Stores"):WaitForChild("FineArt"):WaitForChild("Timothy"):WaitForChild("Dialog")
        }
    }
    
    return function(id)
        local args = {
            [1] = {
                ID = id,
                Character = npcData[storeName].Character,
                Name = npcData[storeName].Name,
                Dialog = npcData[storeName].Dialog
            },
            [2] = "ConfirmPurchase"
        }
        ReplicatedStorage:WaitForChild("NPCDialog"):WaitForChild("PlayerChatted"):InvokeServer(unpack(args))
    end
end

local function findItemInStore(itemName, storeName)
    for _, data in pairs(ItemMarkers) do
        if data.itemName == itemName and (storeName == "All" or data.storeName == storeName) then
            local parts = Workspace:GetPartsInPart(data.marker)
            for _, part in ipairs(parts) do
                local model = part:FindFirstAncestorOfClass("Model")
                if model and (model:FindFirstChild("Main") or model:IsA("BasePart")) then
                    return model
                end
            end
        end
    end
    return nil
end

local function findPurchasedBox()
    local playerName = Player.Name
    for _, child in ipairs(Workspace.PlayerModels:GetChildren()) do
        if child.Name == "Box Purchased by "..playerName then
            return child
        end
    end
    return nil
end

local function renamePurchasedBoxes()
    local playerName = Player.Name
    local count = 1
    for _, child in ipairs(Workspace.PlayerModels:GetChildren()) do
        if child.Name == "Box Purchased by "..playerName then
            child.Name = tostring(count)
            count = count + 1
        end
    end
end

local function findStoreForItem(itemName)
    for _, data in pairs(ItemMarkers) do
        if data.itemName == itemName then
            return data.storeName
        end
    end
    return nil
end

local function getStoreID(storeName)
    if storeIDs[storeName] ~= -1 then
        return storeIDs[storeName]
    end
    
    updateStatus("Подбираем ID для "..storeName, Color3.fromRGB(255, 255, 150))
    
    local purchaseFunc = getPurchaseFunction(storeName)
    local currentID = 0
    
    while not stopRequested do
        currentID = currentID + 1
        purchaseFunc(currentID)
        task.wait(0.5)
        
        local box = findPurchasedBox()
        if box then
            storeIDs[storeName] = currentID
            renamePurchasedBoxes()
            updateStatus("Найден ID: "..currentID, Color3.fromRGB(150, 255, 150))
            return currentID
        end
    end
    
    return nil
end

-- Основная функция покупки
local function buyItem(itemName, storeName)
    if stopRequested then return false end
    
    local char = Player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then
        updateStatus("Персонаж не найден", Color3.fromRGB(255, 100, 100))
        return false
    end
    
    local savedPosition = char.HumanoidRootPart.Position
    renamePurchasedBoxes()
    
    local item = findItemInStore(itemName, storeName)
    if not item then
        updateStatus("Предмет не найден: "..itemName, Color3.fromRGB(255, 100, 100))
        return false
    end
    
    local actualStoreName = storeName
    if storeName == "All" then
        actualStoreName = findStoreForItem(itemName)
        if not actualStoreName then
            updateStatus("Не удалось определить магазин", Color3.fromRGB(255, 100, 100))
            return false
        end
    end
    
    local counterPos = getCounterPosition(actualStoreName)
    if not counterPos then
        updateStatus("Не найдена стойка для "..actualStoreName, Color3.fromRGB(255, 100, 100))
        return false
    end
    
    local itemPos = item:FindFirstChild("Main") and item.Main.Position or item.Position
    char.HumanoidRootPart.CFrame = CFrame.new(itemPos + Vector3.new(0, 3, 0))
    task.wait(0.5)
    
    if not smoothTeleportItem(item, counterPos) then
        updateStatus("Ошибка телепортации", Color3.fromRGB(255, 100, 100))
        return false
    end
    task.wait(0.5)
    
    char.HumanoidRootPart.CFrame = CFrame.new(counterPos + Vector3.new(0, 3, 0))
    task.wait(0.5)
    
    local storeID = getStoreID(actualStoreName)
    if not storeID then
        updateStatus("Не удалось получить ID", Color3.fromRGB(255, 100, 100))
        return false
    end
    
    local purchaseFunc = getPurchaseFunction(actualStoreName)
    purchaseFunc(storeID)
    task.wait(1)
    
    local box = findPurchasedBox()
    if not box then
        updateStatus("Не удалось найти купленный предмет", Color3.fromRGB(255, 100, 100))
        return false
    end
    
    if not smoothTeleportItem(box, savedPosition + Vector3.new(0, 3, 0)) then
        updateStatus("Ошибка телепортации ящика", Color3.fromRGB(255, 100, 100))
        return false
    end
    
    renamePurchasedBoxes()
    return true
end

-- Обработчики кнопок
GUI.StoreSelection.MouseButton1Click:Connect(function()
    if GUI.StoreList.Visible then
        toggleStoreList(false)
    else
        populateStoreList()
        toggleStoreList(true)
        if GUI.ItemList.Visible then
            toggleItemList(false)
        end
    end
end)

GUI.ItemSelection.MouseButton1Click:Connect(function()
    if not selectedStore then
        updateStatus("Сначала выберите магазин", Color3.fromRGB(255, 100, 100))
        return
    end
    
    if GUI.ItemList.Visible then
        toggleItemList(false)
    else
        populateItemList()
        toggleItemList(true)
        if GUI.StoreList.Visible then
            toggleStoreList(false)
        end
    end
end)

GUI.StartButton.MouseButton1Click:Connect(function()
    if isBuying then return end
    
    if not selectedItem then
        updateStatus("Выберите предмет", Color3.fromRGB(255, 100, 100))
        return
    end
    
    local quantity = tonumber(GUI.QuantityInput.Text) or 1
    if quantity <= 0 then
        updateStatus("Неверное количество", Color3.fromRGB(255, 100, 100))
        return
    end
    
    isBuying = true
    stopRequested = false
    purchasedCount = 0
    totalToPurchase = quantity
    updateProgress()
    
    coroutine.wrap(function()
        for i = 1, quantity do
            if stopRequested then break end
            
            updateStatus(string.format("Покупка %d/%d...", i, quantity), Color3.fromRGB(255, 255, 150))
            
            if buyItem(selectedItem, selectedStore or "All") then
                purchasedCount = purchasedCount + 1
                updateProgress()
            else
                break
            end
            
            task.wait(1)
        end
        
        isBuying = false
        if not stopRequested then
            updateStatus("Покупка завершена", Color3.fromRGB(150, 255, 150))
        else
            updateStatus("Покупка остановлена", Color3.fromRGB(255, 150, 0))
        end
    end)()
end)

GUI.StopButton.MouseButton1Click:Connect(function()
    if isBuying then
        stopRequested = true
    end
end)

-- Поддержка мобильных устройств
UserInputService.TouchStarted:Connect(function(touch, gameProcessed)
    if gameProcessed then return end
    
    local touchPos = touch.Position
    local storeAbsPos = GUI.StoreSelection.AbsolutePosition
    local storeAbsSize = GUI.StoreSelection.AbsoluteSize
    
    if touchPos.X >= storeAbsPos.X and touchPos.X <= storeAbsPos.X + storeAbsSize.X and
       touchPos.Y >= storeAbsPos.Y and touchPos.Y <= storeAbsPos.Y + storeAbsSize.Y then
        GUI.StoreSelection.MouseButton1Click:Fire()
    end
    
    local itemAbsPos = GUI.ItemSelection.AbsolutePosition
    local itemAbsSize = GUI.ItemSelection.AbsoluteSize
    
    if touchPos.X >= itemAbsPos.X and touchPos.X <= itemAbsPos.X + itemAbsSize.X and
       touchPos.Y >= itemAbsPos.Y and touchPos.Y <= itemAbsPos.Y + itemAbsSize.Y then
        GUI.ItemSelection.MouseButton1Click:Fire()
    end
end)

-- Основная функция инициализации
local function Initialize()
    -- Создаем GUI
    GUI = CreateMainGUI()
    
    -- Создаем маркеры предметов
    ItemMarkers = CreateItemMarkers(ShopItems)
    
    -- Инициализация интерфейса
    updateStatus("Готов к работе")
    updateProgress()
    
    print("AutoBuy system initialized successfully!")
    
    -- Функция для тестирования из консоли
    _G.ToggleAutoBuyGUI = function()
        GUI.ScreenGui.Enabled = not GUI.ScreenGui.Enabled
    end
end

-- Запускаем инициализацию
local success, err = pcall(Initialize)
if not success then
    warn("Ошибка инициализации AutoBuy: " .. tostring(err))
end

-- Очистка при выходе
Player.CharacterRemoving:Connect(function()
    if GUI and GUI.ScreenGui then
        GUI.ScreenGui:Destroy()
    end
    if ItemMarkers then
        for _, marker in pairs(ItemMarkers) do
            marker.marker:Destroy()
        end
    end
end)
