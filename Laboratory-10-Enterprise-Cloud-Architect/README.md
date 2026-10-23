# Laboratory 10 – The Enterprise Cloud Architect

## Mission Overview

This final laboratory activity focuses on designing, deploying, securing, and maintaining a private cloud infrastructure using virtualization, Linux, Docker, and automation.

For this mission, I developed the **CloudNova Private Web Hosting Infrastructure**, a two-tier containerized web application hosted on Ubuntu Server 24.04 LTS inside Oracle VirtualBox.

The infrastructure uses WordPress as the web application and MariaDB as the database. Docker Compose manages the containers, persistent volumes protect application data, UFW provides host-based firewall configuration, and a custom Bash script supports automated database backups through Cron.

This project brings together the cloud computing concepts and technical skills introduced throughout Laboratory Activities 01–09.

## Objectives

- Design a private cloud infrastructure using an architecture diagram.
- Deploy and configure Ubuntu Server inside Oracle VirtualBox.
- Establish network connectivity between Windows and the Ubuntu virtual machine.
- Install and configure Docker Engine and Docker Compose.
- Deploy a two-tier application consisting of WordPress and MariaDB.
- Configure persistent storage for application and database data.
- Implement firewall rules using UFW with a default-deny policy.
- Create an executable Bash script for database backups.
- Configure Cron to schedule automatic backups.
- Document the infrastructure, configurations, and operational procedures.
- Demonstrate the system's functionality during a live defense.

## Project Architecture

The system consists of the following infrastructure components:

| Component | Technology | Purpose |
|---|---|---|
| Host Computer | Windows 11 | Runs the virtualization environment |
| Hypervisor | Oracle VirtualBox | Hosts the Ubuntu Server virtual machine |
| Guest Operating System | Ubuntu Server 24.04 LTS | Provides the Linux server environment |
| Container Platform | Docker Engine | Runs isolated application containers |
| Container Management | Docker Compose | Defines and manages the application stack |
| Web Application | WordPress | Provides the website and administration interface |
| Database | MariaDB | Stores WordPress application data |
| Persistent Storage | Docker Named Volumes | Preserves application and database files |
| Firewall | UFW | Configures host-based traffic restrictions |
| Automation | Bash and Cron | Performs and schedules database backups |
| Remote Administration | OpenSSH | Allows command-line server administration |

### Architecture Diagram

![CloudNova Architecture](architecture-diagram.png)

## Deployment Overview

The infrastructure was deployed through the following stages:

1. Created an Ubuntu Server virtual machine using Oracle VirtualBox.
2. Configured NAT networking and port forwarding for SSH and HTTP access.
3. Installed Docker Engine and Docker Compose.
4. Created a Docker Compose YAML file defining the WordPress and MariaDB services.
5. Configured environment variables and persistent volumes.
6. Started the application containers using Docker Compose.
7. Accessed the WordPress installation interface from the Windows host.
8. Configured UFW firewall policies and allowed the required ports.
9. Created and tested a custom MariaDB backup script.
10. Installed a Cron Job to schedule database backups.

## Networking Configuration

| Service | Port | Purpose |
|---|---|---|
| SSH | Guest 22 / Host 2222 | Remote administration through NAT port forwarding |
| WordPress | 8080 | Access to the local web application |
| MariaDB | 3306 (internal only) | Database communication between containers |

The Windows host accesses WordPress at:

`http://127.0.0.1:8080`

The database is not directly published through a host port.

## Security Implementation

The server uses UFW with the following configuration:

- Default incoming policy: Deny
- Default outgoing policy: Allow
- SSH (TCP 22): Allowed
- Web application (TCP 8080): Allowed

Database credentials are stored in a protected `.env` file, which is excluded from the public repository.

**Security limitation:** Docker-published ports can bypass normal UFW traffic filtering. This implementation is intended for a locally isolated laboratory demonstration. Additional security measures, including Docker-aware firewall filtering and HTTPS, would be needed for production deployment.

## Automation and Backup

A custom Bash script named `automation-script.sh` performs a MariaDB database backup and saves it as a timestamped SQL file.

The script was successfully tested manually and generated a nonempty database backup file.

The scheduled Cron Job is:

```cron
0 2 * * * /home/cyrus11/cloudnova/automation-script.sh >> /var/log/cloudnova-backup.log 2>&1
```

This schedule is configured for daily execution at 2:00 AM Philippine time, provided the Ubuntu virtual machine is running.

Manual backup execution has been verified. Successful scheduled execution and restoration are separate verification activities.

## Monitoring and Maintenance

The following commands are used to inspect the infrastructure:

```bash
sudo docker compose ps
sudo docker compose logs --tail=30
sudo docker stats
sudo ufw status verbose
systemctl is-active cron
sudo ls -lh backups/
```

## Project Files

| File | Description |
|---|---|
| README.md | Project overview and implementation summary |
| architecture-diagram.png | Network topology and infrastructure architecture |
| docker-compose.yml | Multi-tier container configuration |
| automation-script.sh | Automated MariaDB database backup script |
| operational-manual.md | Infrastructure deployment, operation, and maintenance instructions |
| final-reflection.md | Personal reflection on Laboratory Activities 01–10 |
| .env.example | Example configuration without actual passwords |
| .gitignore | Prevents sensitive files and backups from being committed |

## Skills Learned

This project reinforced my understanding of Linux server administration, virtualization, container deployment, persistent storage, network configuration, firewall management, Bash automation, Cron scheduling, troubleshooting, and technical documentation.

It also demonstrated the importance of integrating individual cloud computing technologies into a single functioning infrastructure.

## Conclusion

The CloudNova Private Web Hosting Infrastructure demonstrates the integration of a Linux virtual machine, multi-container application deployment, persistent storage, host-based security configuration, and operational automation.

The project serves as a practical foundation for understanding enterprise cloud infrastructure design, system administration, and DevOps principles.

The solution is a local laboratory prototype and would require additional hardening, tested disaster recovery, and availability planning before production use.
