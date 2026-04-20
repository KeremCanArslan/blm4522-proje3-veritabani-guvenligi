-- Optimizasyon oncesi, izleme, indeks olusturma ve optimizasyon sonrasi

-- Darbogaz analizi (optimizasyon oncesi)
EXPLAIN ANALYZE
SELECT musteri_no, islem_tarihi, tutar,
       AVG(tutar) OVER(PARTITION BY musteri_no ORDER BY islem_tarihi
                       ROWS BETWEEN 5 PRECEDING AND 1 PRECEDING) AS onceki_5_ort
FROM musteri_islemleri
WHERE tutar > 40000;

-- Sistem izleme
SELECT relname AS tablo_adi,
       seq_scan AS tam_tarama_sayisi,
       seq_tup_read AS okunan_satir,
       idx_scan AS indeks_kullanimi
FROM pg_stat_user_tables
WHERE relname = 'musteri_islemleri';

-- Optimizasyon: indeks ve bellek
CREATE INDEX idx_basarisiz_loglar ON musteri_islemleri(islem_tarihi) WHERE durum = 'Basarisiz';
CREATE INDEX idx_musteri_tutar ON musteri_islemleri(musteri_no, tutar);
SET work_mem = '256MB';

-- Bakim
DELETE FROM musteri_islemleri WHERE islem_id IN (
    SELECT islem_id FROM musteri_islemleri ORDER BY random() LIMIT 5000
);
VACUUM FULL VERBOSE musteri_islemleri;

-- Optimizasyon sonrasi kanit
EXPLAIN ANALYZE
SELECT musteri_no, islem_tarihi, tutar,
       AVG(tutar) OVER(PARTITION BY musteri_no ORDER BY islem_tarihi
                       ROWS BETWEEN 5 PRECEDING AND 1 PRECEDING) AS onceki_5_ort
FROM musteri_islemleri
WHERE tutar > 40000;
