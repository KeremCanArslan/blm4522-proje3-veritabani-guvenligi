# BLM4522 Vize Projeleri

Ankara Universitesi - Bilgisayar Muhendisligi
Ag Tabanli Paralel Dagitim Sistemleri (BLM4522)

Ogrenci: Kerem Can Arslan
Numara: 19291092
Danisman: Ogr. Gor. Enver BAGCI

## Icerik

Proje 1 - Veritabani Performans Optimizasyonu ve Izleme
1 milyon kayitli tablo uzerinde darbogaz analizi, indeks tasarimi ve bellek ayarlari ile yaklasik yuzde 40 hizlanma elde edildi.

Proje 3 - Veritabani Guvenligi ve Erisim Kontrolu
Rol tabanli erisim, Row-Level Security, pgcrypto ile kolon bazli sifreleme, SQL injection savunmasi ve trigger tabanli audit log sistemi uygulandi.

## Kurulum

Proje 1:
    createdb finans_db
    psql -d finans_db -f proje1/sql/01_schema.sql
    psql -d finans_db -f proje1/sql/02_optimization.sql

Proje 3:
    createdb finans_guvenlik_db
    psql -d finans_guvenlik_db -f proje3/sql/01_schema.sql
    psql -d finans_guvenlik_db -f proje3/sql/02_roller_rls.sql
    psql -d finans_guvenlik_db -f proje3/sql/03_audit.sql

## Yapi

    proje1/     - performans optimizasyonu (sql, screenshots)
    proje3/     - guvenlik (sql, flask-demo, screenshots)
    docs/       - proje raporu
