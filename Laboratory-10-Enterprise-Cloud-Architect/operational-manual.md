# CloudNova Enterprise Web Portal
## Operational Manual

**Project:** CloudNova Enterprise Web Portal  
**Laboratory:** 10 – The Enterprise Cloud Architect  
**Subject:** CCM101 – Cloud Computing  
**Operating System:** Ubuntu Server 26.04.1 LTS

---

## 1. Introduction

This operational manual provides the procedures required to deploy, administer, secure, maintain, back up, and troubleshoot the CloudNova Enterprise Web Portal.

The infrastructure consists of an Ubuntu Server virtual machine hosting a Docker Compose application with WordPress and MySQL services.

This documentation is intended to assist administrators in understanding the system's configuration and performing basic operational tasks.

## 2. Infrastructure Requirements

### Hardware Requirements

The demonstration environment uses a Windows host laptop with Oracle VirtualBox.

The Ubuntu Server virtual machine was configured with:

- 3072 MB RAM
- 2 virtual processors
- 25 GB virtual hard disk
- NAT network connectivity

Actual resource requirements may vary according to application usage.

### Software Requirements

- Oracle VirtualBox
- Ubuntu Server 26.04.1 LTS
- OpenSSH Server
- Docker Engine
- Docker Compose plugin
- UFW
- Cron
- WordPress and MySQL container images

## 3. Starting the Infrastructure

Open Oracle VirtualBox Manager.

Select the virtual machine named `Ubuntu-Server-CloudNova` and start it.

Once Ubuntu has booted, log in using the configured Linux account.

### Access Through Windows CMD

Open Windows Command Prompt and enter:

```bash
ssh -p 2222 cloudnovaadmin@127.0.0.1
```

Authenticate using the Ubuntu Server account password.

After a successful login, the terminal should display an Ubuntu shell prompt.

## 4. Application Deployment

Navigate to the project directory:

```bash
cd /home/cloudnovaadmin/cloudnova-enterprise
```

Confirm the Compose file exists:

```bash
ls -l docker-compose.yml
```

Ensure the private `.env` file exists and contains the database password configured for the persistent MySQL instance.

Do not overwrite an existing database password with a newly generated password when using the existing MySQL volume.

Validate the Compose configuration:

```bash
sudo docker compose config --quiet
```

Start the application:

```bash
sudo docker compose up -d
```

Check the services:

```bash
sudo docker compose ps
```

Both WordPress and MySQL should be running.

## 5. Accessing WordPress

WordPress is published on Ubuntu's loopback address at port 8080.

From a separate Windows Command Prompt, create an SSH tunnel:

```bash
ssh -N -o ExitOnForwardFailure=yes -L 127.0.0.1:8888:127.0.0.1:8080 -p 2222 cloudnovaadmin@127.0.0.1
```

Keep the tunnel open.

Open the browser and navigate to:

`http://127.0.0.1:8888/wp-admin/`

Log in using the configured WordPress administrator account.

If the page fails to load, verify the SSH tunnel and Docker container status.

## 6. Container Management

### Display Running Containers

```bash
sudo docker compose ps
```

### Start the Application

```bash
sudo docker compose up -d
```

### Restart the Containers

```bash
sudo docker compose restart
```

### Display Application Logs

```bash
sudo docker compose logs --tail=50 wordpress
```

### Display Database Logs

```bash
sudo docker compose logs --tail=50 database
```

### Check Container Resource Usage

```bash
sudo docker stats --no-stream
```

Avoid removing the named volumes during ordinary maintenance.

The command `docker compose down -v` removes volumes and can destroy application data.

## 7. Persistent Storage Management

The infrastructure contains two named volumes:

- `cloudnova-enterprise_mysql_data`
- `cloudnova-enterprise_wordpress_data`

The MySQL volume preserves database files.

The WordPress volume preserves web application files, uploaded media, plugins, and other persistent application data.

List volumes:

```bash
sudo docker volume ls
```

To demonstrate persistence, create a WordPress test post, restart the containers, and confirm that the post remains available.

## 8. Firewall Management

UFW is configured to block unsolicited incoming connections by default.

### Inspect Firewall Status

```bash
sudo ufw status verbose
```

### Initial Firewall Configuration

The following commands describe the established firewall configuration:

```bash
sudo ufw allow 22/tcp
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable
```

Allow SSH before enabling the firewall to reduce the risk of interrupting remote administration.

The WordPress application uses a loopback-only published port, and MySQL is not directly published to the host.

Docker's handling of published ports requires additional consideration beyond ordinary UFW rules when services are exposed on network interfaces.

## 9. Database Backup Operations

A Bash script named `automation-script.sh` is used to create compressed backups of the WordPress MySQL database.

### Execute Backup Manually

```bash
cd /home/cloudnovaadmin/cloudnova-enterprise
sudo ./automation-script.sh
```

### List Backup Files

```bash
sudo ls -lht backups/
```

Backups are stored as timestamped `.sql.gz` files.

### Verify Backup Integrity

Select the latest nonempty archive:

```bash
LATEST=$(sudo find backups -maxdepth 1 -name 'mysql_backup_*.sql.gz' -size +100c -printf '%T@ %p\n' | sort -nr | head -1 | cut -d' ' -f2-)
```

Verify its gzip integrity:

```bash
sudo gzip -t "$LATEST"
```

Inspect the database definitions:

```bash
sudo gzip -cd "$LATEST" | grep -m 1 'CREATE TABLE'
```

