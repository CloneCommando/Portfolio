using UnityEngine;
using System.Collections;
//including some .NET for dynamic arrays called List in C#
using System.Collections.Generic;

public class Controller : MonoBehaviour
{
	//Flocking code weight parameters
	//set in editor for all flock members
	//if initialized here editor will override settings
	public float wanderWt;
	public float targetWt;
	public float pathWeight;
	public float cohesionWt;
	public float alignmentWt;
	public float separationWt;
	public float separationDist;
	public float avoidDist;
	public float maxForce;
	public float maxSpeed;
	public int numberOfFlockers;
	public float inBoundsWt;
	public float avoidWt;
	public float seekEnemyWt;
	
	// String for the path they will follow
	public string myPath;
	public string Squad;
	
	//needs to be set in editor to promote reusability.
	public Object flockerPrefab;
	public GameObject centroidLocator;
	
	//calculated by controller on update
	private Vector3 flockDirection;
	private Vector3 centroid;
	
	//accessors
	public Vector3 FlockDirection { get {return flockDirection;} }
	public Vector3 Centroid { get {return centroid; } }
	
	// list of flockers
	private List<GameObject> flockers = new List<GameObject>();
	public List<GameObject> Flockers {get{return flockers;}set{flockers = value;}}
	
	
	//this is a 2D C# array for distances
	private float[,] distances;

	public void Start()
	{
		//construct our 2d array based on the value set, do it here so it can be
		//set in editor.
		distances = new float[numberOfFlockers, numberOfFlockers];
		//reference to Vehicle script component for each flocker
		Vehicle flockerVehicle;
		
		// Adds flockers
		for(int i = 0; i < numberOfFlockers; i++)
		{
			//Instantiate a flocker prefab, catch the reference, cast it to a GameObject
			//and add it to our list all in one line.
			flockers.Add( (GameObject) Instantiate(flockerPrefab, new Vector3(800+ 100*i, 45, 400 ), Quaternion.identity) ) ;
			//grab a component reference
			flockerVehicle = flockers[i].GetComponent<Vehicle>();
			//set values in the Vehicle script
			flockerVehicle.Index = i;
			flockerVehicle.Squad = this.Squad;
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
	
	// Call this when the player is killed
	public void killPlayerReference()
	{
		for(int i = 0; i < flockers.Count; i++)
		{
			if(flockers[i]!= null && flockers[i].name != "Empty")
				(flockers[i].GetComponent<Vehicle>()).resetPlayerEnemy();	
		}
	}
	
	public float getDistance(int i, int j)
	{
		return distances[i, j];
	}
	
	public void Update( )
	{
		setCentroid( );
		setFlockDirection( );
		findDistances( );
	}
		
	private void setCentroid( )
	{
		centroid = Vector3.zero;
		for( int i = 0; i < numberOfFlockers; i++)
		{
			centroid += flockers[i].transform.position;
		}
		centroid = centroid/numberOfFlockers;
		//put us at the center of the action
		if(numberOfFlockers != 0)
			centroidLocator.transform.position = centroid;
	}
	
	private void setFlockDirection( )
	{
		flockDirection = Vector3.zero;
		for (int i = 0; i < numberOfFlockers; i++)
		{
			flockDirection += flockers[i].transform.forward;
		}
		flockDirection.Normalize( );		
	}
}