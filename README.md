# Autonomous Driving Control Software of TUM Roborace Team
### Overview
This software stack has been developed and used for the Roborace Event at the Berlin Formula-E Track 2018. It achieved approximately 150kph and 80% of the combined lateral and longitudinal acceleration potential of the DevBot. The overall research project is a joint effort of the Chair of Automotive Technology and the Chair of Automatic Control.

This software component covers the trajectory tracking, state estimation and vehicle dynamics control aspects of the stack. It takes trajectories from the planner as the main input and delivers appropriate steering, powertrain and brake commands. Furthermore, it handles vehicle startup and emergency brake situations. The main functional components are depicted in this architecture diagram:

![Control Architecture](control_architecture.png)

A video of the performance at the Berlin track can be found [here](https://www.youtube.com/watch?v=7NGEM5jcXV4). More information and current updates on the project status are available [here](https://www.ftm.mw.tum.de/en/main-research/vehicle-dynamics-and-control-systems/roborace-autonomous-motorsport/). A list of publications already available to the research community can be found here:
* **[What can we learn from autonomous level 5 motorsport?](https://doi.org/10.1007/978-3-658-22050-1_12)** by *Betz, J.; Wischnewski, A.; Heilmeier, A.; Nobis, F.; Stahl, T.; Hermansdorfer, L.; Lohmann, B.; Lienkamp, M.*
* **[A Race Simulation for Strategy Decisions in Circuit Motorsports](https://doi.org/10.1109/ITSC.2018.8570012)** by *Heilmeier, A.; Graf, M.; Lienkamp, M.*

Already submitted and accepted, but not published yet are:
* **ROS-based localization of a race vehicle at high-speed using LIDAR** by *Stahl, T.; Wischnewski, A.; Betz, J.; Lienkamp, M*
* **Autonomous Racing: A Comparison of SLAM Algorithms for Large Scale Outdoor Environments** by *Nobis, F.; Betz, J. ; Hermansdorfer, L.; Lienkamp, M.*
* **A Software Architecture for an Autonomous Racecar** by *Betz, J.; Wischnewski, A.; Heilmeier, A.; Nobis, F.; Stahl, T.; Hermansdorfer, L.; Lienkamp, M.*

### People Involved
##### Core Developers
* [Alexander Wischnewski](mailto:alexander.wischnewski@tum.de) (Control, State Estimation, System Components, Simulation)
* [Leonhard Hermansdorfer](mailto:hermansdorfer@ftm.mw.tum.de) (Simulation)
* [Thomas Herrmann](mailto:herrmann@ftm.mw.tum.de) (Simulation)

##### Acknowledgements
Several students contributed to the success of the project during their Bachelor's, Master's or Project Thesis.
* Fabian Christ (Trajectory Planning)
* Marco Kappertz (State Estimation)
* Johannes Schwarz (Control)
* Dean Petrovski (Simulation)
* Madeline Wolz (State Estimation)

### Repository structure
The control software itself is splitted in multiple repositories:
* `modules/mod_vehicle_dynamics_control` contains the main software with hardware independent interfaces, but also the parametrizations for different vehicles, as we believe that parameters should be versioned together with code.
* `simulation/sim_vehicle_dynamics` provides a nonlinear single track model which can be used for development and initial tuning of the software.
* `modules/mod_interface_helperfun` contains several small functions which are utilized by the software.
* `modules/veh_passenger` is the vehicle specific repository which adds the vehicle interfaces.

# Installation
This is a brief tutorial how to setup your computer to work on the controller software.

1. Install MATLAB 2018b
2. Create a new folder which will contain the software stack
3. Create subfolders `modules` and `simulation`
4. Checkout the following repositories in the corresponding subfolders on your local machine
    * `modules/mod_vehicle_dynamics_control`
    * `modules/mod_interface_helperfun`
    * `modules/veh_passenger`
    * `simulation/sim_vehicle_dynamics`
5. Check if you setup everything correctly
    * Go to the `Start Simulation` section below and run a simulation
    * If it runs without errors, your setup is ready to go
    * You can now inspect the results as described below

### Comments on software development infrastructure
Due to the requirement, to manage multiple vehicle with the same code, we use Data Dictionaries and Simulink Project extensively. You can find information on [Simulink Project](https://de.mathworks.com/products/simulink/projects.html) and [Data Dictionaries](https://de.mathworks.com/help/simulink/ug/what-is-a-data-dictionary.html) in the Mathworks Simulink Documentation. As long as you do not plan to restructure the repositories or add multiple vehicles, it is not necessary to dive very deep into these topics. There are high level functions available to help you with software configuration (see Working with the Software Stack section).

# Working with the Software Stack
### Start Simulation
* Open the main vehicle project `modules/veh_passenger/veh_passenger.prj`
* Start and Run `modules/veh_passenger/tests/veh_passenger_simulation.slx`

### Use Different Tracks
##### Load a racetrack
The racelines available for simulation can be found under `simulation/sim_vehicle_dynamics/tracks`. Each data dictionary represents a single raceline and the corresponding scenario information (e.g. vehicle start position). To load a new scenario, do the following:
* Call `loadScenario('<YourScenarioName>')`. The scenario name has to be written without a .sldd, e.g. `loadScenario('HongKong')`

##### Create new racetracks
Racetracks can be imported via .csv files. The function for this resides in `simulation/sim_vehicle_dynamics/scripts/CreateNewTrack.m`. It expects a csv file with a header. The format specification can be found in the function documentation of the file. An example is provided in `simulation/sim_vehicle_dynamics/tracks/TrackCreationExample.csv`. Run the script to create a new track definition in the tracks folder. This can be imported via loadScenario afterwards.
* Call `CreateNewTrack('<csvfile>', 1)` to import the csv and create a racetrack

### Data Inspection
##### Create debug logs
* Run `convertSimLogs(logsout, '<YOURFILENAME>.mat')` with a file name of your choice
* Load the .mat while which you have just created
* Inspect the structure `debug`

##### Use the Data Inspection Tool
The software stack provides a MATLAB GUI for basic visualization of all important data for the algorithms. It can be started by running `trajectorycontrolvisualizer` from the MATLAB command line. A general introduction to the usage of the tool can be found in `modules/mod_vehicle_dynamics_control/scripts/ControlVisualizer/ControlVisualizer_GettingStarted.pdf`. Details on the signal meanings are documented in the models.


# Adapt the Software Stack to your vehicle
In the following, you find a guide how to modify the example vehicle such that it corresponds to your own vehicle. The software is currently in use with Speedgoat hardware in the project, however it should be straight-forward to use it on other targets which support a Simulink Toolchain. The guide covers the functional changes necessary and gives a starting point which signals have to be used.

In general, it is recommended to modify the example vehicle. The only case where it is necessary to add a new vehicle is if you have to maintain multiple vehicle configurations or want to contribute to the upstream development. Please have in mind, that every vehicle has a two character identifier, which is used extensively throughout the project. In the case of this example vehicle it is `pa`. You will find this in front of many file names in this tutorials. All of these files are vehicle specific and may be subject to reconfiguration in a multiple vehicle setup.

The example vehicle is provided with two main models. The first, the simulation model (`modules/veh_passenger/tests/veh_passenger_simulation.slx`), is inteded to test the functionality of the Vehicle ECU code with a vehicle which is parametrized very similiar to your vehicle on your computer using Simulink. The second (`modules/veh_passenger/models/VehicleECU.slx`), is a basis for creating the model with the hardware interfaces of your ECU to generate code. It contains all necessary interfaces which have to be connected according to your vehicle configuration. Details on this process can be found in the section below.

The workflow to adapt the software to your vehicle has three steps:
1. Adjust vehicle parameters for simulation and control software
2. Tune controllers to fit your needs in the simulation
3. Add vehicle specific interfaces to the target software

### Adjust the vehicle parameters
The vehicle parameters are located in two different sources. The reason for this is that it should be possible to simulate parameter mismatch between the model and the software by applying different vehicle parameter for the simulation model than in the software.

The control software vehicle parameters must be adjusted in `modules/mod_vehicle_dynamics_control/parameters/vehicle/pa_vehicleparameter.sldd`. A description of the parameters can be found under `modules/mod_vehicle_dynamics_control/parameters/vehicle/Readme.md`.

The simulation vehicle parameters must be adjusted in `simulation\sim_vehicle_dynamics\parameters\pa_sim_vehicleparameter.sldd`. A description of the parameters can be found under `simulation\sim_vehicle_dynamics\parameters\Readme.md`. More details on the used modeling equations are availabe at `simulation\sim_vehicle_dynamics\docs_nstm.pdf`.

### Tune controllers
There are three components which definitly require tuning to your vehicle. You can find the detailed tuning guides here:  
* State Estimation: `modules/mod_vehicle_dynamics_control/estimation/Readme.md`
* Motion Control: `modules/mod_vehicle_dynamics_control/control/Readme.md`
* System & Diagnosis: `modules/mod_vehicle_dynamics_control/system/Readme.md`

In general, we recommend to use our graphical debug tool to adjust the parameters of the algorithms. Please see the *Working with the Software Stack* section for an introduction.

### Adjust vehicle specific interfaces
Open the vehicle ECU model `modules/veh_passenger/models/VehicleECU.slx`. This is your main model which can be used to flash your ECU. It is already partitioned in a *Receive*, *Software* and *Send* part. You have already done the necessary changes to *Software* if you have adjusted all controllers as described above. We will work through the other sections step by step.

##### Receive Parts:
The most important thing comes first: The **TrajectoryPlanning** Interface. This is the core of your communication with the controller. It must be filled with trajectories which are then realized by the controller. They can be send asynchronously, however if the vehicle reaches the end of the current trajectory it goes to a hard emergency brake. The frequency to provide new trajectories is therefore determined by the length and speed profile of the trajectories. Each trajectory *must* have 50 discretization points, due to limitations in code generation for variable sized signals. However, the spatial spacing between the points is arbitrary and can also be variable within a single trajectory.

In general, there are two possiblities: Either you supply a trajectory with all derivative information (acceleration and curvature) or you have to configure the controller to do that (see controller tuning section). In this case, you can provide zeros to these signals.

The software distinguishes between a *Performance Trajectory* and a *Emergency Trajectory*. Both have to be provided by the planner. Under normal circumstances, the *Performance Trajectory* is driven. The *Emergency Trajectory* is used for soft emergency cases, where the vehicle brakes at fast as possible but path tracking is still enabled. This can be used for system failures not directly related to steering or powertrain, e.g. Battery or Temperature Problems, or just to stop the vehicle before it reaches the mission finished command. A detailed descprition of the signals provided for the trajectories, can be found in `modules/mod_vehicle_dynamics_control/interfaces/Readme.md`.

It is necessary to signalize the controller that the trajectory planner and mission planner are active. This is done via setting `Trajectories_CommsStatus` and `Strategy_CommsStatus` to `TUMHealthStatus.OK`. In case they loose communication, they should be set to `TUMHealthStatus.ERROR`. This triggers a soft emergency brake. Furthermore, the mission planner has to signal to the controller that it wants to start the mission via setting `Strategy_Status` to `TUMStrategyState.S_DRIVING_NORMAL`. Again, its possible to trigger an emergency brake via setting the status to `TUMStrategyState.S_DRIVING_EMERGENCY`. All these signals *must* be included in your architecture for the controller to function properly. A reference implementation can be found in the simulation model.

The **VehicleSensorData** bus is the second crucial interface to the controller. A description of what signals are expected can be found in `modules/mod_vehicle_dynamics_control/interfaces/Readme.md`. The minimum required signals for standard operation mode can be found in the implementation of the simulation in `modules/veh_passenger/tests/veh_passenger_simulation.slx`. It is possible to use the controller with less signals than this, however it is recommended to calculate 'replacement' signals, e.g. the longitudinal velocity based on the wheelspeeds and the lateral velocity from a steady-state assumption.

The **VehicleSystemStatus** controls the startup process of the vehicle. Set the `Hardware` signal to `TUMHealthStatus.OK` if all devices are powered up and the system is ready to be used. Set `AIDriverStartup` to the same value if all startup conditions from the Autonomous System are met, e.g. localization available or data logging activated. `AIDriver` is comparable to `AIDriverStartup`, however it monitors the required Autonomous System functions during driving. Your logging should be there during startup, however it might not trigger an emergency brake if it crashes during operation. Therefore it should be included in `AIDriverStartup` but not in the conditions for `AIDriver`. Finally, `VehicleReady2Drive` indicates that the vehicle has given control to the control unit. This means that the steering and powertrain responds immediatly to commands of the controller. This signal is used as a condition to go to internal driving state.

Finally, **ActuatorLimiations** tells the controller what are the current maximum and minimum control values for steering angle at the wheels and the overall powertrain force. These can also be set dynamically and prevent the controller from requesting values which cannot be used. This helps to prevent wind-up of the control outputs.

##### Send Parts:
The send subsystem shows a possible implementation of the output processing. `EnableControlOutputs` and `EnableHardEmergencyBrake` provide additional safety mechanisms, to ensure the vehicle never starts driving before the state machine allows and applies the brakes in case that a hard emergency brake is requested. The negative force value for the hard emergency brake should be adjusted to your vehicle. It is recommended to have a value corresponding to -0.6 to -1g. The signal `RequestControl` can be used to signalize a lower level control unit that the motion controller wants to take control over the actuators. Usually, the lower level control unit responds to this request with the `VehicleReady2Drive` signal mentioned earlier in the VehicleSystemStatus.

The controller requests a steering angle at the wheel via `RequestSteeringAngle_rad`. It is assumed that this is the mean of both front wheels. This signal should be send to the steering actuator. The powertrain force is requested via `RequestLongForce_N`. It is assumed to be the sum of the forces acting upon the vehicle in longitudinal direction. These requests must be split according to the motor and brake configuration and can vary between several vehicles. Furthermore, it is possible to connect a park brake. The controller state machine handles release and locking properly, to be able to start the vehicle on inclined roads.

Finally, it is recommended to use the `Debug` bus provided by the software to inspect whats going on. The simulation model is already configured to log these signals and the description how to convert them to a usable format is given in the section *Working with the Software Stack*. If you want to use the same data analysis workflow on your vehicle, you can implement a similar conversion script for your ECU logs.

##### Model Configuration:
Simulink requires to specify the Target Hardware in the modelconfig. The project uses a quite complex structure to maintain these modelconfigs. This emerged from the need to support mulitple targets with the same code and very different configs. The configs are located in `modules/mod_vehicle_dynamics_control/interfaces/modelconfig.sldd`. The standard config used for the passenger vehicle repository is called `GRT`. Adjust the configuration according to your needs, e.g. Target Hardware and save everything. It is required to reload the project to apply the changes to all models.
