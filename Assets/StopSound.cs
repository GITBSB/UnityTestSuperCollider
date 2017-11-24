using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StopSound : MonoBehaviour {
	public SCInterface sci;

	void Start() {
		sci = SCInterface.Instace;
	}

	void OnMouseEnter() {
		List<object> args = new List<object>();
		args.Add("kick");
		args.Add("out");
		args.Add(4);
		args.Add("amp");
		args.Add(1);
		sci.PlaySynthWithArgs(args);
	}

	void OnMouseExit() {
		List<object> args = new List<object>();
		args.Add("kick");
		args.Add("out");
		args.Add(6);
		args.Add("amp");
		args.Add(1);
		sci.PlaySynthWithArgs(args);

	}
}
