select * from sys.foreign_key_columns
select * from sys.foreign_keys
select * from sys.sysforeignkeys

select * from sys.key_constraints
select * from sys.all_columns

select * from INFORMATION_SCHEMA.KEY_COLUMN_USAGE
select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS

select pk.object_id as ID_pk, fk.object_id as ID_fk, pk.name as chave_prim, fk.name as chave_estr from sys.key_constraints pk left join sys.foreign_keys fk on fk.parent_object_id = pk.object_id

select
	fk_cols.object_id as ID_fkcolunaref,
	fk_cols.name as nome_fkcolunaref,
	fk.object_id as ID_fk,
	fk.name as nome_fk,
	obj.object_id as ID_obj_ori,
	obj.name as nome_obj_ori
from sys.foreign_keys fk
	inner join sys.foreign_key_columns fk_refcols
		inner join sys.all_columns fk_cols
			on fk_cols.object_id = fk_refcols.referenced_object_id
			and fk_cols.column_id = fk_refcols.referenced_column_id
		on fk_refcols.constraint_object_id = fk.object_id
	inner join sys.all_objects obj
		on obj.object_id = fk.parent_object_id

select distinct
	pk_cols.object_id as ID_pkcolunaref,
	pk_cols.name as nome_pkcolunaref,
	pk.object_id as ID_pk,
	pk.name as nome_pk
from sys.key_constraints pk
	inner join sys.all_columns pk_cols
		on pk_cols.object_id = pk.parent_object_id
