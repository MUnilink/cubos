select
    case
        when CTD11.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD11.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD11.CTD_ITEM, ' ')), ' '), '|')
        when CTD10.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD10.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD10.CTD_ITEM, ' ')), ' '), '|')
        when CTD9.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD9.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD9.CTD_ITEM, ' ')), ' '), '|')
        when CTD8.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD8.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD8.CTD_ITEM, ' ')), ' '), '|')
        when CTD7.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD7.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD7.CTD_ITEM, ' ')), ' '), '|')
        when CTD6.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD6.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD6.CTD_ITEM, ' ')), ' '), '|')
        when CTD5.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD5.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD5.CTD_ITEM, ' ')), ' '), '|')
        when CTD4.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD4.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD4.CTD_ITEM, ' ')), ' '), '|')
        when CTD3.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD3.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD3.CTD_ITEM, ' ')), ' '), '|')
        when CTD2.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD2.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD2.CTD_ITEM, ' ')), ' '), '|')
        else 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD1.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD1.CTD_ITEM, ' ')), ' '), '|')
    end as BK_ITEM_CONTABIL11,
    case
        when CTD10.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD10.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD10.CTD_ITEM, ' ')), ' '), '|')
        when CTD9.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD9.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD9.CTD_ITEM, ' ')), ' '), '|')
        when CTD8.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD8.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD8.CTD_ITEM, ' ')), ' '), '|')
        when CTD7.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD7.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD7.CTD_ITEM, ' ')), ' '), '|')
        when CTD6.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD6.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD6.CTD_ITEM, ' ')), ' '), '|')
        when CTD5.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD5.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD5.CTD_ITEM, ' ')), ' '), '|')
        when CTD4.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD4.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD4.CTD_ITEM, ' ')), ' '), '|')
        when CTD3.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD3.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD3.CTD_ITEM, ' ')), ' '), '|')
        when CTD2.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD2.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD2.CTD_ITEM, ' ')), ' '), '|')
        else 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD1.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD1.CTD_ITEM, ' ')), ' '), '|')
    end as BK_ITEM_CONTABIL10,
    case
        when CTD9.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD9.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD9.CTD_ITEM, ' ')), ' '), '|')
        when CTD8.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD8.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD8.CTD_ITEM, ' ')), ' '), '|')
        when CTD7.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD7.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD7.CTD_ITEM, ' ')), ' '), '|')
        when CTD6.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD6.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD6.CTD_ITEM, ' ')), ' '), '|')
        when CTD5.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD5.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD5.CTD_ITEM, ' ')), ' '), '|')
        when CTD4.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD4.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD4.CTD_ITEM, ' ')), ' '), '|')
        when CTD3.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD3.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD3.CTD_ITEM, ' ')), ' '), '|')
        when CTD2.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD2.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD2.CTD_ITEM, ' ')), ' '), '|')
        else 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD1.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD1.CTD_ITEM, ' ')), ' '), '|')
    end as BK_ITEM_CONTABIL9,
    case
        when CTD8.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD8.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD8.CTD_ITEM, ' ')), ' '), '|')
        when CTD7.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD7.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD7.CTD_ITEM, ' ')), ' '), '|')
        when CTD6.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD6.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD6.CTD_ITEM, ' ')), ' '), '|')
        when CTD5.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD5.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD5.CTD_ITEM, ' ')), ' '), '|')
        when CTD4.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD4.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD4.CTD_ITEM, ' ')), ' '), '|')
        when CTD3.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD3.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD3.CTD_ITEM, ' ')), ' '), '|')
        when CTD2.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD2.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD2.CTD_ITEM, ' ')), ' '), '|')
        else 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD1.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD1.CTD_ITEM, ' ')), ' '), '|')
    end as BK_ITEM_CONTABIL8,
    case
        when CTD7.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD7.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD7.CTD_ITEM, ' ')), ' '), '|')
        when CTD6.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD6.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD6.CTD_ITEM, ' ')), ' '), '|')
        when CTD5.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD5.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD5.CTD_ITEM, ' ')), ' '), '|')
        when CTD4.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD4.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD4.CTD_ITEM, ' ')), ' '), '|')
        when CTD3.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD3.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD3.CTD_ITEM, ' ')), ' '), '|')
        when CTD2.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD2.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD2.CTD_ITEM, ' ')), ' '), '|')
        else 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD1.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD1.CTD_ITEM, ' ')), ' '), '|')
    end as BK_ITEM_CONTABIL7,
    case
        when CTD6.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD6.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD6.CTD_ITEM, ' ')), ' '), '|')
        when CTD5.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD5.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD5.CTD_ITEM, ' ')), ' '), '|')
        when CTD4.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD4.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD4.CTD_ITEM, ' ')), ' '), '|')
        when CTD3.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD3.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD3.CTD_ITEM, ' ')), ' '), '|')
        when CTD2.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD2.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD2.CTD_ITEM, ' ')), ' '), '|')
        else 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD1.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD1.CTD_ITEM, ' ')), ' '), '|')
    end as BK_ITEM_CONTABIL6,
    case
        when CTD5.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD5.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD5.CTD_ITEM, ' ')), ' '), '|')
        when CTD4.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD4.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD4.CTD_ITEM, ' ')), ' '), '|')
        when CTD3.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD3.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD3.CTD_ITEM, ' ')), ' '), '|')
        when CTD2.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD2.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD2.CTD_ITEM, ' ')), ' '), '|')
        else 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD1.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD1.CTD_ITEM, ' ')), ' '), '|')
    end as BK_ITEM_CONTABIL5,
    case
        when CTD4.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD4.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD4.CTD_ITEM, ' ')), ' '), '|')
        when CTD3.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD3.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD3.CTD_ITEM, ' ')), ' '), '|')
        when CTD2.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD2.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD2.CTD_ITEM, ' ')), ' '), '|')
        else 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD1.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD1.CTD_ITEM, ' ')), ' '), '|')
    end as BK_ITEM_CONTABIL4,
    case
        when CTD3.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD3.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD3.CTD_ITEM, ' ')), ' '), '|')
        when CTD2.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD2.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD2.CTD_ITEM, ' ')), ' '), '|')
        else 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD1.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD1.CTD_ITEM, ' ')), ' '), '|')
    end as BK_ITEM_CONTABIL3,
    case
        when CTD2.CTD_ITEM is not null then 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD2.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD2.CTD_ITEM, ' ')), ' '), '|')
        else 'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD1.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD1.CTD_ITEM, ' ')), ' '), '|')
    end as BK_ITEM_CONTABIL2,
       'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD1.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTD1.CTD_ITEM, ' ')), ' '), '|') as BK_ITEM_CONTABIL1,
       
       case
           when CTD11.CTD_ITEM is not null then CTD11.CTD_ITEM
           when CTD10.CTD_ITEM is not null then CTD10.CTD_ITEM
           when CTD9.CTD_ITEM is not null then CTD9.CTD_ITEM
           when CTD8.CTD_ITEM is not null then CTD8.CTD_ITEM
           when CTD7.CTD_ITEM is not null then CTD7.CTD_ITEM
           when CTD6.CTD_ITEM is not null then CTD6.CTD_ITEM
           when CTD5.CTD_ITEM is not null then CTD5.CTD_ITEM
           when CTD4.CTD_ITEM is not null then CTD4.CTD_ITEM
           when CTD3.CTD_ITEM is not null then CTD3.CTD_ITEM
           when CTD2.CTD_ITEM is not null then CTD2.CTD_ITEM
           else CTD1.CTD_ITEM
       end as CODIGO_ITEM11,
       case
           when CTD10.CTD_ITEM is not null then CTD10.CTD_ITEM
           when CTD9.CTD_ITEM is not null then CTD9.CTD_ITEM
           when CTD8.CTD_ITEM is not null then CTD8.CTD_ITEM
           when CTD7.CTD_ITEM is not null then CTD7.CTD_ITEM
           when CTD6.CTD_ITEM is not null then CTD6.CTD_ITEM
           when CTD5.CTD_ITEM is not null then CTD5.CTD_ITEM
           when CTD4.CTD_ITEM is not null then CTD4.CTD_ITEM
           when CTD3.CTD_ITEM is not null then CTD3.CTD_ITEM
           when CTD2.CTD_ITEM is not null then CTD2.CTD_ITEM
           else CTD1.CTD_ITEM
       end as CODIGO_ITEM10,
       case
           when CTD9.CTD_ITEM is not null then CTD9.CTD_ITEM
           when CTD8.CTD_ITEM is not null then CTD8.CTD_ITEM
           when CTD7.CTD_ITEM is not null then CTD7.CTD_ITEM
           when CTD6.CTD_ITEM is not null then CTD6.CTD_ITEM
           when CTD5.CTD_ITEM is not null then CTD5.CTD_ITEM
           when CTD4.CTD_ITEM is not null then CTD4.CTD_ITEM
           when CTD3.CTD_ITEM is not null then CTD3.CTD_ITEM
           when CTD2.CTD_ITEM is not null then CTD2.CTD_ITEM
           else CTD1.CTD_ITEM
       end as CODIGO_ITEM9,
       case
           when CTD8.CTD_ITEM is not null then CTD8.CTD_ITEM
           when CTD7.CTD_ITEM is not null then CTD7.CTD_ITEM
           when CTD6.CTD_ITEM is not null then CTD6.CTD_ITEM
           when CTD5.CTD_ITEM is not null then CTD5.CTD_ITEM
           when CTD4.CTD_ITEM is not null then CTD4.CTD_ITEM
           when CTD3.CTD_ITEM is not null then CTD3.CTD_ITEM
           when CTD2.CTD_ITEM is not null then CTD2.CTD_ITEM
           else CTD1.CTD_ITEM
       end as CODIGO_ITEM8,
       case
           when CTD7.CTD_ITEM is not null then CTD7.CTD_ITEM
           when CTD6.CTD_ITEM is not null then CTD6.CTD_ITEM
           when CTD5.CTD_ITEM is not null then CTD5.CTD_ITEM
           when CTD4.CTD_ITEM is not null then CTD4.CTD_ITEM
           when CTD3.CTD_ITEM is not null then CTD3.CTD_ITEM
           when CTD2.CTD_ITEM is not null then CTD2.CTD_ITEM
           else CTD1.CTD_ITEM
       end as CODIGO_ITEM7,
       case
           when CTD6.CTD_ITEM is not null then CTD6.CTD_ITEM
           when CTD5.CTD_ITEM is not null then CTD5.CTD_ITEM
           when CTD4.CTD_ITEM is not null then CTD4.CTD_ITEM
           when CTD3.CTD_ITEM is not null then CTD3.CTD_ITEM
           when CTD2.CTD_ITEM is not null then CTD2.CTD_ITEM
           else CTD1.CTD_ITEM
       end as CODIGO_ITEM6,
       case
           when CTD5.CTD_ITEM is not null then CTD5.CTD_ITEM
           when CTD4.CTD_ITEM is not null then CTD4.CTD_ITEM
           when CTD3.CTD_ITEM is not null then CTD3.CTD_ITEM
           when CTD2.CTD_ITEM is not null then CTD2.CTD_ITEM
           else CTD1.CTD_ITEM
       end as CODIGO_ITEM5,
       case
           when CTD4.CTD_ITEM is not null then CTD4.CTD_ITEM
           when CTD3.CTD_ITEM is not null then CTD3.CTD_ITEM
           when CTD2.CTD_ITEM is not null then CTD2.CTD_ITEM
           else CTD1.CTD_ITEM
       end as CODIGO_ITEM4,
       case
           when CTD3.CTD_ITEM is not null then CTD3.CTD_ITEM
           when CTD2.CTD_ITEM is not null then CTD2.CTD_ITEM
           else CTD1.CTD_ITEM
       end as CODIGO_ITEM3,
       case
           when CTD2.CTD_ITEM is not null then CTD2.CTD_ITEM
           else CTD1.CTD_ITEM
       end as CODIGO_ITEM2,
       
       CTD1.CTD_ITEM as CODIGO_ITEM1,
       case
           when CTD11.CTD_ITEM is not null then CTD11.CTD_DESC01
           when CTD10.CTD_ITEM is not null then CTD10.CTD_DESC01
           when CTD9.CTD_ITEM is not null then CTD9.CTD_DESC01
           when CTD8.CTD_ITEM is not null then CTD8.CTD_DESC01
           when CTD7.CTD_ITEM is not null then CTD7.CTD_DESC01
           when CTD6.CTD_ITEM is not null then CTD6.CTD_DESC01
           when CTD5.CTD_ITEM is not null then CTD5.CTD_DESC01
           when CTD4.CTD_ITEM is not null then CTD4.CTD_DESC01
           when CTD3.CTD_ITEM is not null then CTD3.CTD_DESC01
           when CTD2.CTD_ITEM is not null then CTD2.CTD_DESC01
           else CTD1.CTD_DESC01
       end as DESC_ITEM11,
       case
           when CTD10.CTD_ITEM is not null then CTD10.CTD_DESC01
           when CTD9.CTD_ITEM is not null then CTD9.CTD_DESC01
           when CTD8.CTD_ITEM is not null then CTD8.CTD_DESC01
           when CTD7.CTD_ITEM is not null then CTD7.CTD_DESC01
           when CTD6.CTD_ITEM is not null then CTD6.CTD_DESC01
           when CTD5.CTD_ITEM is not null then CTD5.CTD_DESC01
           when CTD4.CTD_ITEM is not null then CTD4.CTD_DESC01
           when CTD3.CTD_ITEM is not null then CTD3.CTD_DESC01
           when CTD2.CTD_ITEM is not null then CTD2.CTD_DESC01
           else CTD1.CTD_DESC01
       end as DESC_ITEM10,
       case
           when CTD9.CTD_ITEM is not null then CTD9.CTD_DESC01
           when CTD8.CTD_ITEM is not null then CTD8.CTD_DESC01
           when CTD7.CTD_ITEM is not null then CTD7.CTD_DESC01
           when CTD6.CTD_ITEM is not null then CTD6.CTD_DESC01
           when CTD5.CTD_ITEM is not null then CTD5.CTD_DESC01
           when CTD4.CTD_ITEM is not null then CTD4.CTD_DESC01
           when CTD3.CTD_ITEM is not null then CTD3.CTD_DESC01
           when CTD2.CTD_ITEM is not null then CTD2.CTD_DESC01
           else CTD1.CTD_DESC01
       end as DESC_ITEM9,
       case
           when CTD8.CTD_ITEM is not null then CTD8.CTD_DESC01
           when CTD7.CTD_ITEM is not null then CTD7.CTD_DESC01
           when CTD6.CTD_ITEM is not null then CTD6.CTD_DESC01
           when CTD5.CTD_ITEM is not null then CTD5.CTD_DESC01
           when CTD4.CTD_ITEM is not null then CTD4.CTD_DESC01
           when CTD3.CTD_ITEM is not null then CTD3.CTD_DESC01
           when CTD2.CTD_ITEM is not null then CTD2.CTD_DESC01
           else CTD1.CTD_DESC01
       end as DESC_ITEM8,
       case
           when CTD7.CTD_ITEM is not null then CTD7.CTD_DESC01
           when CTD6.CTD_ITEM is not null then CTD6.CTD_DESC01
           when CTD5.CTD_ITEM is not null then CTD5.CTD_DESC01
           when CTD4.CTD_ITEM is not null then CTD4.CTD_DESC01
           when CTD3.CTD_ITEM is not null then CTD3.CTD_DESC01
           when CTD2.CTD_ITEM is not null then CTD2.CTD_DESC01
           else CTD1.CTD_DESC01
       end as DESC_ITEM7,
       case
           when CTD6.CTD_ITEM is not null then CTD6.CTD_DESC01
           when CTD5.CTD_ITEM is not null then CTD5.CTD_DESC01
           when CTD4.CTD_ITEM is not null then CTD4.CTD_DESC01
           when CTD3.CTD_ITEM is not null then CTD3.CTD_DESC01
           when CTD2.CTD_ITEM is not null then CTD2.CTD_DESC01
           else CTD1.CTD_DESC01
       end as DESC_ITEM6,
       case
           when CTD5.CTD_ITEM is not null then CTD5.CTD_DESC01
           when CTD4.CTD_ITEM is not null then CTD4.CTD_DESC01
           when CTD3.CTD_ITEM is not null then CTD3.CTD_DESC01
           when CTD2.CTD_ITEM is not null then CTD2.CTD_DESC01
           else CTD1.CTD_DESC01
       end as DESC_ITEM5,
       case
           when CTD4.CTD_ITEM is not null then CTD4.CTD_DESC01
           when CTD3.CTD_ITEM is not null then CTD3.CTD_DESC01
           when CTD2.CTD_ITEM is not null then CTD2.CTD_DESC01
           else CTD1.CTD_DESC01
       end as DESC_ITEM4,
       case
           when CTD3.CTD_ITEM is not null then CTD3.CTD_DESC01
           when CTD2.CTD_ITEM is not null then CTD2.CTD_DESC01
           else CTD1.CTD_DESC01
       end as DESC_ITEM3,
       case
           when CTD2.CTD_ITEM is not null then CTD2.CTD_DESC01
           else CTD1.CTD_DESC01
       end as DESC_ITEM2,
       CTD1.CTD_DESC01 as DESC_ITEM1
