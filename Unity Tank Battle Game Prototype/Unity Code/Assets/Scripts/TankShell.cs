using UnityEngine;
using System.Collections;

public class TankShell : MonoBehaviour {

	private GUI_Text managerText;
	public GameObject explosion;
	public GameObject largeExplosion;
	private AllyController allyController;
	private Controller enemyController1;
	private Controller enemyController2;
	private Controller enemyController3;
	private float destroyedTime = 0.0f;
	public AudioClip explodeSound;
	public GameObject smokeCloud;
	public float speed;
	
	// Use this for initialization
	void Start () 
	{
		allyController = GameObject.Find("FriendlyController").GetComponent<AllyController>();
		enemyController1 = GameObject.Find("EnemySquad1").GetComponent<Controller>();
		enemyController2 = GameObject.Find("EnemySquad2").GetComponent<Controller>();
		enemyController3 = GameObject.Find("EnemySquad3").GetComponent<Controller>();
		managerText = GameObject.Find("GameManager").GetComponent<GUI_Text>();
	}
	
	// Update is called once per frame
	void Update () 
	{	
		if(destroyedTime == 0.0f)
		{
			GameObject smokeObj = (GameObject) Instantiate(smokeCloud, gameObject.transform.position, Quaternion.identity);
			smokeObj.GetComponent<DetonatorSmoke>().size = 0.5f;
		}
		
		// Make sure the smoke doesnt disappear right away
		if(destroyedTime != 0.0f)
		{
			float elapsedTime = Time.time - destroyedTime;
			if(elapsedTime >= 3.0f)
				Destroy(gameObject);	
		}
	}
	
	void OnCollisionEnter(Collision hit)
	{
		// Make the projectile explode
		Instantiate(explosion, this.transform.position , Quaternion.identity);
		destroyedTime = Time.time;
		// Remove these components to allow smoke to continue put projectile to disappear
		Destroy(gameObject.GetComponent<MeshRenderer>());
		Destroy(gameObject.GetComponent<Rigidbody>());
		Destroy(gameObject.GetComponent<SphereCollider>());
		audio.PlayOneShot(explodeSound);
		
		if(hit.collider.name == "SovietTank(Clone)" || hit.collider.name == "Panzer(Clone)" ||
			hit.collider.name == "Player")
		{
			
			TankHealth tankHp = hit.gameObject.GetComponent<TankHealth>();
			tankHp.health -= 25;
			
			// The tank the projectile hit was destroyed
			if(tankHp.health <= 0)
			{
				if(hit.collider.name == "SovietTank(Clone)")
				{
					AllyVehicle otherTank = hit.gameObject.GetComponent<AllyVehicle>();
					int index = otherTank.Index;
					allyController.Flockers[index] = new GameObject("Empty");
				}
				else if(hit.collider.name == "Panzer(Clone)")
				{
					Vehicle otherTank = hit.gameObject.GetComponent<Vehicle>();
					int index = otherTank.Index;
					
					if(otherTank.Squad == "Squad1")
						enemyController1.Flockers[index] = new GameObject("Empty");
					else if(otherTank.Squad == "Squad2")
						enemyController2.Flockers[index] = new GameObject("Empty");
					else if(otherTank.Squad == "Squad3")
						enemyController3.Flockers[index] = new GameObject("Empty");
					
					managerText.numEnemies --; // Go to our GUI and subtract 1 enemy
				}
				else if(hit.collider.name == "Player")
				{
					allyController.leader = new GameObject();
					enemyController1.killPlayerReference();
					enemyController2.killPlayerReference();
					enemyController3.killPlayerReference();
				}
				Instantiate(largeExplosion, hit.gameObject.transform.position , Quaternion.identity);
				Destroy(hit.gameObject);
			}
				
		}
	}
}
