
CREATE  PROCEDURE pr_corrigir_cd_banco_tabelas
  @cd_banco_atual int,
  @cd_banco_nova int
As

SELECT 'ALTER TABLE ' +
       QUOTENAME( c.TABLE_NAME ) +
       ' NOCHECK CONSTRAINT ' +
       QUOTENAME( c.CONSTRAINT_NAME ) AS ALTER_SCRIPT
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS c
WHERE CONSTRAINT_TYPE = 'FOREIGN KEY'

union all

select 'GO'

union all

select 'update '+t.name+' set cd_banco = '+cast(@cd_banco_nova as varchar)+
       ' where cd_banco = '+cast(@cd_banco_atual as varchar)
as comandosql
from syscolumns c, sysobjects t
where t.id = c.id and c.name = 'cd_banco'

union all

select 'GO'

union all

SELECT 'ALTER TABLE ' +
       QUOTENAME( c.TABLE_NAME ) +
       ' CHECK CONSTRAINT ' +
       QUOTENAME( c.CONSTRAINT_NAME ) AS ALTER_SCRIPT
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS c
WHERE CONSTRAINT_TYPE = 'FOREIGN KEY'

