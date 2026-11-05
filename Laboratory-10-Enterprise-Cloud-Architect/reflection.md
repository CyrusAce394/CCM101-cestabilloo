# Laboratory 10 – Final Mission Reflection
## The Enterprise Cloud Architect

**Subject:** CCM101 – Cloud Computing  
**Project:** CloudNova Enterprise Web Portal

Completing Laboratory 10, The Enterprise Cloud Architect, was the most difficult yet interesting experience I obtained while taking this subject Cloud Computing. With the last laboratory requirement, I got an opportunity to put into practice all that knowledge that I acquired during the previous lab activities. Unlike to the previously lab activities, which included performing some particular task, the current project involved merging different technologies in one functional system. In this work, I learned about cloud infrastructure creation, deployment, protection, and management.

The first thing we had to do was to set up an Ubuntu Server 26.04.1 LTS with the help of Oracle VirtualBox. Due to the limited resources of our laptop, it was necessary to assign memory, processors, and disks properly. At first, I was worried that our laptop would not meet the requirements. But thanks to the proper allocation of resources, we managed to install and run the server without problems. With this project, I learned that resource planning is critical for cloud infrastructure creation.

One more useful lesson for me was how to manage Ubuntu Server remotely via Windows Command Prompt through SSH. Instead of entering commands manually within the virtual machine, we performed all the actions using SSH connection, which allowed copying and executing Linux commands. I learned how cloud administrators remotely manage servers and the significance of network configuration.

Deployment of WordPress and MySQL using Docker Compose was a very useful experience as well. We created a YAML file which described two containers, their communication, and persistent storage volumes. In this way, I learned about advantages of Infrastructure as Code method and interconnection between separate containers. Also, we checked the persistence of data, creating a WordPress post and then restarting the containers and making sure that the post was still available.

Also the one needed also into our project was security. We enabled UFW to block all incoming traffic but allow administrative SSH access. This task helped me understand that implementing the application is not enough because its protection from network attacks is no less important.

The creation of our automatic database backup script was one of the most difficult one. We faced such challenges as MySQL permission errors, wrong command formatting, and an incompletely created backup file. Although these problems were frustrating, they made me analyze the error messages and commands rather than simply following the guide blindly. After fixing our script, we managed to create and verify compressed database backups. Moreover, we implemented a scheduled automatic backup creation via Cron as well as changed the timezone to Philippine Standard Time.

The disaster recovery testing process was especially meaningful to us because we restored our database backup in a new MySQL database and confirmed the presence of WordPress tables and our test post in it. Thus, it became clear that a backup is worth anything only when its contents can be recovered.

To conclude, Laboratory 10 enhanced my technical competencies and also boosted my confidence, patience, and troubleshooting skills. Cloud computing turned out to be much more complicated than running applications online because it includes not only the application but also its protection, automation, monitoring, documentation, and recovery processes. Although our project is just a demonstration of local cloud infrastructure, it helped me acquire practical skills that I can use in my further academic works and profession of information technology specialist.
