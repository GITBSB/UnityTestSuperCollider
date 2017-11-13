using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestIt : MonoBehaviour {
	public OSCInit oscInitScript;

	int nodeID;

	void OnMouseEnter() {
		nodeID = AddGroup ();
		Debug.Log("nodeID" + nodeID);
	}

	void OnMouseExit() {
		DeleteGroup(nodeID);
	}

	private void PlaySynth(string synthName) {
		OSCHandler.Instance.SendMessageToClient("SuperCollider","/synthDef.play", synthName);
	}

	private void PlayWithArgs(List<object> args) {
		OSCHandler.Instance.SendMessageToClient("SuperCollider","/synthDef.playWithArg", args);
	}

	private void AddSynth(string synthName, string synthDef) {
		List<object> args = new List<object>();
		args.Add(synthName);
		args.Add(synthDef);
		OSCHandler.Instance.SendMessageToClient("SuperCollider","/synthDef.add", args);
	}
		
	private int NewGroup(int groupId) {
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

	private void DeleteNode(int nodeId) {
		OSCHandler.Instance.SendMessageToClient ("SuperCollider", "/node.delete", nodeId);
	}

	private void AddEffectToGroup(string effectName, int nodeId, int groupId, int busId) {
		List<object> args = new List<object> ();
		args.Add (effectName);
		args.Add (nodeId);
		args.Add (groupId);
		args.Add (busId);
		OSCHandler.Instance.SendMessageToClient("SuperCollider", "/group.add.effect", args);
	}

	private void AddOutputSynthToGroup(int nodeId, int groupId, int busId) {
		List<object> args = new List<object> ();
		args.Add (nodeId);
		args.Add (groupId);
		args.Add (busId);
		OSCHandler.Instance.SendMessageToClient("SuperCollider", "/group.add.output", args);
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
		
		AddSynth("openhat", synthDef);
	}

	private void callPlayWithArgs() {
		// playWithArgs call
		List<object> args = new List<object>();
		args.Add("tom");
		args.Add("out");
		args.Add(0);
		args.Add("amp");
		args.Add(0.5);
		PlayWithArgs(args);
	}




}
