using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestIt : MonoBehaviour {

	void OnMouseDown(){

		List<object> args1 = new List<object>();
		args1.Add("sine");
		args1.Add( "x = s.nextNodeID");
		args1.Add(1);
		args1.Add(1);

		OSCHandler.Instance.SendMessageToClient("SuperCollider", "/s_new", args1);
	}

	private void playSynth(string synthName) {
		OSCHandler.Instance.SendMessageToClient("SuperCollider","/synthDef.play", synthName);
	}

	private void playWithArgs(List<object> args) {
		OSCHandler.Instance.SendMessageToClient("SuperCollider","/synthDef.playWithArg", args);
	}

	private void addSynth(string synthName, string synthDef) {
		List<object> args = new List<object>();
		args.Add(synthName);
		args.Add(synthDef);
		OSCHandler.Instance.SendMessageToClient("SuperCollider","/synthDef.add", args);
	}




	private void calladdSynth() {
		// addSynth call
		string synthDef = "SynthDef.new(\\openhat, {"
			+ "var hatosc, hatenv, hatnoise, hatoutput;"
			+ "hatnoise = {LPF.ar(WhiteNoise.ar(1),6000)};"
			+ "hatosc = {HPF.ar(hatnoise,2000)};"
			+ "hatenv = {Line.ar(1, 0, 0.3)};"
			+ "hatoutput = (hatosc * hatenv);"
			+ "Out.ar(0, Pan2.ar(hatoutput, 0));}).add;";
		
		addSynth("openhat", synthDef);
	}

	private void callPlayWithArgs() {
		// playWithArgs call
		List<object> args = new List<object>();
		args.Add("tom");
		args.Add("out");
		args.Add(0);
		args.Add("amp");
		args.Add(0.5);
		playWithArgs(args);
	}




}
