#!/bin/bash -e

# resize all images in current directory

ls | xargs -I{} convert -geometry "12.5%" {} {}
