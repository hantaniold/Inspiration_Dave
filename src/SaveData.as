package {
	
import org.flixel.FlxSave;

public class SaveData {
	private static var save:FlxSave;
	private static var isLoaded:Boolean;
	//The data to save
	private static var noteScores:Array;
	private static var timeScores:Array;
	private static var curLevel:int;
	
	//teng bao
	public static function loadExists(fileID:int):Boolean {
		save = new FlxSave();
		isLoaded = save.bind("InspirationDave");
		if (save.data.validSave_1 && fileID == 1) {
			return true;
		} else if (save.data.validSave_2 && fileID == 2) {
			return true;
		} else if (save.data.validSave_3 && fileID == 3) {
			return true;
		}
		return false;
	}
	public static function load(fileID:int):Boolean {
		save = new FlxSave();
		isLoaded = save.bind("InspirationDave");
		if (save.data.validSave_1 && fileID == 1) {
			Registry.noteScores = save.data.noteScores_1;
			Registry.times = save.data.times_1;
			Registry.levelIsUnlocked = save.data.levelIsUnlocked_1;
			Registry.nrDeaths = save.data.nrDeaths_1;
			Registry.level = save.data.level_1;
			Registry.cutscenesWatched = save.data.cutscenesWatched_1;
			Registry.boxesOpened = save.data.boxesOpened_1;
			Registry.sponsorOn = save.data.sponsorOn_1;
			return true;
		} else if (save.data.validSave_2 && fileID == 2) {
			Registry.noteScores = save.data.noteScores_2;
			Registry.times = save.data.times_2;
			Registry.levelIsUnlocked = save.data.levelIsUnlocked_2;
			Registry.nrDeaths = save.data.nrDeaths_2;
			Registry.level = save.data.level_2;
			Registry.cutscenesWatched = save.data.cutscenesWatched_2;
			Registry.boxesOpened = save.data.boxesOpened_2;
			Registry.sponsorOn = save.data.sponsorOn_2;
			return true;					
		} else if (save.data.validSave_3 && fileID == 3) {
			Registry.noteScores = save.data.noteScores_3;
			Registry.times = save.data.times_3;
			Registry.levelIsUnlocked = save.data.levelIsUnlocked_3;
			Registry.nrDeaths = save.data.nrDeaths_3;
			Registry.level = save.data.level_3;
			Registry.cutscenesWatched = save.data.cutscenesWatched_3;
			Registry.boxesOpened = save.data.boxesOpened_3;
			Registry.sponsorOn = save.data.sponsorOn_3;
			return true;
		}
		
		return false;
	}
	
	/** Save function. Returns true on success, false otherwise... **/
	public static function saveGame(fileID:int):Boolean {
		save = new FlxSave();
		var canSave:Boolean = save.bind("InspirationDave");
		if (canSave) {
			if (fileID == 1) {
				save.data.noteScores_1 = Registry.noteScores;
				save.data.times_1 = Registry.times;
				save.data.level_1 = Registry.level;
				save.data.nrDeaths_1 = Registry.nrDeaths;
				save.data.levelIsUnlocked_1 = Registry.levelIsUnlocked;
				save.data.cutscenesWatched_1 = Registry.cutscenesWatched;
				save.data.validSave_1 = true;
				save.data.boxesOpened_1 = Registry.boxesOpened;
				save.data.sponsorOn_1 = Registry.sponsorOn;
				return true;
			} else if (fileID == 2) {
				save.data.noteScores_2 = Registry.noteScores;
				save.data.times_2 = Registry.times;
				save.data.level_2 = Registry.level;
				save.data.nrDeaths_2 = Registry.nrDeaths;
				save.data.levelIsUnlocked_2 = Registry.levelIsUnlocked;
				save.data.cutscenesWatched_2 = Registry.cutscenesWatched;
				save.data.boxesOpened_2 = Registry.boxesOpened;
				save.data.sponsorOn_2 = Registry.sponsorOn;
				save.data.validSave_2 = true;
				return true;
			} else if (fileID == 3) {
				save.data.noteScores_3 = Registry.noteScores;
				save.data.times_3 = Registry.times;
				save.data.level_3 = Registry.level;
				save.data.nrDeaths_3 = Registry.nrDeaths;
				save.data.levelIsUnlocked_3 = Registry.levelIsUnlocked;
				save.data.cutscenesWatched_3 = Registry.cutscenesWatched;
				save.data.boxesOpened_3 = Registry.boxesOpened;
				save.data.sponsorOn_3 = Registry.sponsorOn;
				save.data.validSave_3 = true;
				return true;
			}
		}
		return false;
	}
	
	public static function deleteData(fileID:int):Boolean {
		save = new FlxSave();
		var canDelete:Boolean = save.bind("InspirationDave");
		if (canDelete) {
			if (fileID == 1) save.data.validSave_1 = false;
			if (fileID == 2) save.data.validSave_2 = false;
			if (fileID == 3) save.data.validSave_3 = false;
			Registry.reset();
			return true;
		}
		return false;
	}
}
}

