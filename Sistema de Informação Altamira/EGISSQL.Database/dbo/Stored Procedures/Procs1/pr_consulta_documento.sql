
-------------------------------------------------------------------------------
--pr_consulta_documento
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--                   Anderson
--Banco de Dados   : Egissql
--Objetivo         : Consulta dos Documentos para Controle de Qualidade ISO
--
--Data             : 14.10.2006
--Alteração        : 22.01.2008 - Acerto da Consulta - Carlos Fernandes
--27.05.2008 - Complemento dos Campos - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_consulta_documento
@cd_identificacao_documento     varchar(20) = '',
@cd_tipo_documento              int         = 0,
@cd_departamento                int         = 0,
@cd_fase_documento              int         = 0,
@cd_autor_documento             int         = 0,
@cd_categoria_qualidade         int         = 0, 
@cd_cliente                     int         = 0,
@cd_produto                     int         = 0,
@cd_desenho_cliente             varchar(30) = ''

as

--select * from documento_qualidade

select
  d.cd_identificacao_documento               as Identificacao,
  d.nm_documento_qualidade                   as Descricao,
  d.cd_documento_qualidade                   as Codigo,
  d.dt_documento_qualidade                   as Emissão,
  td.nm_tipo_documento                       as 'TipoDocumento',
  tf.nm_fase_documento                       as Fase,
  ta.nm_autor                                as Autor,
  tc.nm_tipo_copia_documento                 as Copia,
  dp.nm_departamento                         as Departamento,
  nm.nm_norma_qualidade                      as Norma,
  nm_fantasia_cliente                        as Cliente,
  d.cd_desenho_cliente,
  d.dt_revisao_documento,
  d.nm_ref_revisao_documento,
  p.cd_mascara_produto,
  p.nm_fantasia_produto,
  p.nm_produto
from
  Documento_Qualidade d                       with (nolock) 
  left outer join Tipo_Documento_Qualidade td with (nolock) on td.cd_tipo_documento       = d.cd_tipo_documento  
  left outer join Fase_Documento           tf with (nolock) on tf.cd_fase_documento       = d.cd_fase_documento  
  left outer join Tipo_Copia_Documento     tc with (nolock) on tc.cd_tipo_copia_documento = d.cd_tipo_copia_documento  
  left outer join Autor_Documento          ta with (nolock) on ta.cd_autor                = d.cd_autor_documento  
  left outer join Departamento             dp with (nolock) on dp.cd_departamento         = d.cd_departamento
  left outer join Norma_Qualidade          nm with (nolock) on nm.cd_norma_qualidade      = d.cd_categoria_qualidade
  left outer join Cliente c                   with (nolock) on c.cd_cliente               = d.cd_cliente
  left outer join Produto p                   with (nolock) on p.cd_produto               = d.cd_produto
where
  d.cd_identificacao_documento like    case when isnull(@cd_identificacao_documento,'') = '' then d.cd_identificacao_documento           else @cd_identificacao_documento end +'%' and
  isnull(d.cd_tipo_documento,0)      = case when isnull(@cd_tipo_documento,0)           = 0  then isnull(d.cd_tipo_documento,0)          else @cd_tipo_documento          end and
  isnull(d.cd_departamento,0)        = case when isnull(@cd_departamento,0)             = 0  then isnull(d.cd_departamento,0)            else @cd_departamento            end and
  isnull(d.cd_fase_documento,0)      = case when isnull(@cd_fase_documento,0)           = 0  then isnull(d.cd_fase_documento,0)          else @cd_fase_documento          end and
  isnull(d.cd_autor_documento,0)     = case when isnull(@cd_autor_documento,0)          = 0  then isnull(d.cd_autor_documento,0)         else @cd_autor_documento         end and
  isnull(d.cd_cliente,0)             = case when isnull(@cd_cliente,0)                  = 0  then isnull(d.cd_cliente,0)                 else @cd_cliente                 end and
  isnull(d.cd_produto,0)             = case when isnull(@cd_produto,0)                  = 0  then isnull(d.cd_produto,0)                 else @cd_produto                 end and
  isnull(d.cd_desenho_cliente,'')    = case when isnull(@cd_desenho_cliente,'')         = '' then isnull(d.cd_desenho_cliente,'')        else @cd_desenho_cliente         end --and


--  isnull(d.cd_categoria_qualidade,0) = case when @cd_categoria_qualidade     = 0  then isnull(d.cd_categoria_qualidade,0)     else @cd_categoria_qualidade     end

order by
  d.cd_identificacao_documento,
  td.nm_tipo_documento

