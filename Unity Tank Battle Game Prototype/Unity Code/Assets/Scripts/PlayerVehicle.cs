using UnityEngine;
using System.Collections;

//directive to enforce that our parent Game Object has a Character Controller
[RequireComponent(typeof(CharacterController))]

public class PlayerVehicle : MonoBehaviour 
{
	private Camera mainCamera;
	
	private Camera skyCamera;
	
	private bool isInSky = false;
	
	public AudioClip turretFire;
	
	// The Character Controller of my Parent GameObject
	CharacterController characterController;
	
	private Vector3 moveDirection;
	
	public float gravity = 20.0f;
	
	public float forwardMoveSpeed;
	
	private Quaternion initialGunOrientation;
	
	private Quaternion initialCannonOrientation;
	
	private Quaternion initialOrientation;
	
	private float cummulativeGunRotation;
	
	private float cummulativeGunRotationY;
	
	private float cummulativeCannonRotation;
	
	private float cummulativeRotation;
	
	public float rotationFactor = 80.0f;
	
	public float turningFactor = 30.0f;
	
	// Terrain Following variables
	
	private Vector3 hitNormal = Vector3.up;
	
	private Vector3 myScout;
	
	public int scoutDistance = 20; // 20
	
	public float halfHeight = 4.0f;
	
	private RaycastHit rayInfo;
	
	private int layerMask = 1 << 8;
	
	private Vector3 lookAtPoint;
	
	public GameObject scoutObj;
	
	// Tank Variables
	
	private GameObject gun;
	
	private GameObject cannon;
	
	private GameObject tankShell;
	
	public GameObject projectile;
	
	private float firedTime = 0.0f;
	
	private bool musicIsOff = true;
	
	// Use this for initialization
	void Start () 
	{
		characterController = gameObject.GetComponent<CharacterController>();
		
		cannon = GameObject.Find("/Player/Cannon"); // NEEDS TO BE SWITCHED IF NOT PLAYER
		
		gun = GameObject.Find("/Player/Cannon/Gun");
		
		tankShell = GameObject.Find("/Player/Cannon/Gun/tankShell");
		
		//set our moveDirection initally to the vector (0, 0, 0)
		moveDirection = Vector3.zero;
		
		initialGunOrientation = gun.transform.rotation;
		initialCannonOrientation = cannon.transform.rotation;
		initialOrientation = transform.rotation;
		
		cummulativeCannonRotation = 0.0f;
		cummulativeRotation = 0.0f;
		cummulativeGunRotation = 0.0f;
		cummulativeGunRotationY = 0.0f;
		
		mainCamera = GameObject.Find("Main Camera").GetComponent<Camera>();
		skyCamera = GameObject.Find("Sky Camera").GetComponent<Camera>();
		
		GameObject.Find("/Player/Cannon").GetComponent<AudioSource>().volume = 0.0f;
		GameObject.Find("/Player/Cannon").GetComponent<AudioSource>().Play();
	}
	
	void OnControllerColliderHit(ControllerColliderHit hit)
	{
		hitNormal = hit.normal;
	}
	
