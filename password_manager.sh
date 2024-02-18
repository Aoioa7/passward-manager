#!/bin/bash
echo "パスワードマネージャーへようこそ！"
echo "次の選択肢から入力してください(Add Password/Get Password/Exit):"
#Exitが選ばれるまで繰り返される
while :
do
    read choice
    #選択肢による分岐はcase文で実装しました。
    case ${choice} in
        "Add Password")
            echo "サービス名を入力してください:"
            read newService
            echo "ユーザー名を入力してください:"
            read newUser
            echo "パスワードを入力してください:"
            read newPassword
            echo "${newService}:${newUser}:${newPassword}" >> file.txt
            echo "パスワードの追加は成功しました。" 
            echo "次の選択肢から入力してください(Add Password/Get Password/Exit):" ;;
            
        "Get Password")
            echo "サービス名を入力してください:"
            read selectedService
            #処理をし易いように変換しました。
            sed 's/:/,/g' file.txt > file.csv 
            #入力されたサービス名が保存されているかどうかで条件分岐します。
            exist=false
            grep -w ${selectedService} file.csv > result.csv && exist=true
            if ${exist} ; then
                savedService=$(cat result.csv | cut -f 1 -d ',')
                echo "サービス名:"${savedService}
                savedUser=$(cat result.csv | cut -f 2 -d ',')
                echo "ユーザー名:"${savedUser}
                savedPassword=$(cat result.csv | cut -f 3 -d ',')
                echo  "パスワード:"${savedPassword}
            else 
                echo "そのサービスは登録されていません。"
            fi
            #次の繰り返しの前にクリーンにしておきました。
            rm file.csv
            rm result.csv
            echo "次の選択肢から入力してください(Add Password/Get Password/Exit):" ;;
            
        "Exit")
            echo "Thank you!"
            break ;;
            
        *)
            echo "入力が間違えています。Add Password/Get Password/Exit から入力してください。" ;;
        esac
done