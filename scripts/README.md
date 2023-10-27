# Scripts
This folder includes scripts that are necessary to work with the project from within docker container.

There are 2 scenarios that are currently supported:
- working in computelab cluster - where the cl node can differ upon every login
- working on a local own workstation - where we assume the same workstation every time we log in


## ComputeLab Cluster
The flow is as follows:  
1. get a computelab machine and get to its prompt  
    - update its details in the `.ssh/config` and ssh directly to the machine
2. from the project root, run the `./scripts/docker_build_run_cl.sh` script to do the following: 
    - generate a `dev.dockerfile`
    - build the docker image
    - run the docker image
3. Install any auxiliary packages. 
    - in this project, we have a submodule `flash-attention`
    - initialize the sub-module: `git submodule init && git submodule update` 
    - run the `install-flash-attn.sh` script 
4. commit the installations to the image:
    - Temporaly exit the container (ctrl+P+Q) and commit to the image:
    ```
    gkoren@430f346ccb18:~/scratch/code/github/guyk1971/safari$ <press ctrl+p+q>
    gkoren@ipp1-2161:~/safari$ docker commit <container_id> <image_name>
    gkoren@ipp1-2161:~/safari$ docker push <image_name>
    gkoren@ipp1-2161:~/safari$ docker attach 430f346ccb18
    ```
    where:
    - `<container_id>` in this case is `430f346ccb18`  
    - `image_name`= `<docker_repository>/safari-hyena:<updated_image_tag>`  
5. update the script `docker_run_cl.sh` with the `image_name` 

if you've done step 4, the next time you get a computelab machine (assuming identical characteristics), you can either repeat steps 1-3 or just run the `docker_run_cl.sh` 

note that you can also run `docker_run_cl_multi.sh` if you want to run multiple containers on the same machine.


## Local Workstation
The flow is as follows:  
1. ssh to the machine and get to its prompt  
2. from the project root, run the `./scripts/docker_build_run_lws.sh` script to do the following: 
    - generate a `dev.dockerfile`
    - build the docker image
    - run the docker image
3. Install any auxiliary packages. 
    - in this project, we have a submodule `flash-attention`
    - initialize the sub-module: `git submodule init && git submodule update` 
    - run the `install-flash-attn.sh` script 
4. commit the installations to the image:
    - Temporaly exit the container (ctrl+P+Q) and commit to the image:
    ```
    gkoren@430f346ccb18:~/scratch/code/github/guyk1971/safari$ <press ctrl+p+q>
    gkoren@ipp1-2161:~/safari$ docker commit <container_id> <image_name>
    gkoren@ipp1-2161:~/safari$ docker push <image_name>  # optional
    gkoren@ipp1-2161:~/safari$ docker attach 430f346ccb18
    ```
    where:
    - `<container_id>` in this case is `430f346ccb18`  
    - `image_name`= `<docker_repository>/safari-hyena:<updated_image_tag>`  
5. update the script `docker_run_cl.sh` with the `image_name` 

if you've done step 4, the next time you get a computelab machine (assuming identical characteristics), you can either repeat steps 1-3 or just run the `docker_run_lws.sh` 

note that you can also run `docker_run_lws_multi.sh` if you want to run multiple containers on the same machine.



