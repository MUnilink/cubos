--Declare @CdCop int
--Set @CdCop = 62710
 -- NOVA QUERY

select distinct -- PEDIDO DE COMPRA
    Cop.CdCop,
    CodigoCop = Cop.CdCop,
    DataCop = Cop.DtCop,
    DiaSemanaDataCop = Datename(dw, DtCop),
    
    Autorizador = case when Cop.FlCopAut = 0 then 'Pedido NÃO Autorizado' else Isnull(Atd.NmPes, 'Pedido Autorizado') end,
    Comprador = case when Cop.CdCocufnOri is null then '' else Scp.Comprador/* .NmUsr */ end ,
    DtCotacao = Scp.DtCotacao, --Coc.DtCoc
--, AprovadorSolicitacao = Scp.AprovadorSolicitacao
    AprovadorSolicitacao = case when (Scp.AprovadorSolicitacao is null and Scp.FlScpAut = 1) then 'Solicitação Aprovada Automaticamente' else Scp.AprovadorSolicitacao end,
    DhAprovadorSolicitacao = case when (Scp.DhAprovadorSolicitacao is null and Scp.FlScpAut = 1 and Scp.DhAprovadorSolicitacao = '1900-01-01 00:00:00.000') then ' ' else Scp.DhAprovadorSolicitacao end, -- TOTALIZADORES PEDIDO DE COMPRA
    ValorBruTot = CopTot.VrCopiteBru,
    ValorDesTot = CopTot.VrCopiteDes,
    ValorOesTot = CopTot.VrCopiteOes,
    ValorTot = CopTot.VrCopite,
    DataAutorizacao = AtdAut.DhAtdEfe, -- DOCUMENTO DE COMPRA
--,	DtAutorizacao = Cpd.DtCpdAut
    DtAutorizacao =
    (select Top 1 Cpd.DtCpdAut
     from TbCpo Cpo
     join TbCpd Cpd on Cpd.CdCpd = Cpo.Cdcpd
     join TbUsr UsrAut on UsrAut.CdUsr = Cpd.CdUsrAut
     where Cpo.CdCopRem = CopRem.CdCopRem
         and Cpd.FlCpdAut = 1
     order by Cpd.CdCpd desc), --,	NmAutorizador = UsrAut.NmUsr

    NmAutorizador =
    (select Top 1 UsrAut.NmUsr
     from TbCpo Cpo
     join TbCpd Cpd on Cpd.CdCpd = Cpo.Cdcpd
     join TbUsr UsrAut on UsrAut.CdUsr = Cpd.CdUsrAut
     where Cpo.CdCopRem = CopRem.CdCopRem
         and Cpd.FlCpdAut = 1
     order by Cpd.CdCpd desc), --,	DtConferente = Cpd.DtCpdCnf

    DtConferente =
    (select Top 1 Cpd.DtCpdCnf
     from TbCpo Cpo
     join TbCpd Cpd on Cpd.CdCpd = Cpo.Cdcpd
     join TbUsr UsrCnf on UsrCnf.CdUsr = Cpd.CdUsrCnf
     where Cpo.CdCopRem = CopRem.CdCopRem
         and Cpd.FlCpdCnf = 1
     order by Cpd.CdCpd desc), --,	NmConferente = UsrCon.NmUsr

    NmConferente =
    (select Top 1 UsrCnf.NmUsr
     from TbCpo Cpo
     join TbCpd Cpd on Cpd.CdCpd = Cpo.Cdcpd
     join TbUsr UsrCnf on UsrCnf.CdUsr = Cpd.CdUsrCnf
     where Cpo.CdCopRem = CopRem.CdCopRem
         and Cpd.FlCpdCnf = 1
     order by Cpd.CdCpd desc), --,	DtContabil = Cpd.DtCpdCon

    DtContabil =
    (select Top 1 Cpd.DtCpdCon
     from TbCpo Cpo
     join TbCpd Cpd on Cpd.CdCpd = Cpo.Cdcpd
     order by Cpd.CdCpd desc), --,	NmResponsavel = UsrRes.NmUsr

    NmResponsavel =
    (select Top 1 UsrRes.NmUsr
     from TbCpo Cpo
     join TbCpd Cpd on Cpd.CdCpd = Cpo.Cdcpd
     join TbUsr UsrRes on UsrRes.CdUsr = Cpd.CdUsrRes
     where Cpo.CdCopRem = CopRem.CdCopRem
     order by Cpd.CdCpd desc),
    
    DtRecebimento =
    (select Top 1 Cpd.DtCpdCon
     from TbCpo Cpo
     join TbCpd Cpd on Cpd.CdCpd = Cpo.Cdcpd
     join TbUsr UsrAut on UsrAut.CdUsr = Cpd.CdUsrAut
     where Cpo.CdCopRem = CopRem.CdCopRem
         and Cpd.FlCpdAut = 1
     order by Cpd.CdCpd desc), --EMPRESA
                                                                           Empresa = Une.NmUne,
                                                                           CodigoUne = Une.CdUne,
                                                                           LogradouroUne = Convert(Varchar(100), IsNull(RTrim(PesUne.SgTlg) + ' ' + PesUne.NmLgr + ', ', '') + IsNull(PesUne.NrPesEdr + ', ', '') + IsNull(PesUne.NrPesEdrCom, '')),
                                                                           BairroUne = PesUne.NmLocBai,
                                                                           CidadeUne = PesUne.NmLocCid,
                                                                           EstadoUne = PesUne.SgLocEst,
                                                                           CepUne = PesUne.NrPesEdrCep --,	CnpjUne = 	CASE PesUne.TpPes
