package  
{
	/**
     * ...
     * @author seaga
     */
    public class Achievements 
    {
        import com.newgrounds.*;
        public function Achievements() 
        {
            
        }
        //Called once when visiting the world map.
        public static function unlock():void {
            /** Kong high scsores etc **/
            /*
            if (Registry.boxesOpened[0] == true) QuickKong.stats.submit("UnlockedJukebox", 1);
            if (Registry.boxesOpened[1] == true) QuickKong.stats.submit("UnlockedSpinnyJump", 1);
            if (Registry.boxesOpened[2] == true) QuickKong.stats.submit("UnlockedLongTrail", 1);
            if (Registry.boxesOpened[3] == true) QuickKong.stats.submit("UnlockedGlitchyTileset", 1);
            if (Registry.boxesOpened[4] == true) QuickKong.stats.submit("UnlockedOldSprite", 1);
            if (Registry.boxesOpened[5] == true) QuickKong.stats.submit("UnlockedExtraStages", 1);
            if (Registry.boxesOpened[6] == true) QuickKong.stats.submit("UnlockedEverything", 1);
            if (Registry.cutscenesWatched[1] == true) QuickKong.stats.submit("FinishedFirstWorld", 1);
            if (Registry.cutscenesWatched[2] == true) QuickKong.stats.submit("FinishedSecondWorld", 1);
            if (Registry.cutscenesWatched[3] == true) QuickKong.stats.submit("FinishedThirdWorld", 1);
            if (Registry.noteScores[38] > 0) QuickKong.stats.submit("BeatLastExtraStage", 1);
            QuickKong.stats.submit("Score", int(parseFloat(MainMenuState.getTimeScore()) * 100));
*/
            
            //684, 325 are the mute medal in worldmap/playstate
            //275, 323 are the twitter/sounccloud NG unlcosk in HutState.as
            // NG medals/high schore
            
            API.postScore("Score", int(parseFloat(MainMenuState.getTimeScore()) * 100));
            if (Registry.times[5] < Registry.devTimes[5] && Registry.noteScores[5] == 20) API.unlockMedal("Further than most");
            if (Registry.boxesOpened[0] == true) API.unlockMedal("The Jams of Dave");
            if (Registry.boxesOpened[1] == true) API.unlockMedal("Aesthetically Rotating");
            if (Registry.boxesOpened[2] == true) API.unlockMedal("Rendertrail");
            if (Registry.boxesOpened[3] == true) API.unlockMedal("SCRUB GIMP JOB I COULD DO BETTER");
            if (Registry.boxesOpened[4] == true) API.unlockMedal("The Past Was Pitiful");
            if (Registry.boxesOpened[5] == true) API.unlockMedal("Extra Challenge With That");
            if (Registry.boxesOpened[6] == true) API.unlockMedal("Dance Party For The Completionist");
            if (Registry.cutscenesWatched[1] == true) API.unlockMedal("Played The Plains");
            if (Registry.cutscenesWatched[2] == true) API.unlockMedal("Through A Forest");
            if (Registry.cutscenesWatched[3] == true) API.unlockMedal("But Wait, There Is More!");
            if (Registry.noteScores[38] > 0) API.unlockMedal("Almost Or Already There!");
                     

            
        }
    }

}