
--sp_helptext pr_avaliacao_fornecedor
-------------------------------------------------------------------------------
--pr_avaliacao_fornecedor
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Montagem do Relatório de Avaliação do Fornecedor
--Data             : 16.07.2007
--Alteração        : 16.07.2007
------------------------------------------------------------------------------
create procedure pr_avaliacao_fornecedor
@ic_parametro               int = 0,
@cd_fornecedor              int = 0

as

--gerar uma tabela
--select * from fornecedor_avaliacao
--select * from fornecedor
--select * from componente_avaliacao_texto

select
  identity(int,1,1)              as cd_fornecedor_avaliacao,
  getdate()                      as dt_emissao,
  --Fornecedor
  f.cd_fornecedor,
  f.nm_fantasia_fornecedor,
  f.nm_razao_social,
  ltrim(rtrim(f.cd_ddd))+' '+
  ltrim(rtrim(f.cd_telefone))      as Fone,
  --Endereço
  case 
    when charindex('-', f.cd_cep) > 0 then 
      IsNull(rtrim(ltrim(f.nm_endereco_fornecedor)),'')
      + ', ' + rtrim(ltrim(IsNull(cast(f.cd_numero_endereco as varchar(5)),''))) + ' - ' +
      IsNull(rtrim(ltrim(f.nm_bairro)),'')
      + ' - ' + IsNull(rtrim(ltrim(cid.nm_cidade)),'')
      + ' - ' +  IsNull(e.sg_estado,'')
      + ' - ' +  IsNull(rtrim(ltrim(p.nm_pais)),'')
      + isnull(' - CEP: ' + cast(ltrim(rtrim(f.cd_cep)) as varchar(09)), '')
    else
      IsNull(rtrim(ltrim(f.nm_endereco_fornecedor)),'')
      + ', ' + rtrim(ltrim(IsNull(cast(f.cd_numero_endereco as varchar(5)),''))) + ' - ' +
      IsNull(rtrim(ltrim(f.nm_bairro)),'')
      + ' - ' + IsNull(rtrim(ltrim(cid.nm_cidade)),'')
      + ' - ' +  IsNull(e.sg_estado,'')
      + ' - ' +  IsNull(rtrim(ltrim(p.nm_pais)),'')
      + isnull(' - CEP: ' + dbo.fn_formata_mascara('99999-999',right('00000000' + 
      isnull(cast(ltrim(rtrim(f.cd_cep)) as varchar(8)),''),8)), '') 
  end AS nm_endereco_fornecedor,
  f.dt_cadastro_fornecedor

into
  #AvaliacaoFornecedor
from
  fornecedor f
  left outer join Estado e   on e.cd_estado   = f.cd_estado
  left outer join Cidade cid on cid.cd_cidade = f.cd_cidade and
                                cid.cd_estado = f.cd_estado
  left outer join Pais p     on p.cd_pais     = f.cd_pais 
  
where
  f.cd_fornecedor = case when @cd_fornecedor = 0 then f.cd_fornecedor else @cd_fornecedor end 

select 
  af.*,
  --Composição dos Textos
  ca.cd_componente_avaliacao,
  ca.nm_componente_avaliacao       as Componente,
  ca.ds_componente_avaliacao,
  ca.nm_obs_componente,
  ca.cd_ordem_componente,
  cat.cd_item_texto_avaliacao      as Item,
  case when isnull(cat.ic_mostra_item_componente,'N')='S'
  then
    rtrim(ltrim(cast(cd_item_texto_avaliacao as varchar(10))))+'-'
  else
    '' 
  end
  +
  cat.nm_texto_avaliacao           as Texto,
  cat.ds_texto_avaliacao           as Descritivo,
  cat.ic_negrito_texto             as Negrito,
  cat.ic_sublinhado_texto          as Sublinhado,
  cat.ic_tipo_texto                as Tipo,
  cat.ic_mostra_item_componente    as MostraItem,
  cat.cd_ordem_texto,
  cat.nm_complemento_texto         as Complemento

from 
  #AvaliacaoFornecedor af,
  componente_avaliacao ca
  left outer join componente_avaliacao_texto cat on cat.cd_componente_avaliacao = ca.cd_componente_avaliacao
where
  isnull(ca.ic_ativo_componente,'N')= 'S' and
  isnull(cat.ic_ativo_texto,'N')    = 'S'
order by
  ca.cd_ordem_componente,
  cat.cd_ordem_texto