--				When 1 Then Stuff(Stuff(Stuff(Stuff(Right('00000000000000' + convert(varchar, IsNull(PesUne.NrPesCpj, '******')), 14), 13, 0, '-'), 9, 0, '/'), 6, 0, '.'), 3, 0, '.')
--				Else Stuff(Stuff(Stuff(Right('00 000 000 000' + convert(varchar, IsNull(PesUne.NrPesCpj, '*****')), 11), 10, 0, '-'), 7, 0, '.'), 4, 0, '.')
--				End
 ,
                                                                           CnpjUne = case PesUne.TpPes
                                                                                         when 1 then Stuff(Stuff(Stuff(Stuff(Right('00000000000000' + IsNull(convert(varchar, PesUne.NrPesCpj), '******'), 14), 13, 0, '-'), 9, 0, '/'), 6, 0, '.'), 3, 0, '.')
                                                                                         else Stuff(Stuff(Stuff(Right('00 000 000 000' + IsNull(convert(varchar, PesUne.NrPesCpj), '*****'), 11), 10, 0, '-'), 7, 0, '.'), 4, 0, '.')
                                                                                     end ,
                                                                                     CgfUne = PesUne.NrPesCgf,
                                                                                     FoneUne = '(' + Convert(VarChar, PesUne.NrLocCidDdd) + ') ' + Convert(VarChar, MctUne.NrMctTel),
                                                                                     EmailUne = IsNull(convert(varchar(60), MctUne001.NrMctEnd), ''),
                                                                                     SiteUne = IsNull(convert(varchar(60), MctUne002.NrMctEnd), '') -- FORNECEDOR
,
                                                                                     Fornecedor = IsNull(PesFrn.NmPes, ''),
                                                                                     CodigoFrn = Frn.CdFrn,
                                                                                     FornecedorMae = FrnMae.NmFrn,
                                                                                     CodigoFrnMae = FrnMae.CdFrn,
                                                                                     LogradouroFrn = Convert(Varchar(100), IsNull(RTrim(PesFrn.SgTlg) + ' ' + Isnull(PesFrn.NmLgr, '') + ', ', '') + IsNull(PesFrn.NrPesEdr + ', ', '') + IsNull(PesFrn.NrPesEdrCom, '')),
                                                                                     BairroFrn = PesFrn.NmLocBai,
                                                                                     CidadeFrn = PesFrn.NmLocCid,
                                                                                     EstadoFrn = PesFrn.SgLocEst,
                                                                                     CepFrn = PesFrn.NrPesEdrCep --,	CnpjFrn = 	CASE PesFrn.TpPes
