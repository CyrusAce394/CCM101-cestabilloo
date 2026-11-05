# Laboratory 10 – The Enterprise Cloud Architect

## CloudNova Enterprise Web Portal

**Subject:** CCM101 – Cloud Computing  
**Laboratory Activity:** 10  
**Mission:** The Enterprise Cloud Architect  
**Project:** CloudNova Enterprise Web Portal  
**Platform:** Ubuntu Server 26.04.1 LTS  
**Deployment:** Docker Compose, WordPress, and MySQL

---

## 1. Project Overview

The CloudNova Enterprise Web Portal is a containerized web application deployed in a private virtualized server environment. This project was developed as the final requirement for CCM101 – Cloud Computing.

The purpose of the project is to demonstrate the integration of Linux server administration, virtualization, containerization, persistent storage, network security, automation, and disaster recovery.

The infrastructure uses Ubuntu Server running inside Oracle VirtualBox. Docker Compose manages two connected containers: WordPress as the web application and MySQL as the database.

The server is administered remotely using SSH through Windows Command Prompt. Security is supported by UFW firewall rules and restricted application port bindings. Automated database backups are handled by a custom Bash script scheduled through Cron.

## 2. Project Objectives

The project aims to:

1. Design and deploy a virtualized Ubuntu Server infrastructure.
2. Configure network connectivity and SSH remote administration.
3. Install and configure Docker Engine and Docker Compose.
4. Deploy a multi-tier WordPress and MySQL application.
5. Implement Docker persistent volumes for data preservation.
6. Configure UFW firewall security with a default-deny incoming policy.
7. Create a Bash script for automated database backups.
8. Schedule database backups through Cron.
9. Verify database backup integrity and restoration.
10. Document the entire infrastructure for operational maintenance and live demonstration.

## 3. Technologies Used

| Technology | Purpose |
|---|---|
| Windows 11 | Physical host operating system |
| Oracle VirtualBox | Virtual machine hypervisor |
| Ubuntu Server 26.04.1 LTS | Linux server operating system |
| OpenSSH | Remote server administration |
| Docker Engine | Container runtime |
| Docker Compose | Multi-container deployment |
| WordPress | Web application |
| MySQL 8.0 | Relational database |
| Docker Volumes | Persistent data storage |
| UFW | Host-based firewall |
| Bash | Database backup automation |
| Cron | Scheduled backup execution |
| GitHub | Source code and technical documentation |

## 4. Virtual Machine Configuration

The Ubuntu Server virtual machine was configured using the following resources:

| Resource | Configuration |
|---|---|
| VM Name | Ubuntu-Server-CloudNova |
| Operating System | Ubuntu Server 26.04.1 LTS |
| Memory | 3072 MB |
| Processors | 2 |
| Virtual Hard Disk | 25 GB |
| Network | NAT with port forwarding |
| SSH Host Port | 2222 |
| SSH Guest Port | 22 |

These settings were selected to provide a functional demonstration environment while considering the limitations of the host laptop.

## 5. System Architecture

The system follows a two-tier application architecture.

### Web Application Tier

The WordPress container handles website content, user interactions, and administrative functions.

### Database Tier

The MySQL container stores WordPress information, including posts, accounts, and configuration records.

### Infrastructure Layer

Ubuntu Server hosts the Docker environment, while Oracle VirtualBox provides virtualization.

### Security and Operations

UFW controls host firewall rules, SSH provides remote administration, Docker volumes preserve data, and Bash with Cron provides scheduled database backups.


## 6. Infrastructure Deployment

The project uses a Docker Compose YAML configuration file to define and manage the application services.

### Deployment Commands

Navigate to the project directory:

```bash
cd /home/cloudnovaadmin/cloudnova-enterprise
```

Validate the configuration:

```bash
sudo docker compose config --quiet
```

Start the containers:

```bash
sudo docker compose up -d
```

Verify their status:

```bash
sudo docker compose ps
```

The deployment contains two main containers:

- `cloudnova-wordpress`
- `cloudnova-database`

The WordPress container is connected to MySQL through an internal Docker network.

The application publishes its web port only to Ubuntu's loopback interface.

## 7. Persistent Storage

Two Docker named volumes were configured:

- `cloudnova-enterprise_mysql_data`
- `cloudnova-enterprise_wordpress_data`

These volumes store database information and WordPress application files separately from the containers' writable layers.

### Persistence Test

A WordPress post entitled **CloudNova Persistent Storage Test** was created and published.

Both containers were restarted using:

```bash
sudo docker compose restart
```

After the restart, the test post remained available.

This demonstrated that application data survives container restarts.

## 8. Firewall Security

UFW was configured using the principle of least privilege.

The configuration includes:

- Default deny for incoming traffic.
- Default allow for outgoing traffic.
- SSH access permitted on TCP port 22.
- WordPress web port bound to Ubuntu's loopback interface.
- No database port directly published to the host.

Firewall verification:

```bash
sudo ufw status verbose
```

This configuration reduces unnecessary exposure of the services.

## 9. Automated Database Backup

A custom Bash script named `automation-script.sh` was created to export and compress the WordPress MySQL database.

The script:

1. Reads the database password from a private environment file.
2. Exports the WordPress database using `mysqldump`.
3. Compresses the exported SQL data.
4. Tests the compressed archive.
5. Saves the completed backup with a timestamp.

Execute the script:

```bash
sudo ./automation-script.sh
```

View backup files:

```bash
sudo ls -lh backups/
```

Only database records are included in this SQL backup. WordPress media files require separate backup procedures.

## 10. Cron Job Scheduling

The database backup script was configured to execute automatically every day at 2:00 AM Philippine time.

The configured Cron schedule is:

```cron
0 2 * * * /home/cloudnovaadmin/cloudnova-enterprise/automation-script.sh >> /home/cloudnovaadmin/cloudnova-enterprise/backup-cron.log 2>&1
```

Verify the schedule:

```bash
sudo crontab -l
```

Verify the Cron service:

```bash
sudo systemctl is-active cron
```

The server timezone was configured to `Asia/Manila`.

Actual scheduled execution requires the Ubuntu virtual machine to remain running at the scheduled time.

## 11. Disaster Recovery Testing

A separate MySQL database named `cloudnova_recovery_test` was created.

A compressed MySQL backup was restored into this database to test recovery without overwriting the live WordPress database.

The recovered database was verified by checking its WordPress tables and searching for the test post.

The test confirmed that the backup contained recoverable application records.

## 12. Testing and Verification

| Test | Result |
|---|---|
| Ubuntu Server installation | Passed |
| SSH remote connection | Passed |
| Docker installation | Passed |
| Docker Compose deployment | Passed |
| WordPress installation | Passed |
| MySQL connection | Passed |
| Persistent storage restart test | Passed |
| UFW firewall configuration | Passed |
| Manual Bash backup execution | Passed |
| Cron configuration | Passed |
| SQL backup integrity verification | Passed |
| Database restoration test | Passed |

Cron's active configuration was verified. Successful unattended scheduled execution should be confirmed separately using backup logs.

## 13. Conclusion

The CloudNova Enterprise Web Portal successfully demonstrates the deployment and operation of a virtualized, containerized, multi-tier web application.

The project integrates the major concepts learned throughout the Cloud Computing laboratory activities, including virtualization, Linux administration, container deployment, security, data persistence, automation, and disaster recovery.

The completed infrastructure provides a practical demonstration of how different cloud computing technologies work together to support a functional application.

---

**CCM101 – Cloud Computing**  
**Laboratory 10: The Enterprise Cloud Architect**