	// Update is called once per frame
	void Update () 
	{	
		// For preventing screeching noise when music starts up for some reason
		if(musicIsOff && Time.time >= 0.5f)
		{
			GameObject.Find("/Player/Cannon").GetComponent<AudioSource>().volume = 0.5f;
			musicIsOff = false;
		}
		
		// Press the enter key to switch camera
		if(Input.GetKeyDown(KeyCode.P))
		{
			if(isInSky == false)
			{
				skyCamera.depth = 0;
				mainCamera.depth = -1;
			}
			else
			{
				skyCamera.depth = -1;
				mainCamera.depth = 0;
			}
			
			isInSky = !isInSky;
		}
		
		// Controls do not work if we are using the sky camera
		if(isInSky)
			return;
		
		// Used for rotating turret right or left
		if(Input.GetKey(KeyCode.RightArrow))
		{
			cummulativeCannonRotation +=  Time.deltaTime * rotationFactor;
			cummulativeGunRotationY +=  Time.deltaTime * rotationFactor;
		}
		else if(Input.GetKey(KeyCode.LeftArrow))
		{
			cummulativeCannonRotation -=  Time.deltaTime * rotationFactor;
			cummulativeGunRotationY -=  Time.deltaTime * rotationFactor;
		}
		
		// Used for rotating tank left or right
		if(Input.GetKey(KeyCode.D))
		{
			cummulativeRotation += Time.deltaTime * turningFactor;
			cummulativeCannonRotation +=  Time.deltaTime * rotationFactor;
			cummulativeGunRotationY +=  Time.deltaTime * rotationFactor;
		}
		else if(Input.GetKey(KeyCode.A))
		{
			cummulativeRotation -= Time.deltaTime * turningFactor;
			cummulativeCannonRotation -=  Time.deltaTime * rotationFactor;
			cummulativeGunRotationY -=  Time.deltaTime * rotationFactor;
		}
		
		Quaternion currentGunRotation = Quaternion.Euler(cummulativeGunRotation, cummulativeGunRotationY , 0.0f);
		
		Quaternion currentCannonRotation = Quaternion.Euler(0.0f, cummulativeCannonRotation, 0.0f);
		
		Quaternion currentRotation = Quaternion.Euler(0.0f, cummulativeRotation, 0.0f);
		
		transform.rotation = initialOrientation * currentRotation;
		cannon.transform.rotation =  initialCannonOrientation * currentCannonRotation;
		
		
		// Used for tank movement
		moveDirection.x = 0.0f;
		moveDirection.y = 0.0f;
		moveDirection.z = Input.GetAxis("Vertical");
		
		float oldMoveZ = moveDirection.z; // to correct up down turret controls
		
		// Used for moving the tank cannon up or down
		if(Input.GetKey(KeyCode.UpArrow) || Input.GetKeyUp(KeyCode.UpArrow)|| 
			Input.GetKey(KeyCode.DownArrow) || Input.GetKeyUp(KeyCode.DownArrow))
		{
			moveDirection.z = 0.0f;
			float angle = currentGunRotation.eulerAngles.x;
			if(angle >= 180)
				angle -= 360;
			
			if(Input.GetKey(KeyCode.UpArrow))
			{
				if(angle <= 20.0f)
					cummulativeGunRotation +=  Time.deltaTime * rotationFactor;
				if(Input.GetKey(KeyCode.W) || Input.GetKey(KeyCode.S))
					moveDirection.z = oldMoveZ;
			}
			
			if(Input.GetKey(KeyCode.DownArrow))
			{
				if(angle >= -2.0f)
					cummulativeGunRotation -=  Time.deltaTime * rotationFactor;
				if(Input.GetKey(KeyCode.W) || Input.GetKey(KeyCode.S))
					moveDirection.z = oldMoveZ;
			}
		}
		
		gun.transform.rotation = initialGunOrientation * currentGunRotation;
		
		float coolDownTime = Time.time - firedTime; // The amount of time it has been since we last fired
		
		if(firedTime == 0.0f)
			coolDownTime = 4.0f;
		
		// Fire a projectile!
		if (Input.GetKeyDown(KeyCode.Space) && coolDownTime >= 3.5f) 
		{	
			//Vector3 vec = tankShell.transform.forward;
			
			firedTime = Time.time;
			Vector3 pos = tankShell.transform.position;
			
			GameObject tankShellClone = (GameObject) Instantiate(projectile,pos , tankShell.transform.rotation);
			Rigidbody shellClonePhysics = tankShellClone.GetComponent<Rigidbody>();
			TankShell shellStats = tankShellClone.GetComponent<TankShell>();
			float speed = shellStats.speed;
			
			Physics.IgnoreCollision(tankShellClone.transform.root.collider, this.GetComponent<BoxCollider>());
			shellClonePhysics.velocity =  -gun.transform.forward * speed;
			
			audio.PlayOneShot(turretFire);
		}
		
		moveDirection = transform.TransformDirection(moveDirection);
		
		// apply forward speed
		moveDirection *= forwardMoveSpeed;
		
		moveDirection.y -= gravity;
		
		alignWithTerrain();
		
		characterController.Move(moveDirection * Time.deltaTime);
		
	}
	
	void alignWithTerrain()
	{
		myScout = transform.position + (transform.forward * scoutDistance);
		myScout.y += 1000;
		if(Physics.Raycast(myScout, Vector3.down, out rayInfo, Mathf.Infinity, layerMask)){
			lookAtPoint = rayInfo.point;
			myScout.y = lookAtPoint.y + halfHeight;
			transform.LookAt(myScout,hitNormal);
			scoutObj.transform.position = myScout;
		}
	}
	
	
	
}
