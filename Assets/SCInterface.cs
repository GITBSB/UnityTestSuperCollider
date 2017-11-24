using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SCInterface : MonoBehaviour {

	#region Singleton Constructor
	static SCInterface(){}

	public static SCInterface Instace {
		get {
			if (_instance == null) {
				_instance = new GameObject ("SCInterface").AddComponent<SCInterface>();
			}
			return _instance;
		}
	}
	#endregion

	#region Member Variables

	private static SCInterface _instance = null;

	#endregion

	#region Methods
	public void PlaySynth(string synthName) {
		OSCHandler.Instance.SendMessageToClient("SuperCollider","/synthDef.play", synthName);
	}

	public void PlaySynthWithArgs(List<object> args) {
		OSCHandler.Instance.SendMessageToClient("SuperCollider","/synthDef.playWithArg", args);
	}

	public void AddSynth(string synthDef) {
		List<object> args = new List<object>();
		args.Add(MemberInfoGetting.GetMemberName(() => synthDef));
		args.Add(synthDef);
		OSCHandler.Instance.SendMessageToClient("SuperCollider","/synthDef.add", args);
	}


	public void NewGroup(int groupId) {
		OSCHandler.Instance.SendMessageToClient ("SuperCollider", "/group.new", groupId);
	}

	public int NewGroup2() {
		OSCHandler.Instance.SendMessageToClient ("SuperCollider", "/group.new2", "");
		List<object> msg = OSCHandler.Instance.LookForPacket ();
		if (msg.Count > 0 && (msg [0].ToString () == "/group.nodeID")) {
			return int.Parse(msg[1].ToString());
		}
		return 0;
	}
		

	public void DeleteNode(int nodeId) {
		OSCHandler.Instance.SendMessageToClient ("SuperCollider", "/node.delete", nodeId);
	}

	public void AddEffectToGroup(string effectName, int nodeId, int groupId, int busId, Dictionary<string, int> controlValues) {
		List<object> args = new List<object> ();
		args.Add (effectName);
		args.Add (nodeId);
		args.Add (groupId);
		args.Add (busId);
		OSCHandler.Instance.SendMessageToClient("SuperCollider", "/group.add.effect", args);

		// set controlValues if existing
		if (controlValues != null || controlValues.Count > 0) {
			foreach(KeyValuePair<string, int> pair in controlValues) {
				SetNodeValue(nodeId, pair.Key, pair.Value);
			}
		}
	}

	public int AddEffectToGroup2(string effectName, int groupId, int busId, List<object> controlValues) {
		List<object> args = new List<object> ();
		args.Add (groupId);
		args.Add (effectName);
		args.Add("in");
		args.Add(busId);

		//TODO: change to inout with all effect?
		if (effectName != "output") {
			args.Add("out");
			args.Add(busId);
		}
		if (controlValues != null) {
			args.AddRange(controlValues);
		}
		OSCHandler.Instance.SendMessageToClient("SuperCollider", "/group.add.effect2", args);
		// wait for message with nodeId
		List<object> msg = OSCHandler.Instance.LookForPacket ();
		if (msg.Count > 0 && (msg [0].ToString () == "/effect.nodeID")) {
			return int.Parse(msg[1].ToString());
		}
		return 0;
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

	public void StartRecording(float headerFormat) {
		OSCHandler.Instance.SendMessageToClient("SuperCollider", "/recording.start", headerFormat);
	}

	public void StopRecording(float headerFormat) {
		OSCHandler.Instance.SendMessageToClient("SuperCollider", "/recording.stop", "");
	}

	public int GetNewBus() {
		OSCHandler.Instance.SendMessageToClient("SuperCollider", "/bus.getID", "");
		List<object> msg = OSCHandler.Instance.LookForPacket ();
		if (msg.Count > 0 && (msg [0].ToString () == "/bus.ID")) {
			return int.Parse(msg[1].ToString());
		}
		return 0;
	}

	#endregion
}
