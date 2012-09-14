using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class EnviromentController : MonoBehaviour 
{
	public Object treePrefab;
	// list of trees
	private List<GameObject> trees = new List<GameObject>();
	public List<GameObject> Trees {get{return trees;} set{trees = value;}}
	
	public int numOfTrees;
	public bool isFinished = false;
	
	private RaycastHit rayInfo;
	private int layerMask = 1 << 8;
	public float radius = 14.0f;
	public float safeDist = 25.0f;
	
	// Use this for initialization
	void Start () 
	{
		for(int i = 0; i < numOfTrees; i++)
		{	
			// Randomly generate a position for the tree
			float xPos = Random.Range(250,2750);
			float zPos = Random.Range(250,2750);
			float yPos = 500.0f;
			Vector3 posVec = new Vector3(xPos, yPos, zPos);
			
			// Raycast to get height of terrain below tree to place it ad correct height
			if(Physics.Raycast(posVec, Vector3.down, out rayInfo, Mathf.Infinity, layerMask))
				posVec.y = rayInfo.point.y;
			
			// Create an instance of the tree at the correct position
			GameObject myTree = (GameObject) Instantiate(treePrefab, posVec, Quaternion.identity);
			
			trees.Add(myTree);
		}
		
		// We have finished adding trees to our list
		isFinished = true;
	}
	
	// Update is called once per frame
	void Update () 
	{
	
	}
}
