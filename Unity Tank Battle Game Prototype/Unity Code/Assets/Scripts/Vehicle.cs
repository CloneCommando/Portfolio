using UnityEngine;
using System.Collections;
//including some .NET for dynamic arrays called List in C#
using System.Collections.Generic;

public class Vehicle : MonoBehaviour 
{
	//which flocker are we?
	//keep it safe from being editable in the editor by using a property
	private int index = -1;
	public int Index{ get{ return index; } set{index = value;}}
	
	//our controller and characterController
	private Controller flockController = null;
	private EnviromentController envController = null;
	private CharacterController myCharacterController = null;
	private List<GameObject> enemies = new List<GameObject>();
	
	//movement variables
	private bool grounded = false;
	private float speed = 0.0f;
	private float gravity = 20.0f;
	private Vector3 moveDirection;
	
	//steering variables
	private Vector3 steeringForce;
	private Waypoint target = null;
	
	//wander variables
	private float wanderRad = 10.0f;
	private float wanderAng = 0.0f;
	private float wanderDist = 20.0f;
	private float wanderMax = 2.0f;
	
	//flock variables
	private Vector3 centroid;
	private Vector3 flockDirection;
	private Vector3 redDot;
	
	//list of nearby flockers
	private List<GameObject> nearFlockers = new List<GameObject>();
	private List<float> nearFlockersDistances = new List<float>();
	
	// radius for avoid function
	public float radius;
	
	//raycasting for terrain following
	private Vector3 myScout;
	private RaycastHit rayInfo;
	private int layerMask = 1 << 8;
	private Vector3 lookAtPoint;
	public float scoutDistance = 20;
	public float halfHeight = 4.0f;
	private Vector3 hitNormal = Vector3.up;
	
	// list of tree obstacles
	private List<GameObject> treeObstacles = new List<GameObject>();
	private bool isAdded = false;
	
	public string Squad;
	
	// prepositioned tankShell
	private GameObject tankShell;
	public GameObject projectile;
	private float firedTime = 0.0f;
	public AudioClip turretFire;
	private float inRangeDist = 300.0f;
	private bool isInRange = false;
	private float threatDist = 400.0f;
	private float orgPathWeight;
	private float pathWeight;
	private GameObject enemyTarget = null;
	
	public void setController(GameObject inControllerGO)
	{
		flockController = inControllerGO.GetComponent<Controller>();
	}
	
	public void Start()
	{
		//get component reference
		myCharacterController = gameObject.GetComponent<CharacterController>();
		myCharacterController.slopeLimit = 56.0f;
	 
		moveDirection = transform.forward;
		
		if(!target)
		{
			GameObject path = GameObject.Find(flockController.myPath);
			FollowPath p1 = path.GetComponent<FollowPath>();
			target = p1.startingPoint.GetComponent<Waypoint>();
		}
		if(!target)
		{
			Debug.LogError("No target set!");
		}
		
		envController = GameObject.Find("EnviromentController").GetComponent<EnviromentController>();
		tankShell = (transform.FindChild("Cannon/tankShell")).gameObject;
		
		enemies = GameObject.Find("FriendlyController").GetComponent<AllyController>().Flockers;
		enemies.Add(GameObject.Find("FriendlyController").GetComponent<AllyController>().leader);
		orgPathWeight = flockController.pathWeight;
		pathWeight = flockController.pathWeight;
	}
	
	public void resetPlayerEnemy()
	{
		for(int i = 0; i < enemies.Count; i++)
		{
			string name = enemies[i].name;
			
			if(name == "Player")
				enemies[i] = new GameObject("DeadPlayer");
		}
	}
	
	private Vector3 findEnemy()
	{
		float closeDist = 10000.0f;
		GameObject target = null;
		Vector3 forces = Vector3.zero;
		
		// Finds the closest enemy
		for(int i = 0; i < enemies.Count; i++)
		{
			float dist = Vector3.Distance(gameObject.transform.position, enemies[i].transform.position);
			
			if(dist < closeDist)
			{
				closeDist = dist;
				target = enemies[i];
			}
		}
		// If we are not within threat range, dont bother
		if(closeDist >= threatDist)
		{
			pathWeight = orgPathWeight;
			target = null;
		}
		
		if(target == null)
		{
			isInRange = false;
			speed = flockController.maxSpeed;
			return Vector3.zero;
		}
		else
		{
			enemyTarget = target;
			pathWeight = 0;
			// seek the target to get in range of him
			if(closeDist >= inRangeDist-50)
				forces += seek(target.transform.position);
			
			// we are in rang of firing if within +-50 of inRangeDist
			if(closeDist <= inRangeDist + 100)
				isInRange = true;
			else
				isInRange = false;
		}
		
		if(forces.magnitude == 0.0f)
		{
			speed = 0;
			alignWithEnemy(target);
		}
		else
			speed = flockController.maxSpeed;
		
		return forces;
	}
	