from CTD010 CTD1
    left join CTD010 CTD2
        on CTD2.D_E_L_E_T_ = ''
        and CTD2.CTD_ITSUP = CTD1.CTD_ITEM
        and CTD2.CTD_FILIAL = CTD1.CTD_FILIAL
        and CTD2.CTD_ITEM <> CTD2.CTD_ITSUP
        and CTD2.CTD_ITSUP <> ' '
    left join CTD010 CTD3
        on CTD3.D_E_L_E_T_ = ''
        and CTD3.CTD_ITSUP = CTD2.CTD_ITEM
        and CTD3.CTD_FILIAL = CTD2.CTD_FILIAL
        and CTD3.CTD_ITEM <> CTD3.CTD_ITSUP
    left join CTD010 CTD4
        on CTD4.D_E_L_E_T_ = ''
        and CTD4.CTD_ITSUP = CTD3.CTD_ITEM
        and CTD4.CTD_FILIAL = CTD3.CTD_FILIAL
        and CTD4.CTD_ITEM <> CTD4.CTD_ITSUP
    left join CTD010 CTD5
        on CTD5.D_E_L_E_T_ = ''
        and CTD5.CTD_ITSUP = CTD4.CTD_ITEM
        and CTD5.CTD_FILIAL = CTD4.CTD_FILIAL
        and CTD5.CTD_ITEM <> CTD5.CTD_ITSUP
    left join CTD010 CTD6
        on CTD6.D_E_L_E_T_ = ''
        and CTD6.CTD_ITSUP = CTD5.CTD_ITEM
        and CTD6.CTD_FILIAL = CTD5.CTD_FILIAL
        and CTD6.CTD_ITEM <> CTD6.CTD_ITSUP
    left join CTD010 CTD7
        on CTD7.D_E_L_E_T_ = ''
        and CTD7.CTD_ITSUP = CTD6.CTD_ITEM
        and CTD7.CTD_FILIAL = CTD6.CTD_FILIAL
        and CTD7.CTD_ITEM <> CTD7.CTD_ITSUP
    left join CTD010 CTD8
        on CTD8.D_E_L_E_T_ = ''
        and CTD8.CTD_ITSUP = CTD7.CTD_ITEM
        and CTD8.CTD_FILIAL = CTD7.CTD_FILIAL
        and CTD8.CTD_ITEM <> CTD8.CTD_ITSUP
    left join CTD010 CTD9
        on CTD9.D_E_L_E_T_ = ''
        and CTD9.CTD_ITSUP = CTD8.CTD_ITEM
        and CTD9.CTD_FILIAL = CTD8.CTD_FILIAL
        and CTD9.CTD_ITEM <> CTD9.CTD_ITSUP
    left join CTD010 CTD10
        on CTD10.D_E_L_E_T_ = ''
        and CTD10.CTD_ITSUP = CTD9.CTD_ITEM
        and CTD10.CTD_FILIAL = CTD9.CTD_FILIAL
        and CTD10.CTD_ITEM <> CTD10.CTD_ITSUP
    left join CTD010 CTD11
        on CTD11.D_E_L_E_T_ = ''
        and CTD11.CTD_ITSUP = CTD10.CTD_ITEM
        and CTD11.CTD_FILIAL = CTD10.CTD_FILIAL
        and CTD11.CTD_ITEM <> CTD11.CTD_ITSUP
where CTD1.D_E_L_E_T_ = ' ' and (CTD1.CTD_ITEM = CTD1.CTD_ITSUP or CTD1.CTD_ITSUP = ' ')
union
select 'P |01|CTD010||',
       'P |01|CTD010||',
       'P |01|CTD010||',
       'P |01|CTD010||',
       'P |01|CTD010||',
       'P |01|CTD010||',
       'P |01|CTD010||',
       'P |01|CTD010||',
       'P |01|CTD010||',
       'P |01|CTD010||',
       'P |01|CTD010||',
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