# Docker in WSL, Ubuntu Container, and Agent Shell — Observed Setup

Scope: only what was set up and verified on this PC (host `D3V-001`, user `D3V_001`). This is not an installation guide for RikkaHub or any other app.

## Environment

- Host OS: Windows, version 10.0.26300.9550 (as reported by `ver`).
- WSL distro: `kali-linux` (Kali GNU/Linux Rolling 2026.3), state Running, WSL version 2. It is the only WSL distro listed by `wsl -l -v`.
- Docker engine: runs inside the `kali-linux` distro. Docker Desktop is not installed.

## How Docker is reached

Docker commands are routed through WSL. There are two routes:

1. **PowerShell.** The profile at `C:\Users\D3V_001\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1` defines:
   ```powershell
   function docker {
       wsl.exe -d kali-linux docker @args
   }
   ```
   `docker ps` works in PowerShell.

2. **Command Prompt.** The `AutoRun` value under `HKCU\Software\Microsoft\Command Processor` loads `C:\Users\D3V_001\macros.doskey`, which contains:
   ```
   docker=wsl.exe -d kali-linux docker $*
   ```
   This applies only to interactive Command Prompt sessions. The agent shell does not load it.

Plain `docker` resolves to `C:\Users\D3V_001\AppData\Local\Microsoft\WinGet\Links\docker.exe`. That binary fails with:
```
failed to connect to the docker API at npipe:////./pipe/docker_engine ... The system cannot find the file specified.
```

**Use this form for Docker commands run through the agent shell:**
```
wsl -d kali-linux docker ps -a
wsl -d kali-linux docker exec ubuntu2404 <command>
```

## Container `ubuntu2404`

- Image: `ubuntu:24.04`. Inside the container, `/etc/os-release` reports Ubuntu 24.04.5 LTS.
- Created with `sleep infinity` as the main process, so it stays running.
- Current container ID starts with `aa38c17ea024`. The container was deleted and recreated to add the mount. The earlier ID `d512c6357954` no longer exists.
- Mount (verified with `docker inspect`):
  - Source: `/mnt/c/Users/D3V_001/repos` (Windows `C:\Users\D3V_001\repos`)
  - Destination: `/workspace`
  - Read-write: yes
  - Changes sync both ways.
- `/workspace` is owned by `ubuntu:ubuntu` with mode `drwxrwxrwx`.
- There is no `/repo` path in the container.

## Agent shell

- Shell: Windows Command Prompt (`cmd.exe`).
- Workspace root: `C:\Users\D3V_001\repos`.
- Commands:
  - `dir` works.
  - `ls` fails with `'ls' is not recognized as an internal or external command`.
- The agent runs as `d3v-001\d3v_001`, the same account as the user.
- Plain `docker` and `docker exec` fail with the npipe error above.
- `wsl -d kali-linux docker ps -a` and `wsl -d kali-linux docker exec ubuntu2404 cat /etc/os-release` both work.

## Agent file tools

- They accept only paths relative to the workspace root.
- A request for `\\wsl$\Ubuntu\etc\os-release` was rejected with `Only paths relative to the workspace are allowed`.
- To get WSL or container files into the agent's reach, use the bind mount. Files in `/workspace` in the container are the same files as in `C:\Users\D3V_001\repos`.

## Errors observed during setup

| Error | Context |
|---|---|
| `Agent tool failed: C:\mnt\c\Users\D3V_001\repos` | Agent shell, command `cat /etc/os-release`. Path translation problem. |
| `Agent tool failed: C:\workspace` | Agent shell and file tools, after a configuration change. The workspace root was not `C:\Users\D3V_001\repos` at that point. After a later configuration change, `dir` ran against `C:\Users\D3V_001\repos`. |
| `Unable to create Docker workspace: ... invalid mount config for type "bind" ... mount path must be absolute` | Agent tool's own Docker workspace setup. |
| `npipe:////./pipe/docker_engine` not found | Plain `docker` in the agent shell. |

## Open item

- In PowerShell, `docker exec ubuntu2404 cat /etc/os-release` printed nothing before the container was recreated. The same command through `wsl -d kali-linux docker exec` returned the Ubuntu release info. This was not investigated further.
