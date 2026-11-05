# Laboratory 10 – Final Mission Reflection
## The Enterprise Cloud Architect

**Subject:** CCM101 – Cloud Computing  
**Project:** CloudNova Enterprise Web Portal

Conducting Laboratory 10, The Enterprise Cloud Architect, was quite an engaging activity since I managed to see the importance of cloud computing in the management of applications in the current digital age. This activity helped us integrate all the skills and knowledge gained during the previous laboratories into one system and provided me with an insight into the interaction between various technologies to provide reliable services.

First of all, we were installing Ubuntu Server 26.04.1 LTS on Oracle VirtualBox. The installation process required careful configuration due to limited resources (memory and storage space) of our laptop. In this way, I managed to learn about the importance of proper resource allocation when setting up a server environment. Moreover, the SSH service was configured which allowed accessing the Ubuntu Server through Windows Command Prompt. It was much easier to execute commands in this way, which also helped me to gain insights into remote server administration.

One of the most interesting activities was deployment of WordPress and MySQL using Docker Compose. We managed to create a configuration file where both containers could communicate within an internal network. Thus, I found out how important containerization is because of the independence of different services and their connection at the same time. Also, we managed to implement persistent volumes which are responsible for keeping application data safe. We tested it by rebooting the services and saw that some vital information could still be available after rebooting.

Moreover, configuring the UFW firewall was also a useful activity since it allowed me to understand the importance of security in server administration.

In my opinion, the creation of the automated database backup became one of the most difficult stages for me personally. There were errors related to permissions to the database and Bash commands, and we had to try a few times in order to fix everything correctly. Instead of abandoning our efforts, we analyzed the errors and corrected the script so that it could work properly. We also scheduled automatic backups with Cron. It helped me understand how automation helps to save time.

Another achievement is a successful test of the database recovery. Our group managed to restore the database backup in a separate recovery database and to check whether WordPress information was still there. It helped me understand that backups have to be tested for sure in order to be able to recover data in case of some problems.

All in all, the final laboratory helped me feel more confident about using such tools as Linux, Docker, networking and security as well as scripts in order to automate processes. However, the most important thing is that I learned the importance of patience, collaboration and solving problems in this way. Becoming good at cloud computing is an ongoing process of learning and practice.
