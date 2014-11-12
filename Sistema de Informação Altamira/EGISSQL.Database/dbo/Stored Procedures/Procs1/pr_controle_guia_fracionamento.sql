
------------------------------------------------------------------------------------------
--GBS - Global Business Solution	             2004
------------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server       
--Autor(es)		: Daniel C. Neto.
--Banco de Dados	: EGISSQL
--Objetivo		: Fazer o Controle de Guias de Fracionamento
--Data			: 13/09/2004
-- 15/09/2004 - Acerto de Campo - Daniel C. Neto.
-- 24/09/2004 - Inclusão de campos e exclusão de outros - Daniel C. Neto.
-- 05/10/2004 - Inclusão do campo de Qtd. Est. Emb. no parametro 1 - Daniel C. Neto.
-- 15/12/2004 - Inclusão de campo cd_tipo_embalagem - Daniel C. Neto.
-- 14/02/2005 - Inclusão de campo nm_produto - Daniel C. Neto.
-- 02.05.2005 - Alteração da Busca do Lote - Carlos Fernandes
-- 03.06.2005 - Alterado para a busca do Lote para o próximo que tiver saldo. - Rafael Santiago
-- 25.10.2005 - Checagem de diversos Lotes - Carlos Fernandes
-- 30.10.2005 - Carlos Fernandes
-- 22.05.2006 - Colocação da Data de Fechamento da guia e do usuário - Carlos Fernandes
-- 17.03.2007 - Sobra da Quantidade Principal/EO da Guia - Carlos Fernandes
-- 31.03.2007 - Não permitir fechar guias Canceladas - Carlos Fernandes
-- 03.01.2008 - Ajuste para Geração da guia de fracionamento - Carlos Fernandes.
-- 08.01.2007 - Ordem do fechamento da Guia - Carlos Fernandes
-- 31.01.2008 - Acerto da Unidade de Medida - Carlos Fernandes
-- 08.11.2010 - Lote Interno - Carlos Fernandes
-- 02.12.2010 - Lote do Fabricante - Carlos Fernandes
-- 15.12.2010 - Ajustes Diversos - Carlos Fernandes
-- 24.01.2011 - Desenvolvimento para Sobra / Produto da Sobra - Carlos Fernandes
-- 26.01.2011 - Sobra - Carlos Fernandes
---------------------------------------------------------------------------------------------

CREATE  PROCEDURE pr_controle_guia_fracionamento

  @ic_parametro     int, 
  @dt_inicial       datetime,
  @dt_final         datetime,

  -- Usado parametros 3 e 7

  @ic_tipo_pesquisa char(1)     = 'C',
  @nm_filtro        varchar(80) = '',
  @cd_lote_produto  int         = 0,
  @ic_tipo_consulta char(1)     = ''

as

declare @cd_fase_produto int

set @cd_fase_produto = ( select cd_fase_produto from Parametro_Comercial where cd_empresa = dbo.fn_empresa())

------------------------------------------------------------
if @ic_parametro = 1 -- Select para a guia de fracionamento.
------------------------------------------------------------
begin

  SELECT distinct
  gfi.cd_guia_fracionamento, 
  gfi.qt_fracionada, 
  gf.dt_guia_fracionamento, 
  te.nm_tipo_embalagem, 
  p.cd_produto, 
  p.nm_fantasia_produto,
  dbo.fn_mascara_produto(p.cd_produto) as cd_mascara_produto,
  gf.dt_guia_fechada,
  gf.dt_guia_cancelada,
  o.nm_fantasia_operador,
  u.nm_fantasia_usuario,
  gf.cd_laudo,
  gf.cd_lote,
  l.cd_lote                            as cd_lote_laudo,
  l.cd_lote_interno,
  l.cd_lote_fabricante,
  gfi.cd_lote_fracionamento,
  gfi.cd_item_guia_fracionamento
--select * from guia_fracionamento
--select * from guia_fracionamento_item
--select * from laudo

FROM
  Guia_Fracionamento      gf  with (nolock) inner join         
  Guia_Fracionamento_Item gfi with (nolock) on gf.cd_guia_fracionamento     = gfi.cd_guia_fracionamento   INNER JOIN
  Produto_Fracionamento   pf  with (nolock) ON gfi.cd_produto_fracionamento = pf.cd_produto_fracionamento INNER JOIN
  Tipo_Embalagem          te  with (nolock) ON pf.cd_tipo_embalagem         = te.cd_tipo_embalagem        left outer join
  Produto                 p   with (nolock) ON pf.cd_produto_fracionado     = p.cd_produto                left outer join
  Operador                o   with (nolock) on gfi.cd_operador              = o.cd_operador               left outer join
  egisadmin.dbo.usuario   u   with (nolock) on u.cd_usuario                 = gf.cd_usuario            
  left outer join Laudo   l   with (nolock) on l.cd_laudo                   = gf.cd_laudo
  
