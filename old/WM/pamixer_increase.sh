#!/bin/sh

# Allow for volume boost if the volume is not exceeding 130

(( $(pamixer --get-volume) < 150 )) && pamixer --allow-boost --increase 10
