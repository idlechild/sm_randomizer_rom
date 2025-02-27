#!/usr/bin/env bash
# Remember to commit an updated build.bat as well if making changes

# Return an error if any command fails
success=0
trap success=1 ERR

echo Building Super Metroid Randomizer

find . -name build.py -exec python3 {} \;

cd resources
python3 create_dummies.py 00.sfc ff.sfc
./asar --no-title-check --symbols=wla --symbols-path=../build/sm.sym ../src/main.asm 00.sfc
./asar --no-title-check --symbols=wla --symbols-path=../build/sm.sym ../src/main.asm ff.sfc
python3 sort_debug_symbols.py ../build/sm.sym ../build/sorted.sym ../build/combined.sym
python3 create_ips.py 00.sfc ff.sfc sm.ips
rm 00.sfc ff.sfc

for f in ../src/randopatches/ips/*.ips; do python3 merge_ips.py $f sm.ips; done

cp sm.ips ../build/sm.ips > /dev/null

cd ..
echo Done
exit $success
