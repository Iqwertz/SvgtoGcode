#!/bin/bash
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"

chmod +x SvgToGcode
xvfb-run ./SvgToGcode