--				When 1 Then Stuff(Stuff(Stuff(Stuff(Right('00000000000000' + convert(varchar, IsNull(PesFrn.NrPesCpj, '******')), 14), 13, 0, '-'), 9, 0, '/'), 6, 0, '.'), 3, 0, '.')
--				Else Stuff(Stuff(Stuff(Right('00 000 000 000' + convert(varchar, IsNull(PesFrn.NrPesCpj, '*****')), 11), 10, 0, '-'), 7, 0, '.'), 4, 0, '.')
--				End
 ,
                                                                                     CnpjFrn = case PesFrn.TpPes
                                                                                                   when 1 then Stuff(Stuff(Stuff(Stuff(Right('00000000000000' + IsNull(convert(varchar, PesFrn.NrPesCpj), '******'), 14), 13, 0, '-'), 9, 0, '/'), 6, 0, '.'), 3, 0, '.')
                                                                                                   else Stuff(Stuff(Stuff(Right('00 000 000 000' + IsNull(convert(varchar, PesFrn.NrPesCpj), '*****'), 11), 10, 0, '-'), 7, 0, '.'), 4, 0, '.')
                                                                                               end,
                                                                                               CgfFrn = Isnull(PesFrn.NrPesCgf, '') --,	FoneFrn = '(' + Convert(VarChar, PesFrn.NrLocCidDdd) + ') ' + Convert(VarChar, MctFrn.NrMctTel) + IsNull(' ' + MctFrn.NmMct, '')
,
                                                                                               FoneFrn = Isnull(PesFrn.TelFrn, ''),
                                                                                               Contato = Isnull(PesFrn.ContFrn, '') -- REMESSA
,
                                                                                               CodigoRem = Coprem.CdCopRem,
                                                                                               DataRem = Coprem.DtCopRem,
                                                                                               DiaSemanaDataRem = Datename(dw, Coprem.DtCopRem),
                                                                                               DataRec = Coprem.DtCopRemRec,
                                                                                               DiaSemanaDataRec = Datename(dw, Coprem.DtCopRemRec) -- ITEM
,
                                                                                               CodigoIte = Copite.CdCopite,
                                                                                               NomeCodigoAlt = Tca.NmTca,
                                                                                               CodigoObjAlt = IsNull(Cao.NrCao, ''),
                                                                                               Objeto = Obj.NmObj + case
                                                                                                                        when Com.NmCom is null then ''
                                                                                                                        else ' ' + Com.NmCom
                                                                                                                    end,
                                                                                                                    CodigoObj = Obj.CdObj,
                                                                                                                    QuantidadeIte = CopIte.QtCopite,
                                                                                                                    UnidadeIte = Und.SgUnd,
                                                                                                                    PrecoUntIte = Copite.VrCopiteUnt,
                                                                                                                    ValorIte = Copite.VrCopite,
                                                                                                                    IPIIte = Convert(Decimal(19, 0), 100 * NullIf(Copits.VrCopits / Copite.VrCopiteBru, 0)) -- CONDIÇÕES DE PAGAMENTO
,
                                                                                                                    FormaPagamento = Fpg.NmFpg,
                                                                                                                    PrazoMedio = Fpg.QtFpgPrzMed,
                                                                                                                    TipoOperacao = Top0.NmTop,
                                                                                                                    TipoFrete = Dom.Description,
                                                                                                                    Transportadora = Isnull(PesTra.NmPes, '') -- OBSERVAÇÃO
,
                                                                                                                    Obs = IsNull(Cop.TtCop, '') --Usu´ario que fez solicitacao de comrpa
--,	Requisitante = Requisitante.Usuario
,
                                                                                                                    Requisitante = Scp.Solicitante --(Select top 1 Usr.NmUsr
 --                      From TbUsr Usr
 --                      join TbScp Scp on Scp.CdUsr = Usr.CdUsr
 --				   join TbCocScp CosScp on CosScp.CdScp = Scp.CdScp
 --				   where CosScp.CdCoc = Coc.CdCoc)
