# Домашнее задание к занятию "8.02 Система мониторинга Zabbix" - "Борисенко Даниил"

## Цели задания

1. Научиться устанавливать Zabbix Server c веб-интерфейсом.
2. Научиться устанавливать Zabbix Agent на хосты.
3. Научиться устанавливать Zabbix Agent на компьютер и подключать его к серверу Zabbix.

---

## Задание 1

### Условие

Установите Zabbix Server с веб-интерфейсом.

#### Процесс выполнения

1. Выполняя ДЗ, сверяйтесь с процессом, отражённым в записи лекции.
2. Установите PostgreSQL.
3. Пользуясь конфигуратором команд с официального сайта, составьте набор команд для установки последней версии Zabbix с поддержкой PostgreSQL и Apache.
4. Выполните все необходимые команды для установки Zabbix Server и Zabbix Web Server.

#### Требования к результатам

1. Прикрепите в файл `README.md` скриншот авторизации в админке.
2. Приложите в файл `README.md` текст использованных команд в GitHub.

### Ход решения

Был установлен Zabbix Server с веб-интерфейсом.

В процессе выполнения были установлены:

- PostgreSQL;
- Zabbix Server;
- Zabbix Web Interface;
- Apache;
- Zabbix Agent 2.

1. Сначала были получены права суперпользователя и установлен PostgreSQL:

```bash
sudo -s
apt install postgresql
```

2. Далее был добавлен официальный репозиторий Zabbix:

```bash
wget https://repo.zabbix.com/zabbix/7.4/release/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.4+ubuntu26.04_all.deb
dpkg -i zabbix-release_latest_7.4+ubuntu26.04_all.deb
apt update
```

3. После этого были установлены компоненты Zabbix Server, веб-интерфейса, Apache, PostgreSQL-модуля и Zabbix Agent 2:

```bash
apt install zabbix-server-pgsql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent2 php-pgsql -y
```

4. Затем был создан пользователь базы данных и база данных для Zabbix:

```bash
sudo -u postgres createuser --pwprompt zabbix
sudo -u postgres createdb -O zabbix zabbix
```

5. После создания базы данных была загружена начальная схема Zabbix:

```bash
zcat /usr/share/zabbix/sql-scripts/postgresql/server.sql.gz | sudo -u zabbix psql zabbix
```

6. Далее был отредактирован конфигурационный файл Zabbix Server, где был указан пароль для подключения к базе данных:

```bash
sudo nano /etc/zabbix/zabbix_server.conf
```

7. После настройки конфигурации сервисы были запущены и добавлены в автозагрузку:

```bash
systemctl restart zabbix-server zabbix-agent2 apache2
systemctl enable zabbix-server zabbix-agent2 apache2
```

8. После установки был открыт веб-интерфейс Zabbix.

![Zabbix Web](./task1_zabbix-web.png)

---

## Задание 2

### Условие

Установите Zabbix Agent на два хоста.

#### Процесс выполнения

1. Выполняя ДЗ, сверяйтесь с процессом, отражённым в записи лекции.
2. Установите Zabbix Agent на 2 виртуальные машины, одной из них может быть ваш Zabbix Server.
3. Добавьте Zabbix Server в список разрешённых серверов ваших Zabbix Agent.
4. Добавьте Zabbix Agent в раздел `Configuration` → `Hosts` вашего Zabbix Server.
5. Проверьте, что в разделе `Latest Data` начали появляться данные с добавленных агентов.

#### Требования к результатам

1. Приложите в файл `README.md` скриншот раздела `Configuration` → `Hosts`, где видно, что агенты подключены к серверу.
2. Приложите в файл `README.md` скриншот лога Zabbix Agent, где видно, что он работает с сервером.
3. Приложите в файл `README.md` скриншот раздела `Monitoring` → `Latest data` для обоих хостов, где видны поступающие от агентов данные.
4. Приложите в файл `README.md` текст использованных команд в GitHub.

### Ход решения

Для выполнения задания были установлены и настроены Zabbix Agent 2 на двух хостах.

Один — Zabbix Server, второй — ВМ с установленным Zabbix Agent 2.

1. На хостах был установлен агент и необходимые плагины:

```bash
sudo -s
wget https://repo.zabbix.com/zabbix/7.4/release/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.4+ubuntu26.04_all.deb
dpkg -i zabbix-release_latest_7.4+ubuntu26.04_all.deb
apt update
apt install zabbix-agent2
apt install zabbix-agent2-plugin-mongodb zabbix-agent2-plugin-mssql zabbix-agent2-plugin-postgresql
```

2. После установки был отредактирован конфигурационный файл агента:

```bash
sudo nano /etc/zabbix/zabbix_agent2.conf
```

В конфигурационный файл были добавлены параметры подключения к Zabbix Server:

```text
Server=127.0.0.1,192.168.122.134
ServerActive=127.0.0.1,192.168.122.134
Hostname=ZabbixAgent
```

Для второго агента был указан отдельный hostname:

```text
Hostname=ZabbixAgent2
```

3. После изменения конфигурации Zabbix Agent 2 был перезапущен:

```bash
sudo systemctl restart zabbix-agent2
sudo systemctl enable zabbix-agent2
```

4. Статус агента проверялся командой:

```bash
sudo systemctl status zabbix-agent2
```

5. Также были просмотрены логи агента:

```bash
sudo journalctl -u zabbix-agent2.service --no-pager
```

В логах видно, что Zabbix Agent 2 успешно запускается и работает с указанным hostname.

![Zabbix Agent logs](./task2.1_logs.png)

6. После настройки агентов в веб-интерфейсе Zabbix были добавлены два узла сети в разделе:

`Сбор данных` → `Узлы сети`

Агенты добавлены, активированы и доступны по интерфейсу ZBX.

![Zabbix Hosts](./task2.2_hosts.png)

7. После подключения агентов была проверена страница последних данных:

`Мониторинг` → `Последние данные`

На странице отображаются метрики с двух хостов: `ZabbixAgent` и `ZabbixAgent2`.

![Latest Data](./task2.3_last_data.png)

---

## Задание 3 со звёздочкой*

### Условие

Установите Zabbix Agent на Windows-компьютер и подключите его к серверу Zabbix.

#### Требования к результатам

1. Приложите в файл `README.md` скриншот раздела `Latest Data`, где видно свободное место на диске `C:`.

### Ход решения

---

**Список используемой литературы:**

- [Zabbix: Download and install Zabbix](https://www.zabbix.com/download)
- [Zabbix Documentation: Installation from packages](https://www.zabbix.com/documentation/current/en/manual/installation/install_from_packages)
- [Zabbix Documentation: Zabbix agent 2](https://www.zabbix.com/documentation/current/en/manual/concepts/agent2)
- [Zabbix Documentation: Configuration file — zabbix_agent2.conf](https://www.zabbix.com/documentation/current/en/manual/appendix/config/zabbix_agent2)
- [Zabbix Documentation: Hosts](https://www.zabbix.com/documentation/current/en/manual/config/hosts/host)

---
