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
            #すでに暗号化されている場合、ここで復号化します。
            if test -e file.txt.gpg ;then
                gpg  file.txt.gpg
                rm file.txt.gpg
            fi
            echo "${newService}:${newUser}:${newPassword}" >> file.txt
            echo "パスワードの追加は成功しました。" 
            
            #ここにステップ3の暗号化機能を実装します。
            gpg -c file.txt
            rm file.txt
            
            echo "パスワードの暗号化は成功しました"
            echo "次の選択肢から入力してください(Add Password/Get Password/Exit):" ;;
            
        "Get Password")
            echo "サービス名を入力してください:"
            read selectedService
            
            #ここにステップ3の復号化機能を実装します。
            if test -e file.txt.gpg ; then
                gpg  file.txt.gpg
            fi
            
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
            #復号化したファイルも消しておきますが、もともと暗号化していない場合には気をつけます。
            if test -e file.txt.gpg ; then
                rm file.txt
            fi
            
            echo "次の選択肢から入力してください(Add Password/Get Password/Exit):" ;;
            
        "Exit")
            echo "Thank you!"
            break ;;
            
        #例えばAdd Passwordで入力したサービス名がすでに存在していた時に中断する実装も良さそうだと思いました。
        #さらに、パスワードを変更したいときにModify Passwordなどで既存のサービス名を入力する機能なども欲しいです。
            
        *)
            echo "入力が間違えています。Add Password/Get Password/Exit から入力してください。" ;;
        esac
done