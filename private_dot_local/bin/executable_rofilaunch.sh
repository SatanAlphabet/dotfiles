#!/usr/bin/env bash

pkill -x rofi || rofi "$@" -show