	private void alignWithEnemy(GameObject enemy)
	{
		Vector3 vec = enemy.transform.position - gameObject.transform.position;
		float rightDotVTOC = Vector3.Dot(vec, this.gameObject.transform.right);
		
		float rotateRate = 10.0f;
		
		if(rightDotVTOC > 0)
			gameObject.transform.Rotate(Vector3.up, rotateRate * Time.deltaTime);
		else
			gameObject.transform.Rotate(Vector3.up, -rotateRate * Time.deltaTime);
	}
	
	private void fireShell()
	{
		float coolDownTime = Time.time - firedTime;
		
		if(coolDownTime >= 4.0)
		{
			firedTime = Time.time;
			Vector3 pos = tankShell.transform.position;
			
			GameObject tankShellClone = (GameObject) Instantiate(projectile, pos, tankShell.transform.rotation);
			Rigidbody shellClonePhysics = tankShellClone.GetComponent<Rigidbody>();
			TankShell shellStats = tankShellClone.GetComponent<TankShell>();
			float speed = shellStats.speed;
			
			Physics.IgnoreCollision(tankShellClone.transform.root.collider, this.GetComponent<BoxCollider>());
			shellClonePhysics.velocity = gameObject.transform.forward * speed;
			
			audio.PlayOneShot(turretFire);
		}	
	}
	
	private Vector3 TankAvoidance()
	{
		Vector3 force = Vector3.zero;
		
		for(int i = 0; i < flockController.Flockers.Count; i++)
		{
			if((GameObject)flockController.Flockers[i]!= null && 
				((GameObject)flockController.Flockers[i]).name != "Empty")
			{	
				Vehicle obst = flockController.Flockers[i].GetComponent<Vehicle>();
				
				if(obst.Index != this.Index) // make sure that we do not avoid ourself
				force += Avoid(obst.transform.position, obst.radius, flockController.avoidDist);
			}
		}
		
		return force;
	}
	
	private Vector3 TreeAvoidance()
	{
		Vector3 force = Vector3.zero;
		
		for(int i = 0; i < treeObstacles.Count; i++)
		{
			GameObject obst = (GameObject) treeObstacles[i];
			
			force += Avoid(obst.transform.position, envController.radius, envController.safeDist);
		}
		
		return force;
	}
	
	private Vector3 Avoid(Vector3 obstaclePos, float obstacleRadius, float safeDistance)
	{
		Vector3 vectorToObstacleCenter = obstaclePos - transform.position;
		vectorToObstacleCenter.y = 0;
		
		float distance = vectorToObstacleCenter.magnitude;
		
		// Too far away to worry about
		if(distance - obstacleRadius > safeDistance)
			return Vector3.zero;
		
		// Object is behind us so don't worry about it
		if(Vector3.Dot(transform.forward, vectorToObstacleCenter) < 0)
			return Vector3.zero;
		
		float rightDotVTOC = Vector3.Dot(vectorToObstacleCenter, transform.right);
		
		// The radii  of the two objects are not intersecting
		if(obstacleRadius + radius < Mathf.Abs(rightDotVTOC))
			return Vector3.zero;
		
		Vector3 desVel = Vector3.zero;
		
		if(rightDotVTOC > 0)
			desVel = transform.right * (-flockController.maxSpeed * (safeDistance/distance));
		else
			desVel = transform.right * (flockController.maxSpeed * (safeDistance/distance));
			
		
		return desVel - (transform.forward * speed);
		
	}
	
	private Vector3 Separation ( )
	{
		nearFlockers = new List<GameObject>();
		nearFlockersDistances = new List<float>();
		
		for(int i = 0; i < flockController.numberOfFlockers; i++)
		{
			if(Index != i)//Dont count ourselves
			{
				float dist = flockController.getDistance(Index,i); // Distance between flocker and other flockers
				
				if(dist < flockController.separationDist)// Closer than seperation distance
				{
					nearFlockers.Add((GameObject)flockController.Flockers[i]);
					nearFlockersDistances.Add(dist);
				}
			}
		}
		
		Vector3 steeringForce = Vector3.zero;
		
		for(int j = 0; j < nearFlockers.Count; j++)
		{
			Vector3 vectAway = flockController.Flockers[Index].transform.position - 
				nearFlockers[j].transform.position; // Vector away from near Flockers
			vectAway.y = 0;
			
			vectAway.Normalize();
			
			steeringForce += (1/nearFlockersDistances[j]) * vectAway; // sum vectors with inverse distances
		}
		
		steeringForce.Normalize();
		steeringForce *= flockController.maxSpeed;
		steeringForce -= transform.forward * speed;
		
		return steeringForce;
	}
	
