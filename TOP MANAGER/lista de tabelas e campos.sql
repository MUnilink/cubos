select
    tabs.object_id as ID_tabela,
    tabs.name as tabela,
	tabs.type_desc as tipo_obj,
	fk.name as chave_estr,
	fk.name as nome_fk,
	fk_cols.name as nome_fkcolunaref
from sys.all_objects tabs
	left join sys.foreign_keys fk
		inner join sys.foreign_key_columns fk_refcols
			inner join sys.all_columns fk_cols
				on fk_cols.object_id = fk_refcols.referenced_object_id
				and fk_cols.column_id = fk_refcols.referenced_column_id
			on fk_refcols.constraint_object_id = fk.object_id
		on fk.parent_object_id = tabs.object_id
where
        tabs.schema_id = 1
    and tabs.type_desc in ('USER_TABLE', 'VIEW') --('FOREIGN_KEY_CONSTRAINT', 'PRIMARY_KEY_CONSTRAINT')
    --and lower(tabs.name) in ('tblan', 'tblnt', 'tbtra')
	and lower(tabs.name) = 'tbcct'
