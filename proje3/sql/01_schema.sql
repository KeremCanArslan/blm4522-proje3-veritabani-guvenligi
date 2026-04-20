-- finans_guvenlik_db için şema
-- Proje 3 - Erişim kontrolü ve şifreleme için kullanılacak tablolar

CREATE EXTENSION IF NOT EXISTS pgcrypto;

DROP TABLE IF EXISTS audit_log CASCADE;
DROP TABLE IF EXISTS islemler CASCADE;
DROP TABLE IF EXISTS hesaplar CASCADE;
DROP TABLE IF EXISTS musteriler CASCADE;


CREATE TABLE musteriler (
    musteri_id SERIAL PRIMARY KEY,
    ad_soyad VARCHAR(100) NOT NULL,
    tc_kimlik BYTEA NOT NULL,
    email BYTEA,
    telefon VARCHAR(20),
    sube_kodu VARCHAR(10) NOT NULL,
    kayit_tarihi TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE hesaplar (
    hesap_id SERIAL PRIMARY KEY,
    musteri_id INT REFERENCES musteriler(musteri_id) ON DELETE CASCADE,
    hesap_no VARCHAR(20) UNIQUE NOT NULL,
    bakiye DECIMAL(15,2) DEFAULT 0,
    para_birimi VARCHAR(3) DEFAULT 'TRY',
    acilis_tarihi TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE islemler (
    islem_id SERIAL PRIMARY KEY,
    hesap_id INT REFERENCES hesaplar(hesap_id),
    islem_tarihi TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tutar DECIMAL(15,2) NOT NULL,
    islem_tipi VARCHAR(50),
    kredi_karti_no BYTEA,
    durum VARCHAR(20) DEFAULT 'Basarili'
);


CREATE TABLE audit_log (
    log_id SERIAL PRIMARY KEY,
    tablo_adi VARCHAR(50),
    islem_tipi VARCHAR(10),
    kayit_id INT,
    eski_veri JSONB,
    yeni_veri JSONB,
    kullanici_adi VARCHAR(100),
    ip_adresi INET,
    islem_zamani TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- 1000 ornek musteri
INSERT INTO musteriler (ad_soyad, tc_kimlik, email, telefon, sube_kodu)
SELECT
    'Musteri_' || i,
    pgp_sym_encrypt(LPAD((10000000000 + i)::text, 11, '0'), 'GizliAnahtar2026!'),
    pgp_sym_encrypt('musteri' || i || '@ornekbanka.com', 'GizliAnahtar2026!'),
    '0532' || LPAD((random() * 10000000)::int::text, 7, '0'),
    CASE (i % 5)
        WHEN 0 THEN 'IST001'
        WHEN 1 THEN 'ANK001'
        WHEN 2 THEN 'IZM001'
        WHEN 3 THEN 'BUR001'
        ELSE 'ADN001'
    END
FROM generate_series(1, 1000) AS i;


INSERT INTO hesaplar (musteri_id, hesap_no, bakiye)
SELECT
    m.musteri_id,
    'TR' || LPAD((10000000000 + m.musteri_id * 10 + h.n)::text, 24, '0'),
    (random() * 100000)::decimal(15,2)
FROM musteriler m
CROSS JOIN generate_series(1, 2) AS h(n);


INSERT INTO islemler (hesap_id, tutar, islem_tipi, kredi_karti_no, durum)
SELECT
    (random() * 1999 + 1)::int,
    (random() * 5000)::decimal(15,2),
    CASE WHEN random() < 0.5 THEN 'EFT' ELSE 'Kredi Karti' END,
    pgp_sym_encrypt(
        '4532' || LPAD((random() * 1000000000000)::bigint::text, 12, '0'),
        'GizliAnahtar2026!'
    ),
    CASE WHEN random() < 0.05 THEN 'Basarisiz' ELSE 'Basarili' END
FROM generate_series(1, 10000);


SELECT 'musteriler' AS tablo, COUNT(*) AS kayit_sayisi FROM musteriler
UNION ALL SELECT 'hesaplar', COUNT(*) FROM hesaplar
UNION ALL SELECT 'islemler', COUNT(*) FROM islemler
UNION ALL SELECT 'audit_log', COUNT(*) FROM audit_log;
