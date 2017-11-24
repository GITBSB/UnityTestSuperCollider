using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OSCInit : MonoBehaviour {

	// Use this for initialization
	void Start () {
		OSCHandler.Instance.Init ();
		SynthDefsHelper.Instace.Init(); // ?benötigt?
	}

	/*
	void Update() {
		OSCHandler.Instance.UpdateLogs();
	}
	*/
}
