using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SCInterface : MonoBehaviour {

	//TODO: OSC Handler nur von hier zugreifbar machen

	#region Singleton Constructor
	static SCInterface(){}

	public static SCInterface Instance {
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
	private Dictionary<int, int> _groupBus = new Dictionary<int, int> ();

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


	private void NewGroupWithNodeId(int groupId) {
		OSCHandler.Instance.SendMessageToClient ("SuperCollider", "/group.new", groupId);
	}

	private int NewGroup() {
		OSCHandler.Instance.SendMessageToClient ("SuperCollider", "/group.new2", "");
		List<object> msg = OSCHandler.Instance.LookForPacket ();
		if (msg.Count > 0 && (msg [0].ToString () == "/group.nodeID")) {
			return int.Parse(msg[1].ToString());
		}
		Debug.LogError ("NewGroup: no response from SuperCollider");
		return 0;
	}
		

	public void DeleteNode(int nodeId) {
		OSCHandler.Instance.SendMessageToClient ("SuperCollider", "/node.delete", nodeId);
	}

	public void AddEffectToGroupWithNodeID(string effectName, int groupId, int nodeId, Dictionary<string, int> controlValues) {
		if (_groupBus.ContainsKey (groupId)) {
			int busId = _groupBus [groupId];
			List<object> args = new List<object> ();
			args.Add (effectName);
			args.Add (nodeId);
			args.Add (groupId);
			args.Add (busId);
			OSCHandler.Instance.SendMessageToClient ("SuperCollider", "/group.add.effect", args);

			// set controlValues if existing
			if (controlValues != null) {
				foreach (KeyValuePair<string, int> pair in controlValues) {
					SetNodeValue (nodeId, pair.Key, pair.Value);
				}
			}
		} else {
			Debug.LogError (string.Format ("AddEffectToGroup: Group {0} not existing", groupId));
		}
	}

	public int AddEffectToGroup(string effectName, int groupId, List<object> controlValues) {
		if (_groupBus.ContainsKey (groupId)) {
			int busId = _groupBus [groupId];
			List<object> args = new List<object> ();
			args.Add (groupId);
			args.Add (effectName);
			args.Add ("in");
			args.Add (busId);

			//TODO: change to inout with all effect?
			if (effectName != "output") {
				args.Add ("out");
				args.Add (busId);
			}
			if (controlValues != null) {
				args.AddRange (controlValues);
			}
			OSCHandler.Instance.SendMessageToClient ("SuperCollider", "/group.add.effect2", args);
			// wait for message with nodeId
			List<object> msg = OSCHandler.Instance.LookForPacket ();
			if (msg.Count > 0 && (msg [0].ToString () == "/effect.nodeID")) {
				return int.Parse (msg [1].ToString ());
			}
		}
		Debug.LogError(string.Format("AddEffectToGroup: Group {0} not existing", groupId));
		return 0;
	}

	public void AddOutputSynthToGroup(int nodeId, int groupId, int busId) {
		List<object> args = new List<object> ();
		args.Add (nodeId);
		args.Add (groupId);
		args.Add (busId);
		OSCHandler.Instance.SendMessageToClient("SuperCollider", "/group.add.output", args);
	}

	public void SetNodeValue(int nodeId, string controlName, double controlValue) {
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
		Debug.LogError("GetNewBus: No response from SuperCollider");
		return 0;
	}

	public int GetBusFromGroup(int group) {
		return _groupBus [group];	
	}

	private void AddBusToGroup(int group, int bus) {
		_groupBus.Add (group, bus);
	}

	private bool DeleteBusfromGroup(int group) {
		// TODO: Bus freigeben möglich?
		return _groupBus.Remove (group);
	}


	public int CreateUsableGroup() {
		int groupid = NewGroup();
		int busid = GetNewBus();
		AddBusToGroup (groupid, busid);
		AddEffectToGroup("output", groupid, null);
		return groupid;
	}

	public void CreateUsableGroupWithNodeID(int nodeId) {
		if (!_groupBus.ContainsKey (nodeId)) {
			NewGroupWithNodeId (nodeId);
			int busid = GetNewBus ();
			AddBusToGroup (nodeId, busid);
			AddEffectToGroup ("output", nodeId, null);
		} else {
			Debug.LogError(string.Format("Group with ID: {0} already exists in Dictionary", nodeId));
		}
	}

	public void DeleteGroup(int group) {
		
		if (DeleteBusfromGroup (group)) {
			DeleteNode (group);
		} else {
			Debug.LogError (string.Format ("DeleteGroup: group {0} not existing", group));
		}
	}
	#endregion
}
