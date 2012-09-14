using UnityEngine;
using System.Collections;

public class Obstacle : MonoBehaviour {
	
	public float radius;
	private Vector3 position;
	
	public Vector3 Position { get{return position;}}
	
	// Use this for initialization
	void Start () {
		 position = transform.position;
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
