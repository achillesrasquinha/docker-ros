FROM ghcr.io/achillesrasquinha/ros:base

ENV NOVNC_PORT=5000 \
    ROS_WORKSPACE=/home/ros/ros_ws \
    DISPLAY_WIDTH=1920 \
    DISPLAY_HEIGHT=1080

COPY ./app /app

COPY ./start /start
RUN chmod +x /start

WORKDIR ${ROS_WORKSPACE}

USER ${USER}

RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ${HOME}/.bashrc

EXPOSE ${NOVNC_PORT}

CMD [ "/start" ]