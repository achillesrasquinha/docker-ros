FROM ghcr.io/achillesrasquinha/ros:base

ENV NOVNC_PORT=5000 \
    ROS_WORKSPACE=/home/ros/ros_ws \
    DISPLAY_WIDTH=1024 \
    DISPLAY_HEIGHT=768 \
    USER=ros

COPY ./app /app

COPY ./start /start
RUN chmod +x /start

USER ${USER}

VOLUME [ "${ROS_WORKSPACE}" ]

RUN mkdir -p ${ROS_WORKSPACE}/src

RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ${HOME}/.bashrc

EXPOSE ${NOVNC_PORT}

CMD [ "/start" ]

WORKDIR ${ROS_WORKSPACE}