where
  --gf.dt_guia_fechada is null and
  gf.dt_guia_fracionamento between @dt_inicial and @dt_final
order by
  gf.dt_guia_fracionamento  desc,
  gfi.cd_guia_fracionamento desc 

end

-----------------------------------------------------------------------
else if @ic_parametro = 2 -- Select para a seleção e criação da Guia.
-----------------------------------------------------------------------
begin

--select * from Lote_produto
--select * from Lote_produto_Saldo

SELECT

  distinct

  p.nm_fantasia_produto, 
  p.nm_produto,
  pf.cd_produto,
  isnull(um.sg_unidade_medida,'') as sg_unidade_medida,

  --Lote---------------------------------------------------------------------------------------
    
  ( select top 1 
     l.nm_ref_lote_produto 
   from
     Lote_Produto_item lp             with (nolock) 
     inner join lote_produto_saldo ls on ls.cd_lote_produto = lp.cd_lote_produto and 
                                         ls.cd_produto      = lp.cd_produto      and 
                                         isnull(ls.qt_saldo_reserva_lote,0) > 0
     inner join lote_produto l        on l.cd_lote_produto  = lp.cd_lote_produto
     left outer join produto pro      on lp.cd_produto      = pro.cd_produto
                       
   where
     lp.cd_produto = pf.cd_produto 
   order by
     l.dt_final_lote_produto,
     l.dt_entrada_lote_produto )        as cd_lote,

  --Diversos Lotes---------------------------------------------------------------------------

  case when 
  ( select count(l.nm_ref_lote_produto) 
   from
     Lote_Produto_item lp             with (nolock) 
     inner join lote_produto_saldo ls on ls.cd_lote_produto = lp.cd_lote_produto and 
                                         ls.cd_produto      = lp.cd_produto      and 
                                         isnull(ls.qt_saldo_reserva_lote,0) > 0
     inner join lote_produto l        on l.cd_lote_produto  = lp.cd_lote_produto
     left outer join produto pro      on lp.cd_produto      = pro.cd_produto
                       
   where
     lp.cd_produto = pf.cd_produto )>0 then 'Diversos Lote  ' else '01 Lote        ' end as nm_quantidade_lote,

  dbo.fn_mascara_produto(pf.cd_produto) as cd_mascara_produto, 
  ps.qt_saldo_atual_produto             as qt_saldo_atual_produto, 
  ps.qt_saldo_reserva_produto           as qt_saldo_reserva_produto, 

  --Quantidade no Movimento de Estoque Fracionado 

  ( select top 1 qt_movimento_estoque
    from Movimento_Estoque me  with (nolock) 
    where me.cd_produto      = pf.cd_produto and
          me.cd_fase_produto = @cd_fase_produto and
          me.cd_tipo_documento_estoque = 13
    order by dt_movimento_estoque desc)  as qt_produto_fracionado,

  ( select top 1 
     l.dt_final_lote_produto
   from
     Lote_Produto_item lp              with (nolock) 
     inner join lote_produto_saldo ls  on ls.cd_lote_produto = lp.cd_lote_produto and 
                                          ls.cd_produto = lp.cd_produto           and 
                                          ls.qt_saldo_reserva_lote > 0
     inner join lote_produto l         on l.cd_lote_produto  = lp.cd_lote_produto
     left outer join produto pro       on lp.cd_produto      = pro.cd_produto
                   
   where
     lp.cd_produto = pf.cd_produto 
   order by
     l.dt_final_lote_produto,
     l.dt_entrada_lote_produto ) as 'DtValidade',

   p.cd_unidade_medida,
   isnull(pf.ic_sobra_produto,'N') as ic_sobra_produto


FROM         
  Produto_Fracionamento pf          with (nolock)
  left outer join Produto_Saldo ps  ON pf.cd_produto        = ps.cd_produto and 
                                       ps.cd_fase_produto   = @cd_fase_produto
  INNER JOIN Produto p              ON pf.cd_produto        = p.cd_produto
  left outer join unidade_medida um on um.cd_unidade_medida = p.cd_unidade_medida

