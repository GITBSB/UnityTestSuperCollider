using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SynthDefsSound : MonoBehaviour {
	public static string kick = "SynthDef.new(\\kick, {"
		+ "arg out = 0, amp = 0, pan = 0;"
		+ "var env, bass;"
		+ "env = EnvGen.kr(Env.perc(0.001, 0.2, 1, -4), 1, doneAction:2);"
		+ "bass = SinOsc.ar(80) + Crackle.ar(1, 0.5);"
		+ "Out.ar(out, Pan2.ar(bass*env, pan, amp));}).add;";


}
