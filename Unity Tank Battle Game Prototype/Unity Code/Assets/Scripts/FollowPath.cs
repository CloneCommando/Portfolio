using UnityEngine;
using System.Collections;

public class FollowPath : MonoBehaviour 
{
	
	public GameObject startingPoint = null;
	
	// Use this for initialization
	void Start () 
	{
		if(startingPoint == null)
			Debug.LogError("Path does not have a starting point!");
	}
	
	// Update is called once per frame
	void Update () 
	{
	
	}
}
