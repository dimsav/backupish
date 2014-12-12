#!/bin/sh

# =================
# Import the config
# =================

. ./config.sh

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
