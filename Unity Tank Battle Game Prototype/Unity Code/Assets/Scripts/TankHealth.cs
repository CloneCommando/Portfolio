using UnityEngine;
using System.Collections;

public class TankHealth : MonoBehaviour {
	
	public int health;
	public GameObject smoke;
	public GameObject fire;
	
	// Use this for initialization
	void Start () 
	{
	}
	
	// Update is called once per frame
	void Update () 
	{
		if(health <= 70 && health > 40)
			Instantiate(smoke,gameObject.transform.position - gameObject.transform.forward*20,Quaternion.identity);
		else if(health <= 40 && health > 1)
			Instantiate(fire,gameObject.transform.position - gameObject.transform.forward*20,Quaternion.identity);
	}
}
