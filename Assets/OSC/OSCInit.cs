using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OSCInit : MonoBehaviour {
	private Dictionary<string, ServerLog> servers;

	// Use this for initialization
	void Start () {
		Debug.Log("call OSCHandler init");
		OSCHandler.Instance.Init ();
		servers = new Dictionary<string, ServerLog> ();
		servers = OSCHandler.Instance.Servers;
	}


	void Update() {
		OSCHandler.Instance.UpdateLogs();

		//LookForPacket();
	}

	public List<object> LookForPacket() {
		bool waitForPacket = true;
		List<object> msg = new List<object>();
		while(waitForPacket) {		
			if (OSCHandler.Instance.packets.Count > 0) {
				msg.Add(OSCHandler.Instance.packets[0].Address);
				msg.Add(OSCHandler.Instance.packets[0].Data[0].ToString());

				Debug.Log (string.Format ("ADDRESS: {0} VALUE 0: {1}", 
					OSCHandler.Instance.packets [0].Address,
					OSCHandler.Instance.packets [0].Data [0].ToString ()));
				OSCHandler.Instance.packets.RemoveAt (0);
				waitForPacket = false;
				return msg;
			}
		}
		return msg;
	}

	void IUpdate() {
		OSCHandler.Instance.UpdateLogs();

		foreach (KeyValuePair<string, ServerLog> item in servers) {
			if (item.Value.log.Count > 0) {
				int packet = item.Value.packets.Count - 1;
				Debug.Log (string.Format ("Server: {0} ADDRESS: {1} VALUE 0: {2}", 
					item.Key,
					item.Value.packets [packet].Address,
					item.Value.packets [packet].Data [0].ToString ()));
				
			}
		}
	}	
}
