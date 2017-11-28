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

	public static string sound_bass = "SynthDef.new(\\bass_Ex, {"
		+ "arg out, freq = 300, gate = 1, pan = 0, cut = 4000, rez = 0.8, amp = 2;"
		+ "Out.ar(out, Pan2.ar(RLPF.ar(SinOsc.ar(freq,0.05), cut, rez),pan)"
		+ "* EnvGen.kr(Env.linen(0.01, 0.5, 0.3), gate, amp, doneAction: 2);)}).add;";
	
	public static string sound_patt = "SynthDef.new(\\pattern_Ex, {"
		+ "arg out, freq = 300, gate = 1, pan = 0, cut = 4000, rez = 0.8, amp = 1;"
		+ "Out.ar(out, Pan2.ar(RLPF.ar(Pulse.ar(freq,0.05), cut, rez),pan)"
		+"* EnvGen.kr(Env.linen(0.01, 0.5, 0.3), gate, amp, doneAction: 2);)}).add;";
}