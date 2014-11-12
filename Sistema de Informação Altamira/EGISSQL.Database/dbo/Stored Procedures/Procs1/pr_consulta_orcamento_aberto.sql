

--pr_consulta_orcamento_aberto
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                      2001                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes         
--Consultas em aberto para Orçamento
--Data         : 15.05.2001
--Atualizado   : 28.06.2001 - Lucio
-----------------------------------------------------------------------------------
create procedure pr_consulta_orcamento_aberto

@ic_parametro      int,
@cd_departamento   int,
@dt_inicial        datetime,
@dt_final          datetime

-- Parâmetro 0 = Departamento Selecionado
--           1 = Geral

as

if ( @ic_parametro = 0 )
begin

   select 
      b.status,
      b.dataconit as 'Data',
      a.fan_cli   as 'Cliente',
      b.numeroit  as 'Numero',
      b.numeroit  as 'cd_consulta',
      b.item      as 'Item',
      b.item      as 'cd_item_consulta',
      b.cod_ant   as 'Produto',
      b.descricao as 'Descricao',
      b.qt        as 'Qtd',
      d.fan_ven   as 'Setor',
      a.vendint   as 'Interno',
      b.nduteis   as 'DiasUteis',
      b.dtentr    as 'Entrega',
      b.precolist as 'Lista', 
      b.preco     as 'Unitario',
      b.ncrep     as 'ConsultaRepres',
      b.itcrep    as 'ItemConsultaRepres'

   from
       CADVDI a, CADIVDI b, SapSql.dbo.GrupoProduto_Departamento c,
       FTVEND d
   where
       a.DATACON between @dt_inicial and 
                         @dt_final            and 
       a.NUMERO          = b.NUMEROIT         and
       b.DTDEL           is null              and
--     b.NUMPED          = 0                  and
       b.DTPERDA         is null              and
       b.ORCAMIT         = 'S'                and
       b.LORC            <> 'S'               and
       b.DTEPC           is null              and
       b.ALMOXIT         = c.cd_grupo_produto and
       c.cd_departamento = @cd_departamento   and
       c.ic_orcamento    = 'S'                and
       a.VDEXT02         = d.COD_VEN
   order by a.NUMERO, b.ITEM
end

else

begin

   select 
      a.fan_cli   as 'Cliente',
      a.vendint   as 'Interno',
      b.status,
      b.dataconit as 'Data',
      b.numeroit  as 'Numero',
      b.item      as 'Item',
      b.cod_ant   as 'Produto',
      b.descricao as 'Descricao',
      b.qt        as 'Qtd',
      b.nduteis   as 'DiasUteis',
      b.dtentr    as 'Entrega',
      b.precolist as 'Lista',
      b.preco     as 'Unitario',
      d.fan_ven   as 'Setor'
   from
       CADVDI a, 
       CADIVDI b, 
       SapSql.dbo.GrupoProduto_Departamento c,
       FTVEND d
   where
       a.DATACON between @dt_inicial and 
                         @dt_final            and 
       a.NUMERO          = b.NUMEROIT         and
       b.DTDEL           is null              and
--     b.NUMPED          = 0                  and
       b.DTPERDA         is null              and
       b.ORCAMIT         = 'S'                and
       b.LORC            <> 'S'               and 
       b.DTEPC           is null              and
       b.ALMOXIT         = c.cd_grupo_produto and
       c.IC_ORCAMENTO    = 'S'                and
       a.VDEXT02         = d.COD_VEN
   order by a.NUMERO, b.ITEM 
end


