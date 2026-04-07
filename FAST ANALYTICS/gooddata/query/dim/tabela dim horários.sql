select
    convert(char(5), DATEADD(MINUTE, n, 0), 108) AS HoraMinuto,  -- 108 = hh:mi:ss, char(5) pega hh:mi
    n * 60 as Segundos
from (SELECT TOP (1440) row_number() over(order by (SELECT NULL)) - 1 AS n FROM sys.all_objects) T
