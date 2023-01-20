## Usage

`nix develop .#monado-basic` for monado and steamvr driver with support for lighthouse headsets, maybe

`nix develop .#monado-slam-handtracking` for monado and steamvr driver with support for headsets needing slam tracking and hand tracking

### Testing your headset

Run `monado-cli` probe to check 

### SteamVR usage

Do not run `monado-service` in the dev shell.

Run `monado-steamvr-bodge` in the dev shell to bodge your steam libs and register the driver, then launch steam from the dev shell.

You need controllers for this, steamvr will not allow you to complete room setup if you only have hand tracking.

### OpenXR usage

Run `monado-service` in the dev shell.

Run an openxr application in another instance of the dev shell.