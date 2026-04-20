-- Audit log trigger sistemi

CREATE OR REPLACE FUNCTION audit_trigger_fn()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO audit_log (tablo_adi, islem_tipi, kayit_id, yeni_veri, kullanici_adi, ip_adresi)
        VALUES (TG_TABLE_NAME, TG_OP, NEW.musteri_id, to_jsonb(NEW), current_user, inet_client_addr());
        RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO audit_log (tablo_adi, islem_tipi, kayit_id, eski_veri, yeni_veri, kullanici_adi, ip_adresi)
        VALUES (TG_TABLE_NAME, TG_OP, NEW.musteri_id, to_jsonb(OLD), to_jsonb(NEW), current_user, inet_client_addr());
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO audit_log (tablo_adi, islem_tipi, kayit_id, eski_veri, kullanici_adi, ip_adresi)
        VALUES (TG_TABLE_NAME, TG_OP, OLD.musteri_id, to_jsonb(OLD), current_user, inet_client_addr());
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;


DROP TRIGGER IF EXISTS musteriler_audit ON musteriler;
CREATE TRIGGER musteriler_audit
    AFTER INSERT OR UPDATE OR DELETE ON musteriler
    FOR EACH ROW EXECUTE FUNCTION audit_trigger_fn();


GRANT INSERT ON audit_log TO banka_admin, musteri_temsilcisi_ist, musteri_temsilcisi_ank;
GRANT USAGE ON SEQUENCE audit_log_log_id_seq TO banka_admin, musteri_temsilcisi_ist, musteri_temsilcisi_ank;
