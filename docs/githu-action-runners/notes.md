# Installing and Configuring Github Actions Runners - Self Hosted

## Runners as Service

* Create the runner on github
* [Installing the service](https://docs.github.com/en/actions/how-tos/manage-runners/self-hosted-runners/configure-the-application#uninstalling-the-service)


**Errors**

```bash
[vagrant@github-action-runner actions-runner]$ sudo systemctl status actions.runner.* --no-pager -l
× actions.runner.cb0n3y-the-road-to-devops.ro4d-runner.service - GitHub Actions Runner (cb0n3y-the-road-to-devops.ro4d-runner)
     Loaded: loaded (/etc/systemd/system/actions.runner.cb0n3y-the-road-to-devops.ro4d-runner.service; enabled; preset: disabled)
     Active: failed (Result: exit-code) since Fri 2026-06-26 16:54:24 UTC; 5s ago
   Duration: 2ms
    Process: 81669 ExecStart=/home/vagrant/actions-runner/runsvc.sh (code=exited, status=203/EXEC)
   Main PID: 81669 (code=exited, status=203/EXEC)
        CPU: 1ms

Jun 26 16:54:24 github-action-runner systemd[1]: Started GitHub Actions Runner (cb0n3y-the-road-to-devops.ro4d-runner).
Jun 26 16:54:24 github-action-runner systemd[81669]: actions.runner.cb0n3y-the-road-to-devops.ro4d-runner.service: Failed to locate executable /home/vagrant/actions-runner/runsvc.sh: Permission denied
Jun 26 16:54:24 github-action-runner systemd[81669]: actions.runner.cb0n3y-the-road-to-devops.ro4d-runner.service: Failed at step EXEC spawning /home/vagrant/actions-runner/runsvc.sh: Permission denied
Jun 26 16:54:24 github-action-runner systemd[1]: actions.runner.cb0n3y-the-road-to-devops.ro4d-runner.service: Main process exited, code=exited, status=203/EXEC
Jun 26 16:54:24 github-action-runner systemd[1]: actions.runner.cb0n3y-the-road-to-devops.ro4d-runner.service: Failed with result 'exit-code'.
```

SELinux is making its job. So we have to change some stuff there first.

```bash
sudo chcon -R system_u:object_r:usr_t:s0 /home/vagrant/actions-runner
cd /home/vagrant/actions-runner
sudo ./svc.sh install
sudo ./svc.sh start
```

A new check returned the expected status:

```bash
[vagrant@github-action-runner actions-runner]$ sudo systemctl status actions.runner.* --no-pager -l
● actions.runner.cb0n3y-the-road-to-devops.ro4d-runner.service - GitHub Actions Runner (cb0n3y-the-road-to-devops.ro4d-runner)
     Loaded: loaded (/etc/systemd/system/actions.runner.cb0n3y-the-road-to-devops.ro4d-runner.service; enabled; preset: disabled)
     Active: active (running) since Fri 2026-06-26 16:55:49 UTC; 3min 9s ago
   Main PID: 81861 (runsvc.sh)
      Tasks: 22 (limit: 24732)
     Memory: 56.3M (peak: 58.2M)
        CPU: 929ms
     CGroup: /system.slice/actions.runner.cb0n3y-the-road-to-devops.ro4d-runner.service
             ├─81861 /bin/bash /home/vagrant/actions-runner/runsvc.sh
             ├─81864 ./externals/node20/bin/node ./bin/RunnerService.js
             └─81871 /home/vagrant/actions-runner/bin/Runner.Listener run --startuptype service

Jun 26 16:55:49 github-action-runner systemd[1]: Started GitHub Actions Runner (cb0n3y-the-road-to-devops.ro4d-runner).
Jun 26 16:55:49 github-action-runner runsvc.sh[81861]: .path=/home/vagrant/.local/bin:/home/vagrant/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin
Jun 26 16:55:49 github-action-runner runsvc.sh[81864]: Starting Runner listener with startup type: service
Jun 26 16:55:49 github-action-runner runsvc.sh[81864]: Started listener process, pid: 81871
Jun 26 16:55:49 github-action-runner runsvc.sh[81864]: Started running service
Jun 26 16:55:51 github-action-runner runsvc.sh[81864]: √ Connected to GitHub
Jun 26 16:55:52 github-action-runner runsvc.sh[81864]: Current runner version: '2.335.1'
Jun 26 16:55:52 github-action-runner runsvc.sh[81864]: 2026-06-26 16:55:52Z: Listening for Jobs
```