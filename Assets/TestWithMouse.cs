using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestWithMouse : MonoBehaviour {

	void OnMouseDown(){
		float testValue = 7.0f;
		OSCHandler.Instance.SendMessageToClient("SuperCollider", "/test", testValue);
	}
}
