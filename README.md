## Подготовка

# Настроить host mikrotik-ansible

Необходима установка модулей с ansible-galaxy для возможности управления устройствами на ROS:
1) [ansible.netcommon](https://docs.ansible.com/ansible/latest/collections/ansible/netcommon/network_cli_connection.html#ansible-collections-ansible-netcommon-network-cli-connection/)
2) [community.routeros](https://galaxy.ansible.com/ui/repo/published/community/routeros/) ```shellansible-galaxy collection install community.routeros```

# Подготовка mikrotik

В первую очередь необходимо зайти на роутер, установить пароль admin и убедиться что на mikrotik установлена ROS 7.x, синтаксис ROS 6.x местами отличается, по этому нет 100% гарантий что роли ansible обработают нормально. Базовые моменты, как смена пароля, добавление/удаление правил в firewall, nat имеют одинаковый синтаксис на обоих ROS.

Настройка микротика по доступу ssh и добавлению пользователя ansible для работы play-book, по умолчанию при настройке с нуля play-book сам выполняет  их от имени пользователя admin с паролем который вы задали, пароль необходимо указать в файле ```hosts -> ansible_ssh_pass```

```
[routers_pre_setup:vars]
ansible_connection=ansible.netcommon.network_cli
ansible_network_os=community.routeros.routeros
ansible_user=admin
ansible_ssh_pass=PASSWORD
```

и вносить вручную через терминал не требуется, но если вы хотите управлять уже настроенным роутером, то стоит выполнить следующее:


Добавить пользователя ansible с указанным паролем и группой прав full

```
/use add name=ansible password=PASSWORD group=full
```
Включить доступ по ssh в services
```
/ip service enable ssh
```

Указать с каких ip можно подключаться к mikrotik по ssh

```
/ip service set ssh address=192.168.0.0/16,10.0.0.0/8
```

Открыть порт ssh в firewall

```
/ip firewall filter add action=accept chain=input comment="Access to SSH  Mikrotik for Ansible" dst-port=22 protocol=tcp
```

Разместить правило на нужном месте в firewall

```
/ip firewall filter move [find comment="Access to SSH  Mikrotik for Ansible"] 6
```


# Взаимодействие с переменными
Перед настройкой нового mikrotik необходимо изменить данные в *динамических переменных*, согласно порядку настройки соответствующего клиента под которого готовится оборудование, так же прописать IP адрес если он отличается от стандартного в *hosts* файле

[Содержимое файла hosts](https://gitlab)

pre_routers ansible_host - запускает tasks под пользователейм admin

new_routers - запускает tasks под пользователем ansible

<details>
    <summary>hosts</summary>
    
    ```
    #Настройка роутера с нуля начинается тут ==========
    [routers_pre_setup]
    pre_routers ansible_host=192.168.88.1

    [routers_pre_setup:vars]
    ansible_connection=ansible.netcommon.network_cli
    ansible_network_os=community.routeros.routeros
    ansible_user=admin
    ansible_ssh_pass=PASSWORD

    [routers_new]
    new_routers ansible_host=192.168.88.1

    [routers_new:vars]
    ansible_connection=ansible.netcommon.network_cli
    ansible_network_os=community.routeros.routeros
    ansible_user=ansible
    ansible_ssh_pass=PASSWORD

    #Статическое значение не менять!!!
    [routers_l2tp_server]
    l2tp_server_mikrotik ansible_host=IPADDRESS

    [routers_l2tp_server:vars]
    ansible_connection=ansible.netcommon.network_cli
    ansible_network_os=community.routeros.routeros
    ansible_user=ansible
    ansible_ssh_pass=PASSWORD

    #Указать ip роутера клиента до куда будет строиться маршрут
    [router_l2tp_server_client]
    client_mikrotik ansible_host=

    [router_l2tp_server_client:vars]
    ansible_connection=ansible.netcommon.network_cli
    ansible_network_os=community.routeros.routeros
    ansible_user=ansible
    ansible_ssh_pass=PASSWORD
    ```
</details>


## Виды переменных

[Описание](https://gitlab)

[Содержимое файла dinamic_vars.yml](https://gitlab)


[Содержимое файла static_vars.yml](https://gitlab)


# Примеры запуска play-books

1) Запуск play-book на всю группу которая прописана в **hosts**
```
sudo ansible-playbook all_backup_mikrotiks.yml
```

2) Запуск play-book на конкретный хост из списка **hosts**

Запуск на конкретных хосты
```
sudo ansible-playbook all_backup_mikrotiks.yml -i hosts -l 'host-1:host-4'
```
Запуск на диапазон хостов
```
sudo ansible-playbook all_backup_mikrotiks.yml -i hosts -l 'host[1-2]'
```
Запуск на маски
```
sudo ansible-playbook all_backup_mikrotiks.yml -i hosts -l 'host-1*'
```
