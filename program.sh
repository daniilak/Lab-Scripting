
# function myfunc {
#     echo $(( $1 + $2 ))
# }
# myfunc 1 2 

function main {
    clear
    echo "          Список"
    echo "          ------"
    echo "Выберите номер лабораторной работы:"
    echo
    echo "[1]Ханойская башня"
    echo "[2]Быки и коровы"
    echo "[3]Игра пятнашки (15)"
    echo
    read number
    if [ "$number" == 1 ]; then
        han
    elif [ "$number" == 2 ]; then
        echo "2"
    elif [ "$number" == 3 ]; then
        echo "2"
    else
        echo "WTF?!"
    fi
}
function go_to_main {
    read -t 2 -p "Возвращаемся к главному меню..."
    main
}
function han {
    a=0
    while [ $a -lt 1 ]
    do 
        clear
        echo "Ханойская башня. Напишите, сколько дисков в ней (вводите число):"
        read disk
        
        case $disk in
            ''|*[!0-9]*) read -t 2 -p "Нужно было ввести число..." ;;
            *) a=1 ;;
        esac
    done
    for (( x=1; x < (1 << $disk ); x++ )) ; do
        i=$((($x & $x - 1 ) % 3))
        j=$(((($x | $x - 1 ) + 1 ) % 3))
        echo "Двигаем с башни $i на башню $j"
    done
    go_to_main
    
}
main
