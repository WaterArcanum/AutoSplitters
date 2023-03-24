// Zone Runner Anniversary Edition Auto Spliter.
// Author: Arko
// Contact: speedrun.com/user/WaterArko | github.com/WaterArcanum

state("Zone Runner - Anniversary Edition")
{
    // Best pointer path I could find.
    int stateID : "mmf2d3d9.dll", 0x001125B8, 0x0, 0x8, 0xE4, 0x0, 0x8, 0x1D8, 0x9B0;
}

startup
{
    // The first zone is a nice little range, the rest is absolute chaos.
    var Zone1States = Enumerable.Range(2, 10); // 2–11
    var Zone2States = new int[] {14, 12, 15, 17, 18, 19, 20, 21, 1, 22};
    var Zone3States = new int[] {23, 26, 29, 30, 16, 27, 31, 34, 32, 33};
    var Zone4States = new int[] {39, 40, 42, 49, 50, 51, 52, 53, 41, 43, 37};
    var Zone5States = new int[] {68, 60, 71, 63, 69, 70, 72, 62, 73, 74};
    vars.LevelStates =  Zone1States.Union(Zone2States).Union(Zone3States)
                            .Union(Zone4States).Union(Zone5States).ToArray(); // Put every level ID in one array
    vars.ZoneLastLevelStates = new int[] {11, 22, 33, 43, 74};

    // Unused vars:
    // vars.ZoneWinStates = new int[] {67, 66, 65, 82, 58};
    // vars.ZoneStartStates = new int[] {0, 13, 38, 24, 61};
    // vars.CreditsScreen = 84;
    
    vars.Zone1StartScreen = 0;
    vars.GameOverScreen = 47;
    vars.TitleScreen = 45;
    vars.Zone1LevelSelectScreen = 75;

    settings.Add("split_all", true, "Split every level");
    settings.SetToolTip("split_all", "When disabled, splits occur only on zone transitions.");

    settings.Add("reset_on_gameover", true, "Reset on Game Over");
    settings.SetToolTip("reset_on_gameover", "When enabled, the timer resets whenever your run ends.");
}

start
{
    // This won't work if you're on an empty save, as you are entering from the Title Screen.
    // Having that check would however cause the timer to start whenever you close the game or the value is cleared otherwise.
    return current.stateID == vars.Zone1StartScreen && old.stateID == vars.Zone1LevelSelectScreen;
}

split
{
    // If the stateID value changes…
    if(current.stateID != old.stateID) {
        // … determine whether to split on each level or zone…
        int[] stateArray = settings["split_all"] ? vars.LevelStates : vars.ZoneLastLevelStates;
        // … and split if the previous stateID was a level or zone respectively.
        if(Array.Exists(stateArray, x => x == old.stateID)) {
            if(current.stateID == vars.GameOverScreen) return; // Do not split on death.
            return true;
        }
    }
}

reset
{
    if(settings["reset_on_gameover"])
        return current.stateID == vars.TitleScreen current.stateID == vars.GameOverScreen;
}