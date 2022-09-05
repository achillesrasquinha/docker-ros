FROM ghcr.io/achillesrasquinha/ros:base

ENV NOVNC_PORT=5000 \
    ROS_WORKSPACE=/home/ros/ros_ws \
    DISPLAY_WIDTH=1920 \
    DISPLAY_HEIGHT=1080 \
    USER=ros

COPY ./app /app

USER ${USER}

COPY ./start /start
RUN chmod +x /start \
    && mkdir -p ${ROS_WORKSPACE}/src

WORKDIR ${ROS_WORKSPACE}

RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ${HOME}/.bashrc

VOLUME [ "${ROS_WORKSPACE}" ]

EXPOSE ${NOVNC_PORT}

CMD [ "/start" ]