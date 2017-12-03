using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class AnotherTest : MonoBehaviour {
    private SCHandlerLC sce;
    private void Start()
    {
        sce = SCHandlerLC.Instance;
    }
    void OnMouseEnter() {
        List<object> args = new List<object>();
        args.Add("out");
        args.Add(sce.GetBusFromGroup(30));
        sce.PlaySynth("kick", args);
    }
}
