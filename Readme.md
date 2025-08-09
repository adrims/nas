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
`notifiarr`
  
  - **WARNING!!!** After my expierence I don't recommend this service, is not worth it for 5$ having free ones as Recyclarr or Configurarr
  - Requires account creation -> https://notifiarr.com/
  - Guide to sync trash-guides (requires unique payment of 5$ min) -> https://trash-guides.info/Guide-Sync/
  To see data in the website, first you need to create your notifiarr services and link with your apps.
    - Go to the config file and change whatever you need, is quite self explanatory the config file.
  After your apps/clients has been syncronized with Notifiarr website, you can start sync all profiles you need
    - **IMPORTANT!!**, not sync all profiles, a lot of them are incompatible, sync only your requirements.

  - Custom profile to have Original + Spanish:
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

  `bazarr` 

  Some providers requires signup in ther pages:

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


`prowler`

- To keep posted on free signups on private trackers -> https://opentrackers.org/


### QBittorrent
 - Check the pod logs to connect the first time, depends on the version will be "admin/adminadmin" or "admin/{temporal password generated printed on logs}"

### Cloudflare
- First you need a domain and should be manage by cloudflare
- Go to https://one.dash.cloudflare.com/
- Open Network -> Tunnels
- Create a new tunnel, it will give a command to run the docker container, you can take the token and set up the docker compose to run the command with the token provided.

### JellyFin
  - Activate Hardware acceleration
    - Check the jellyfin documentation -> https://jellyfin.org/docs/general/post-install/transcoding/hardware-acceleration/
    - Check if the drivers are already installed, in this case for intel VAAPI/QSV ```vainfo```, that should return all formats supported by your drivers (the command may will differ on each driver/arch), otherwise install the proper drivers for your machine.
    - Check the groups with access to your GPU, in this case:
        ``` 
        ls -l /dev/dri
        ls -l /dev/dri/renderD128
    - You will see something like:
        ```
        crw-rw---- 1 root video  226,   0 Aug  9 06:51 card0
        crw-rw---- 1 root render 226, 128 Aug  3 12:34 renderD128
    - Add those groups to you're cointainer jellyfin - [Example](https://github.com/adrims/nas/blob/master/mediaserver/docker-compose.yml#L97)
    - Restart the container and go to Dashboard -> PlayBack -> Transcoding
    - Select your hardware acceleration from the table ![GPU Table](documentation\images\GPU-table.png)
    - QSV device -> In this case ```/dev/dri/renderD128 ``` You need to pick the one you're using depending on your system (if you're using containers don't forget to mount it [Example](https://github.com/adrims/nas/blob/master/mediaserver/docker-compose.yml#L95))
    - Activate the formats that your drivers support, usually there are a command that shows you all supported format, in this case ```vainfo```
    - To enable H.264 or HVEC ensure you have HuC firmware configured, otherwise it may cause sync issue.
    - To check if you have HuC firmware configure on Linux you can use:
      ```
        cat /sys/kernel/debug/dri/0/i915_huc_status (for older versions)
        cat /sys/kernel/debug/dri/0/gt/uc/huc_info (for newer versions)

        Should return something lke:

        HuC firmware: i915/tgl_huc.bin
        status: RUNNING
        version: found 7.9.3
        uCode: 589504 bytes
        RSA: 256 bytes
        HuC status: 0x00090001
    - Activate them or deactivate them accorderly

### MultiLanguage
- If you want to have multilanguage audio on movies/shows, I reccomend to set up multiple sonarr/radarr instances per language, you need good indexers with the language you want, otherwise you will get only Original or English.
- To have a good performance on those instances, remove all the indexers and only let the ones are providing the assets in the language you want.
- Have only one profile per instance, forcing on each profile the language you want to use, this also will help to search the titles in the proper language and avoid miss torrents (If you have only one profile and try to manage the languages by priority, won't work as you are gonna miss many torrents if doesn't have the original title)
- With the non original language I recommend to have a profile more flexible in terms of qualities, also in the minimum numbers of seeds in the indexer.
- Private indexers are the key, some examples that private indexers that I saw they're working quite well:
  - [Emuwarez](https://emuwarez.it/) - Spanish
  - [Torrentleach](https://www.torrentleech.org/) - English
        



