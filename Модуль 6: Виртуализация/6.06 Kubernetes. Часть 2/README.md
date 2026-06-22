# Домашнее задание к занятию "6.06 Kubernetes. Часть 2" - "Борисенко Даниил"

---

## Задание 1

### Условие

**Выполните действия:**

1. Создайте свой кластер с помощью kubeadm.
2. Установите любой понравившийся CNI плагин.
3. Добейтесь стабильной работы кластера.

### Ход решения

---

## Задание 2

### Условие

Есть файл с деплоем:

```yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis
spec:
  selector:
    matchLabels:
      app: redis
  replicas: 1
  template:
    metadata:
      labels:
        app: redis
    spec:
      containers:
      - name: master
        image: bitnami/redis
        env:
         - name: REDIS_PASSWORD
           value: password123
        ports:
        - containerPort: 6379
```

**Выполните действия:**

1. Создайте Helm Charts.
2. Добавьте в него сервис.
3. Вынесите все нужные, на ваш взгляд, параметры в `values.yaml`.
4. Запустите чарт в своём кластере и добейтесь его стабильной работы.

### Ход решения

---

## Задание 3*

### Условие

1. Изучите [документацию](https://kubernetes.io/docs/concepts/storage/volumes/#hostpath) по подключению volume типа hostPath.
2. Дополните деплоймент в чарте подключением этого volume.
3. Запишите что-нибудь в файл на сервере, подключившись к поду с помощью `kubectl exec`, и проверьте правильность подключения volume.

### Ход решения

---