	private Vector3 Alignment( )
	{
		// Desired Velocity - Current Velocity
		return (flockDirection* flockController.maxForce) - (transform.forward * speed);
	}
	
	private Vector3 Cohesion( ) 
	{
		return seek(centroid);
	}
	
	private Vector3 wander( )
	{
		wanderAng += (Random.value * wanderMax * 2 - wanderMax);
		
		Vector3 redDot = transform.position + (transform.forward * wanderDist);
		redDot.y = 0;
		
		Vector3 offset = transform.forward * wanderRad;
		offset.y = 0;
		
		Quaternion quat = Quaternion.AngleAxis(wanderAng, transform.up);
		offset = quat * offset;
		
		redDot += offset;
		
		return seek(redDot);
	}
		
	private void ClampSteering( )
	{
		if (steeringForce.magnitude > flockController.maxForce)
		{
			steeringForce.Normalize( );
			steeringForce *= flockController.maxForce;
		}		
	}
	
	private Vector3 seek(Vector3 pos)
	{
		Vector3 dv = pos - transform.position;
		dv.y =0;
	 	dv = dv.normalized * flockController.maxForce;
	 	dv -= transform.forward * speed;
	 	return dv;
	}
	
	private Vector3 seek(Transform trans) 
	{
		return seek(trans.position);
	}
		
	private Vector3 flee(GameObject go) 
	{
		Vector3 dv = go.transform.position - transform.position * -1;
		dv.y = 0;
		dv = dv.normalized * flockController.maxForce;
	 	dv -= transform.forward * speed;
	 	return dv;
	}
	
	private Vector3 followPath(Waypoint myPoint)
	{
		// If we have arrived at the Waypoint we were seeking, go to the next one
		if(myPoint.hasArrived(transform.position))
		{
			myPoint = myPoint.nextWaypoint;
			target = myPoint;
		}
		
		return seek(myPoint.Position);
	}
	
	void alignWithTerrain()
	{
		myScout = transform.position + (transform.forward * scoutDistance);
		myScout.y += 1000;
		if(Physics.Raycast(myScout, Vector3.down, out rayInfo, Mathf.Infinity, layerMask)){
			lookAtPoint = rayInfo.point;
			myScout.y = lookAtPoint.y + halfHeight;
			transform.LookAt(myScout,hitNormal);
		}
	}
	
	// Update is called once per frame
	public void FixedUpdate ()
	{
		if(isAdded == false && envController.isFinished == true)
		{
			isAdded = true;
			treeObstacles = envController.Trees;
		}
		
		centroid = flockController.Centroid;
		flockDirection =  flockController.FlockDirection;
		
		if(grounded)
		{
			CalcSteeringForce( );
			ClampSteering();

			moveDirection = transform.forward;
			// movedirection equals velocity
			moveDirection *= speed;

			//add acceleration
			moveDirection += steeringForce* Time.deltaTime;//modified for dt
			//update speed
			speed = moveDirection.magnitude;
			if (speed > flockController.maxSpeed) 
			{
				speed = flockController.maxSpeed;
				moveDirection = moveDirection.normalized * flockController.maxSpeed;
			}
			//orient transform
			if  (moveDirection != Vector3.zero) transform.forward = moveDirection;
		}
		
		// Apply gravity
	 	moveDirection.y -= gravity * Time.deltaTime;
		CollisionFlags flags = myCharacterController.Move(moveDirection * Time.deltaTime);
		grounded = (flags & CollisionFlags.CollidedBelow) != 0;
		
		alignWithTerrain();
		
		// if we are in range
		if(isInRange)
		{
			Vector3 vec = enemyTarget.transform.position - gameObject.transform.position;
			float frontDotVTOC = Vector3.Dot(vec, this.gameObject.transform.forward);
			
			// if the enemy is in front of us
			if(frontDotVTOC >= 0)
				fireShell();
		}

	}
	
	private void CalcSteeringForce( )
	{
		steeringForce = Vector3.zero;
		//steeringForce += flockController.wanderWt * wander( );
    	//steeringForce += flockController.alignmentWt * Alignment( );
		//steeringForce += flockController.cohesionWt * Cohesion( );		
		steeringForce += flockController.avoidWt * TankAvoidance();
		steeringForce += flockController.avoidWt * TreeAvoidance();
		steeringForce += pathWeight * followPath(target);
		steeringForce += flockController.seekEnemyWt * findEnemy();
	}
		
}

