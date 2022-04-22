#!/bin/sh

# Allow for volume boost if the volume is not exceeding 130

(( $(pamixer --get-volume) < 130 )) && pamixer --allow-boost --increase 10
