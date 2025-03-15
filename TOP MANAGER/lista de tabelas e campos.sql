select
	tabori.type_desc as tipo_ori,
    tabori.name as tabela_ori,
	fk_colsori.name as nome_fkcolunaori,
	tabref.type_desc as tipo_ref,
	tabref.name as tabela_ref,
	fk_colsref.name as nome_fkcolunaref,
	tabori.object_id as ID_tabela_ori,
	tabref.object_id as ID_tabela_ref,
	fk.name as chave_estr,
	fk.name as nome_fk

from sys.foreign_keys fk
	inner join sys.foreign_key_columns fk_ref
		inner join sys.all_columns fk_colsref
			on fk_colsref.object_id = fk_ref.referenced_object_id
			and fk_colsref.column_id = fk_ref.referenced_column_id
		on fk_ref.constraint_object_id = fk.object_id
	inner join sys.foreign_key_columns fk_ori
		inner join sys.all_columns fk_colsori
			on fk_colsori.object_id = fk_ori.parent_object_id
			and fk_colsori.column_id = fk_ori.parent_column_id
		on fk_ori.constraint_object_id = fk.object_id
	inner join sys.all_objects tabref on tabref.object_id = fk.referenced_object_id
	inner join sys.all_objects tabori on tabori.object_id = fk.parent_object_id

where
        tabref.schema_id = 1 and tabori.schema_id = 1
    --and tabref.type_desc in ('USER_TABLE', 'VIEW') order by tabela_ref
	--and lower(tabref.name) in (lower('tbobj')) order by tabela_ori
	--and lower(tabori.name) in (lower('tbobj')) order by tabela_ref
	
	and lower(fk_colsref.name) in (lower('tpobj')) order by tabela_ori
	--and lower(fk_colsori.name) in (lower('cdobj')) order by tabela_ref


select * from TbCop pedidoCompra
select * from TbCopite pedidoCompraItem1
select * from TbCopits pedidoCompraItem2
select * from TbScp solicitacaoCompra
select * from TbCoprem
select * from TbCocsca cotacao
select * from TbCocscp

select * from TbCld CLD
select * from TbAgc agencia
select * from TbDep
select * from TbFin fim
select * from TbCcs ccusto
select * from TbLfs lancFiscal
select * from TbLot loteOuLotacao select * from TbObj

select * from TbCocfrn
select * from TbCocune
select * from TbCocufn

select * from TbFrn fornecedor
select * from Projetos
select * from TbClp
select * from TbTdo tipoDoc
select * from TbUne unidade
select * from TbUsr usuarios
select * from TbFpg condPagto
select * from TbTop operacao
select * from TbOed
select * from TbOep
select * from TbOes

select * from TbObj
select * from TbObj
select * from TbTit