#!/bin/bash


trap "exit 1" TERM
export TOP_PID=$$


board=( {1..15} "" )         
target=( "${board[@]}" )     
empty=15                     
last=0                       
A=0 B=1 C=2 D=3              
topleft='\e[0;0H'            

nocursor='\e[?25l'           
normal=\e[0m\e[?12l\e[?25h   
fmt="$nocursor$topleft
%2s  %2s   %2s  %2s
%2s  %2s   %2s  %2s
%2s  %2s   %2s  %2s
%2s  %2s   %2s  %2s
"
## I prefer this ASCII board
fmt="\e[?25l\e[0;0H\n
\t+----+----+----+----+
\t|    |    |    |    |
\t| %2s | %2s | %2s | %2s |
\t|    |    |    |    |
\t+----+----+----+----+
\t|    |    |    |    |
\t| %2s | %2s | %2s | %2s |
\t|    |    |    |    |
\t+----+----+----+----+
\t|    |    |    |    |
\t| %2s | %2s | %2s | %2s |
\t|    |    |    |    |
\t+----+----+----+----+
\t|    |    |    |    |
\t| %2s | %2s | %2s | %2s |
\t|    |    |    |    |
\t+----+----+----+----+\n\n"

function getRandomNum {
    num=$((RANDOM % 10))
    echo $num
}
n1=$(getRandomNum)
n2=$(getRandomNum)
n3=$(getRandomNum)
n4=$(getRandomNum)
while [ "$n1" -eq "$n2" ]
do
    n2=$(getRandomNum)
done

while [[ "$n1" -eq "$n3" ]] || [[ "$n2" -eq "$n3" ]]
do 
    n3=$(getRandomNum)
done
while [[ "$n1" -eq "$n4" ]] || [[ "$n2" -eq "$n4" ]] || [[ "$n3" -eq "$n4" ]]
do 
    n4=$(getRandomNum)
done
# echo ${n1} ${n2} ${n3} ${n4}

print_board() {
    printf "$fmt" "${board[@]}"
}
borders() {
    local x=$(( ${empty:=0} % 4 )) y=$(( $empty / 4 ))
    unset bordering    
    [ $y -lt 3 ] && bordering[$A]=$(( $empty + 4 ))
    [ $y -gt 0 ] && bordering[$B]=$(( $empty - 4 ))
    [ $x -gt 0 ] && bordering[$C]=$(( $empty - 1 ))
    [ $x -lt 3 ] && bordering[$D]=$(( $empty + 1 ))
}
checkPuzzle() {
    if [ "${board[*]}" = "${target[*]}" ]; then
        print_board
        printf "\a\tРешено за %d шагов\n\n" "$moves"
        exit
    fi
}
move() {
    movelist="$empty $movelist"    
    moves=$(( $moves + 1 ))        
    board[$empty]=${board[$1]}     
    board[$1]=""                   
    last=$empty                    
    empty=$1                       
}
random_move() {
local sq
    while :
    do
        sq=$(( $RANDOM % $# + 1 ))
        sq=${!sq}
        [ $sq -ne ${last:-666} ] &&   
        break
    done
    move "$sq"
}
shuffle()  {
    local n=0 max=$(( $RANDOM % 100 + 150 ))    
    while [ $(( n += 1 )) -lt $max ]
    do
        borders                                  
        random_move "${bordering[@]}"            
    done
}

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
        hod=0
        while [ "1" -eq "1" ]
        do
            hod=$(($hod + 1))
            hodd $hod
        done
    elif [ "$number" == 3 ]; then
        
        trap 'printf "$normal"' EXIT       
        clear
        print_board
        echo
        echo "Давай сыграем в пятнашки! Игра закончится, когда ты сделаешь всё по-порядку."
        echo "Используй стрелочки для игры."
        echo "Жмякай энтор, чтобы продолжить"
        shuffle
        moves=0
        read -s
        clear
        while :
        do
            borders
            print_board
            printf "\t   %d-ый шаг" "$moves"
            checkPuzzle
            read -sn1 -p $'        \e[K' key
            case $key in
                A) [ -n "${bordering[$A]}" ] && move "${bordering[$A]}" ;;
                B) [ -n "${bordering[$B]}" ] && move "${bordering[$B]}" ;;
                C) [ -n "${bordering[$C]}" ] && move "${bordering[$C]}" ;;
                D) [ -n "${bordering[$D]}" ] && move "${bordering[$D]}" ;;
                q) echo; break ;;
            esac
        done
    else
        echo "WTF?!"
    fi
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
    kill -s TERM $TOP_PID
    
}





function check {
    if [ "$1" -eq "$2" ]; then
        echo "Цифры не должны повторяться"
    fi
    if [[ "$1" -eq "$3" ]] || [[ "$2" -eq "$3" ]]; then
        echo "Цифры не должны повторяться"
    fi
    if [[ "$1" -eq "$4" ]] || [[ "$2" -eq "$4" ]] || [[ "$3" -eq "$4" ]]; then
        echo "Цифры не должны повторяться"
    fi
    echo "Ухх, сейчас суперкомпьютеры Илона Маска посчитают"
}
function checkBulls {
    countB=0
    countC=0
    if [ "$n1" -eq "$1" ]; then
        countB=$(($countB + 1))
    fi
    if [ "$n2" -eq "$2" ]; then
        countB=$(($countB + 1))
    fi
    if [ "$n3" -eq "$3" ]; then
        countB=$(($countB + 1))
    fi
    if [ "$n4" -eq "$4" ]; then
        countB=$(($countB + 1))
    fi

    if [[ "$n1" -eq "$2" ]] || [[ "$n1" -eq "$3" ]] || [[ "$n1" -eq "$4" ]]; then
        countC=$(($countC + 1))
    fi
    if [[ "$n2" -eq "$1" ]] || [[ "$n2" -eq "$3" ]] || [[ "$n2" -eq "$4" ]]; then
        countC=$(($countC + 1))
    fi
    if [[ "$n3" -eq "$1" ]] || [[ "$n3" -eq "$2" ]] || [[ "$n3" -eq "$4" ]]; then
        countC=$(($countC + 1))
    fi
    if [[ "$n4" -eq "$1" ]] || [[ "$n4" -eq "$2" ]] || [[ "$n4" -eq "$3" ]]; then
        countC=$(($countC + 1))
    fi
    echo "${countB} бык(-а) ${countC} коров(-ы)"
    if [ "${countB}" -eq "4" ]; then
        echo
        echo "Ура! Вы отгадали число и поступили в Гарвард!"
        kill -s TERM $TOP_PID
    fi 
    
}
function hodd {
    echo "${1} ход!"
    echo ${n1} ${n2} ${n3} ${n4}
    echo "Введите 4-значное число без повторений цифр, например, 1234:"
    read answer
    case $answer in
        ''|*[!0-9]*) 
            read -t 2 -p "Эх, а зачем кракозябры-то?..."
            echo 
        ;;
        *)
            len=${#answer}
            if [ "${#answer}" -eq "4" ]; then
                echo $(check ${answer:0:1} ${answer:1:1} ${answer:2:1} ${answer:3:1})
                echo $(checkBulls ${answer:0:1} ${answer:1:1} ${answer:2:1} ${answer:3:1})
            else
                echo "Нужно ввести четыре цифры!"
            fi
        ;;
    esac
}


main


