# CloudNova Private Web Hosting Infrastructure
## Operational Manual

**Course:** CCM101 – Cloud Computing  
**Mission:** Laboratory 10 – The Enterprise Cloud Architect  
**Infrastructure:** Ubuntu Server, Docker Compose, WordPress and MariaDB  
**Deployment Type:** Local private cloud laboratory

---

## 1. Introduction

This operational manual provides instructions for deploying, operating, securing, monitoring, and maintaining the CloudNova Private Web Hosting Infrastructure.

The system is hosted on an Ubuntu Server virtual machine running inside Oracle VirtualBox. Its main purpose is to demonstrate an integrated cloud infrastructure consisting of a web application, database, persistent storage, firewall configuration, and automated operational tasks.

The infrastructure is intended for learning and local demonstration. It is not a public production hosting environment.

## 2. System Requirements

### Host Machine

| Component | Configuration |
|---|---|
| Laptop | Acer Aspire A314-35 |
| Operating System | Windows 11 |
| Processor | Intel Pentium Silver N6000 |
| Memory | 8 GB RAM |
| Hypervisor | Oracle VirtualBox |

### Guest Operating System

- Ubuntu Server 24.04 LTS
- Docker Engine
- Docker Compose plugin
- OpenSSH Server
- UFW Firewall
- Cron Scheduler

### Application Stack

- WordPress web application
- MariaDB database
- Two Docker named volumes
- Docker internal bridge network

## 3. Infrastructure Architecture

The infrastructure uses a two-tier architecture.

### Web Application Tier

WordPress receives browser requests and provides the application's interface. It communicates with MariaDB through an internal Docker network.

### Database Tier

MariaDB stores WordPress content, configuration data, and user information.

The database does not publish port 3306 to the host machine.

### Storage Layer

Two Docker named volumes preserve application data:

- `cloudnova_database_data`
- `cloudnova_wordpress_data`

These volumes allow data to remain available when containers are restarted or recreated, provided the volumes are not deleted.

### Network Configuration

VirtualBox NAT networking is used to provide outbound network access and selected inbound port forwarding.

| Purpose | Host Port | Guest Port |
|---|---|---|
| SSH access | 2222 | 22 |
| WordPress website | 8080 | 8080 |

The configured host-side forwarding addresses use `127.0.0.1`.

## 4. Ubuntu Server Provisioning

1. Create a virtual machine in Oracle VirtualBox.
2. Allocate appropriate system memory, virtual processors, and disk storage.
3. Attach the Ubuntu Server 24.04 LTS installation ISO.
4. Install Ubuntu Server without a graphical desktop.
5. Create a standard administrator account.
6. Install and enable OpenSSH.
7. Configure NAT networking and the required port-forwarding rules.
8. Update the operating system.

Example update commands:

```bash
sudo apt update
sudo apt upgrade -y
```

Verify the operating system:

```bash
lsb_release -a
hostname
free -h
df -h
```

## 5. Remote Server Administration

SSH allows administrators to work with the Ubuntu Server from Windows Terminal.

Connection command from the Windows host:

```powershell
ssh -p 2222 cyrus11@127.0.0.1
```

The virtual machine must be powered on for this connection to succeed.

## 6. Docker Environment

Docker Engine and Docker Compose are installed using Docker's official Ubuntu repository.

Verify installation:

```bash
sudo docker --version
sudo docker compose version
sudo docker run hello-world
```

The `hello-world` container confirms that Docker can download and execute a container image.

## 7. Application Deployment

The application project is stored in:

```text
/home/cyrus11/cloudnova
```

The main deployment files are:

- `docker-compose.yml`
- `.env`
- `automation-script.sh`

The `.env` file contains environment variables used by MariaDB and WordPress. It must not be uploaded to a public GitHub repository.

### Starting the Application

```bash
cd ~/cloudnova
sudo docker compose up -d
```

### Checking Container Status

```bash
sudo docker compose ps
```

Expected application services:

- `db`
- `wordpress`

### Accessing WordPress

Open the following address from the Windows host browser:

```text
http://127.0.0.1:8080
```

Complete the WordPress installation process and log in using the administrator credentials.

## 8. Persistent Data Management

Docker named volumes are used to preserve the WordPress application files and MariaDB data.

Check existing volumes:

```bash
sudo docker volume ls
```

Inspect the application containers:

```bash
sudo docker compose ps
```

### Important Data Protection Rule

Avoid executing the following command unless intentionally removing the application volumes:

```bash
sudo docker compose down -v
```

The `-v` option can delete the named volumes and permanently remove stored application data.

For a persistence test, create a WordPress post, reboot the VM, and verify that the post remains available after the containers restart.

## 9. Security Configuration

The Ubuntu Server uses UFW with a default-deny incoming policy.

### Firewall Commands

Allow SSH:

```bash
sudo ufw allow 22/tcp
```

Allow the WordPress application port:

```bash
sudo ufw allow 8080/tcp
```