,
                                                                                                                    DtRequisicao = Scp.DtSolicitacao --(Select top 1 Scp.DtScp From TbScp Scp join TbCocScp CosScp on CosScp.CdScp = Scp.CdScp where CosScp.CdCoc = Coc.CdCoc)
 -- PEDIDO DE COMPRA
from TbCopIte CopIte
    inner join TbCopRem CopRem on CopRem.CdCopRem = CopIte.CdCopRem
        left join TbCpo Cpo on Cpo.CdCopRem = CopRem.CdCopRem
            left join TbCpd Cpd on Cpd.CdCpd = Cpo.CdCpd
                left join TbUsr UsrAut on UsrAut.CdUsr = Cpd.CdUsrAut
                left join TbUsr UsrCon on UsrCon.CdUsr = Cpd.CdUsrCnf
                left join TbUsr UsrRes on UsrRes.CdUsr = Cpd.CdUsrRes
        inner join TbCop Cop on Cop.CdCop = CopRem.CdCop
        left join
        (
            select
                Coprem.CdCop ,
                Comprador = Max(UsrCom.NmUsr) ,
                DtCotacao = Max(Coc.DtCoc) ,
                Solicitante = Max(UsrScp.NmUsr) ,
                AprovadorSolicitacao = Max(UsrAtd.NmUsr) ,
                DtSolicitacao = Max(Scp.DtScp) ,
                DhAprovadorSolicitacao = Max(Atd.DhAtdEfe) ,
                Scp.FlScpAut
            from TbCopite Copite
                inner join TbCoprem Coprem on Coprem.CdCoprem = Copite.CdCoprem
                inner join TbCocsca Cocsca on Cocsca.CdCocufo = Copite.CdCocufoOri
                    inner join TbCocscp Cocscp on Cocscp.CdCocscp = Cocsca.CdCocscp
                        inner join TbScp Scp on Scp.CdScp = Cocscp.CdScp
                            inner join TbUsr UsrScp on UsrScp.CdUsr = Scp.CdUsr
                            left join TbAtd Atd
                                on Atd.NrAtdRef = Scp.CdScp
                                and Atd.TpAtdRef = 470
                                and Atd.CdDmnopc = 1 --TbScp: Solicitação de Compra / Aprovado
                                
                                left join TbUsr UsrAtd on UsrAtd.CdUsr = Atd.CdUsr
                        inner join TbCoc Coc on Coc.CdCoc = Cocscp.CdCoc
                            inner join TbUsr UsrCom on UsrCom.CdUsr = Coc.CdUsrRes
            group by Coprem.CdCop, Scp.FlScpAut
        ) Scp on Scp.CdCop = Cop.CdCop -- Dados Solicitação, requisitante e data de requisição Adicionado 04/03/2013 chamado:18331