where
  isnull(ps.qt_saldo_atual_produto,0) > 0 and
  (case when @ic_tipo_pesquisa = 'C' then p.cd_mascara_produto 
        when @ic_tipo_pesquisa = 'D' then p.nm_produto
        else p.nm_fantasia_produto end ) like @nm_filtro + '%'

order by
  p.nm_fantasia_produto


end

-----------------------------------------------------------------------
else if @ic_parametro = 3 -- Select para a Geração da Guia de Fracionamento.
-----------------------------------------------------------------------
begin

  --select * from guia_fracionamento

SELECT     
  p.nm_fantasia_produto, 
  pf.cd_produto,                    --Produto Original
  pf.cd_produto_fracionamento,      --Código Interno de Controle
  pf.cd_produto_fracionado,         --Produto que será gerado pelo Fracionamento

  --Lote-------------------------------------------------------------------------
    
  ( select top 1 
     l.nm_ref_lote_produto 
   from
     Lote_Produto_item lp             with (nolock) 
     inner join lote_produto_saldo ls on ls.cd_lote_produto = lp.cd_lote_produto and 
                                         ls.cd_produto      = lp.cd_produto      and 
                                         isnull(ls.qt_saldo_reserva_lote,0) > 0
     inner join lote_produto l        on l.cd_lote_produto  = lp.cd_lote_produto
     left outer join produto pro      on lp.cd_produto      = pro.cd_produto
                       
   where
     lp.cd_produto = pf.cd_produto 
   order by
     l.dt_final_lote_produto,
     l.dt_entrada_lote_produto ) as cd_lote,

  dbo.fn_mascara_produto(pf.cd_produto) as cd_mascara_produto, 
  isnull(ps.qt_saldo_reserva_produto,0) as qt_saldo_reserva_produto,

  ( select top 1 
     l.dt_final_lote_produto
   from
     Lote_Produto_item lp             with (nolock) 
     inner join lote_produto_saldo ls on ls.cd_lote_produto = lp.cd_lote_produto and 
                                         ls.cd_produto = lp.cd_produto           and 
                                         isnull(ls.qt_saldo_reserva_lote,0) > 0
     inner join lote_produto l        on l.cd_lote_produto  = lp.cd_lote_produto
     left outer join produto pro      on lp.cd_produto      = pro.cd_produto
                       
   where
     lp.cd_produto = pf.cd_produto 
   order by
     l.dt_final_lote_produto,
     l.dt_entrada_lote_produto ) as 'DtValidade',

  dbo.fn_mascara_produto(pf.cd_produto_fracionado) as cd_mascara_produto_f, 
  ppf.nm_fantasia_produto                          as nm_fantasia_produto_f, 
  isnull(pfs.qt_saldo_reserva_produto,0)           as qt_saldo_reserva_produto_f,
  0.00                                             as qtd_estoque_lote,
  0.00                                             as qtd_vendido_lote,
  cast(0 as float)                                 as qt_produto_fracionado,
  pf.qt_produto_fracionado                         as qt_conversao,
  
  --Embalagem

  te.cd_tipo_embalagem,
  te.nm_tipo_embalagem,
  te.cd_produto                                    as cd_produto_embalagem,
  pfse.qt_saldo_reserva_produto                    as qt_saldo_reserva_produto_e
  
FROM         
  Produto_Fracionamento pf left outer join
  Produto_Saldo ps   ON pf.cd_produto        = ps.cd_produto and 
                        ps.cd_fase_produto   = @cd_fase_produto         INNER JOIN
  Produto p          ON pf.cd_produto        = p.cd_produto             left outer join
  Produto ppf        on ppf.cd_produto       = pf.cd_produto_fracionado left outer join
  Produto_Saldo pfs  ON pfs.cd_produto       = pf.cd_produto_fracionado and 
                        pfs.cd_fase_produto  = @cd_fase_produto         left outer join
  Tipo_Embalagem te  on te.cd_tipo_embalagem = pf.cd_tipo_embalagem     left outer join
  Produto_Saldo pfse on pfse.cd_produto      = te.cd_produto and
                        pfse.cd_fase_produto = @cd_fase_produto

--select * from tipo_embalagem
--select * from produto_embalagem
--select * from produto_fracionamento

where
  pf.cd_produto = @nm_filtro

