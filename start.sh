chown -R strider:strider /home/strider

echo "sourcing files"
source ~/.rvm/scripts/rvm
export PATH=$PATH:$NVM_BIN
if [ "$DB_PORT" = "" ] 
then
   echo "can't find DB_PORT env variable which is used to set the mongodb connection"
else
   export DB_URI=$(echo "$DB_PORT" | sed -e 's/tcp/mongodb/')
fi

if [[ -n $GENERATE_ADMIN_USER ]]; then
  echo "Creating admin user"
  ADMIN="admin@rsm.com"
  PASSWD="12341234"
  DB_URI=$(echo "$DB_PORT" | sed -e 's/tcp/mongodb/') opt/strider/src/bin/strider addUser -f -l $ADMIN -p $PASSWD -a true
  echo "Admin User: $ADMIN, Admin Pass: $PASSWD"
fi
supervisord -c /etc/supervisor/supervisord.conf
