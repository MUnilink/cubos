select 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT11.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTT11.CTT_CUSTO, ' ')), ' '), '|') as BK_CENTRO_CUSTO11,
       case
           when CTT10.CTT_CUSTO is null
                or CTT9.CTT_CUSTO is null
                or CTT8.CTT_CUSTO is null
                or CTT7.CTT_CUSTO is null
                or CTT6.CTT_CUSTO is null
                or CTT5.CTT_CUSTO is null
                or CTT4.CTT_CUSTO is null
                or CTT3.CTT_CUSTO is null
                or CTT2.CTT_CUSTO is null
                or CTT1.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT11.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTT11.CTT_CUSTO, ' ')), ' '), '|')
           else 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT10.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTT10.CTT_CUSTO, ' ')), ' '), '|')
       end as BK_CENTRO_CUSTO10,
       case
           when CTT10.CTT_CUSTO is null
                or CTT9.CTT_CUSTO is null
                or CTT8.CTT_CUSTO is null
                or CTT7.CTT_CUSTO is null
                or CTT6.CTT_CUSTO is null
                or CTT5.CTT_CUSTO is null
                or CTT4.CTT_CUSTO is null
                or CTT3.CTT_CUSTO is null
                or CTT2.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT11.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTT11.CTT_CUSTO, ' ')), ' '), '|')
           when CTT1.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT10.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTT10.CTT_CUSTO, ' ')), ' '), '|')
           else 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT9.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTT9.CTT_CUSTO, ' ')), ' '), '|')
       end as BK_CENTRO_CUSTO9,
       case
           when CTT10.CTT_CUSTO is null
                or CTT9.CTT_CUSTO is null
                or CTT8.CTT_CUSTO is null
                or CTT7.CTT_CUSTO is null
                or CTT6.CTT_CUSTO is null
                or CTT5.CTT_CUSTO is null
                or CTT4.CTT_CUSTO is null
                or CTT3.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT11.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTT11.CTT_CUSTO, ' ')), ' '), '|')
           when CTT2.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT10.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTT10.CTT_CUSTO, ' ')), ' '), '|')
           when CTT1.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT9.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTT9.CTT_CUSTO, ' ')), ' '), '|')
           else 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT8.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTT8.CTT_CUSTO, ' ')), ' '), '|')
       end as BK_CENTRO_CUSTO8,
       case
           when CTT10.CTT_CUSTO is null
                or CTT9.CTT_CUSTO is null
                or CTT8.CTT_CUSTO is null
                or CTT7.CTT_CUSTO is null
                or CTT6.CTT_CUSTO is null
                or CTT5.CTT_CUSTO is null
                or CTT4.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT11.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTT11.CTT_CUSTO, ' ')), ' '), '|')
           when CTT3.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT10.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTT10.CTT_CUSTO, ' ')), ' '), '|')
           when CTT2.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT9.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTT9.CTT_CUSTO, ' ')), ' '), '|')
           when CTT1.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT8.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTT8.CTT_CUSTO, ' ')), ' '), '|')
           else 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT7.CTT_CUSTO, ' '))+RTRIM(COALESCE(CTT7.CTT_CUSTO, ' ')), ' '), '|')
       end as BK_CENTRO_CUSTO7,
       case
           when CTT10.CTT_CUSTO is null
                or CTT9.CTT_CUSTO is null
                or CTT8.CTT_CUSTO is null
                or CTT7.CTT_CUSTO is null
                or CTT6.CTT_CUSTO is null
                or CTT5.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT11.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTT11.CTT_CUSTO, ' ')), ' '), '|')
           when CTT4.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT10.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTT10.CTT_CUSTO, ' ')), ' '), '|')
           when CTT3.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT9.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTT9.CTT_CUSTO, ' ')), ' '), '|')
           when CTT2.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT8.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTT8.CTT_CUSTO, ' ')), ' '), '|')
           when CTT1.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT7.CTT_CUSTO, ' '))+RTRIM(COALESCE(CTT7.CTT_CUSTO, ' ')), ' '), '|')
           else 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT6.CTT_CUSTO, ' '))+RTRIM(COALESCE(CTT6.CTT_CUSTO, ' ')), ' '), '|')
       end as BK_CENTRO_CUSTO6,
       case
           when CTT10.CTT_CUSTO is null
                or CTT9.CTT_CUSTO is null
                or CTT8.CTT_CUSTO is null
                or CTT7.CTT_CUSTO is null
                or CTT6.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT11.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTT11.CTT_CUSTO, ' ')), ' '), '|')
           when CTT5.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT10.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTT10.CTT_CUSTO, ' ')), ' '), '|')
           when CTT4.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT9.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTT9.CTT_CUSTO, ' ')), ' '), '|')
           when CTT3.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT8.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTT8.CTT_CUSTO, ' ')), ' '), '|')
           when CTT2.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT7.CTT_CUSTO, ' '))+RTRIM(COALESCE(CTT7.CTT_CUSTO, ' ')), ' '), '|')
           when CTT1.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT6.CTT_CUSTO, ' '))+RTRIM(COALESCE(CTT6.CTT_CUSTO, ' ')), ' '), '|')
           else 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT5.CTT_CUSTO, ' '))+RTRIM(COALESCE(CTT5.CTT_CUSTO, ' ')), ' '), '|')
       end as BK_CENTRO_CUSTO5,
       case
           when CTT10.CTT_CUSTO is null
                or CTT9.CTT_CUSTO is null
                or CTT8.CTT_CUSTO is null
                or CTT7.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT11.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTT11.CTT_CUSTO, ' ')), ' '), '|')
           when CTT6.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT10.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTT10.CTT_CUSTO, ' ')), ' '), '|')
           when CTT5.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT9.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTT9.CTT_CUSTO, ' ')), ' '), '|')
           when CTT4.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT8.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTT8.CTT_CUSTO, ' ')), ' '), '|')
           when CTT3.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT7.CTT_CUSTO, ' '))+RTRIM(COALESCE(CTT7.CTT_CUSTO, ' ')), ' '), '|')
           when CTT2.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT6.CTT_CUSTO, ' '))+RTRIM(COALESCE(CTT6.CTT_CUSTO, ' ')), ' '), '|')
           when CTT1.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT5.CTT_CUSTO, ' '))+RTRIM(COALESCE(CTT5.CTT_CUSTO, ' ')), ' '), '|')
           else 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT4.CTT_CUSTO, ' '))+RTRIM(COALESCE(CTT4.CTT_CUSTO, ' ')), ' '), '|')
       end as BK_CENTRO_CUSTO4,
       case
           when CTT10.CTT_CUSTO is null
                or CTT9.CTT_CUSTO is null
                or CTT8.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT11.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTT11.CTT_CUSTO, ' ')), ' '), '|')
           when CTT7.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT10.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTT10.CTT_CUSTO, ' ')), ' '), '|')
           when CTT6.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT9.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTT9.CTT_CUSTO, ' ')), ' '), '|')
           when CTT5.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT8.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTT8.CTT_CUSTO, ' ')), ' '), '|')
           when CTT4.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT7.CTT_CUSTO, ' '))+RTRIM(COALESCE(CTT7.CTT_CUSTO, ' ')), ' '), '|')
           when CTT3.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT6.CTT_CUSTO, ' '))+RTRIM(COALESCE(CTT6.CTT_CUSTO, ' ')), ' '), '|')
           when CTT2.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT5.CTT_CUSTO, ' '))+RTRIM(COALESCE(CTT5.CTT_CUSTO, ' ')), ' '), '|')
           when CTT1.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT4.CTT_CUSTO, ' '))+RTRIM(COALESCE(CTT4.CTT_CUSTO, ' ')), ' '), '|')
           else 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT3.CTT_CUSTO, ' '))+RTRIM(COALESCE(CTT3.CTT_CUSTO, ' ')), ' '), '|')
       end as BK_CENTRO_CUSTO3,
       case
           when CTT10.CTT_CUSTO is null
                or CTT9.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT11.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTT11.CTT_CUSTO, ' ')), ' '), '|')
           when CTT8.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT10.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTT10.CTT_CUSTO, ' ')), ' '), '|')
           when CTT7.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT9.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTT9.CTT_CUSTO, ' ')), ' '), '|')
           when CTT6.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT8.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTT8.CTT_CUSTO, ' ')), ' '), '|')
           when CTT5.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT7.CTT_CUSTO, ' '))+RTRIM(COALESCE(CTT7.CTT_CUSTO, ' ')), ' '), '|')
           when CTT4.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT6.CTT_CUSTO, ' '))+RTRIM(COALESCE(CTT6.CTT_CUSTO, ' ')), ' '), '|')
           when CTT3.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT5.CTT_CUSTO, ' '))+RTRIM(COALESCE(CTT5.CTT_CUSTO, ' ')), ' '), '|')
           when CTT2.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT4.CTT_CUSTO, ' '))+RTRIM(COALESCE(CTT4.CTT_CUSTO, ' ')), ' '), '|')
           when CTT1.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT3.CTT_CUSTO, ' '))+RTRIM(COALESCE(CTT3.CTT_CUSTO, ' ')), ' '), '|')
           else 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT2.CTT_CUSTO, ' '))+RTRIM(COALESCE(CTT2.CTT_CUSTO, ' ')), ' '), '|')
       end as BK_CENTRO_CUSTO2,
       case
           when CTT10.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT11.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTT11.CTT_CUSTO, ' ')), ' '), '|')
           when CTT9.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT10.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTT10.CTT_CUSTO, ' ')), ' '), '|')
           when CTT8.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT9.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTT9.CTT_CUSTO, ' ')), ' '), '|')
           when CTT7.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT8.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTT8.CTT_CUSTO, ' ')), ' '), '|')
           when CTT6.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT7.CTT_CUSTO, ' '))+RTRIM(COALESCE(CTT7.CTT_CUSTO, ' ')), ' '), '|')
           when CTT5.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT6.CTT_CUSTO, ' '))+RTRIM(COALESCE(CTT6.CTT_CUSTO, ' ')), ' '), '|')
           when CTT4.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT5.CTT_CUSTO, ' '))+RTRIM(COALESCE(CTT5.CTT_CUSTO, ' ')), ' '), '|')
           when CTT3.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT4.CTT_CUSTO, ' '))+RTRIM(COALESCE(CTT4.CTT_CUSTO, ' ')), ' '), '|')
           when CTT2.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT3.CTT_CUSTO, ' '))+RTRIM(COALESCE(CTT3.CTT_CUSTO, ' ')), ' '), '|')
           when CTT1.CTT_CUSTO is null then 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT2.CTT_CUSTO, ' '))+RTRIM(COALESCE(CTT2.CTT_CUSTO, ' ')), ' '), '|')
           else 'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT1.CTT_CUSTO, ' '))+RTRIM(COALESCE(CTT1.CTT_CUSTO, ' ')), ' '), '|')
       end as BK_CENTRO_CUSTO1,
       CTT11.CTT_DESC01 as CTT_DESC01_11,
       case
           when CTT10.CTT_DESC01 is null
                or CTT9.CTT_DESC01 is null
                or CTT8.CTT_DESC01 is null
                or CTT7.CTT_DESC01 is null
                or CTT6.CTT_DESC01 is null
                or CTT5.CTT_DESC01 is null
                or CTT4.CTT_DESC01 is null
                or CTT3.CTT_DESC01 is null
                or CTT2.CTT_DESC01 is null
                or CTT1.CTT_DESC01 is null then CTT11.CTT_DESC01
           else CTT10.CTT_DESC01
       end as CTT_DESC01_10,
       case
           when CTT10.CTT_DESC01 is null
                or CTT9.CTT_DESC01 is null
                or CTT8.CTT_DESC01 is null
                or CTT7.CTT_DESC01 is null
                or CTT6.CTT_DESC01 is null
                or CTT5.CTT_DESC01 is null
                or CTT4.CTT_DESC01 is null
                or CTT3.CTT_DESC01 is null
                or CTT2.CTT_DESC01 is null then CTT11.CTT_DESC01
           when CTT1.CTT_DESC01 is null then CTT10.CTT_DESC01
           else CTT9.CTT_DESC01
       end as CTT_DESC01_9,
       case
           when CTT10.CTT_DESC01 is null
                or CTT9.CTT_DESC01 is null
                or CTT8.CTT_DESC01 is null
                or CTT7.CTT_DESC01 is null
                or CTT6.CTT_DESC01 is null
                or CTT5.CTT_DESC01 is null
                or CTT4.CTT_DESC01 is null
                or CTT3.CTT_DESC01 is null then CTT11.CTT_DESC01
           when CTT2.CTT_DESC01 is null then CTT10.CTT_DESC01
           when CTT1.CTT_DESC01 is null then CTT9.CTT_DESC01
           else CTT8.CTT_DESC01
       end as CTT_DESC01_8,
       case
           when CTT10.CTT_DESC01 is null
                or CTT9.CTT_DESC01 is null
                or CTT8.CTT_DESC01 is null
                or CTT7.CTT_DESC01 is null
                or CTT6.CTT_DESC01 is null
                or CTT5.CTT_DESC01 is null
                or CTT4.CTT_DESC01 is null then CTT11.CTT_DESC01
           when CTT3.CTT_DESC01 is null then CTT10.CTT_DESC01
           when CTT2.CTT_DESC01 is null then CTT9.CTT_DESC01
           when CTT1.CTT_DESC01 is null then CTT8.CTT_DESC01
           else CTT7.CTT_DESC01
       end as CTT_DESC01_7,
       case
           when CTT10.CTT_DESC01 is null
                or CTT9.CTT_DESC01 is null
                or CTT8.CTT_DESC01 is null
                or CTT7.CTT_DESC01 is null
                or CTT6.CTT_DESC01 is null
                or CTT5.CTT_DESC01 is null then CTT11.CTT_DESC01
           when CTT4.CTT_DESC01 is null then CTT10.CTT_DESC01
           when CTT3.CTT_DESC01 is null then CTT9.CTT_DESC01
           when CTT2.CTT_DESC01 is null then CTT8.CTT_DESC01
           when CTT1.CTT_DESC01 is null then CTT7.CTT_DESC01
           else CTT6.CTT_DESC01
       end as CTT_DESC01_6,
       case
           when CTT10.CTT_DESC01 is null
                or CTT9.CTT_DESC01 is null
                or CTT8.CTT_DESC01 is null
                or CTT7.CTT_DESC01 is null
                or CTT6.CTT_DESC01 is null then CTT11.CTT_DESC01
           when CTT5.CTT_DESC01 is null then CTT10.CTT_DESC01
           when CTT4.CTT_DESC01 is null then CTT9.CTT_DESC01
           when CTT3.CTT_DESC01 is null then CTT8.CTT_DESC01
           when CTT2.CTT_DESC01 is null then CTT7.CTT_DESC01
           when CTT1.CTT_DESC01 is null then CTT6.CTT_DESC01
           else CTT5.CTT_DESC01
       end as CTT_DESC01_5,
       case
           when CTT10.CTT_DESC01 is null
                or CTT9.CTT_DESC01 is null
                or CTT8.CTT_DESC01 is null
                or CTT7.CTT_DESC01 is null then CTT11.CTT_DESC01
           when CTT6.CTT_DESC01 is null then CTT10.CTT_DESC01
           when CTT5.CTT_DESC01 is null then CTT9.CTT_DESC01
           when CTT4.CTT_DESC01 is null then CTT8.CTT_DESC01
           when CTT3.CTT_DESC01 is null then CTT7.CTT_DESC01
           when CTT2.CTT_DESC01 is null then CTT6.CTT_DESC01
           when CTT1.CTT_DESC01 is null then CTT5.CTT_DESC01
           else CTT4.CTT_DESC01
       end as CTT_DESC01_4,
       case
           when CTT10.CTT_DESC01 is null
                or CTT9.CTT_DESC01 is null
                or CTT8.CTT_DESC01 is null then CTT11.CTT_DESC01
           when CTT7.CTT_DESC01 is null then CTT10.CTT_DESC01
           when CTT6.CTT_DESC01 is null then CTT9.CTT_DESC01
           when CTT5.CTT_DESC01 is null then CTT8.CTT_DESC01
           when CTT4.CTT_DESC01 is null then CTT7.CTT_DESC01
           when CTT3.CTT_DESC01 is null then CTT6.CTT_DESC01
           when CTT2.CTT_DESC01 is null then CTT5.CTT_DESC01
           when CTT1.CTT_DESC01 is null then CTT4.CTT_DESC01
           else CTT3.CTT_DESC01
       end as CTT_DESC01_3,
       case
           when CTT10.CTT_DESC01 is null
                or CTT9.CTT_DESC01 is null then CTT11.CTT_DESC01
           when CTT8.CTT_DESC01 is null then CTT10.CTT_DESC01
           when CTT7.CTT_DESC01 is null then CTT9.CTT_DESC01
           when CTT6.CTT_DESC01 is null then CTT8.CTT_DESC01
           when CTT5.CTT_DESC01 is null then CTT7.CTT_DESC01
           when CTT4.CTT_DESC01 is null then CTT6.CTT_DESC01
           when CTT3.CTT_DESC01 is null then CTT5.CTT_DESC01
           when CTT2.CTT_DESC01 is null then CTT4.CTT_DESC01
           when CTT1.CTT_DESC01 is null then CTT3.CTT_DESC01
           else CTT2.CTT_DESC01
       end as CTT_DESC01_2,
       case
           when CTT10.CTT_DESC01 is null then CTT11.CTT_DESC01
           when CTT9.CTT_DESC01 is null then CTT10.CTT_DESC01
           when CTT8.CTT_DESC01 is null then CTT9.CTT_DESC01
           when CTT7.CTT_DESC01 is null then CTT8.CTT_DESC01
           when CTT6.CTT_DESC01 is null then CTT7.CTT_DESC01
           when CTT5.CTT_DESC01 is null then CTT6.CTT_DESC01
           when CTT4.CTT_DESC01 is null then CTT5.CTT_DESC01
           when CTT3.CTT_DESC01 is null then CTT4.CTT_DESC01
           when CTT2.CTT_DESC01 is null then CTT3.CTT_DESC01
           when CTT1.CTT_DESC01 is null then CTT2.CTT_DESC01
           else CTT1.CTT_DESC01
       end as CTT_DESC01_1,
       CTT11.CTT_CUSTO as CTT_CUSTO_11,
       case
           when CTT10.CTT_CUSTO is null
                or CTT9.CTT_CUSTO is null
                or CTT8.CTT_CUSTO is null
                or CTT7.CTT_CUSTO is null
                or CTT6.CTT_CUSTO is null
                or CTT5.CTT_CUSTO is null
                or CTT4.CTT_CUSTO is null
                or CTT3.CTT_CUSTO is null
                or CTT2.CTT_CUSTO is null
                or CTT1.CTT_CUSTO is null then CTT11.CTT_CUSTO
           else CTT10.CTT_CUSTO
       end as CTT_CUSTO_10,
       case
           when CTT10.CTT_CUSTO is null
                or CTT9.CTT_CUSTO is null
                or CTT8.CTT_CUSTO is null
                or CTT7.CTT_CUSTO is null
                or CTT6.CTT_CUSTO is null
                or CTT5.CTT_CUSTO is null
                or CTT4.CTT_CUSTO is null
                or CTT3.CTT_CUSTO is null
                or CTT2.CTT_CUSTO is null then CTT11.CTT_CUSTO
           when CTT1.CTT_CUSTO is null then CTT10.CTT_CUSTO
           else CTT9.CTT_CUSTO
       end as CTT_CUSTO_9,
       case
           when CTT10.CTT_CUSTO is null
                or CTT9.CTT_CUSTO is null
                or CTT8.CTT_CUSTO is null
                or CTT7.CTT_CUSTO is null
                or CTT6.CTT_CUSTO is null
                or CTT5.CTT_CUSTO is null
                or CTT4.CTT_CUSTO is null
                or CTT3.CTT_CUSTO is null then CTT11.CTT_CUSTO
           when CTT2.CTT_CUSTO is null then CTT10.CTT_CUSTO
           when CTT1.CTT_CUSTO is null then CTT9.CTT_CUSTO
           else CTT8.CTT_CUSTO
       end as CTT_CUSTO_8,
       case
           when CTT10.CTT_CUSTO is null
                or CTT9.CTT_CUSTO is null
                or CTT8.CTT_CUSTO is null
                or CTT7.CTT_CUSTO is null
                or CTT6.CTT_CUSTO is null
                or CTT5.CTT_CUSTO is null
                or CTT4.CTT_CUSTO is null then CTT11.CTT_CUSTO
           when CTT3.CTT_CUSTO is null then CTT10.CTT_CUSTO
           when CTT2.CTT_CUSTO is null then CTT9.CTT_CUSTO
           when CTT1.CTT_CUSTO is null then CTT8.CTT_CUSTO
           else CTT7.CTT_CUSTO
       end as CTT_CUSTO_7,
       case
           when CTT10.CTT_CUSTO is null
                or CTT9.CTT_CUSTO is null
                or CTT8.CTT_CUSTO is null
                or CTT7.CTT_CUSTO is null
                or CTT6.CTT_CUSTO is null
                or CTT5.CTT_CUSTO is null then CTT11.CTT_CUSTO
           when CTT4.CTT_CUSTO is null then CTT10.CTT_CUSTO
           when CTT3.CTT_CUSTO is null then CTT9.CTT_CUSTO
           when CTT2.CTT_CUSTO is null then CTT8.CTT_CUSTO
           when CTT1.CTT_CUSTO is null then CTT7.CTT_CUSTO
           else CTT6.CTT_CUSTO
       end as CTT_CUSTO_6,
       case
           when CTT10.CTT_CUSTO is null
                or CTT9.CTT_CUSTO is null
                or CTT8.CTT_CUSTO is null
                or CTT7.CTT_CUSTO is null
                or CTT6.CTT_CUSTO is null then CTT11.CTT_CUSTO
           when CTT5.CTT_CUSTO is null then CTT10.CTT_CUSTO
           when CTT4.CTT_CUSTO is null then CTT9.CTT_CUSTO
           when CTT3.CTT_CUSTO is null then CTT8.CTT_CUSTO
           when CTT2.CTT_CUSTO is null then CTT7.CTT_CUSTO
           when CTT1.CTT_CUSTO is null then CTT6.CTT_CUSTO
           else CTT5.CTT_CUSTO
       end as CTT_CUSTO_5,
       case
           when CTT10.CTT_CUSTO is null
                or CTT9.CTT_CUSTO is null
                or CTT8.CTT_CUSTO is null
                or CTT7.CTT_CUSTO is null then CTT11.CTT_CUSTO
           when CTT6.CTT_CUSTO is null then CTT10.CTT_CUSTO
           when CTT5.CTT_CUSTO is null then CTT9.CTT_CUSTO
           when CTT4.CTT_CUSTO is null then CTT8.CTT_CUSTO
           when CTT3.CTT_CUSTO is null then CTT7.CTT_CUSTO
           when CTT2.CTT_CUSTO is null then CTT6.CTT_CUSTO
           when CTT1.CTT_CUSTO is null then CTT5.CTT_CUSTO
           else CTT4.CTT_CUSTO
       end as CTT_CUSTO_4,
       case
           when CTT10.CTT_CUSTO is null
                or CTT9.CTT_CUSTO is null
                or CTT8.CTT_CUSTO is null then CTT11.CTT_CUSTO
           when CTT7.CTT_CUSTO is null then CTT10.CTT_CUSTO
           when CTT6.CTT_CUSTO is null then CTT9.CTT_CUSTO
           when CTT5.CTT_CUSTO is null then CTT8.CTT_CUSTO
           when CTT4.CTT_CUSTO is null then CTT7.CTT_CUSTO
           when CTT3.CTT_CUSTO is null then CTT6.CTT_CUSTO
           when CTT2.CTT_CUSTO is null then CTT5.CTT_CUSTO
           when CTT1.CTT_CUSTO is null then CTT4.CTT_CUSTO
           else CTT3.CTT_CUSTO
       end as CTT_CUSTO_3,
       case
           when CTT10.CTT_CUSTO is null
                or CTT9.CTT_CUSTO is null then CTT11.CTT_CUSTO
           when CTT8.CTT_CUSTO is null then CTT10.CTT_CUSTO
           when CTT7.CTT_CUSTO is null then CTT9.CTT_CUSTO
           when CTT6.CTT_CUSTO is null then CTT8.CTT_CUSTO
           when CTT5.CTT_CUSTO is null then CTT7.CTT_CUSTO
           when CTT4.CTT_CUSTO is null then CTT6.CTT_CUSTO
           when CTT3.CTT_CUSTO is null then CTT5.CTT_CUSTO
           when CTT2.CTT_CUSTO is null then CTT4.CTT_CUSTO
           when CTT1.CTT_CUSTO is null then CTT3.CTT_CUSTO
           else CTT2.CTT_CUSTO
       end as CTT_CUSTO_2,
       case
           when CTT10.CTT_CUSTO is null then CTT11.CTT_CUSTO
           when CTT9.CTT_CUSTO is null then CTT10.CTT_CUSTO
           when CTT8.CTT_CUSTO is null then CTT9.CTT_CUSTO
           when CTT7.CTT_CUSTO is null then CTT8.CTT_CUSTO
           when CTT6.CTT_CUSTO is null then CTT7.CTT_CUSTO
           when CTT5.CTT_CUSTO is null then CTT6.CTT_CUSTO
           when CTT4.CTT_CUSTO is null then CTT5.CTT_CUSTO
           when CTT3.CTT_CUSTO is null then CTT4.CTT_CUSTO
           when CTT2.CTT_CUSTO is null then CTT3.CTT_CUSTO
           when CTT1.CTT_CUSTO is null then CTT2.CTT_CUSTO
           else CTT1.CTT_CUSTO
       end as CTT_CUSTO_1
