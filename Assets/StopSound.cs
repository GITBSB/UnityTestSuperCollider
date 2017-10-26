using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StopSound : MonoBehaviour {

	void OnMouseEnter() {
		OSCHandler.Instance.SendMessageToClient("SuperCollider", "/stop", 0);
	}
}
