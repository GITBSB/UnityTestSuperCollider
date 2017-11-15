using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestIt : MonoBehaviour {
	public OSCInit oscInitScript;

	int nodeID;

	void OnMouseEnter() {
		NewGroup(2);
		NewGroup(3);
		AddEffectToGroup("distort", 100, 2, 4);
		AddOutputSynthToGroup(101, 2, 4);

		AddEffectToGroup("echo", 102, 3, 6);
		AddOutputSynthToGroup(103, 3, 6);
	}

	void OnMouseExit() {
		

	}

	public void PlaySynth(string synthName) {
		OSCHandler.Instance.SendMessageToClient("SuperCollider","/synthDef.play", synthName);
	}

	public void PlaySynthWithArgs(List<object> args) {
		OSCHandler.Instance.SendMessageToClient("SuperCollider","/synthDef.playWithArg", args);
	}

	public void AddSynth(string synthName, string synthDef) {
		List<object> args = new List<object>();
		args.Add(synthName);
		args.Add(synthDef);
		OSCHandler.Instance.SendMessageToClient("SuperCollider","/synthDef.add", args);
	}
		
	public void NewGroup(int groupId) {
		OSCHandler.Instance.SendMessageToClient ("SuperCollider", "/group.new", groupId);
		/* wait for answer
		List<object> msg = oscInitScript.LookForPacket ();
		if (msg.Count > 0 && (msg [0].ToString () == "/group.nodeID")) {
			Debug.Log("ID-Valule back:  " + msg[1].ToString());
			return int.Parse(msg[1].ToString());
		}
		return 0;
		*/
	}

	public void DeleteNode(int nodeId) {
		OSCHandler.Instance.SendMessageToClient ("SuperCollider", "/node.delete", nodeId);
	}

	public void AddEffectToGroup(string effectName, int nodeId, int groupId, int busId) {
		List<object> args = new List<object> ();
		args.Add (effectName);
		args.Add (nodeId);
		args.Add (groupId);
		args.Add (busId);
		OSCHandler.Instance.SendMessageToClient("SuperCollider", "/group.add.effect", args);
	}

	public void AddOutputSynthToGroup(int nodeId, int groupId, int busId) {
		List<object> args = new List<object> ();
		args.Add (nodeId);
		args.Add (groupId);
		args.Add (busId);
		OSCHandler.Instance.SendMessageToClient("SuperCollider", "/group.add.output", args);
	}

	public void SetNodeValue(int nodeId, string controlName, int controlValue) {
		List<object> args = new List<object> ();
		args.Add (nodeId);
		args.Add (controlName);
		args.Add (controlValue);
		OSCHandler.Instance.SendMessageToClient("SuperCollider", "/node.set.value", args);
	}
		
	private void CalladdSynth() {
		// addSynth call
		string synthDef = "SynthDef.new(\\openhat, {"
			+ "var hatosc, hatenv, hatnoise, hatoutput;"
			+ "hatnoise = {LPF.ar(WhiteNoise.ar(1),6000)};"
			+ "hatosc = {HPF.ar(hatnoise,2000)};"
			+ "hatenv = {Line.ar(1, 0, 0.3)};"
			+ "hatoutput = (hatosc * hatenv);"
			+ "Out.ar(0, Pan2.ar(hatoutput, 0));}).add;";
		
		AddSynth("openhat", synthDef);
	}
		

	public void CallPlayWithArgs() {
		// playWithArgs call
		List<object> args = new List<object>();
		args.Add("kick");
		args.Add("out");
		args.Add(4);
		args.Add("amp");
		args.Add(1);
		PlaySynthWithArgs(args);
	}
}
