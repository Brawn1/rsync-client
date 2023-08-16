SSH und Rsync in einen Debian Container gepackt, für eine einfach Verwendung.

Hierbei handelt es nicht um ein Backup System, sondern beinhaltet die Tools um selber auf die schnelle Daten von einem System in ein anderes zu Transferieren.
Dabei kann es mit jedem Endpunkt arbeiten, was RSYNC mit oder ohne SSH kann (Optional kann man auch scp verwenden).

Der Container erzeugt beim ersten Start, Automatisch die SSH Schlüssel und kopiert sie in den **/config** Ordner.


## Docker Compose Beispiele

### RSYNC mit SSH

Sicherung **/data** auf den Server **rsync.server.at** als **user1** in den Ordner **/backup** mit SSH und RSYNC.

Mit der Option **-o StrictHostKeyChecking=no** kann man die Prüfung und den erstmaligen Prompt überspringen (sollte nur verwendet werden, falls man den Server kennt, bzw. einen Grund hat).
 

docker-compose.yaml

```yaml
version: "3"

services:
  rsync_client:
    restart: on-failure
    image: guenterbailey/rsync-client:latest
    build: .
    volumes:
      - ./config:/config
      - roothome:/root:rw <-- optional
    command: "rsync -aC --progress -e 'ssh -o StrictHostKeyChecking=no' /data/ user1@rsync.server.at:/backup/"
```

### RSYNC

Sicherung **/data** auf den Server **rsync.server.at** nach **backup**.

```yaml
version: "3"

services:
  rsync_client:
    restart: on-failure
    image: guenterbailey/rsync-client:latest
    build: .
    volumes:
      - ./config:/config
    command: "rsync -aC --progress /data/ rsync.server.at::backup/"
```