order by
  te.nm_tipo_embalagem, -- Cuidado esta ordem é pra validar estoque de embalagem tb!
  ppf.nm_fantasia_produto

end

------------------------------------------------------------
else if @ic_parametro = 4 -- Select para a consulta de guias.
------------------------------------------------------------
begin

--select * from guia_fracionamento_item
--select * from produto_fracionamento

SELECT 
  gfi.cd_guia_fracionamento, 
  gfi.cd_item_guia_fracionamento, 
  gfi.qt_fracionada, 
  gf.dt_guia_fracionamento, 
  te.nm_tipo_embalagem, 
  p.cd_produto,
  p.nm_fantasia_produto,
  p.nm_produto,
  dbo.fn_mascara_produto(p.cd_produto) as cd_mascara_produto,
  gf.cd_lote,
  o.nm_fantasia_operador,
  gf.dt_guia_fechada,
  gf.dt_guia_cancelada,
  pp.cd_produto          as cd_produto_principal,
  pp.cd_mascara_produto  as 'CodigoPrincipal',
  pp.nm_fantasia_produto as 'FantasiaPrincipal',
  pp.nm_produto          as 'ProdutoPrincipal',
  gfi.qt_real_fracionada,
  gfi.qt_dif_fracionada, 
  gfi.qt_sobra_fracionada,
  gfi.qt_sobra_fracionada * isnull(pf.qt_produto_fracionado,0) as qt_sobra_ri, --Quantidade para Geração da RI
  pf.qt_produto_fracionado,
  gf.cd_laudo,
  l.cd_lote_fabricante,
  gfi.cd_lote_fracionamento,
  isnull(pf.ic_sobra_produto,'N') as ic_sobra_produto


FROM
  Guia_Fracionamento gf                  with (nolock) 
  inner join Guia_Fracionamento_Item gfi with (nolock) on gf.cd_guia_fracionamento     = gfi.cd_guia_fracionamento
  INNER JOIN Produto_Fracionamento pf    with (nolock) ON gfi.cd_produto_fracionamento = pf.cd_produto_fracionamento 
  INNER JOIN Tipo_Embalagem te           with (nolock) ON pf.cd_tipo_embalagem         = te.cd_tipo_embalagem 
  left outer join Produto p              with (nolock) ON pf.cd_produto_fracionado     = p.cd_produto 
  left outer join Operador o             with (nolock) on o.cd_operador                = gfi.cd_operador
  left outer join Produto pp             with (nolock) on pp.cd_produto                = gfi.cd_produto
  left outer join Laudo l                with (nolock) on l.cd_laudo                   = gf.cd_laudo
where
  gf.cd_guia_fracionamento = ( case when isnull(@nm_filtro,'') = '' then
                                 gf.cd_guia_fracionamento 
                               else @nm_filtro end ) and
  gf.dt_guia_fracionamento between (case when isnull(@nm_filtro,'') = ''  then
                                      @dt_inicial 
                                    else gf.dt_guia_fracionamento end ) and 
                                   (case when isnull(@nm_filtro,'') = ''  then
                                      @dt_final
                                    else gf.dt_guia_fracionamento end )
                                   
order by
  gf.cd_guia_fracionamento desc

end

------------------------------------------------------------------
else if @ic_parametro = 5 -- Select para o Fechamento de Guias.
------------------------------------------------------------------
begin

SELECT 
  0    as Sel,
  gf.cd_guia_fracionamento, 
  0.00 as qt_fracionada, 
  gf.dt_guia_fracionamento, 
  ''   as nm_tipo_embalagem, 
  ''   as nm_fantasia_produto,
  ''   as cd_mascara_produto,
  gf.cd_lote,
  0  as cd_operador,
  (select top 1 isnull(o.nm_fantasia_operador,'') from Operador o 
                                                       left outer join guia_fracionamento_item gfi on gfi.cd_operador = o.cd_operador and
                                                                                                      gfi.cd_guia_fracionamento = gf.cd_guia_fracionamento
                                                        ) as nm_fantasia_operador,
  0  as cd_produto,
  0  as cd_produto_fracionado,
  gf.dt_guia_fechada,
  gf.dt_guia_cancelada,
  0  as cd_item_guia_fracionamento,
  gf.ic_guia_impressa,

  ( select top 1 
     l.dt_final_lote_produto
   from
     Lote_Produto l with (nolock) 
   where
     l.nm_ref_lote_produto = gf.cd_lote 
   order by
     l.dt_final_lote_produto,
     l.dt_entrada_lote_produto ) as 'DtValidade',

  ( select top 1 
     l.dt_inicial_lote_produto
   from
     Lote_Produto l with (nolock) 
   where
     l.nm_ref_lote_produto = gf.cd_lote 
   order by
     l.dt_final_lote_produto,
     l.dt_entrada_lote_produto ) as 'DtInicioValidade',

  ( select top 1 
     l.cd_lote_produto
   from
     Lote_Produto l with (nolock) 
   where
     l.nm_ref_lote_produto = gf.cd_lote ) as cd_lote_produto,

  u.nm_fantasia_usuario,
  gf.cd_laudo 

