Thomas Colligan

Final Project Documentation


Date: February 2012
Course: 4002-542-01 Native App Dev iPhone



Note: This is a prototype for a game that I made as an individual project in my intro iPhone Development Class. 
Time spent in development: ~28hrs.




Product Definition Statement: Math Mage is an educational math game targeted at Elementary and Jr. High School students, however 
anyone who wants to practice their basic math skills can play it as well.




Features Implemented:


Multiple Choice Math test system that obtains its questions from a plist
Wizards and enemies that animate and 
attack each other
Ability to create your own persistent Custom Math Test
Has a persistent High Scores and Best Times list that updates 
when appropriate
.

Difficult Level system implemented: Easy, Normal, or Hard


Options data is persistent and saved to a plist :Audio Level and Difficulty level
Sounds play during certain key events




Code Description:



Models
CustomTestData: Uses Singleton design pattern to save and retrieve data relating to Custom Tests that the user has created


GameData: Uses Singleton design pattern to save and retrieve data relating to High Scores, Best Times, Audio Level, and Difficulty level


MathTest: Loads the plist of Math questions and creates a structured Math test, using a queue to feed the next question of the Test when needed. 
Also generates multiple choice answers to each question.


SoundManager: Manages the loading and playing of all sounds throughout the app 


SpriteAnimator: Creates and positions all sprite animation related items

View 

Controllers
CustomizedTestVC: Generates a scrollable view that allows the user to create their own custom test


CustomTestSelectionVC: Allows the user to choose from a list of the Custom Tests they have created to be Quizzed on


GameScreenVC: Where the majority of the work is done. Handles all of the gameplay logic such as which animations to pay, checking if 
an answer to a question is correct or not, making the timer count down, making buttons and labels fly across the screen at appropriate times, etc...


HighScoresVC: Displays the High Scores and Best times to the user


InstructionsVC: Displays the Instruction text that informs that player how to play the game 


MainMenuVC: The first screen that you see after the game loads, displays all the possible things you can do in the app such as play a game, create a custom test, view 
your high scores, alter the games options, etc...


OptionsVC: Displays the games configurable options such as game difficulty level and audio level, and lets you alter them to your preferences


TestSelectionVC: Displayed after you choose to play a game, show a list of possible test types you can take including: Addition, Subtraction, Multiplication, 
Division, Mixed, and Custom



Delegate
MathMageAppDelegate: Pushes the MainMenuVC onto the screen.





Sources:



Sounds:


Buzzer -  http://soundfxnow.com/soundfx/Buzzer2.mp3
Ding -  http://soundfxnow.com/soundfx/GameshowBellDing1.mp3


All other Sounds I created using Logic Pro 9



Images:


Chalkboard Image:  http://georgesrestaurant.com/?attachment_id=22


All other images I created using Photoshop

