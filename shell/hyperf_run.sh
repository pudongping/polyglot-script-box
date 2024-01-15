#!/bin/bash
#Author: Alex
#Deployment scripts on the development environment.

function console_blue() {
    echo -e "\033[36m $1 \033[0m"
}

function console_green() {
    echo -e "\033[32m $1 \033[0m"
}

function console_orangered() {
    echo -e "\033[31m\033[01m $1 \033[0m"
}

function select_branch() {
    read -p 'Please select branch (no choice default branch: dev) >>> ' branch
    if [[ -z $branch ]]
    then
        branch='dev'
    fi
    echo $branch
}

function deploy_admin_php() {
    console_blue 'deploy admin_php ...'
    cd /home/rngtech/Project/php/admin-php
    git checkout $1
    git pull origin $1
    sudo rm -rf /home/rngtech/Project/php/admin-php/runtime/container
    sudo docker restart admin_php
    sudo docker exec admin_php bash -c 'cd admin_php && php bin/hyperf.php start >> /dev/null 2>&1 &'
    console_green 'Success!'
}

function deploy_content_supplier() {
    console_blue 'deploy content_supplier ...'
    cd /home/rngtech/Project/php/content_supplier
    git checkout $1
    git pull origin $1
    sudo rm -rf /home/rngtech/Project/php/content_supplier/runtime/container
    sudo docker restart content_supplier_web_1
    console_green 'Success!'
}

function deploy_order_tank() {
    console_blue 'deploy order_tank ...'
    cd /home/rngtech/Project/php/order_tank
    git checkout $1
    git pull origin $1
    sudo rm -rf /home/rngtech/Project/php/order_tank/runtime/container
    sudo docker restart order_tank
    sudo docker exec order_tank bash -c 'cd order_tank && php bin/hyperf.php start >> /dev/null 2>&1 &'
    console_green 'Success!'
}

function deploy_user() {
    console_blue 'deploy user ...'
    cd /home/rngtech/Project/php/user
    git checkout $1
    git pull origin $1
    sudo rm -rf /home/rngtech/Project/php/user/runtime/container
    sudo docker restart user_web_1
    sudo docker exec user_web_1 bash -c 'cd /opt/www && php bin/hyperf.php start >> /dev/null 2>&1 &'
    console_green 'Success!'
}

console_blue 'Please enter the number to the item you want to deploy : '

select project in 'admin-php' 'content_supplier' 'order_tank' 'user'
do
    case $project in
        'admin-php')
            branch=$(select_branch)
            deploy_admin_php $branch
        break
        ;;
        'content_supplier')
            branch=$(select_branch)
            deploy_content_supplier $branch
        break
        ;;
        'order_tank')
            branch=$(select_branch)
            deploy_order_tank $branch
        break
        ;;
        'user')
            branch=$(select_branch)
            deploy_user $branch
        break
        ;;
        *)
            console_orangered 'Whoop! You selected the number is invalid! Please selected again:'
    esac
done

exit 1