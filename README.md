### Docker for ROS

### Usage

```shell
$ docker run \
    --rm \
    -it \
    -v "./ros_ws:/home/ros/ros_ws" \
    -p "3000:5000" \
    ghcr.io/achillesrasquinha/ros
```