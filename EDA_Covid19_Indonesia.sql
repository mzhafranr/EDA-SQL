-- menampilkan 5 data pertama
select * from covid c;

-- Menghapus baris-baris dengan isi kolom "Locaion" yang bernama "Indonesia"
DELETE FROM covid
WHERE "Location" = 'Indonesia';

--sebaran dan tingkat kejadian
SELECT
    "Province",
    SUM("Total_Cases") AS Total_Cases,
    SUM("Total_Deaths") AS Total_Deaths,
    SUM("Total_Recovered") AS Total_Recovered
FROM
    covid
GROUP BY
    "Province";
 
-- Kesehatan provinsi
SELECT
    "Province",
    SUM("Total_Deaths") AS td,
    SUM("Total_Cases") AS tc,
    ((sum("Total_Deaths")::Float / SUM("Total_Cases")) * 100)  AS Case_Fatality_Rate 
FROM
    covid
GROUP BY
    "Province"
ORDER BY
    Case_Fatality_Rate DESC;

--pertumbuhan harian
SELECT
    "Date",
    "Location",
    "New_Cases",
    LAG("New_Cases", 1, 0) OVER (PARTITION BY "Location" ORDER BY "Date") AS previous_cases,
    "New_Cases" - LAG("New_Cases", 1, 0) OVER (PARTITION BY "Location" ORDER BY "Date") AS growth_cases,
    "New_Deaths",
    LAG("New_Deaths", 1, 0) OVER (PARTITION BY "Location" ORDER BY "Date") AS previous_deaths,
    "New_Deaths" - LAG("New_Deaths", 1, 0) OVER (PARTITION BY "Location" ORDER BY "Date") AS growth_deaths
FROM
    covid c 
ORDER BY
    "Location", "Date";
      
-- Tampilkan pertumbuhan bulanan
SELECT
    EXTRACT(MONTH FROM "Date") AS bulan,
    SUM("New_Cases") AS total_kasus_baru,
    SUM("New_Deaths") AS total_kematian_baru
FROM
    covid c 
GROUP BY
    bulan
ORDER BY
    bulan;
   
 -- Jumlah Kasus dan Kematian Berdasarkan Lokasi (Location)
SELECT
    "Location",
    SUM("Total_Cases") AS Total_Cases,
    SUM("Total_Deaths") AS Total_Deaths
FROM
    covid c 
GROUP BY
    "Location"
ORDER BY
    Total_Cases DESC;
--Rata-rata Kepadatan Penduduk dan luas wilayah terhadap total kasus 
SELECT
    "Province",
    AVG("Population_Density") AS Average_Population_Density,
    AVG("Area_(km2)") AS Average_Area,
    SUM("Total_Cases") AS Total_Cases
FROM
    covid c 
GROUP BY
    "Province"
ORDER BY
    Total_Cases DESC;


