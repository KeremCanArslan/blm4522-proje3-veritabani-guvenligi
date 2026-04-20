-- Roller, yetkiler ve RLS

DROP ROLE IF EXISTS banka_admin;
DROP ROLE IF EXISTS musteri_temsilcisi_ist;
DROP ROLE IF EXISTS musteri_temsilcisi_ank;
DROP ROLE IF EXISTS analist;

CREATE ROLE banka_admin LOGIN PASSWORD 'Admin2026!';
CREATE ROLE musteri_temsilcisi_ist LOGIN PASSWORD 'Temsilci2026!';
CREATE ROLE musteri_temsilcisi_ank LOGIN PASSWORD 'Temsilci2026!';
CREATE ROLE analist LOGIN PASSWORD 'Analist2026!';

GRANT USAGE ON SCHEMA public TO banka_admin, musteri_temsilcisi_ist, musteri_temsilcisi_ank, analist;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO banka_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO banka_admin;

GRANT SELECT, INSERT, UPDATE ON musteriler, hesaplar, islemler TO musteri_temsilcisi_ist;
GRANT SELECT, INSERT, UPDATE ON musteriler, hesaplar, islemler TO musteri_temsilcisi_ank;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO musteri_temsilcisi_ist, musteri_temsilcisi_ank;

GRANT SELECT ON musteriler, islemler TO analist;
GRANT SELECT (hesap_id, musteri_id, hesap_no, para_birimi, acilis_tarihi) ON hesaplar TO analist;


ALTER TABLE musteriler ENABLE ROW LEVEL SECURITY;

CREATE POLICY ist_temsilcisi_politikasi ON musteriler
    FOR ALL TO musteri_temsilcisi_ist
    USING (sube_kodu = 'IST001');

CREATE POLICY ank_temsilcisi_politikasi ON musteriler
    FOR ALL TO musteri_temsilcisi_ank
    USING (sube_kodu = 'ANK001');

CREATE POLICY admin_politikasi ON musteriler
    FOR ALL TO banka_admin, analist
    USING (true);
