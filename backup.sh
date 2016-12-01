#!/bin/sh

CURRENT_DIR="$( cd "$( dirname "$0" )" && pwd )"

# =================
# Import the config
# =================

. $CURRENT_DIR/config.sh

# =============
# The script...
# =============

mkdir -p $backup_dir

echo "Compressing files"
for dir in $directories; do
    zip_file_name=$(echo "$dir" | tr / -)
    zip -r -q  "$backup_dir/$zip_file_name.zip" "$directories_base_dir/$dir"
done

echo "Creating db dumps"
for db in $databases; do
  mysqldump --force --opt --user=$MYSQL_USER -p$MYSQL_PASSWORD --databases $db > "$db.sql"
  gzip "$db.sql"
  mv "$db.sql.gz" "$backup_dir/db_$db.gz"
done

if [ "$upload_to_dropbox" = "true" ]; then
    echo "Uploading to dropbox"
    bash $CURRENT_DIR/vendor/dropbox_uploader.sh upload $backup_dir $thetime
fi

if [ "$delete_created_backups" = "true" ]; then
    echo "Deleting created files"
    rm -rf $backup_dir
fi
