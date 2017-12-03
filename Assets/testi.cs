using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class testi : MonoBehaviour
{
    private SCHandlerLC sce;
    private void Start()
    {
        sce = SCHandlerLC.Instance;
    }
    void OnMouseEnter()
    {
        sce.AddEffectToGroup("GroupOutput", 30, null);
        //sce.ChangeGroupVolume(sce.GetMasterOutput(), 0.2);
    }
 
}