Apply default security policies:

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
```

Activate UFW:

```bash
sudo ufw enable
```

Verify the rules:

```bash
sudo ufw status verbose
```

The configuration permits SSH administration and web application access while denying other incoming traffic under UFW's host filtering policy.

**Important security consideration:** Docker's published ports may bypass conventional UFW filtering. Network isolation is additionally supported by VirtualBox NAT and restricting host port forwarding to the Windows loopback interface. Separate connectivity testing is required to confirm effective access restrictions.

### Additional Security Practices

- Keep operating system packages updated.
- Use strong, unique administrator passwords.
- Protect the `.env` file with restrictive permissions.
- Do not publish database credentials.
- Keep MariaDB accessible only through the Docker network.
- Avoid exposing the local HTTP demonstration to the public internet.
- Add TLS, Docker-aware firewall rules, and further hardening before any production deployment.

## 10. Backup Automation

Database backups are handled by the executable script:

```text
automation-script.sh
```

The script creates a timestamped SQL dump of the WordPress database and saves it under:

```text
/home/cyrus11/cloudnova/backups/
```

### Run a Manual Backup

```bash
cd ~/cloudnova
sudo ./automation-script.sh
```

### Verify Backup Files

```bash
sudo ls -lh backups/
```

The script was manually tested successfully and generated nonempty SQL backup files.

### Scheduled Backup

The following root Cron Job schedules daily backup execution:

```cron
0 2 * * * /home/cyrus11/cloudnova/automation-script.sh >> /var/log/cloudnova-backup.log 2>&1
```

The server timezone is configured as `Asia/Manila`.

This schedule is intended to execute every day at 2:00 AM Philippine time, while the VM is running.

### Verify Cron

```bash
systemctl is-active cron
sudo crontab -l
```

### Review Backup Logs

```bash
sudo tail -n 30 /var/log/cloudnova-backup.log
```

A manually successful backup is not sufficient to establish that an actual scheduled execution has occurred. Check the log and resulting backup file after a scheduled run.

### Backup Scope and Limitations

The script backs up MariaDB database contents. It does not include every WordPress file, plugin, theme, or uploaded media item.

For complete disaster recovery, both WordPress storage and the database should be backed up and restored together. Copies should also be stored outside the VM to protect against virtual disk failure.

## 11. Database Recovery Procedure

Recovery should first be tested on an isolated test deployment to avoid overwriting important production data.

General recovery procedure:

1. Identify a known-good SQL backup.
2. Verify that the WordPress and MariaDB versions are compatible with the backup.
3. Stop application writes.
4. Preserve the existing database before restoration.
5. Import the database backup into the correct MariaDB database.
6. Restart or reconnect the WordPress application as needed.
7. Verify that users, posts, and other database records are restored.
8. Test web application functionality.

The generated SQL files provide backup material, but a successful recovery must be independently demonstrated.

## 12. System Monitoring

### Check Running Containers

```bash
sudo docker compose ps
```

### Inspect Container Resources

```bash
sudo docker stats
```

### Check Application Logs

```bash
sudo docker compose logs --tail=30 wordpress
```

### Check Database Logs

```bash
sudo docker compose logs --tail=30 db
```

### Check Server Memory

```bash
free -h
```

### Check Disk Usage

```bash
df -h /
```

### Check Firewall Configuration

```bash
sudo ufw status verbose
```

## 13. Maintenance Procedures

### Restart Containers

```bash
sudo docker compose restart
```

### Stop Containers

```bash
sudo docker compose stop
```

### Start Containers

```bash
sudo docker compose up -d
```

### Safely Shut Down Ubuntu

```bash
sudo shutdown -h now
```

When Ubuntu shuts down properly, its virtual disk preserves configuration files, installed services, and Docker volumes.

The WordPress website becomes temporarily unavailable while the virtual machine is powered off.

## 14. Basic Troubleshooting

| Problem | Possible Cause | Suggested Action |
|---|---|---|
| WordPress does not load | Container stopped or port forwarding incorrect | Check `docker compose ps` and VirtualBox NAT rules |
| SSH connection refused | OpenSSH unavailable or VM off | Start the VM and verify SSH |
| Database connection error | MariaDB stopped or credentials inconsistent | Check database logs and `.env` configuration |
| Container image download fails | Network or registry connection problem | Verify DNS, internet access, and retry the image pull |
| Cron backup fails | Wrong script interpreter, missing permissions, or database problem | Check shebang, execution permissions, and Cron logs |
| Low system performance | Limited VM CPU or memory | Inspect `top`, `free -h`, and `docker stats` |


## 15. Conclusion

The CloudNova Private Web Hosting Infrastructure integrates virtualization, containerization, persistent storage, network administration, host firewall configuration, and automation into one local cloud computing environment.

This operational manual provides instructions for maintaining and troubleshooting the system while highlighting the importance of documentation, reliable backups, and security verification.

The implementation demonstrates core enterprise cloud architecture concepts in a laboratory environment, rather than claiming full production readiness.
