# Demo
Готовое системное окружение на базе docker для проведения демонстраций и тестов.

## Системные требования
- [docker](https://docs.docker.com/)* >= 20.10 ([установка](https://docs.docker.com/get-started/#download-and-install-docker))
- [docker-compose](https://docs.docker.com/compose/)* >= 1.29 ([установка](https://docs.docker.com/compose/install/))
- [make](https://www.gnu.org/software/make/) >= 4.1
- [git](https://git-scm.com/doc) >= 2.17 ([установка](https://git-scm.com/book/ru/v2/%D0%92%D0%B2%D0%B5%D0%B4%D0%B5%D0%BD%D0%B8%D0%B5-%D0%A3%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BA%D0%B0-Git))

В случае запуска в рамках Ubuntu установку docker и docker-compose можно выполнить запуском команд в корневой директории
репозитория:
```shell
make install-docker
make install-docker-compose
```

## Установка
- Клонируем репозиторий командой и переходим в него: `git clone git@github.com:alekciy/demo.git && cd demo`.
- Запускаем один из примеров ниже.
Остановка всех контейнеров с примерами выполняется командой: `make down`.

## Примеры

### Пример 1: PostgreSQL диапазонный тип данных для КВС

- **Запуск**: `make example-pg_range-up`.
- **Цель**: Демонстрация плюсов при использовании диапазонного типа данных PostgreSQL.

В ходе запуска стартует PostgreSQL сервер в котором создаются таблицы и загружаются данные со значениями КВС
(Коэффициент Возраст-Стаж по ОСАГО). После чего выводятся реквизиты доступа к базе.

Данный пример содержит 4 варианта (схемы) хранения КВС в РСУБД. Предназначен для наглядной демонстрации преимущества
схемы построенной на диапазонном типе данных PostgreSQL. Подробное описание и сравнение можно найти в статье на Хабре
[PostgreSQL: пример использования диапазонного типа данных при расчете коэффициента возраст-стаж в ОСАГО](https://habr.com/ru/company/regru/blog/696628/).
