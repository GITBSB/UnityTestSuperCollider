using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SynthDefsHelper : MonoBehaviour {


	// TODO: wird zz. nicht gebraucht. - > Klasse wird evtl. bei Erstellung der Synthdefs innerhalb Unity gebraucht.

	#region Singleton Constructor
	static SynthDefsHelper(){}

	public static SynthDefsHelper Instace {
		get {
			if (_instance == null) {
				_instance = new GameObject ("SynthDefsHelper").AddComponent<SynthDefsHelper>();
			}
			return _instance;
		}
	}
	#endregion

	#region enum
	public enum Effects {
		Output,
		Reverb,
		Echo,
		Distortion
	};

	public enum Sounds {
		Kick
	};
	#endregion

	#region Member Variables
	private static SynthDefsHelper _instance = null;
	private Dictionary<string, string> _sounds = new Dictionary<string, string>();
	private Dictionary<string, string> _effects = new Dictionary<string, string>();
	#endregion

	#region Properties
	// TODO: needed?
	public Dictionary<string, string> GetSounds {
		get {
			return _sounds;
		}
	}
	#endregion

	public void Init() {
		
	}

	#region methods
	private void AddSounds() {
		string synthD = "SynthDef.new(\\Kick, {"
			+ "arg out, amp = 0, pan = 0;"
			+ "var env, bass;"
			+ "env = EnvGen.kr(Env.perc(0.001, 0.2, 1, -4), 1, doneAction:2);"
			+ "bass = SinOsc.ar(80) + Crackle.ar(1, 0.5);"
			+ "Out.ar(out, Pan2.ar(bass*env, pan, amp));}).add;";

		_sounds.Add("Kick", synthD);
	}

	private void AddEffects() {
		string synthD = "SynthDef.new(\\Kick, {"
			+ "arg out, amp = 0, pan = 0;"
			+ "var env, bass;"
			+ "env = EnvGen.kr(Env.perc(0.001, 0.2, 1, -4), 1, doneAction:2);"
			+ "bass = SinOsc.ar(80) + Crackle.ar(1, 0.5);"
			+ "Out.ar(out, Pan2.ar(bass*env, pan, amp));}).add;";

		_sounds.Add("Kick", synthD);
	}

	public string getSoundDef(string synthName) {
		return _sounds[synthName];
	}

	public string getEffectdDef(string synthName) {
		return _effects[synthName];
	}
	#endregion
}
