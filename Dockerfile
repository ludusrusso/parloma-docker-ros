FROM fjctp/armhf-ros-kinetic-core

RUN apt-get update
RUN apt-get install ros-kinetic-rosserial -y
RUN apt-get install ros-kinetic-rosbridge-suite -y

RUN apt-get install nginx -y

COPY ./web /web

RUN /bin/bash -c "source /opt/ros/kinetic/setup.bash && mkdir -p /parloma/ros/src && cd /parloma/ros/src && catkin_init_workspace && cd .. && catkin_make"
COPY ./parloma_driver /parloma/ros/src/parloma_driver
COPY ./serial_bridge /parloma/ros/src/serial_bridge
COPY ./parloma_msgs /parloma/ros/src/parloma_msgs

RUN /bin/bash -c "source /opt/ros/kinetic/setup.bash && cd  /parloma/ros && catkin_make"
RUN echo source /parloma/ros/devel/setup.bash >> ~/.bashrc

COPY ./nginx.conf /etc/nginx/sites-enabled/parloma
RUN rm /etc/nginx/sites-enabled/default
RUN update-rc.d nginx enable

COPY ./entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD roslaunch parloma_driver demo.launch
