using UnityEngine;
using System.Collections;

public class GUI_Text : MonoBehaviour {

	TankHealth playerHP = null;
	TankHealth allyHP = null;
	public int numEnemies = 3;
	
	Color myColor;
	GUIText healthText;
	GUIText enemiesText;
	GUIText allyText;
	bool isUpdated = false;
	bool playerWin = false;
	bool playerLost = false;
	bool timeIsSet = false;
	float switchTime = 0.0f;
	
	// Use this for initialization
	void Start () 
	{
		playerHP = GameObject.Find("Player").GetComponent<TankHealth>();
		healthText = GameObject.Find("GUI HP").GetComponent<GUIText>();
		allyText = GameObject.Find("GUI allyHP").GetComponent<GUIText>();
		enemiesText = GameObject.Find("GUI numEnemies").GetComponent<GUIText>();
		myColor = Color.blue;
		healthText.material.color = myColor;
		enemiesText.material.color = myColor;
		allyText.material.color = myColor;
	}
	
	void getValues()
	{
		numEnemies = GameObject.Find("EnemySquad1").GetComponent<Controller>().numberOfFlockers;
		numEnemies += GameObject.Find("EnemySquad2").GetComponent<Controller>().numberOfFlockers;
		numEnemies += GameObject.Find("EnemySquad3").GetComponent<Controller>().numberOfFlockers;
		allyHP = GameObject.Find("SovietTank(Clone)").GetComponent<TankHealth>();
		isUpdated = true;
	}
	
	// Update is called once per frame
	void Update () 
	{
		if(playerHP != null)
			healthText.text = "Health: " + playerHP.health.ToString();
		else
		{
			healthText.text = "Health: 0";
			playerLost = true;
		}
		
		if(allyHP != null)
			allyText.text = "Ally HP: " + allyHP.health.ToString();
		else
			allyText.text = "Ally HP: 0";
		
		enemiesText.text = "Enemies: " + numEnemies.ToString();
		
		if(numEnemies == 0)
			playerWin = true;
		
		if(!isUpdated && Time.time < 0.5f && Time.time > 0.1f)
			getValues();
		
		if(!timeIsSet && (playerWin || playerLost))
		{
			switchTime = Time.time;
			timeIsSet = true;
		}
		//Debug.Log(Time.time - switchTime);
		if(playerWin && (Time.time - switchTime) >= 5.0f)
			Application.LoadLevel("WinScreen");
		if(playerLost && (Time.time - switchTime) >= 5.0f)
			Application.LoadLevel("LoseScreen");
	}
}
