#!/bin/bash -e

# show all images' sizes in current directory

ls | xargs -I{} identify {} | cut -d" " -f3
