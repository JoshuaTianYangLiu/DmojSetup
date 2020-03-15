#!/bin/bash

rm README.md

sudo apt-get update
sudo apt install --assume-yes git gcc g++ make python3-dev libxml2-dev libxslt1-dev zlib1g-dev gettext curl
sudo apt install --assume-yes python3-pip
pip3 install virtualenv
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt install --assume-yes nodejs
npm install -g sass postcss-cli autoprefixer

sudo apt update
sudo apt install --assume-yes mariadb-server libmysqlclient-dev

virtualenv dmojsite
. dmojsite/bin/activate

mysql -u root -e "CREATE DATABASE dmoj DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;GRANT ALL PRIVILEGES ON dmoj.* to 'dmoj'@'localhost' IDENTIFIED BY 'password123';exit;"

git clone https://github.com/DMOJ/site.git
cd site
git submodule init
git submodule update

pip3 install -r requirements.txt
pip3 install mysqlclient

mv ../DmojSetup/local_settings.py dmoj/

python3 manage.py check

./make_style.sh
python manage.py collectstatic

python manage.py compilemessages
python manage.py compilejsi18n

python manage.py migrate
python manage.py migrate

python manage.py loaddata navbar
python manage.py loaddata language_small
python manage.py loaddata demo

echo "Done, run [. ../dmojsite/bin/activate] to activate your virtualenv and [python manage.py runserver] to run your server"