from CTT010 CTT11
    left join CTT010 CTT10
        on CTT11.CTT_CCSUP = CTT10.CTT_CUSTO
        and CTT10.CTT_CUSTO <> CTT10.CTT_CCSUP
    left join CTT010 CTT9
        on CTT10.CTT_CCSUP = CTT9.CTT_CUSTO
        and CTT9.CTT_CUSTO <> CTT9.CTT_CCSUP
    left join CTT010 CTT8
        on CTT9.CTT_CCSUP = CTT8.CTT_CUSTO
        and CTT8.CTT_CUSTO <> CTT8.CTT_CCSUP
    left join CTT010 CTT7
        on CTT8.CTT_CCSUP = CTT7.CTT_CUSTO
        and CTT7.CTT_CUSTO <> CTT7.CTT_CCSUP
    left join CTT010 CTT6
        on CTT7.CTT_CCSUP = CTT6.CTT_CUSTO
        and CTT6.CTT_CUSTO <> CTT6.CTT_CCSUP
    left join CTT010 CTT5
        on CTT6.CTT_CCSUP = CTT5.CTT_CUSTO
        and CTT5.CTT_CUSTO <> CTT5.CTT_CCSUP
    left join CTT010 CTT4
        on CTT5.CTT_CCSUP = CTT4.CTT_CUSTO
        and CTT4.CTT_CUSTO <> CTT4.CTT_CCSUP
    left join CTT010 CTT3
        on CTT4.CTT_CCSUP = CTT3.CTT_CUSTO
        and CTT3.CTT_CUSTO <> CTT3.CTT_CCSUP
    left join CTT010 CTT2
        on CTT3.CTT_CCSUP = CTT2.CTT_CUSTO
        and CTT2.CTT_CUSTO <> CTT2.CTT_CCSUP
    left join CTT010 CTT1
        on CTT2.CTT_CCSUP = CTT1.CTT_CUSTO
        and CTT1.CTT_CUSTO <> CTT1.CTT_CCSUP
where CTT11.D_E_L_E_T_ = ' '
union
select 'P |01|CTT010||',
       'P |01|CTT010||',
       'P |01|CTT010||',
       'P |01|CTT010||',
       'P |01|CTT010||',
       'P |01|CTT010||',
       'P |01|CTT010||',
       'P |01|CTT010||',
       'P |01|CTT010||',
       'P |01|CTT010||',
       'P |01|CTT010||',
       '01 - INDEFINIDO',
       '01 - INDEFINIDO',
       '01 - INDEFINIDO',
       '01 - INDEFINIDO',
       '01 - INDEFINIDO',
       '01 - INDEFINIDO',
       '01 - INDEFINIDO',
       '01 - INDEFINIDO',
       '01 - INDEFINIDO',
       '01 - INDEFINIDO',
       '01 - INDEFINIDO',
       '01 - INDEFINIDO',
       '01 - INDEFINIDO',
       '01 - INDEFINIDO',
       '01 - INDEFINIDO',
       '01 - INDEFINIDO',
       '01 - INDEFINIDO',
       '01 - INDEFINIDO',
       '01 - INDEFINIDO',
       '01 - INDEFINIDO',
       '01 - INDEFINIDO',
       '01 - INDEFINIDO'