using UnityEngine;
using System.Collections;
//including some .NET for dynamic arrays called List in C#
using System.Collections.Generic;

public class AllyController : MonoBehaviour 
{

	//Flocking code weight parameters
	//set in editor for all flock members
	//if initialized here editor will override settings
	public float wanderWt;
	public float targetWt;
	public float separationWt;
	public float separationDist;
	public float avoidDist;
	public float maxForce;
	public float maxSpeed;
	public int numberOfFlockers;
	public float avoidWt;
	public float followLeaderWt;
	public float seekEnemyWt;
	
	// The Leader Everyone will be following
	public GameObject leader;
	
	//needs to be set in editor to promote reusability.
	public Object flockerPrefab;
	
	// list of flockers
	private List<GameObject> flockers = new List<GameObject>();
	public List<GameObject> Flockers {get{return flockers;} set{flockers = value;}}
	
	// List of the obstacles
	private List<GameObject> obstacles = new List<GameObject>();
	public List<GameObject> Obstacles {get{return obstacles;}}
	
	//this is a 2D C# array for distances
	private float[,] distances;

	public void Start()
	{
		//construct our 2d array based on the value set, do it here so it can be
		//set in editor.
		distances = new float[numberOfFlockers, numberOfFlockers];
		//reference to Vehicle script component for each flocker
		AllyVehicle flockerVehicle;
		
		// Adds flockers
		for(int i = 0; i < numberOfFlockers; i++)
		{
			//Instantiate a flocker prefab, catch the reference, cast it to a GameObject
			//and add it to our list all in one line.
			flockers.Add( (GameObject) Instantiate(flockerPrefab, 
				new Vector3(leader.transform.position.x+ 60*i, leader.transform.position.y+25, leader.transform.position.z+110 ), Quaternion.identity) ) ;
			//grab a component reference
			flockerVehicle = flockers[i].GetComponent<AllyVehicle>();
			//set values in the Vehicle script
			flockerVehicle.Index = i;
			flockerVehicle.setController(gameObject);
		}
	}
	
	void findDistances( )
	{
		float dist;
		for(int i = 0 ; i < numberOfFlockers; i++)
		{
			for( int j = i+1; j < numberOfFlockers; j++)
			{
				dist = Vector3.Distance(flockers[i].transform.position, flockers[j].transform.position);
				distances[i, j] = dist;
				distances[j, i] = dist;
			}
		}
	}
	
	public float getDistance(int i, int j)
	{
		return distances[i, j];
	}
	
	public void Update( )
	{
		findDistances( );
	}
}
