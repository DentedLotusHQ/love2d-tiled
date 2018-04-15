## Configure busted testing framework
1) Install Busted. This wiil install luarocks package manager for our version of lua, and install the busted testing framework
    * `sudo chmod u+x install_busted.sh`
    * `sudo ./install_busted.sh`
1) Set up a task in VSCode to run the tests:
  ```json
  {
  "version": "2.0.0",
  "tasks": [
    {
      "label": "run",
      "type": "shell",
      "command": "love .",
      "group": {
        "kind": "build",
        "isDefault": true
        }
      },
      {
        "label": "test",
        "type":"shell",
        "command": "busted",
        "args": [
          "tests/**"
        ],
        "group":{
          "kind": "test",
          "isDefault": true
        }
      }
    ]
  }
  ```
  Pressing ctrl+shift+T will now prompt you to select a test task. Selecting test will run Busted on any file in `tests` that has the naming convention `*_spec.lua`
