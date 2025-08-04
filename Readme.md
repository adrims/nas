# NAS

## Useful Commands

### Container Management
- `docker logs {CONTAINER_NAME}`  
  Check logs of a running container

- `docker exec -it {CONTAINER_SERVICE_NAME} id`  
  Check which user is running inside a container

### Configuration
- `getent passwd 1000`  
  Lists user accounts on the system matching UID 1000
  
- `sudo chown -R 1000:1000 {FOLDER_PATH} or 1000:{groupid} {FOLDER_PATH} check group id with: id -g`  
  Ensure mounted volume on host is owned by UID/GID 1000, matching the user in Docker Compose settings. Useful to fix permission issues from container services writting files from shared volumes with the host.

### Services that requires external signup/login
- `notifiarr`
  Requires account creation -> https://notifiarr.com/
  Guide to sync trash-guides (requires unique payment of 5$ min) -> https://trash-guides.info/Guide-Sync/
  To see data in the website, first you need to create your notifiarr services and link with your apps.
    - Go to the config file and change whatever you need, is quite self explanatory the config file.
  After your apps/clients has been syncronized with Notifiarr website, you can start sync all profiles you need
    - !IMPORTANT, not sync all profiles, a lot of them are incompatible, sync only your requirements.

  Custom profile to have Original + Spanish:
  ```
  {
    "trash_id": "custom-original-spanish",
    "trash_scores": {
        "spanish-anime-multi": 500,
        "spanish-anime-vose": -10000,
        "spanish-multi-vf": 500,
        "spanish-multi-vo": 500,
        "spanish-vose": 0
    },
    "name": "Language: Original + Spanish",
    "includeCustomFormatWhenRenaming": false,
    "specifications": [
        {
        "name": "Original Language",
        "implementation": "LanguageSpecification",
        "negate": false,
        "required": true,
        "fields": {
            "value": -2
        }
        },
        {
        "name": "Spanish Language",
        "implementation": "LanguageSpecification",
        "negate": false,
        "required": true,
        "fields": {
            "value": 3
        }
        },
        {
        "name": "MULTi",
        "implementation": "ReleaseTitleSpecification",
        "negate": false,
        "required": true,
        "fields": {
            "value": "\\b(MULTi)(\\b|\\d)"
        }
        }
    ]
  }

`bazarr` Some providers requires signup in ther pages:

- Opensubtitles.com
- Addic7ed (This one requires captcha resolver)
- Integration with AniDB:
    - Create an account on -> https://anidb.net/
    - Create new project on -> https://anidb.net/software/add
    - Create new client -> !IMPORTANT should be HTTP
    - Configure the client name and version on bazarr

`no-ip` 

- Requires create an account -> https://www.noip.com/es-MX
- Create a new DNS config
- Create a new DNS key
- Pass the user and key on the commands, you can use an .env file:

            command:
            [
                "--username", "${NOIP_USERNAME}",
                "--password", "${NOIP_PASSWORD}",
                "--hostnames", "${NOIP_HOSTNAMES}"
            ]
    
- If you use DNS key hostname should be generic not your DNS -> all.ddnskey.com

### QBittorrent
 - Check the pod logs to connect the first time, depends on the version will be "admin/adminadmin" or "admin/{temporal password generated printed on logs}"

### Cloudflare
- First you need a domain and should be manage by cloudflare
- Go to https://one.dash.cloudflare.com/
- Open Network -> Tunnels
- Create a new tunnel, it will give a command to run the docker container, you can take the token and set up the docker compose to run the command with the token provided.