FROM
  Guia_Fracionamento gf                       with (nolock) 
  left outer join egisadmin.dbo.usuario   u   on u.cd_usuario                 = gf.cd_usuario

where
  gf.cd_guia_fracionamento = ( case when IsNull(@nm_filtro,'') = '' then
                                 gf.cd_guia_fracionamento 
                               else IsNull(@nm_filtro,'') end ) and

  -- Seguindo a lógica pedida: - Só trazer as guias abertas e que estejam impressas ou a pedida.
  IsNull(gf.dt_guia_fechada,'01/01/1900') = ( case when (IsNull(@nm_filtro,'') = '') then 
                                              ( case when (gf.dt_guia_fechada is null) then
                                                  ( case when IsNull(gf.ic_guia_impressa,'N') = 'S' then
                                                      IsNull(gf.dt_guia_fechada,'01/01/1900')
                                                    else IsNull(gf.dt_guia_fechada,GetDate()) + 1 end )
                                                else IsNull(gf.dt_guia_fechada,'01/01/1900') + 1 end )
                                          else IsNull(gf.dt_guia_fechada,'01/01/1900') end ) and
  --Guias Canceladas não entram para Fechamento
  dt_guia_cancelada is null
order by
  --gf.dt_guia_fechada desc
  gf.dt_guia_fracionamento desc
 
end 

--select * from guia_fracionamento

------------------------------------------------------------------
else if @ic_parametro = 6 -- Select para o Estorno de Guias.
------------------------------------------------------------------
begin

SELECT 
  0 as Sel,
  gf.cd_guia_fracionamento, 
  0.00 as qt_fracionada, 
  gf.dt_guia_fracionamento, 
  '' as nm_tipo_embalagem, 
  '' as nm_fantasia_produto,
  '' as cd_mascara_produto,
  gf.cd_lote,
  (select top 1 isnull(o.nm_fantasia_operador,'') from Operador o 
                                                       left outer join guia_fracionamento_item gfi on gfi.cd_operador = o.cd_operador and
                                                                                                      gfi.cd_guia_fracionamento = gf.cd_guia_fracionamento
                                                        ) as nm_fantasia_operador,
  0  as cd_produto,
  0  as cd_produto_fracionado,
  gf.dt_guia_fechada,
  0  as cd_item_guia_fracionamento,
  gf.dt_guia_cancelada,
  gf.cd_laudo

FROM
  Guia_Fracionamento gf       with (nolock)
where
  gf.cd_guia_fracionamento = ( case when IsNull(@nm_filtro,'') = '' then
                                 gf.cd_guia_fracionamento 
                               else IsNull(@nm_filtro,'') end ) and
  gf.dt_guia_fracionamento between (case when IsNull(@nm_filtro,'') = ''  then
                                      @dt_inicial 
                                    else gf.dt_guia_fracionamento end ) and 
                                   (case when IsNull(@nm_filtro,'') = ''  then
                                      @dt_final
                                    else gf.dt_guia_fracionamento end ) and

  -- Seguindo a lógica pedida: - Só trazer as guias fechadas no período e que não estejam canceladas.
  -- ou a pedida.
  IsNull(gf.dt_guia_fechada,GetDate()) = ( case when (IsNull(@nm_filtro,'') = '') then 
                                           ( case when (gf.dt_guia_fechada is null) then
                                               IsNull(gf.dt_guia_fechada,GetDate()) + 1
                                             else 
                                               ( case when gf.dt_guia_cancelada is null then
                                                   gf.dt_guia_fechada
                                                 else IsNull(gf.dt_guia_fechada,GetDate()) + 1 
                                                 end )
                                             end )
                                           else IsNull(gf.dt_guia_fechada,GetDate()) end )

                                 
end 

