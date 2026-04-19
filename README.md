# VYUD AI B2B Landing Page

Улучшенный лендинг с интеграцией Supabase и Google Calendar.

## 🚀 Что изменилось

### 1. Форма → Supabase (вместо Formspree)
- Лиды сохраняются напрямую в твою базу Supabase
- Row Level Security (RLS) защищает данные
- Полный контроль над данными, без лимитов сторонних сервисов

### 2. Google Calendar интеграция
- После отправки формы показывается виджет бронирования
- Лид сразу может выбрать слот для демо
- Автоматическое приглашение на почту

### 3. Защита от спама (Honeypot)
- Скрытое поле ловит ботов
- Не требует CAPTCHA (лучше для UX)
- Боты "отправляют" форму, но данные не сохраняются

### 4. Улучшенный UX
- Валидация полей с подсветкой ошибок
- Анимация загрузки на кнопке
- Плавные переходы между состояниями формы
- Step indicator показывает прогресс

---

## 📦 Установка

### Шаг 1: Настройка Supabase

1. Зайди в [Supabase Dashboard](https://supabase.com/dashboard)
2. Создай новый проект или открой существующий
3. Перейди в **SQL Editor**
4. Выполни содержимое файла `setup_supabase.sql`

### Шаг 2: Получение ключей Supabase

1. В Supabase Dashboard → **Settings** → **API**
2. Скопируй:
   - `Project URL` → это твой `SUPABASE_URL`
   - `anon public` key → это твой `SUPABASE_ANON_KEY`

### Шаг 3: Настройка index.html

Открой `index.html` и найди секцию конфигурации (около строки 470):

```javascript
// ============================================
// КОНФИГУРАЦИЯ - ЗАМЕНИ НА СВОИ ЗНАЧЕНИЯ!
// ============================================
const SUPABASE_URL = 'YOUR_SUPABASE_URL';           // ← замени
const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY'; // ← замени
```

### Шаг 4: Деплой на GitHub Pages

```bash
# Клонируй репозиторий (если ещё нет)
git clone https://github.com/Retyreg/vyud-AI-landing.git
cd vyud-AI-landing

# Замени index.html новым файлом
cp /path/to/new/index.html ./index.html

# Коммит и пуш
git add .
git commit -m "feat: Supabase + Google Calendar интеграция"
git push origin main
```

---

## 🗓️ Google Calendar

URL для записи уже настроен в коде:
```
https://calendar.google.com/calendar/appointments/schedules/AcZssZ2Q1BiHUkIBYZ69cKODCZY3-3ALBK-ZLcKSDa93d-uH9Ef_CopjzEssV8eA1VWFM86umATJGueu?gv=true
```

Если нужно изменить — найди переменную `CALENDAR_URL` в JS-секции.

---

## 📊 Yandex.Metrika Goals

Настроены следующие цели:
- `click_header_demo` — клик на CTA в header
- `click_hero_demo` — клик на главную CTA в hero
- `click_telegram_b2b` — клик на Telegram-бот
- `submit_demo_form` — успешная отправка формы
- `show_calendar` — показ календаря после отправки

---

## 🔒 Безопасность

- **RLS включен** — анонимные пользователи могут только INSERT
- **Honeypot защита** — боты не смогут спамить форму
- **Anon key безопасен** — он предназначен для клиентского использования

⚠️ **НИКОГДА не используй service_role key на фронтенде!**

---

## 🐛 Troubleshooting

### Форма не сохраняет данные
1. Проверь консоль браузера (F12 → Console)
2. Убедись, что `SUPABASE_URL` и `SUPABASE_ANON_KEY` корректны
3. Проверь, что таблица `leads` создана в Supabase
4. Проверь RLS политики: `SELECT * FROM pg_policies WHERE tablename = 'leads';`

### Google Calendar кнопка не появляется
1. Проверь, что скрипт загружается: `https://calendar.google.com/calendar/scheduling-button-script.js`
2. Проверь консоль на ошибки
3. Убедись, что календарь публично доступен

### Honeypot срабатывает на реальных пользователях
Это не должно происходить — поле полностью скрыто (`position: absolute; left: -9999px`).
Если происходит — проверь, что CSS загружается корректно.

---

## 📁 Структура файлов

```
vyud-AI-landing-B2B/
├── index.html                    # Главная страница (4 вертикали)
├── _industry_template.html       # Шаблон для отдельных отраслевых лендингов
├── images/screenshots/           # Скриншоты TMA (step-1..4.png, см. README внутри)
├── setup_supabase.sql            # SQL для настройки базы данных
├── privacy.html                  # Политика конфиденциальности
├── offer.pdf                     # Публичная оферта
├── CNAME                         # Домен для GitHub Pages
└── README.md                     # Эта документация
```

---

## 🏭 Отраслевая архитектура

Лендинг построен с учётом будущего разделения по отраслям:

- `index.html` — общий лендинг с 4 вертикалями (HoReCa / Отели / Ритейл / FMCG)
- `_industry_template.html` — шаблон для отдельных отраслевых страниц
- `INDUSTRIES` в JS (`index.html`) — единый источник отраслевого контента

**Когда выделять отдельный лендинг:**
1. Смотри Яндекс.Метрику → цели `click_industry_*` и `submit_demo_form` с параметром `industry`
2. Когда один сегмент даёт ≥40% лидов — копируй шаблон, заполняй плейсхолдеры
3. Деплой как `horeca.html` / `hotels.html` / `retail.html` / `fmcg.html`

```bash
# Пример: создать лендинг для HoReCa
cp _industry_template.html horeca.html
# Заполни все {{PLACEHOLDER}} — их список в комментарии в начале файла
git add horeca.html && git commit -m "feat(landing): add HoReCa industry page"
git push origin main
```

**Плейсхолдеры в шаблоне:**

| Плейсхолдер | Пример |
|---|---|
| `{{INDUSTRY_KEY}}` | `horeca` |
| `{{INDUSTRY_NAME}}` | `Кофейни и рестораны` |
| `{{INDUSTRY_ICON}}` | `🍽️` |
| `{{INDUSTRY_TAGLINE}}` | `Официант знает стандарт приветствия за первую смену` |
| `{{INDUSTRY_H1}}` | `PDF с регламентом → бариста прошёл квиз` |
| `{{INDUSTRY_SUBHEAD}}` | `Подзаголовок под отрасль` |
| `{{INDUSTRY_TEMPLATES}}` | `приветствие гостя, принятие заказа, ...` |

---

## 🆘 Поддержка

Вопросы? Telegram: [@vyud_ai](https://t.me/vyud_ai)
