using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class AllyVehicle : MonoBehaviour 
{
	//which flocker are we?
	//keep it safe from being editable in the editor by using a property
	private int index = -1;
	public int Index{ get{ return index; } set{index = value;}}
	
	//our controller and characterController
	private AllyController flockController = null;
	private EnviromentController envController = null;
	private CharacterController myCharacterController = null;
	
	//movement variables
	private bool grounded = false;
	private float speed = 0.0f;
	private float gravity = 20.0f;
	private Vector3 moveDirection;
	
	//steering variables
	private Vector3 steeringForce;
	private GameObject target = null;
	
	//wander variables
	private float wanderRad = 10.0f;
	private float wanderAng = 0.0f;
	private float wanderDist = 20.0f;
	private float wanderMax = 2.0f;
	
	//flock variables
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
	
	// For AI firing
	private GameObject tankShell;
	public GameObject projectile;
	private float firedTime = 0.0f;
	public AudioClip turretFire;
	private float inRangeDist = 250.0f;
	private bool isInRange = false;
	private float threatDist = 350.0f;
	private float orgPathWeight;
	private float pathWeight;
	private GameObject enemyTarget = null;
	private List<GameObject> enemies = new List<GameObject>();
	private float orgLeaderWt;
	private float followLeaderWt;
	
	public void setController(GameObject inControllerGO)
	{
		flockController = inControllerGO.GetComponent<AllyController>();
	}
	
	public void Start()
	{
		//get component reference
		myCharacterController = gameObject.GetComponent<CharacterController>();
		myCharacterController.slopeLimit = 56.0f;
		moveDirection = transform.forward;
		
		if(!target)
		{
			target = flockController.leader;
		}
		if(!target)
		{
			Debug.LogError("No target set for leader!");
		}
		
		followLeaderWt = flockController.followLeaderWt;
		orgLeaderWt = followLeaderWt;
		
		envController = GameObject.Find("EnviromentController").GetComponent<EnviromentController>();
		tankShell = (transform.FindChild("Cannon/tankShell")).gameObject;
		
		enemies = GameObject.Find("EnemySquad1").GetComponent<Controller>().Flockers;
		List<GameObject> enemyList2 = GameObject.Find("EnemySquad2").GetComponent<Controller>().Flockers;
		List<GameObject> enemyList3 = GameObject.Find("EnemySquad3").GetComponent<Controller>().Flockers;
		
		for(int i = 0; i < enemyList2.Count; i++)
			enemies.Add(enemyList2[i]);
		
		for(int i = 0; i < enemyList3.Count; i++)
			enemies.Add(enemyList3[i]);	
	}
	
	private Vector3 findEnemy()
	{
		float closeDist = 10000.0f;
		GameObject target = null;
		Vector3 forces = Vector3.zero;
		float dist;
		// Finds the closest enemy
		for(int i = 0; i < enemies.Count; i++)
		{
			if(enemies[i] != null)
			{
				dist = Vector3.Distance(gameObject.transform.position, enemies[i].transform.position);
				
				if(dist < closeDist)
				{
					closeDist = dist;
					target = enemies[i];
				}
			}
		}
		// If we are not within threat range, dont bother
		if(closeDist >= threatDist)
		{
			target = null;
			followLeaderWt = orgLeaderWt;
		}
		
		if(target == null)
		{
			isInRange = false;
			return Vector3.zero;
		}
		else
		{
			enemyTarget = target;
			followLeaderWt = 0;
			// seek the target to get in range of him
			if(closeDist >= inRangeDist-50)
				forces += seek(target.transform.position);
			
			// we are in rang of firing if within +-100 of inRangeDist
			if(closeDist <= inRangeDist + 100)
				isInRange = true;
			else
				isInRange = false;
		}
		
		if(forces.magnitude == 0.0f)
		{
			alignWithEnemy(target);
		}
		
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
		
		if(coolDownTime >= 3.5)
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
	
	private Vector3 ObstacleAvoidance()
	{
		Vector3 force = Vector3.zero;
		
		for(int i = 0; i < flockController.Obstacles.Count; i++)
		{
			Obstacle obst = flockController.Obstacles[i].GetComponent<Obstacle>();
			
			force += Avoid(obst.Position, obst.radius, flockController.avoidDist);
		}
		
		return force;
	}
	
	private Vector3 TankAvoidance()
	{
		Vector3 force = Vector3.zero;
		
		for(int i = 0; i < flockController.Flockers.Count; i++)
		{
			Vehicle obst = flockController.Flockers[i].GetComponent<Vehicle>();
			
			if(obst.Index != this.Index) // make sure that we do not avoid ourself
				force += Avoid(obst.transform.position, obst.radius, flockController.avoidDist);
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
	
	private Vector3 arrival(Vector3 pos, float arrivalDistance)
	{
		Vector3 dv = pos - transform.position;
		dv.y = 0;
		float dist = dv.magnitude;
		dv = dv.normalized * flockController.maxSpeed * (dist/arrivalDistance);
		dv -= transform.forward * speed;
		
		return dv;
	}
	
	private Vector3 followTheLeader()
	{
		Vector3 forces = Vector3.zero;
		
		Vector3 behindLeader = target.transform.position - (target.transform.forward * speed);
		
		forces += arrival(behindLeader, 80);
		
		// Stop when we get close enough
		if(forces.magnitude <= flockController.maxSpeed + 10)
			forces = Vector3.zero;
		
		return forces;
	}
	
	void alignWithTerrain()
	{
		myScout = transform.position + (transform.forward * scoutDistance);
		myScout.y += 1000;
		if(Physics.Raycast(myScout, Vector3.down, out rayInfo, Mathf.Infinity, layerMask)){
			lookAtPoint = rayInfo.point;
			hitNormal = rayInfo.normal;
			myScout.y = lookAtPoint.y + halfHeight;
			transform.LookAt(myScout,hitNormal);
		}
	}
	
	// Update is called once per frame
	public void FixedUpdate ()
	{
		target = flockController.leader;
		
		if(isAdded == false && envController.isFinished == true)
		{
			isAdded = true;
			treeObstacles = envController.Trees;
		}
		
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
		steeringForce += flockController.wanderWt * wander( );
	    //steeringForce += flockController.inBoundsWt * stayInBounds( );		
 		//steeringForce += flockController.targetWt * seek(target.transform);
		steeringForce += flockController.separationWt * Separation();
		//steeringForce += flockController.avoidWt * ObstacleAvoidance();
		//steeringForce += flockController.avoidWt * TankAvoidance();
		steeringForce += flockController.avoidWt * TreeAvoidance();
		steeringForce += followLeaderWt * followTheLeader();
		steeringForce += flockController.seekEnemyWt * findEnemy();
	}
}