A successful integrity test does not replace an actual database restoration test.

These SQL backups do not include WordPress uploaded files and other media. A complete recovery strategy requires backing up the WordPress persistent volume separately.

## 10. Automated Backup Scheduling

The root Cron scheduler was configured to run the backup script every day at 2:00 AM Philippine time.

The Cron entry is:

```cron
0 2 * * * /home/cloudnovaadmin/cloudnova-enterprise/automation-script.sh >> /home/cloudnovaadmin/cloudnova-enterprise/backup-cron.log 2>&1
```

### Verify the Cron Schedule

```bash
sudo crontab -l
```

### Check the Cron Service

```bash
sudo systemctl is-active cron
```

### Check the Timezone

```bash
timedatectl
```

The server should use `Asia/Manila`.

### Inspect Scheduled Backup Logs

```bash
sudo tail -n 30 /home/cloudnovaadmin/cloudnova-enterprise/backup-cron.log
```

Cron schedules operate only while the Ubuntu virtual machine and the Cron service are running.

The configured schedule and active service were verified during development. Actual scheduled execution should be confirmed using the generated logs and backup timestamps.

## 11. Disaster Recovery Procedure

The backup restoration process was tested using a separate database named `cloudnova_recovery_test`.

This test database was used to avoid overwriting the live WordPress database.

The recovery procedure consists of:

1. Selecting a validated database backup.
2. Preparing an isolated MySQL recovery database.
3. Importing the SQL statements from the backup archive.
4. Verifying the restored WordPress tables.
5. Checking application records in the recovered database.

### Inspect the Existing Recovery Database

Open the MySQL console:

```bash
sudo docker compose exec database mysql -u root -p
```

Enter the MySQL root password privately.

Run:

```sql
SHOW TABLES FROM cloudnova_recovery_test;
```

Verify the test record:

```sql
SELECT ID, post_title
FROM cloudnova_recovery_test.wp_posts
WHERE post_title = 'CloudNova Persistent Storage Test';
```

Exit the database console:

```sql
exit;
```

The laboratory recovery test successfully restored WordPress tables and the persistent storage test post.

Do not restore an unverified backup directly over the live WordPress database.

## 12. System Monitoring

### Memory Usage

```bash
free -h
```

### Disk Usage

```bash
df -h /
```

### CPU and Process Monitoring

```bash
top
```

Press `q` to exit the monitoring screen.

### Container Resource Usage

```bash
sudo docker stats --no-stream
```

### Docker Service Status

```bash
sudo systemctl is-active docker
```

### Web Application Availability

Inside Ubuntu:

```bash
curl -I http://127.0.0.1:8080
```

An HTTP response confirms that the web server is responding, although the application should also be tested through the browser.

## 13. Troubleshooting Guide

### Problem: Docker Compose Cannot Find the Configuration File

Cause: The terminal is outside the project directory.

Solution:

```bash
cd /home/cloudnovaadmin/cloudnova-enterprise
```

Then rerun the Docker Compose command.

### Problem: WordPress Cannot Be Accessed From Windows

Possible causes include an inactive SSH tunnel, stopped containers, or a local port conflict.

Verify:

```bash
sudo docker compose ps
```

Confirm the SSH tunnel is running on Windows port 8888.

### Problem: MySQL Connection Failed

Check the database container:

```bash
sudo docker compose logs --tail=50 database
```

Verify that the application configuration uses the correct database credentials and container service name.

Do not replace the `.env` password without understanding how the existing MySQL volume was initialized.

### Problem: Database Backup Fails

Check that the database container is running.

Confirm the private `.env` file exists.

Inspect the backup script and verify the `mysqldump` command includes:

```bash
--single-transaction --no-tablespaces
```

### Problem: Cron Backup Does Not Run

Check Cron status:

```bash
sudo systemctl is-active cron
```

Verify the root Cron schedule:

```bash
sudo crontab -l
```

Inspect the backup log and confirm that the virtual machine was running at the scheduled time.

## 14. Security Considerations

The administrator should:

- Protect SSH, database, and WordPress passwords.
- Avoid committing `.env` files to GitHub.
- Keep database backup files private.
- Review firewall rules regularly.
- Update Ubuntu and container images during scheduled maintenance.
- Verify backups and periodically test restoration.
- Avoid exposing the MySQL container directly to external networks.
- Use HTTPS and stronger credential management for any production deployment.

## 15. Shutdown and Restart Procedure

To shut down Ubuntu safely:

```bash
sudo shutdown -h now
```

After restarting the VM, check:

```bash
sudo docker compose ps
```

The Compose services use the `unless-stopped` restart policy.

If necessary, start them with:

```bash
sudo docker compose up -d
```

Application data should remain available because the containers use persistent volumes.

## 16. Operational Limitations

The system is a local private-cloud proof of concept.

It depends on the physical Windows host, VirtualBox, and Ubuntu Server remaining operational.

The current automated backup process protects database data only. Full application recovery would also require WordPress file backups.

Further production improvements would include off-site backups, centralized monitoring, HTTPS, credential rotation, and additional security controls.

## 17. Conclusion

The CloudNova Enterprise Web Portal demonstrates the operational management of a containerized multi-tier application.

The infrastructure combines Ubuntu Server, Docker Compose, persistent storage, UFW firewall security, Bash automation, Cron scheduling, and tested MySQL database recovery.

This manual provides the essential procedures needed to operate and maintain the laboratory environment.

---

**CloudNova Enterprise Web Portal**  
**CCM101 – Laboratory 10**
