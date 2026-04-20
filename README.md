# BLM4522 - Proje 3: Veritabanı Güvenliği ve Erişim Kontrolü

Ankara Üniversitesi - Bilgisayar Mühendisliği  
Ağ Tabanlı Paralel Dağıtım Sistemleri (BLM4522)

**Öğrenci:** Kerem Can Arslan  
**Numara:** 19291092

## Konu
PostgreSQL 16 üzerinde erişim kontrolü, veri şifreleme, SQL injection savunması ve audit logları.

## Kurulum
```bash
createdb finans_guvenlik_db
psql -d finans_guvenlik_db -f sql/01_schema.sql
```

## Yapı
- `sql/` - Veritabanı şeması ve güvenlik scriptleri
- `flask-demo/` - SQL injection demosu için örnek web uygulaması
- `screenshots/` - Uygulama ekran görüntüleri
- `docs/` - Proje raporu