--------------------------------------------------------------
else if @ic_parametro = 7 -- Select para a Impressão das Guias.
--------------------------------------------------------------
begin

  declare @SQL       varchar(8000)
  declare @SQLUPDATE varchar(8000)

set @SQL = ' SELECT     
  0  as Sel,
  gf.cd_guia_fracionamento, 
  gf.cd_lote, 
  gf.dt_guia_fracionamento,
  gf.dt_guia_fechada, 
  dbo.fn_mascara_produto(pf.cd_produto) as cd_mascara_produto,
  p.nm_fantasia_produto, 
  p.nm_produto, 
  dbo.fn_mascara_produto(pf.cd_produto_fracionado) as cd_mascara_produto_frac,
  ppf.nm_fantasia_produto AS nm_fantasia_produto_frac, 
  gfi.qt_fracionada, 
  op.nm_fantasia_operador, 
  un.sg_unidade_medida, 
  te.nm_tipo_embalagem,
  pf.qt_peso_conversao,
  pf.qt_produto_fracionado as qt_conversao,

 ( select top 1   
     l.dt_inicial_lote_produto  
   from  
     Lote_Produto l  with (nolock) 
   where  
     l.nm_ref_lote_produto = gf.cd_lote   
   order by  
     l.dt_inicial_lote_produto,  
     l.dt_entrada_lote_produto ) as DtFabricacao,

  ( select top 1 
     l.dt_final_lote_produto
   from
     Lote_Produto l with (nolock) 
   where
     l.nm_ref_lote_produto = gf.cd_lote 
   order by
     l.dt_final_lote_produto,
     l.dt_entrada_lote_produto ) as DtValidade,
   l.cd_lote_interno             as LoteInterno,
   gf.cd_laudo,
   gfi.cd_lote_fracionamento, l.cd_lote_fabricante, l.cd_lote_interno
into #SelecaoInicial
FROM         
  Guia_Fracionamento gf with (nolock) left outer join
  Guia_Fracionamento_Item gfi ON gf.cd_guia_fracionamento = gfi.cd_guia_fracionamento left outer join
  Produto_Fracionamento pf ON gfi.cd_produto_fracionamento = pf.cd_produto_fracionamento left outer join
  Produto p ON pf.cd_produto = p.cd_produto left outer join
  Produto ppf ON pf.cd_produto_fracionado = ppf.cd_produto left outer join
  Operador op ON gfi.cd_operador = op.cd_operador left outer join
  Unidade_Medida un ON pf.cd_unidade_medida = un.cd_unidade_medida left outer join
  Tipo_Embalagem te ON pf.cd_tipo_embalagem = te.cd_tipo_embalagem
  left outer join Laudo l on l.cd_laudo = gf.cd_laudo
where ' 

  if isNull(@nm_filtro,'') = ''
    set @SQL = @SQL + ' gf.dt_guia_fracionamento between ' +
                        QuoteName(cast(@dt_inicial as varchar),'''') + ' and ' +
                        QuoteName(cast(@dt_final as varchar),'''')
  else
    set @SQL = @SQL + ' gf.cd_guia_fracionamento in ( ' + @nm_filtro + ')'

  -----------------------------------------------------------------------
  if @ic_tipo_pesquisa = 'S' -- Atualizar a guia e colocar como impressa.
  -----------------------------------------------------------------------
  begin
    set @SQL = @SQL + ' select * from #SelecaoInicial order by cd_guia_fracionamento '

    set @SQLUPDATE = 'update Guia_Fracionamento
                      set ic_guia_impressa = ''S''
                      where ' 
    if IsNull(@nm_filtro,'') = ''
      set @SQLUPDATE = @SQLUPDATE + ' dt_guia_fracionamento between ' +
                                    QuoteName(cast(@dt_inicial as varchar),'''') + ' and ' +
                                    QuoteName(cast(@dt_final as varchar),'''') 
    else
      set @SQLUPDATE = @SQLUPDATE + ' cd_guia_fracionamento in ( ' + @nm_filtro + ')'

    exec(@SQLUPDATE)

  end
  else
    set @SQL = @SQL + 
     ' select distinct 
      Sel,
      cd_guia_fracionamento, 
      dt_guia_fracionamento,
      cd_lote
    from
      #SelecaoInicial
    group by 
      Sel,
      cd_guia_fracionamento, 
      dt_guia_fracionamento,
      cd_lote '


    exec(@SQL)


end

