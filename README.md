# AI Usage

Using AI, machine learning, LLMs, etc. to create, complete, review, revise your programs is prohibited. Please review [the policy](https://docs.google.com/document/d/1FTTJo1v01HPq0dXpDwy-cNXdqnkTwELhqXaQvR6V2ZY/edit?tab=t.0#heading=h.fk8aiubtizzq) provided in the [course syllabus](https://docs.google.com/document/d/1FTTJo1v01HPq0dXpDwy-cNXdqnkTwELhqXaQvR6V2ZY/edit?usp=sharing).

Use of AI is a violation of the course's [Academic Integrity Policy](https://docs.google.com/document/d/1FTTJo1v01HPq0dXpDwy-cNXdqnkTwELhqXaQvR6V2ZY/edit?tab=t.0#heading=h.2os03sldo3cd) and students shall be sanctioned accordingly.

> Failure to follow the spirit of the academic honesty policy shall result in the following consequences:
> * A zero grade for the assignment at a minimum, a failing grade ('F') for the course in most cases. 
> * Your name, your actions, and the evidence collected shall be submitted to Student Affairs.
> * Student Affairs shall contact the department chair and levy their own disciplinary action.
>
> Students who earn a failing grade must repeat the course and may be placed on Academic Notice due to low GPA.

If in doubt, ask your instructor to clarify. Ignorance is not an explanation nor an excuse.

# Hello Dragon

## Objective

The objective of this exercise is to demonstrate familiarity with the DragonRuby runtime by completing some trivial objectives. Reading and following the examples given in [Building Games with DragonRuby](https://book.dragonriders.community) book is sufficient preparation to accomplish this exercise.

## Development Environment Requirements

You will need a `git` client and a text editor such as Microsoft Visual Studio Code.

The repository is self-contained. It includes binaries (executables) for Windows (amd64), Linux (amd64), and macOS (arm). The Linux binaries have the suffix `.linux`, the macOS binaries have the suffix `.macos`, and the Windows binaries have the traditional `.exe` extension.

No additional software or Gems are required to develop or run the project.

As a convenience, there is a polyglot script that can be used to run DragonRuby on all three platforms. The name of the script is `rundr.ps1`. If used, the script will identify the platform you are on and execute the appropriate binary for your platform. This script is provided as a convenience and no guarantee or warrant is given that it will work flawlessly.

## Getting Started

1. Fork and clone the repository.
1. Read the `README.md` and identify the requirements of the project
1. Edit the files in `mygame` to achieve the goals stated in the `README.md`.

A `Rakefile` is provided to help with linting. Unlike a Gem, a DragonRuby project typically does not have a `Rakefile` for testing and linting.

## Project Requirements

Achieve the following goals:

* The background color must be steel blue. Steel blue is [70, 130, 180] using the RGB color model where each value is between 0 and 255.

* Upon startup, the game should load the song Axel Funk which is in the file `mygame/sounds/Factor6_-_03_-_Axel_Funk.ogg`. The song must be set to repeat. The song does not restart when the game restarts.

* The `m` key pauses music playback.

* The `-` key lowers the volume and the `+` key raises the volume.

* The _player_ is represented by the dragon sprites, `mygame/sprites/misc/dragon-*.png`. Have the player appear in the center of the display. The arrow keys control the direction in which the dragon may fly. Have the dragon flap its wings continuously using the provided sprites. Rotate the dragon to face in the direction it flies. When resting (not flying) the dragon faces to the right. The dragon may not fly off the screen. The dragon's speed is 10. The player must be a class defined in `player.rb`.

* Every 3 seconds, spawn a cloud sprite using `mygame/sprites/nuvem.png`. The clouds travel from right to left. They are spawned off screen and travel at the same speed as the dragon from the right edge of the display and disappear past the left edge of the display. When the cloud disappears, it is removed from the game's state. A cloud may be a hash or a class.

* Place three squares in the display. The squares are represented by the red, green, and blue square sprites, `mygame/sprites/square/red.png`, `mygame/sprites/square/green.png`, `mygame/sprites/square/blue.png`. The squares may be placed anywhere in the display. The player cannot overlap with the squares. Whenever the player makes contact with a block, the short horn sound effect is played, `mygame/sounds/419698__14fvaltrovat__short-horn.wav`. The blocks may be a hash or a class.

* The game is a game object defined in `game.rb`. In `main.rb`, the game object is instantiated and the game object is given a pointer to `args`. From there, the game object has its own tick method. In the game object's tick method, the game sets defaults (initially), checks for input, calculates the game's state, and renders the game's display.

* Each game lasts 15 seconds. At the end of the game, the display is replaced with a label that says "Press the space bar to play again." Pressing the space bar restarts the game from the beginning.

* Draw a label in the upper left hand corner counting down the seconds from 15 to 0. The label color is white, [255, 255, 255] using the RGB color model where each value is between 0 and 255.

* The order in which the display is drawn is background (first), blocks, player, and label (last).

* Do not modify `main.rb`. 

## `TODO` Comments

If there is a comment that contains the string `TODO` then this is a hint that something needs to be done. The `TODO` comments contain instructions on what to do. Along with the corresponding tests in `mygame/app/test_*.rb`, a plan can be devised as to what needs to be done.

Once a `TODO` is completed, either change the `TODO` to `DONE`, remove `TODO:`, or remove the entire comment.

The TODO comments are there to help you complete the assignment and serve no other purpose.

## AUTHORS File

In order for your instructors to know who worked on the project, there is a file in your repository named `AUTHORS.txt` which shall contain each student's name, CSU email address, and GitHub user name. This file is located at the root level of your repository.

The file `AUTHORS.txt` is left empty so you may fill it in. Let's imagine your name is Tuffy Titan. Tuffy's email address is tuffy@csu.fullerton.edu. Tuffy's GitHub user name is `tuffytitan`. With this information, the contents of the `AUTHORS.txt` file will look like the following example:

```
Tuffy Titan
tuffy@csu.fullerton.edu
@tuffytitan
```

## Rubric

This exercise is worth 15 points. There is 1 part so there is a total of 15 points possible. Each program must interpret cleanly before it is graded. _Submissions that do not interpret cleanly shall be assigned a zero grade._ This means syntax errors or other errors that cause the program to fail shall not be graded.

A detailed rubric is assigned to each lab in Canvas. The rubric in Canvas will specify points and criteria.

Generally, each exercise part is assessed on at least two dimensions. The descriptions below serve as a general reminder of how exercises are assessed.

* Functionality (approximately 9 points): Your submission shall be assessed for the appropriate constructs and strategies to address the exercise. A program that passes the instructor's tests completely receives full marks for this dimension. A program that partially passes the instructor's tests receives partial-marks. A program that fails the majority or all the tests receives no marks.

* Format & Readability (approximately 6 points): Your submission shall be assessed by checking whether your code passes the style and format check, as well as how well it follows the proper naming conventions, and internal documentation guidelines. Git log messages are an integral part of how readable your project is. _Failure to include or complete an AUTHORS.txt file forfeits all marks. Failure to write clear and meaningful repository log messages shall forfeit all marks._

## Usage

To run the game, use the appropriate `dragonruby` binary (executable).

### macOS

```shell
./dragonruby.macos
```

### Linux

```shell
./dragonruby.linux
```

### Windows

```shell
.\dragonruby.exe
```

### Convenience Script

As a convenience, there is a polyglot script that can be used to run DragonRuby on all three platforms. The name of the script is `rundr.ps1`. If used, the script will identify the platform you are on and execute the appropriate binary for your platform. This script is provided as a convenience and no guarantee or warrant is given that it will work flawlessly.

```shell
# mac & Linux
./rundr.ps1
# Windows
.\rundr.ps1
```

If you use this script on Windows, be aware that the Execution Policy on Windows may not allow this script to run. Should you wish, you can change the Execution Policy to something more permissive. Making such a change can leave your computer in a vulnerable state and should only be done by a student who understands the risks.

## Project Layout

```
AUTHORS.txt              your name, CSU email and @github-user
dragonruby.*             DragonRuby for each platform
rundr.ps1                runs the right DragonRuby for your platform
mygame/
  Rakefile               style check and test tasks
  app/main.rb            DragonRuby's entry point; do not modify
  app/game.rb            the Game class; your work goes here
  app/player.rb          the dragon (solution only)
  app/test_authors.rb    tests for AUTHORS.txt
  sounds/                music and sound effects
  sprites/               images
```

## Development

A `Rakefile` is provided in `mygame`. Run these from inside `mygame`.

```bash
rake --tasks     # list tasks
rake test        # run tests
rake rubocop     # style check
rake             # rubocop and test
```

Style is enforced with RuboCop.

Tests are files named `mygame/app/test_*.rb`. DragonRuby does not include Minitest, so tests use DragonRuby's own test runner instead: every top-level method whose name starts with `test_` is called with `args` and `assert`. See `mygame/app/test_authors.rb` for an example. Students are encouraged to write their own tests. To run one test file without `rake`, start DragonRuby from the top of the repository:

```shell
# mac & Linux
./rundr.ps1 mygame --test app/test_authors.rb --no-tick
# Windows
.\rundr.ps1 mygame --test app\test_authors.rb --no-tick
```

# Assets

* [nuvem.png](https://opengameart.org/content/cloud-2) by Ian Peter retrieved 2026-10-25
* [Short-horn.wav by 14FValtrovaT](https://freesound.org/people/14FValtrovaT/sounds/419698/) retrieved 2026-10-25
* [Axel Funk](https://archive.org/details/ZX_Spectrum_is_Alive-4030/Factor6_-_03_-_Axel_Funk.mp3) by Factor 6 from [ZX Spectrum is Alive](https://archive.org/details/ZX_Spectrum_is_Alive-4030)
