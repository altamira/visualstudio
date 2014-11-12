
-------------------------------------------------------------------------------
--sp_helptext pr_detalhe_tabelas
-------------------------------------------------------------------------------
--pr_detalhe_tabelas
-------------------------------------------------------------------------------

create procedure pr_detalhe_tabelas
@nm_tabela varchar(8000) = '',
@nm_campo  varchar(8000) = '',
@tipo_consulta varchar(200) =''
as

select
  sc.colorder as 'Posição da Coluna',  
  so.[name]   as 'Nome da Tabela',
  sc.[name]   as 'Nome da Coluna',
  st.[name]   as 'Natureza do Atributo',
  sc.length   as 'Tamanho',
  sc.xprec    as 'Precisão', 
  sc.xscale   as 'Decimais',
  so.refdate  as 'Data de Criação'
from 
  sysobjects                 so with(nolock)
  inner join      syscolumns sc with(nolock) on sc.[id]  = so.[id]
  left outer join systypes   st with(nolock) on st.xtype = sc.xtype 
where 
  so.xtype = case when @tipo_consulta = '' then 
               so.xtype 
             else 
               @tipo_consulta 
             end  and 
  so.[name] like case when ltrim(rtrim(isnull(@nm_tabela,''))) = '' then 
                   so.[name] 
                 else 
                   @nm_tabela 
                 end and
  sc.[name] like case when ltrim(rtrim(isnull(@nm_campo,''))) = '' then 
                   sc.[name] 
                 else 
                   @nm_campo 
                 end
order by
  so.[id],
  sc.colorder

-- select * from syscolumns
-- select * from sysobjects
