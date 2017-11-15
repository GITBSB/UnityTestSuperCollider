using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StopSound : MonoBehaviour {
	public TestIt oscInterface;

	void OnMouseEnter() {
		List<object> args = new List<object>();
		args.Add("kick");
		args.Add("out");
		args.Add(4);
		args.Add("amp");
		args.Add(1);
		oscInterface.PlaySynthWithArgs(args);
	}

	void OnMouseExit() {
		List<object> args = new List<object>();
		args.Add("kick");
		args.Add("out");
		args.Add(6);
		args.Add("amp");
		args.Add(1);
		oscInterface.PlaySynthWithArgs(args);

	}
}
