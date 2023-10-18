#!/bin/bash

if [ $# != 0 ]
then
    echo "Недопустимое количество аргументов (должно быть равно 0)"
else
    goaccess ../04/*.log --log-format=COMBINED > index.html
fi