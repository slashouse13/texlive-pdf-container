# LaTeX compiler

Simple docker image that uses R's Texlive to pick a `.tex` file and converts it to a pdf.

I created this mostly to not have texlive installed on my machine as it's a mess to maintain.

## Run

```sh
./build_and_run.sh <file name>
```
The resulting pdf, log, out files will be put in the current folder

__This build takes ages__ (R is the worst to build/install packages) so either use the already built image or just patiently wait.

## Known issues
When building, sometimes texlive uses malfunctioning repos
```
./install-tl: TLPDB::from_file could not get texlive.tlpdb from: https://mirror.apps.cam.ac.uk/pub/tex-archive/systems/texlive/tlnet/tlpkg/texlive.tlpdb
Maybe the repository setting should be changed.
More info: https://tug.org/texlive/acquire.html
```
Just keep re-running the build, it eventually passes, or set the `TEXLIVE_SOURCE_URL` environment variable before building via [./build_and_run.sh](./build_and_run.sh), i.e.
```sh
export TEXLIVE_SOURCE_URL=https://gb.mirrors.cicku.me/ctan
./build_and_run.sh
```