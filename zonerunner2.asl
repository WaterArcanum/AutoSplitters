// Zone Runner 2 Auto Spliter.
// Author: Arko
// Contact: speedrun.com/user/WaterArko | github.com/WaterArcanum

state("zonerunner2")
{
    int stateID : 0x0045070
}

startup
{
    var Zone1States = Enumerable.Range(4, 10); // 4–13
    var Zone2States = Enumerable.Range(16, 10); // 16–25
    var Zone3States = Enumerable.Range(32, 10); // 32–41
    vars.LevelStates = Zone1States.Union(Zone2States).Union(Zone3States).ToArray(); // Put every level ID in one array
    vars.ZoneLastLevelStates = new int[] {13, 25, 41};

    settings.Add("split_all", true, "Split every level");
    settings.SetToolTip("split_all", "When disabled, splits occur only on zone transitions.");

    settings.Add("reset_on_death", false, "Reset on death");
    settings.SetToolTip("reset_on_death", "When enabled, the timer resets whenever you die.");

    vars.Zone1StartScreen = 3;
    vars.GameOverScreen = 2;
    vars.TitleScreen = 0;
}

start
{
    return current.stateID == vars.Zone1StartScreen;
}

split
{
    // If the stateID value changes…
    if(current.stateID != old.stateID) {
        // … determine whether to split on each level or zone…
        int[] stateArray = settings["split_all"] ? vars.LevelStates : vars.ZoneLastLevelStates;
        // … and split if the previous stateID was a level or zone respectively.
        if(Array.Exists(stateArray, x => x == old.stateID))
        {
            if(current.stateID == vars.GameOverScreen) return; // Do not split on death.
            return true;
        }
    }
}

reset
{
    return current.stateID == vars.TitleScreen || (current.stateID == vars.GameOverScreen && settings["reset_on_death"]);
}

