# tk4- with jcc docker

## What is this?

This is a Dockerfile and script for use with github actions to automatically build/test MVS 3.8J (tk4-) C programs. Could also be used to test all kinds of programs. 

Actions:

- Downloads http://wotho.ethz.ch/tk4-/tk4-_v1.00_current.zip and extracts to `/tk4-/`
- Changes tk4- so that the 3505 reader is on port 3506 and uses EBCDIC instead of ASCII
- Clones https://github.com/mvslovers/jcc.git to `/jcc` (technically `/`)
- Clones https://github.com/mvslovers/rdrprep.git, makes and installs `rdrprep` to `/usr/local/bin`
- Installs the bash script `/tk4-/tk4_loaded.sh` for use to detect when tk4- is fully loaded

## Build

To build this image: `docker build --tag "tk4-jcc" .`


## Included scripts

The script: `tk4_loaded.sh` waits until tk4- is done loading. Used in automation.

```bash
#!/usr/bin/env bash

# tk4_loaded.sh

while [ ! -f /tk4-/done_tk4_jcc.txt ]
do
  sleep 1
done

echo "Done!"
``` 
