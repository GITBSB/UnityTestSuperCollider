using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class SCHandlerLC : MonoBehaviour
{
    #region Singleton Constructor
    static SCHandlerLC() { }

    public static SCHandlerLC Instance
    {
        get
        {
            if (_instance == null)
            {
                _instance = new GameObject("SCExtensionLoopCube").AddComponent<SCHandlerLC>();
            }
            return _instance;
        }
    }
    #endregion
    private static SCHandlerLC _instance = null;
    private SCInterface _scInterface;
    private Dictionary<int, int> _groupBus = new Dictionary<int, int>();
    private int _masterBus = 0;
    private int _masterOutput;

    private void Start()
    {
        _scInterface = SCInterface.Instance;
    }

    public void PlaySynth(string synthName, List<object> controlValues)
    {
        _scInterface.PlaySynthDef(synthName, controlValues);
    }

    public void AddOutputToGroup(int nodeId, int groupId, int busId)
    {
        _scInterface.CreateNewSynth("GroupOutput", groupId, busId, busId, null);
    }

    public void AddEffectToGroup(string synthName, int synthId, int groupId, List<object> controlValues)
    {
        int action = 0;
        int busId = GetBusFromGroup(groupId);
        _scInterface.CreateNewSynth(synthName, synthId, action, groupId, busId, busId, controlValues);
    }

    public int AddEffectToGroup(string synthName, int groupId, List<object> controlValues)
    {
        int busId = GetBusFromGroup(groupId);
        return _scInterface.CreateNewSynth(synthName, groupId, busId, busId, controlValues);
    }

    /// <summary>
    /// Creates a group with own Output and bus
    /// </summary>
    /// <returns> groupId </returns>
    public int CreateUsableGroup()
    {
        CreateMasterIfNecessary();
        Debug.Log(_masterBus);
        int groupId = _scInterface.CreateGroup();
        int busId = _scInterface.GetNewBus();
        AddBusToGroup(groupId, busId);
        _scInterface.CreateNewSynth("GroupOutput", groupId, busId, _masterBus, null);
        return groupId;
    }

    /// <summary>
    /// Creates a group with groupId with own Output and bus
    /// </summary>
    /// <param name="groupId"></param>
    public void CreateUsableGroup(int groupId)
    {
        CreateMasterIfNecessary();

        if (!_groupBus.ContainsKey(groupId))
        {
            _scInterface.CreateGroup(groupId);

            int busId = _scInterface.GetNewBus();
            AddBusToGroup(groupId, busId);
            _scInterface.CreateNewSynth("GroupOutput", groupId, busId, _masterBus, null);
        }
        else
        {
            Debug.LogError(string.Format("Group with ID: {0} already exists in Dictionary", groupId));
        }
    }

    /// <summary>
    /// Change Volume of a group
    /// </summary>
    /// <param name="groupId"></param>
    /// <param name="volume"> Value between 0..1 </param>
    public void ChangeGroupVolume(int groupId, double volume)
    {
        _scInterface.SetNodeValue(groupId, "vol", volume);
    }

    public void DeleteGroup(int group)
    {

        if (DeleteBusfromGroup(group))
        {
            _scInterface.DeleteNode(group);
        }
        else
        {
            Debug.LogError(string.Format("DeleteGroup: group {0} not existing", group));
        }
    }

    private void CreateMasterIfNecessary()
    {
        if (_masterBus == 0)
        {
            CreateMasterOutput();
        }
    }

    public int GetMasterOutput()
    {
        return _masterOutput;
    }

    private void CreateMasterOutput()
    {
        _masterBus = _scInterface.GetNewBus();
        _masterOutput = _scInterface.CreateNewSynth("GroupOutput", 1, _masterBus, 0, null);
    }

    public int GetBusFromGroup(int group)
    {
        int res;
        if(!_groupBus.TryGetValue(group, out res))
        {
            Debug.LogError(string.Format("No bus mapping found for group {0}", group));
        }
        return res;
    }

    private void AddBusToGroup(int group, int bus)
    {
        _groupBus.Add(group, bus);
    }

    private bool DeleteBusfromGroup(int group)
    {
        return _groupBus.Remove(group);
    }
}
