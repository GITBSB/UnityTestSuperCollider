using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SynthDefsEffect : MonoBehaviour {

	public static string output = "SynthDef.new(\\output, {"
		+ "arg in, vol=1;"
		+ "var sig;"
		+ "sig = In.ar(in, 2);"
		+ "\tOut.ar(0, sig * vol);}).add;";

	public static string echo = "SynthDef.new(\\echo, {"
		+ "arg in, out, delay = 0.2, decay = 5;"
		+ "var sig;"
		+ "sig = In.ar(in,2);"
		+ "sig = CombN.ar(sig, 0.5, delay, decay, 1, sig);"
		+ "Out.ar(out, sig);}).add;";

	public static string reverb = "SynthDef.new(\\reverb, {"
		+ "arg in, out;"
		+ "var sig;"
		+ "sig = In.ar(in, 1);"
		+ "sig = FreeVerb.ar(sig, 0.9, 0.6, 0.4)!2;"
		+ "Out.ar(out, sig);}).add;";

	public static string distort = "SynthDef.new(\\distort, {"
		+ "arg in, out, pregain=40, amp=0.2, gate=1;"
		+ "var env, sig;"
		+ "env = Linen.kr(gate, 0.05, 1, 0.1, 2);"
		+ "sig = In.ar(in, 2);"
		+ "XOut.ar(out, env, (sig * pregain).distort * amp);}, [\\ir, 0.1, 0.1, 0]).add;";
}
