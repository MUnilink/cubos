select
	trim(SRA.RA_NOMECMP) as 'NOME',
	trim(SRA.RA_CIC) as 'CPF',
	trim(SRA.RA_EMAIL) as 'E-MAIL',
	trim(SRJ.RJ_DESC) as 'Função CBO',
	'' as 'Motivo do Cadastro',
	trim(SRA.RA_NASC) as 'Data Nascimento',

	case SRA.RA_RG
		when null then 'PASSAPORTE'
		else 'RG'
	end as 'RG/Passaporte',
	
	trim(isnull(SRA.RA_RG, SRA.RA_NUMEPAS)) as 'Número',
	trim(isnull(SRA.RA_DTRGEXP, SRA.RA_EMISPAS)) as 'Data de Emissão',
	concat(trim(isnull(SRA.RA_RGORG, SRA.RA_EMISPAS)), '/' , trim(isnull(SRA.RA_RGUF, SRA.RA_UFPAS))) as 'Órgão Emissor/Estado',

	trim(SRA.RA_HABILIT) as 'CNH',
	trim(SRA.RA_CATCNH) as 'Categoria',
	trim(SRA.RA_DTVCCNH) as 'Validade CNH',
	trim(SRA.RA_DTEMCNH) as 'Data de Emissão',
	concat(trim(SRA.RA_CNHORG), '/', trim(SRA.RA_UFCNH)) as 'Órgão Emissor/Estado',

	trim(SRA.RA_ENDEREC) as 'Endereço Completo',
	trim(SRA.RA_NUMENDE) as 'Número',
	trim(SRA.RA_BAIRRO) as 'Bairro',
	trim(SRA.RA_MUNICIP) as 'Cidade',
	trim(SRA.RA_ESTADO) as 'Estado',
	trim(SRA.RA_CEP) as 'CEP',
	concat(trim(SRA.RA_DDDFONE), trim(SRA.RA_TELEFON)) as 'Tel. Fixo',
	concat(trim(SRA.RA_DDDCELU), trim(SRA.RA_NUMCELU)) as 'Celular',
	trim(SRA.RA_MAE) as 'Nome da Mâe'
from SRA010 as SRA
	inner join SRJ010 as SRJ (nolock)
		on SRJ.D_E_L_E_T_ = ''
		and substring(SRA.RA_FILIAL, 1, 4) = SRJ.RJ_FILIAL
        and SRA.RA_CODFUNC = SRJ.RJ_FUNCAO
where SRA.D_E_L_E_T_ = ''