select
    tabs.object_id as ID_tabela,
    tabs.name as tabela,
	tabs.type_desc as tipo_obj,
	fk.name as chave_estr,
	fk.name as nome_fk,
	fk_colsref.name as nome_fkcolunaref
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
	inner join sys.all_objects tabsref on fk.referenced_object_id = tabsref.object_id
	inner join sys.all_objects tabsori on fk.parent_object_id = tabsori.object_id

where
        tabs.schema_id = 1
    and tabs.type_desc in ('USER_TABLE', 'VIEW') --('FOREIGN_KEY_CONSTRAINT', 'PRIMARY_KEY_CONSTRAINT')
    --and lower(tabs.name) in ('tblan', 'tblnt', 'tbtra')
	and lower(tabs.name) = 'tbcld'
