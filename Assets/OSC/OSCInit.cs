using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OSCInit : MonoBehaviour {

	// Use this for initialization
	void Start () {
		Debug.Log("call OSCHandler init");
		OSCHandler.Instance.Init ();
	}
}
