using UnityEngine;
using System.Collections;

public class Waypoint : MonoBehaviour 
{
	
	public Waypoint nextWaypoint = null;
	
	private Vector3 position;
	
	public Vector3 Position { get { return position; } }
	
	public float reachedWaypointDist = 40;
	
	private RaycastHit rayInfo;
	
	private int layerMask = 1 << 8;
	
	// Use this for initialization
	void Start () 
	{
		// Randomly generate a position for the tree
		float xPos = gameObject.transform.position.x;
		float zPos = gameObject.transform.position.z;
		float yPos = gameObject.transform.position.x-1;
		Vector3 posVec = new Vector3(xPos, yPos, zPos);
		
		// Raycast to get height of terrain below tree to place it ad correct height
		if(Physics.Raycast(posVec, Vector3.down, out rayInfo, Mathf.Infinity, layerMask))
			posVec.y = rayInfo.point.y;
		
		transform.position = posVec;
		
		position = transform.position;
	}
	
	// Update is called once per frame
	void Update () 
	{
		if(nextWaypoint == null)
			Debug.LogError("A Waypoint does not have a nextWaypoint!");
	}
	
	public bool hasArrived(Vector3 objectPosition)
	{
		float dist = Vector3.Distance(transform.position, objectPosition);
		
		if(dist <= reachedWaypointDist)
			return true;
		else
			return false;
	}
}
