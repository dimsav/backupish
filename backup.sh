#!/bin/sh

# ============================================
# Settings for the directories to be backed up
# ============================================

directories_base_dir='..'
directories='
    myproject
'
databases='
    mydb
    another_db
'

# ============================================
# Settings for the mysql connection
# ============================================

MYSQL_USER="homestead"
MYSQL_PASSWORD="secret"

# ===============================================
# Directory containing the temporary backup files
# ===============================================

backups_dir='backups'
thetime=`date +%Y-%m-%d_%H-%M-%S`
backup_dir="$backups_dir/$thetime"

# ========================================================
# Choose if you want to delete the backups after uploading
# ========================================================

delete_created_backups=true



# =============
# The script...
# =============

mkdir -p $backup_dir

for dir in $directories; do
    zip_file_name=$(echo "$dir" | tr / -)
    echo $zip_file_name
    zip -r -q  "$backup_dir/$zip_file_name.zip" "$directories_base_dir/$dir"
done

for db in $databases; do
  mysqldump --force --opt --user=$MYSQL_USER -p$MYSQL_PASSWORD --databases $db | gzip > "$backup_dir/db_$db.gz"
done

bash vendor/dropbox_uploader.sh upload $backup_dir $thetime

if [ "$delete_created_backups" = "true" ]; then
    rm -rf $backup_dir
fi
