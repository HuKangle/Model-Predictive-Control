## Description

1. This package contains implementations for online-plan synthesis algorithm give a dynamic
environment (as the finite transition system) and a potential infeasible Linear temporal
logic formula (as the robot’s task). It outputs the predicted trajectories at each
time-step that optimize the reward-related objectives and finally fulfill the task maximumly.

![grid.png](grid.png)
* Simulation Video: [Simulation video](https://www.youtube.com/watch?v=RyRnKXDDH5U)

2. In the experiment, the neighbor numbers of simulation snapshot provide the time-varying reward 
(Here we use the random values) which is our optimization objective.
![experiment.jpg](experiment.jpg)
* Experiment Video: [Experiment video](https://www.youtube.com/watch?v=16j6TmVUrTk)
## Reference

**Receding Horizon Control Based Online LTL Motio sPlanning in Partially Infeasible
Environments**.
Mingyu Cai, H. Peng and Z. Kan. Journal of Autonomous Robot.[paper link](https://drive.google.com/file/d/1y-fGCU9np0Pt-vxuniRe6Vo35Hp2z505/view?usp=sharing)

## Features

- Allow both normal and infeasible LTL based product automaton task formulas
- Motion model can be dynamic and initially unknown
- Soft specification is maximumly satisfied.
- Online-Path planning is designed from the model predicted control methodology.
- Collect and transfer the real-time data via Optitrack camera systems 
- Allow automatically calibrate the mobile robots to obtain its orientation and dynamics.

## Debugging
### Ptthon3
* Install python packages like networkx2.0.ply
* Add to your PYTHONPATH, to import it in your own project.
* ltlba_32 and ltlba_64 are executable files complied under Linux, please follow [ltl2ba/README.txt]
* Try [path_plan.py](https://github.com/mingyucai/Model-Predictive-Control/blob/master/path_plan.py)
### MATLAB
* Add folder to your PYTHONPATH.
* Try [Receding_Horizon_Control.py](https://github.com/mingyucai/Model-Predictive-Control/blob/master/Matlab_simulation/LTL_MPC/RHC_ACC.m)
