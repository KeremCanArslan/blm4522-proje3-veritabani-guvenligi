-- finans_db - musteri_islemleri tablosu ve 1M veri uretimi

CREATE DATABASE finans_db;
\c finans_db;

CREATE TABLE musteri_islemleri (
    islem_id SERIAL PRIMARY KEY,
    musteri_no INT NOT NULL,
    islem_tarihi TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tutar DECIMAL(15,2) NOT NULL,
    islem_tipi VARCHAR(50),
    kredi_karti_no VARCHAR(20),
    durum VARCHAR(20) DEFAULT 'Basarili'
);

INSERT INTO musteri_islemleri (musteri_no, islem_tarihi, tutar, islem_tipi, kredi_karti_no, durum)
SELECT
    (random() * 10000 + 1)::int,
    NOW() - (random() * (interval '365 days')),
    (random() * 50000)::decimal(15,2),
    CASE WHEN random() < 0.5 THEN 'EFT' ELSE 'Kredi Karti' END,
    '4532' || LPAD((random() * 1000000000000)::bigint::text, 12, '0'),
    CASE WHEN random() < 0.05 THEN 'Basarisiz' ELSE 'Basarili' END
FROM generate_series(1, 1000000);
