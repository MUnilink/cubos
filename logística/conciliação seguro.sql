select
   DU8.DU8_DOCSEG as 'SEGURO',
   DU8.DU8_CODFOR as 'COD_SEGURADORA',
   DU8.DU8_LOJFOR as 'LOJA_SEGURADORA',
   DU8.DU8_VALMER as 'VALOR_EMBARQUE_TOT',
   DU9.DU9_VALOR as 'PREMIO_TOT',
   DT6.DT6_SERIE as 'SERIE',
   DT6.DT6_DOC as 'CTE/NFS',
   DL5.DL5_VALAVB as 'VALOR_EMBARQUE' ,
   DT6.DT6_CLIDEV as 'COD_DEVEDOR',
   DT6.DT6_LOJDEV as 'LOJA_DEVEDOR',
   SA1.A1_NOME as 'Devedor',
   SA2.A2_NOME as 'Seguradora',
   cast(DL5.DL5_DATEMI as datetime) as 'DATA',
   sum(DU7.DU7_PREMIO) as 'PREMIO',

   case DL5.DL5_STATUS
      when '0' then 'Aguardando Averbação'
      when '1' then 'Falha de comunicação'
      when '2' then 'Averbado'
      when '3' then 'Recusado'
      when '4' then 'Aguardando Cancelamento'
      when '5' then 'Falha de comunicação do cancelamento'
      when '6' then 'Averbação cancelada'
      when '7' then 'Cancelamento da averbação recusado'
      when '8' then 'Documento cancelado antes da averbação'
   end as STATUS
from DU8010 (nolock) /* seguro */
   inner join DU9010 as DU9
      on DU8.DU8_FILIAL + DU8.DU8_DOCSEG = DU9.DU9_FILIAL + DU9.DU9_DOCSEG 
   inner join DT6010 as DT6
      on DT6.DT6_FILIAL + substring(DT6.DT6_DOCSEG, 1, 9) = DU8.DU8_FILIAL + DU8.DU8_DOCSEG
   inner join DL5010 as DL5
      on DL5.DL5_FILDOC + DL5.DL5_DOC + DL5.DL5_SERIE = DT6.DT6_FILDOC + DT6.DT6_DOC + DT6.DT6_SERIE
   inner join DU7010 as DU7
      on DU7.DU7_FILDOC + DU7.DU7_DOC + DU7.DU7_SERIE = DT6.DT6_FILDOC + DT6.DT6_DOC + DT6.DT6_SERIE
   inner join SA2010 as SA2
      on SA2.A2_COD + SA2.A2_LOJA = DU8.DU8_CODFOR + DU8.DU8_LOJFOR
   inner join SA1010 as SA1
      on SA1.A1_COD + SA1.A1_LOJA = DT6.DT6_CLIDEV + DT6.DT6_LOJDEV

where 
       DU9.DU9_CODHIS = '00' 
   and DU9.D_E_L_E_T_ = ' '
   and DT6.D_E_L_E_T_ = ' '
   and DU7.D_E_L_E_T_ = ' '
   and DL5.D_E_L_E_T_ = ' ' 
group by 
   DU8.DU8_DOCSEG,
   DU8.DU8_CODFOR,
   DU8.DU8_LOJFOR,
   DU8.DU8_VALMER,
   DU9.DU9_VALOR,
   DT6.DT6_SERIE,
   DT6.DT6_DOC,
   DL5.DL5_VALAVB ,
   DT6.DT6_CLIDEV,
   DT6.DT6_LOJDEV,
   DL5.DL5_DATEMI,
   DL5.DL5_STATUS,
   SA1.A1_NOME,
   SA2.A2_NOME