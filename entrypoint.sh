#!/bin/bash

source /opt/ros/kinetic/setup.bash
source /parloma/ros/devel/setup.bash
service nginx start

exec "$@"
