
CREATE PROCEDURE pr_controle_fmea_processo

--pr_controle_fmea_processo
---------------------------------------------------
--GBS - Global Business Solution	       2004
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Daniel Carrasco Neto
--Banco de Dados: EgisSQL
--Objetivo      : Fazer o controle de Processos FMEA.
--Data          : 10/08/2004
---------------------------------------------------

@cd_processo   int,
@dt_inicial    datetime,
@dt_final      datetime

AS


set dateformat dmy

select    
  -- Falta definição.
  1 as ic_processo_padrao,
  1 as ic_processo_especial,
  1 as ic_sem_fmea,
  1 as ic_cancelado,
  1 as ic_fmea,
  1 as ic_aprovado,
  1 as ic_liberado,
  --------------------
  pp.cd_processo_padrao, 
  pp.dt_processo_padrao, 
  pp.nm_processo_padrao,
  u.nm_fantasia_usuario as nm_fantasia_usuario_fmea,
  c.nm_fantasia_cliente, 
  '' as nm_fantasia_produto,
--  prod.nm_fantasia_produto, 
  '' as cd_mascara_produto,
  '' as Descricao,
  'PP' as Tipo_Processo,
--  dbo.fn_mascara_produto(prod.cd_produto) as cd_mascara_produto,
  gf.nm_grupo_fmea,
  f.dt_fmea_padrao,
  f.dt_aprov_fmea_padrao,
  f.dt_lib_fmea_padrao


from
  Processo_Padrao pp 
left outer join FMEA f on 
  f.cd_Processo_padrao = pp.cd_processo_padrao
left outer join Cliente c on 
  f.cd_cliente = c.cd_cliente
left outer join EgisAdmin.dbo.Usuario u on
  f.cd_usuario_fmea = u.cd_usuario 
--left outer join Produto prod on pp.cd_produto = prod.cd_produto  -- Falta Definição
left outer join Grupo_FMEA gf on
  gf.cd_grupo_fmea = f.cd_grupo_fmea
  
where     
  IsNull(pp.cd_processo_padrao,'') = (case when isnull(@cd_processo,'') = '' then
                                       IsNull(pp.cd_processo_padrao,'') else
                                       isnull(@cd_processo,'') end ) and
  (IsNull(pp.dt_processo_padrao,GetDate())  between 

   ( case when isnull(@cd_processo,0) = 0 
     then @dt_inicial else IsNull(pp.dt_processo_padrao,GetDate()) end ) and 
   ( case when isnull(@cd_processo,0) = 0 
     then @dt_final else IsNull(pp.dt_processo_padrao,GetDate()) end ) )

order by  
  pp.dt_processo_padrao

