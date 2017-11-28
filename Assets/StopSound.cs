using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StopSound : MonoBehaviour {
	private SCInterface sci;

	void Start() {
		sci = SCInterface.Instance;
	}

	void OnMouseEnter() {
		List<object> args = new List<object>();
		args.Add("kick");
		args.Add("out");
		args.Add(sci.GetBusFromGroup(10));
		args.Add("amp");
		args.Add(1);
		sci.PlaySynthWithArgs(args);
	}

	void OnMouseExit() {
		List<object> args = new List<object>();
		args.Add("kick");
		args.Add("out");
		args.Add(sci.GetBusFromGroup(10));
		args.Add("amp");
		args.Add(1);
		sci.PlaySynthWithArgs(args);

	}
}
