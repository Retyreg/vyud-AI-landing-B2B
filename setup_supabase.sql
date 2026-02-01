-- ============================================
-- VYUD AI: Настройка таблицы лидов в Supabase
-- ============================================
-- Выполни этот скрипт в SQL Editor Supabase:
-- https://supabase.com/dashboard/project/YOUR_PROJECT/sql

-- 1. Создание таблицы лидов
CREATE TABLE IF NOT EXISTS public.leads (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Основные поля
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT,
    company_size TEXT,
    role TEXT,
    document TEXT,
    
    -- Метаданные
    source TEXT DEFAULT 'vyud.tech',
    status TEXT DEFAULT 'new',
    
    -- Для аналитики
    utm_source TEXT,
    utm_medium TEXT,
    utm_campaign TEXT
);

-- 2. Включение Row Level Security (RLS)
ALTER TABLE public.leads ENABLE ROW LEVEL SECURITY;

-- 3. Политика: разрешить анонимную вставку (INSERT)
-- Это позволяет форме на сайте записывать данные без авторизации
CREATE POLICY "Allow anonymous inserts" 
ON public.leads 
FOR INSERT 
TO anon 
WITH CHECK (true);

-- 4. Политика: запретить анонимное чтение
-- По умолчанию SELECT закрыт, пока не создана политика
-- Только авторизованные пользователи с service_role key смогут читать

-- 5. Индекс для быстрого поиска по email
CREATE INDEX IF NOT EXISTS idx_leads_email ON public.leads(email);

-- 6. Индекс для сортировки по дате
CREATE INDEX IF NOT EXISTS idx_leads_created ON public.leads(created_at DESC);

-- ============================================
-- ОПЦИОНАЛЬНО: Триггер для уведомлений в Telegram
-- ============================================
-- Требует расширение pg_net (включи в Dashboard → Database → Extensions)

-- CREATE OR REPLACE FUNCTION notify_new_lead()
-- RETURNS TRIGGER AS $$
-- BEGIN
--     PERFORM net.http_post(
--         url := 'https://api.telegram.org/bot<YOUR_BOT_TOKEN>/sendMessage',
--         body := json_build_object(
--             'chat_id', '<YOUR_CHAT_ID>',
--             'text', format('🔥 Новый лид!%s%s👤 %s%s📧 %s%s📱 %s%s🏢 %s',
--                 chr(10), chr(10),
--                 NEW.name, chr(10),
--                 NEW.email, chr(10),
--                 COALESCE(NEW.phone, '-'), chr(10),
--                 COALESCE(NEW.company_size, '-')
--             ),
--             'parse_mode', 'HTML'
--         )::jsonb
--     );
--     RETURN NEW;
-- END;
-- $$ LANGUAGE plpgsql;

-- CREATE TRIGGER on_new_lead
-- AFTER INSERT ON public.leads
-- FOR EACH ROW
-- EXECUTE FUNCTION notify_new_lead();

-- ============================================
-- ПРОВЕРКА
-- ============================================
-- После выполнения скрипта проверь:
-- 1. Таблица создана: SELECT * FROM public.leads LIMIT 1;
-- 2. RLS включен: SELECT relname, relrowsecurity FROM pg_class WHERE relname = 'leads';
-- 3. Политики созданы: SELECT * FROM pg_policies WHERE tablename = 'leads';
