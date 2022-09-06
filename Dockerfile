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

RUN mkdir -p ${ROS_WORKSPACE}/src \
    && echo "PATH=$HOME/.local/bin:$PATH" >> $HOME/.bashrc \
    && echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ${HOME}/.bashrc \
    && echo "source ${ROS_WORKSPACE}/devel/setup.bash" >> ${HOME}/.bashrc

EXPOSE ${NOVNC_PORT}

VOLUME [ "${ROS_WORKSPACE}" ]

CMD [ "/start" ]

WORKDIR ${ROS_WORKSPACE}