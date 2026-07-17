# Backup Strategy (3-2-1)

A brief overview of how backups are structured across this homelab. Details are intentionally generic here; specific paths, hostnames, and credentials live in a private repo.

## The 3-2-1 rule in practice

- **3 copies:** the primary NAS array, a cloud cold-storage copy, and a separate cloud photo library that predates the homelab and is no longer actively synced -- an independent, frozen point-in-time copy.
- **2 media types:** local RAID HDD array + cloud object storage.
- **1 offsite:** the cloud cold-storage copy.

## What actually gets backed up

- NAS data (documents, media, app data) syncs to cloud cold storage on a schedule.
- Backup-server snapshots (VM/container backups) also sync to the same cloud storage account, in a separate path, so total loss of the backup server doesn't mean losing the backups themselves.
- The sync credential used for the backup-server copy is deliberately scoped without delete permission, so a bug or compromise on the source side can add data but can't destroy what's already offsite.
- Soft delete is enabled on the cloud storage account (30-day window) as a second, independent layer of protection against destructive syncs or accidental deletion.

## Reference implementation

`configs/scripts/pbs-azure-backup.sh` and `.cron` show the actual sync script used for the backup-server copy, sanitized. The no-delete SAS scoping described above is implemented right there in how the destination credential is generated, not in the script itself.

## Lessons learned

- **A sync is not a backup** unless you've thought about what happens when the sync itself goes wrong. A live mirror that can delete or overwrite the remote copy defeats the purpose of having an offsite copy at all. Either restrict the sync credential's permissions, enable versioning/soft delete on the destination, or both.
- **RAID is not a backup.** It protects against a drive failure, not against deletion, corruption, or ransomware. Treat it as local redundancy, not as one of your "3" copies on its own.
- **Test your restores.** A backup you've never restored from is a theory, not a backup. This setup went untested for months before a deliberate restore-test checklist and a recurring reminder were put in place.
