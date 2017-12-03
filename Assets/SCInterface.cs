using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SCInterface : MonoBehaviour {
	
	#region Singleton Constructor
	static SCInterface(){}

	public static SCInterface Instance {
		get {
			if (_instance == null) {
				_instance = new GameObject ("SCInterface").AddComponent<SCInterface>();
			}
			return _instance;
		}
	}
	#endregion

	#region Member Variables
	private static SCInterface _instance = null;
	private OSCHandler _oscHandler;
	private string _clientId = "SuperCollider";

	#endregion

	#region Methods

	void Start() {
		_oscHandler = OSCHandler.Instance;
	}

    //TODO: Not working!!!
    /// <summary>
    /// Clean-up and shutdown SuperCollider
    /// </summary>
    void OnDisable()
    {
        //find another wa
       // SendMessageToClient("SuperCollider", "/exitSuperCollider", "");
    }

    //TODO:
    /// <summary>
    /// Start SuperCollider
    /// </summary>
    void OnEnable()
    {

    }

    public void PlaySynthDef(string synthName, List<object> controlValues)
    {
        if(controlValues == null)
        {
            _oscHandler.SendMessageToClient(_clientId, "/synthDef.play", synthName);
        } else
        {
            controlValues.Insert(0, synthName);
            _oscHandler.SendMessageToClient(_clientId, "/synthDef.play", controlValues);
        }
    }

    public void CreateNewSynth(string synthName, int synthId, int action, int targetId, int inBus, int outBus, List<object> controlValues)
    {
        List<object> args = new List<object>();
        args.Add(synthName);
        args.Add(synthId);
        args.Add(action);
        args.Add(targetId);
        args.Add("in");
        args.Add(inBus);
        args.Add("out");
        args.Add(outBus);

        _oscHandler.SendMessageToClient(_clientId, "/synthDef.create", args);
        // set controlValues if existing
        if (controlValues != null)
        {
            foreach (KeyValuePair<string, int> pair in controlValues)
            {
                SetNodeValue(synthId, pair.Key, pair.Value);
            }
        }
    }

    public int CreateNewSynth(string effectName, int groupId, int inBus, int outBus, List<object> controlValues)
    {
        List<object> args = new List<object>();
        args.Add(groupId);
        args.Add(effectName);
        args.Add("in");
        args.Add(inBus);
        args.Add("out");
        args.Add(outBus);

        if (controlValues != null)
        {
            args.AddRange(controlValues);
        }
        _oscHandler.SendMessageToClient(_clientId, "/synthDef.create_2", args);
        // wait for message with nodeId
        List<object> msg = _oscHandler.LookForPacket();
        if (msg.Count > 0 && (msg[0].ToString() == "/effect.nodeID"))
        {
            return int.Parse(msg[1].ToString());
        }
        return -1;
    }

    public void CreateGroup(int groupId)
    {
        _oscHandler.SendMessageToClient(_clientId, "/group.create", groupId);
    }

    public int CreateGroup()
    {
        _oscHandler.SendMessageToClient(_clientId, "/group.create_2", "");
        return LookForPacket("/group.nodeID");
    }

    public void SetNodeValue(int nodeId, string controlName, double controlValue)
    {
        List<object> args = new List<object>();
        args.Add(nodeId);
        args.Add(controlName);
        args.Add(controlValue);
        _oscHandler.SendMessageToClient(_clientId, "/node.set.value", args);
    }

    public void DeleteNode(int nodeId)
    {
        _oscHandler.SendMessageToClient(_clientId, "/node.delete", nodeId);
    }

    public void StartRecording(float headerFormat)
    {
        _oscHandler.SendMessageToClient(_clientId, "/recording.start", headerFormat);
    }

    public void StopRecording(float headerFormat)
    {
        _oscHandler.SendMessageToClient(_clientId, "/recording.stop", "");
    }

    public int GetNewBus()
    {
        _oscHandler.SendMessageToClient(_clientId, "/bus.getID", "");
        return LookForPacket("/bus.ID");
    }

    public int BufferRead(string path)
    {
        _oscHandler.SendMessageToClient(_clientId, "/buffer.read", path);
        return LookForPacket("/buffer.number");
    }

    private int LookForPacket(string indicatorString)
    {
        List<object> msg = _oscHandler.LookForPacket();
        if (msg.Count > 0 && (msg[0].ToString() == indicatorString))
        {
            return int.Parse(msg[1].ToString());
        }
        Debug.LogError(string.Format("LookForPacket for {0} not succesfull!", indicatorString));
        return -1;
    }

    //not used
    public void SaveLoadSynth(string synthDef)
    {
        List<object> args = new List<object>();
        args.Add(MemberInfoGetting.GetMemberName(() => synthDef));
        args.Add(synthDef);
        _oscHandler.SendMessageToClient(_clientId, "/synthDef.add", args);
    }

    #endregion
}