/*left join TbCocFrn CocFrn (nolock) on CocFrn.CdCocfrn = Cocufn.CdCocfrn --CocFrn.CdFrn = Frn.CdFrn
left join	TbCoc	CocReq		(nolock) on CocReq.CdCoc	 = CocFrn.CdCoc
left join	TbCocScp CocScp		(nolock) on CocScp.Cdcoc	 = CocReq.Cdcoc
left join	TbScp Scp		(nolock) on Scp.Cdscp	 = cocscp.Cdscp  and Scp.CdObj = Copite.CdObj
left join TbUsr UsrReq		(nolock) on UsrReq.CdUsr	 = Scp.CdUsr*/ -- Usuario requisitante chamado:18402 07/01/2013 LP
--left join (Select distinct
--				Usuario = Usr.NmUsr
--			,	Cod = CocScp.CdCoc
--			,	Obj  = Scp.CdObj
--			From TbScp Scp
--			left join TbCocScp CocScp (nolock) on  CocScp.CdScp = Scp.CdScp
--			join TbUsr Usr (nolock)	 on Usr.CdUsr = Scp.CdUsr
--			) Requisitante on Requisitante.Cod = Coc.CdCoc and Requisitante.Obj = CopIte.CdObj
-- EMPRESA

    inner join TbUne Une on Une.CdUne = Cop.CdUne
        inner join
        (
            select
                Pes.CdPes ,
                Pes.NmPes ,
                Tlg.SgTlg ,
                Lgr.NmLgr ,
                Pes.NrPesEdr ,
                Pes.NrPesEdrCom ,
                Pes.NrPesEdrCep ,
                NmLocBai = case Loc.TpLoc when 5 then Loc.NmLoc end,
                NmLocCid = case LocCid.TpLoc when 4 then LocCid.NmLoc else Loc.NmLoc end,
                NrLocCidDdd = case LocCid.TpLoc when 4 then LocCid.NrLocDdd else Loc.NrLocDdd end,
                SgLocEst = case LocEst.TpLoc when 3 then LocEst.SgLoc else LocCid.SgLoc end,
                Pes.TpPes ,
                Pes.NrPesCpj ,
                Pes.NrPesCgf
            from TbPes Pes
                inner join TbLlg Llg on Llg.CdLlg = Pes.CdLlg
                    inner join TbLoc Loc on Loc.CdLoc = Llg.CdLoc
                        inner join TbLoc LocCid on LocCid.CdLoc = Loc.CdLocMae
                            inner join TbLoc LocEst on LocEst.CdLoc = LocCid.CdLocMae
                    inner join TbLgr Lgr on Lgr.CdLgr = Llg.CdLgr
                        inner join TbTlg Tlg on Tlg.CdTlg = Lgr.CdTlg
        ) PesUne on PesUne.CdPes = Une.CdPes
            left join
            (
                select Top 1
                    Pes.CdPes ,
                    Mct.NrMctTel ,
                    Mct.NmMct
                from TbPes Pes
                    inner join TbMct Mct on Mct.CdPes = Pes.CdPes
                        inner join TbTmc Tmc on Tmc.CdTmc = Mct.CdTmc
                where Tmc.TpTmc = 1 -- Telefone
                order by Mct.CdMct
            ) MctUne on MctUne.CdPes = PesUne.CdPes
            
            left join
            (
                select Top 1
                    Pes.CdPes ,
                    Mct.NrMctEnd
                from TbPes Pes
                    inner join TbMct Mct on Mct.CdPes = Pes.CdPes
                        inner join TbTmc Tmc on Tmc.CdTmc = Mct.CdTmc
                where Tmc.TpTmc = 2 -- e-Mail
                order by Mct.CdMct) MctUne001 on MctUne001.CdPes = PesUne.CdPes
            
            left join
            (
                elect Top 1
                    Pes.CdPes ,
                    Mct.NrMctEnd
                from TbPes Pes
                    inner join TbMct Mct on Mct.CdPes = Pes.CdPes
                        inner join TbTmc Tmc on Tmc.CdTmc = Mct.CdTmc
                where Tmc.TpTmc = 3 -- Web Page
                order by Mct.CdMct
            ) MctUne002 on MctUne002.CdPes = PesUne.CdPes -- FORNECEDOR
    
    inner join TbFrn Frn on Frn.CdFrn = Cop.CdFrn
        inner join
        (
            select
                Pes.CdPes ,
                Pes.NmPes ,
                Tlg.SgTlg ,
                Lgr.NmLgr ,
                Pes.NrPesEdr ,
                Pes.NrPesEdrCom ,
                Pes.NrPesEdrCep ,
                NmLocBai = case Loc.TpLoc when 5 then Loc.NmLoc end,
                NmLocCid = case LocCid.TpLoc when 4 then LocCid.NmLoc else Loc.NmLoc end,
                NrLocCidDdd = case LocCid.TpLoc when 4 then LocCid.NrLocDdd else Loc.NrLocDdd end,
                SgLocEst = case LocEst.TpLoc when 3 then LocEst.SgLoc else LocCid.SgLoc end,
                Pes.TpPes ,
                Pes.NrPesCpj ,
                Pes.NrPesCgf ,
                TelFrn = Mct.NrMctTel ,
                ContFrn = Mct.NmMct
            from TbPes Pes
                left join TbLlg Llg on Llg.CdLlg = Pes.CdLlg
                left join TbLoc Loc on Loc.CdLoc = Llg.CdLoc
                left join TbLgr Lgr on Lgr.CdLgr = Llg.CdLgr
                left join TbTlg Tlg on Tlg.CdTlg = Lgr.CdTlg
                left join TbLoc LocCid on LocCid.CdLoc = Loc.CdLocMae
                left join TbLoc LocEst on LocEst.CdLoc = LocCid.CdLocMae
                left join TbMct Mct on Mct.CdMct = Pes.CdMct
            and Mct.CdTmc = 28
        ) PesFrn on PesFrn.CdPes = Frn.CdPes
        inner join TbFrn FrnMae on FrnMae.CdFrn = Frn.CdFrnMae
    
    inner join TbObj Obj on Obj.CdObj = CopIte.CdObj
        left join TbCao Cao on Cao.CdObj = Obj.CdObj
    
    inner join TbUap Uap on Uap.CdUap = CopIte.CdUap
    inner join TbUnd Und on Und.CdUnd = Uap.CdUnd
        left join TbCom Com on Com.CdCom = Copite.CdCom
        left join TbTca Tca on Tca.CdTca = Cao.CdTca
    and FlTcaDef = 1 -- Tipo de Código Alternativo Padrão

    and Tca.CdTca = Cao.CdTca
        left join TbCopits Copits
    join TbOes Oes on Oes.SgOes = 'IPI' on Copits.CdCopite = Copite.CdCopite
    and Copits.CdOes = Oes.CdOes -- CONDIÇÕES DE PAGAMENTO
    join TbTop Top0 on Top0.CdTop = Cop.CdTop
    join VwDom Dom on Dom.Field = 'TpCopFrt'
    and Dom.Number = Cop.TpCopFrt
        left join TbFpg Fpg on Fpg.CdFpg = Cop.CdFpg
        left join TbFrn FrnTra on FrnTra.CdFrn = Cop.CdFrnTra
        left join TbPes PesTra on PesTra.CdPes = FrnTra.CdPes -- TOTALIZADORES PEDIDO DE COMPRA
    join
        (select CdCop = Coprem.CdCop ,
                VrCopiteBru = Sum(Copite.VrCopiteBru) ,
                VrCopiteDes = Sum(VrCopiteDes) ,
                VrCopiteOes = Sum(VrCopiteOes) ,
                VrCopite = Sum(VrCopite)
        from TbCopRem Coprem
        join TbCopite Copite on Copite.CdCoprem = Coprem.CdCoprem
        where Coprem.CdCop = @CdCop
        group by Coprem.CdCop) CopTot on CopTot.CdCop = Cop.CdCop -- AUTORIZAÇÃO
        left join
        (select CdCop = Atd.NrAtdRef ,
                Pes.NmPes
        from TbAtd Atd
            left join TbUsr Usr on Usr.CdUsr = Atd.CdUsr
            left join TbPes Pes on Pes.CdPes = Usr.CdPes
        where --Atd.TpAtdRef = 430
    Atd.NrAtdRef = @CdCop
            and Atd.CdDmnOpc = 1) Atd on Atd.CdCop = Cop.CdCop -- AUTORIZAÇÃO ISMAEL MARQUES 13/07/2012
        left join
        (select Atd.CdAtd ,
                Atd.DhAtdEfe ,
                Dom.Description ,
                Cop.CdCop
        from TbAtd Atd
        join VwDom Dom on Dom.Field = 'TpAtdRef'
        and Dom.Number = Atd.TpAtdRef
        join TbCop Cop on Cop.CdCop = Atd.NrAtdRef
        and Atd.TpAtdRef = 430) AtdAut on AtdAut.CdCop = Cop.CdCop
    where Cop.CdCop = @CdCop