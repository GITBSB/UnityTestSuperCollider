using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StopSound : MonoBehaviour {
    private SCHandlerLC sce;
    private void Start()
    {
        sce = SCHandlerLC.Instance;
    }
    void OnMouseEnter() {

        sce.CreateUsableGroup(30);

    }

    private void ausgabe(object e)
    {
        Debug.Log(e);
    }
}
