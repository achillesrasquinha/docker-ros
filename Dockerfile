FROM bitnami/minideb:buster

ENV NOVNC_DIR=/noVNC \
    NOVNC_PORT=5000 \
    GROUP_ID=1001 \
    USER_ID=1001 \
    USER=ros \
    GROUP=ros \
    HOME=/home/ros \
    DISPLAY=:0.0 \
    DISPLAY_WIDTH=1920 \
    DISPLAY_HEIGHT=1080 \
    LANG=C.UTF-8 \
    LANGUAGE=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    ROS_DISTRO=noetic \
    ROS_WORKSPACE=/home/ros/ros_ws

RUN set -e \
    && groupadd -g ${GROUP_ID} ${GROUP} \
    && useradd -rm -d ${HOME} -s /bin/bash -g ${GROUP} -G sudo -u ${USER_ID} ${USER} \
    && apt-get update && \
    apt-get install -y --no-install-recommends \
        gnupg2 \
        lsb-release \
    && sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 \
    && apt-get update \
    && apt-get install --no-install-recommends -y \
        bash \
        git \
        gcc \
        g++ \
        xfce4 \
        xvfb \
        xterm \
        x11vnc \
        ros-${ROS_DISTRO}-desktop-full \
        python3 \
        python3-numpy \
        supervisor \
        dbus-x11 \
    && git clone https://github.com/novnc/noVNC.git --depth 1 ${NOVNC_DIR} \
    && ln -s ${NOVNC_DIR}/vnc_lite.html ${NOVNC_DIR}/index.html \
    && git clone https://github.com/novnc/websockify.git --depth 1 ${NOVNC_DIR}/websockify \
    && cd ${NOVNC_DIR}/websockify \
    && python3 setup.py install \
    && mkdir -p ${ROS_WORKSPACE}/src

COPY ./app /app

COPY ./start /start
RUN chmod +x /start

WORKDIR ${ROS_WORKSPACE}

USER ${USER}

RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ${HOME}/.bashrc

EXPOSE ${NOVNC_PORT}

CMD [ "/start" ]