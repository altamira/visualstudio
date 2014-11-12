
-- Rodar esse comando para criação de indice caso não exista
--   BEGIN TRANSACTION
--   CREATE NONCLUSTERED INDEX IX_Pedido_Compra_Item_Requisicao ON dbo.Pedido_Compra_Item
--   	(
--   	cd_requisicao_compra
--   	) ON [PRIMARY]
--   GO
--   COMMIT

--   BEGIN TRANSACTION
--   CREATE NONCLUSTERED INDEX IX_Requisicao_Compra_Item_Requisicao ON dbo.Requisicao_Compra_Item
--   	(
--   	cd_requisicao_compra
--   	) ON [PRIMARY]
--   GO
--   COMMIT



---------------------------------------------------------------------------------------------------------------------  
--pr_consulta_requisicao_compra  
---------------------------------------------------------------------------------------------------------------------  
--GBS - Global Business Solution LTDA                                     2004  
---------------------------------------------------------------------------------------------------------------------  
--Stored Procedure : Microsoft SQL Server 2000  
--Autor(es)  : Sandro Campos  
--Banco de Dados : EGISSQL  
--Objetivo  : Consultar Pedido Compra  
--Data   : ??????  
--Alteração  : 02/01/2003 - Daniel C. Neto.  
--       07/01/2003 - Rafael Santiago  
--Desc. Alteração : Acertos Gerais.  
--                      : 20/03/2003 - Valor Default para o @cd_tipo_data - Daniel C. Neto.  
--                      : 15/04/2003 - Alterado forma de consultar atraso. - Daniel C. Neto.  
--                      : 16/05/2003 - Acertos Gerais ( Dt. Necessidade e Observação )  
--   :            - Inclusão de campo ic_nao_aprovado - Daniel C. Neto.  
--                      : 11/09/2003 - Incluído nova flag pra indicar  
--                                     se a requisição está pronta para o processo de compras.  
--                                     - Daniel C. Neto.  
--                      : 17/09/2003 - Incluída nova variável para o Parâmetro 2   
--                                     - Daniel C. Neto.  
--                      : 25/09/2003 - Incluído novo parâmetro de filtro de consulta  
--                                     - Daniel C. Neto.  
--                      : 30/10/2003 - Acertos Gerais - Daniel C. Neto.  
--                      : 11/11/2003 - Incluído filtro por departamento, supervisão e comprador.  
--                                     Daniel C. Neto.  
--                      : 16/12/2003 - Inclusão de campos usados na procedure  
--                                     pr_consumo_medio, para agilizar consulta - Daniel C. Neto  
--                      : 06/01/2004 - Mudado relacionamento no ic_parametro 1 para pegar o campo Requisitante - Daniel C. Neto  
--                      : 06/01/2004 - Incluído campo de grupo de produto especial - Daniel C. Neto,.  
--                      : 06/01/2004 - Comentado Filtro que existia pelo status da requisição, já que basta mostrar todos os  
--                                     itens que não tenham o campo cd_pedido_compra preenchido no item para indicar que o mesmo  
--                                     está em aberto - ELIAS  
--                      : 07/01/2004 - Acerto Par. 2 - Daniel C. Neto  
--                      : 22/01/2004 - Incluído parâmetro de filtro recebido - Daniel C. Neto.  
--                      : 26/01/2004 - Acerto par. 2 - Daniel C. Neto.  
--                      : 18/02/2004 - Comentado código para trazer requisições sem itens - Daniel C. Neto.  
--                      : 08/03/2004 - Acerto no campo de Requisitante. - Daniel C. Neto.  
--                      : 17/03/2004 - Usado função para consumo médio trimestral - Daniel C. Neto.  
--                      : 17/03/2004 - Recálculo de Dias - Daniel C. Neto.  
--                      : 13/04/2004 - Transformado descrição em Varchar(2000) no parâmetro 2 - Daniel C. Neto.  
--                      : 03/06/2004 - Acerto no campo de medida bruta - Daniel C. neto.  
--                      : 21/09/2004 - Incluído tipo de placa - Daniel C. Neto.  
--                      : 05/11/2004 - Acerto no filtro de usuário - Daniel C. Neto.  
--                      : 16/11/2004 - Modificado filtro de data na requisição de compra - Dzniel C. Neto.  
--                                   - Incluído filtro na consulta de n. específico da requisição - Daniel C. Neto.  
--Atualização           : 10/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso  
--                      : 22/01/2004 - Acerto do filtro para busca da data inicial do parametro_suprimento - Carlos Fernandes  
--         : 24/01/2005 - Incluído mais um tipo de filtro de data no parametro 2 - Daniel C. Neto.  
--                      : 01/02/2005 - Verifica o tipo de filtro desta consulta (Necessidade ou Emissão) no Parâmetro Suprimento - ELIAS  
--                      : 05/02/2005 - Verificação do Flag de Aprovação pela Requisição de Compras - Carlos Fernandes  
--                      : 10/02/2005 - Incluído campo nm_status_requisicao - André  
--                      : 14/02/2005 - Incluído campo de país e verificação pra não trazer requisições relacionadas a PI - Daniel C. Neto.  
--                      : 26/05/2006 - Ajustado para melhorar performace (adicionado With(Nolock)) - ELIAS  
--                      : 19/07/2006 - Adicionado novo parâmetro que definirá uma filtragem da requisição pelo mercado
--                                     e criação e utilização de índices, além de adicionar with(nolock) na parte de SQL 
--                                     Dinâmico - Fabio
--                        18/10/2006 - Tirado referência aos indices, pois estava dando problemas nos clientes.
--                                   - Acerto no parametro 2 que estava com erro.
--                                   - Daniel C. Neto.
--                        27/10/2006 - Colocado para pegar centro de custo e plano de compra dos itens da requisição.
--                                   - Daniel C. Neto.
--                        09/11/2006 - Incluído campo qt_mes_compra_produto - Daniel C. Neto.
--                        27.06.2007 - Acerto na Consulta quando o Tipo Matéria_prima, não é chapa de aço - Carlos
---------------------------------------------------------------------------------------------------------------------  
  
CREATE PROCEDURE pr_consulta_requisicao_compra  
  
  
@ic_parametro         int,  
@cd_tipo_requisicao   int,  
@cd_status_requisicao int,   
@dt_inicial           datetime,  
@dt_final             datetime,  
@cd_req_compra        int,  
@cd_tipo_data         int     = 0,   -- 0 para Filtrar por emissão, 1 para filtrar por necessidade, 2 por Liberação.  
@ic_tipo_filtro       char(1) = 'T', -- T para Todos, A para em Aberto, C em Cotação e P para em pedido.  
@cd_usuario           int     = 0,    -- Informa o usuário  
@cd_tipo_mercado      int     = 0   --Filtros "0" - Todos / "1" - Mercado Interno / "2" - Mercado Externo
AS  
Begin
 set nocount on
  
 declare @cd_comprador          int,  
         @ic_tipo_usuario       char(1),  
         @cd_departamento       int,  
         @ic_filtra_necessidade char(1),  
         @dt_inicio_req_aberto  datetime,
         @ic_tipo_requisicao    char(1)  
  
 Select @ic_tipo_usuario = IsNull(ic_tipo_usuario,'N'),  
        @cd_comprador    = isNull(cd_comprador,0),  
        @cd_departamento = IsNull(cd_departamento,0)  
 From EgisAdmin.dbo.Usuario with(nolock)  
 where cd_usuario = @cd_usuario  
  

set @ic_tipo_requisicao = 'N'

if @cd_tipo_requisicao<>0
begin
  select 
    @ic_tipo_requisicao = isnull(ic_tipo_requisicao,'N')
  from
    tipo_requisicao with (nolock) 
  where
    cd_tipo_requisicao = @cd_tipo_requisicao
end
    

--Data de Início para Consulta da Requisição  
  
  Select 
    @dt_inicio_req_aberto  = dt_inicio_req_aberto,  
    --Indica se será filtrado por Necessidade - ELIAS  
    @ic_filtra_necessidade = isnull(ic_filtro_nec_req_compra,'S'),
    @cd_tipo_mercado = ( case @cd_tipo_mercado
                           when 1 then 1
                           when 2 then 2
                           else 0 end ) --Evitar que por nenhuma hipótese esse novo parâmetro venha a gerar algum problema no sistema
  from parametro_suprimento with(nolock)  
  where 
    cd_empresa = dbo.fn_empresa()  
  
  
--Checagem da Data Inicial  
  
  if ( @dt_inicio_req_aberto is not null ) and  
     ( @dt_inicial < @dt_inicio_req_aberto )   
  begin  
    set @dt_inicial = @dt_inicio_req_aberto   
  end  
  
  
  -------------------------------------------------------------------------------  
  if @ic_parametro = 1    -- Consulta de Requisição Compras (Todos)  
  -------------------------------------------------------------------------------  
    begin  
    
      select rc.cd_requisicao_compra,  
             rc.dt_emissao_req_compra,  
             rc.dt_necessidade_req_compra,  
             rc.cd_departamento,  
             rc.cd_aplicacao_produto,  
             rc.cd_plano_compra,  
             cast (rc.ds_requisicao_compra as varchar(255)) as ds_requisicao_compra,  
             rc.cd_centro_custo,  
             rc.qt_cotacao_req_compra,  
             rc.cd_tipo_requisicao,  
             rc.cd_processo_fabricacao,  
             rc.cd_requisitante AS cd_usuario,  
             rc.dt_usuario,  
             rc.cd_tipo_produto_espessura,  
             rc.cd_status_requisicao,  
             sr.nm_status_requisicao,   
             rc.ic_tipo_requisicao,  
             IsNull(( select top 1 x.cd_pedido_compra from Pedido_Compra_Item x with(nolock)  
                       where x.cd_requisicao_compra = rc.cd_requisicao_compra and  
                             x.qt_saldo_item_ped_compra > 0 ),0) as cd_pedido_compra,  
    
             rc.qt_peso_req_compra,  
             rc.cd_item_pedido_compra,  
             rc.ic_maquina,  
             isnull(rc.ic_aprovada_req_compra,'N') as ic_aprovada_req_compra,  
             ap.nm_aplicacao_produto,  
             plc.nm_plano_compra,  
             plc.cd_mascara_plano_compra,  
             cc.nm_centro_custo,  
             dp.nm_departamento,  
             tr.nm_cor_prioridade_bk,  
             tr.nm_cor_prioridade_fg,  
             tr.nm_tipo_requisicao,  
             usuario.nm_fantasia_usuario,  
             rc.cd_destinacao_produto,  
             rc.cd_plano_financeiro,  
             IsNull(rc.ic_reprovada_req_compra, 'N') as ic_reprovada_req_compra,  
             IsNull(rc.ic_liberado_proc_compra,'N')  as ic_liberado_proc_compra,  
             IsNull(( select top 1 x.cd_cotacao from Cotacao_item x with(nolock)  
                      where x.cd_requisicao_compra = rc.cd_requisicao_compra  ),0) as cotacao_compra,  
             IsNull(( select top 1 IsNull(x.cd_pedido_compra,0) from Pedido_Compra_Item x with(nolock)  
                      where x.cd_requisicao_compra = rc.cd_requisicao_compra and  
                            x.qt_saldo_item_ped_compra = 0 ),0) as PedRecebido,
              
             ( case IsNull(cd_tipo_mercado,1)
                when 1 then 'N'
                else 'S' 
             end ) as ic_importacao
      into #Requisicao_Compra  
               
      from Requisicao_compra rc with(nolock)  
        Inner join Tipo_Requisicao tr with(nolock) 
          on tr.cd_tipo_requisicao = rc.cd_tipo_requisicao
--         left outer join Requisicao_Compra_Item rci with(nolock) on rci.cd_requisicao_compra = rc.cd_requisicao_compra  
        left outer join Aplicacao_Produto ap          with(nolock) on ap.cd_aplicacao_produto=rc.cd_aplicacao_produto  
        left outer join Centro_Custo cc               with(nolock) on cc.cd_centro_custo=rc.cd_centro_custo  
        left outer join Departamento dp               with(nolock) on dp.cd_departamento=rc.cd_departamento        
        left outer join plano_compra plc              with(nolock) on plc.cd_plano_compra=rc.cd_plano_compra  
        left outer join status_requisicao sr          with(nolock) on sr.cd_status_requisicao=rc.cd_status_requisicao  
        left outer join egisadmin.dbo.usuario usuario with(nolock) on usuario.cd_usuario=rc.cd_requisitante  
      where      
        --Filtro pelo código da Requisição de Compra
        (   IsNull(rc.cd_requisicao_compra,0) =  (case @cd_req_Compra
                                                    when 0 then IsNull(rc.cd_requisicao_compra,0)  
                                                    else @cd_req_Compra  
                                                  end ) 
        ) 
        --Filtra as Requisições por Data      
        and ( ( @cd_req_compra <> 0 ) or  
              ( @cd_req_compra = 0 and
                (case 
                   when (@ic_filtra_necessidade = 'S') then (IsNull(cast(cast(rc.dt_necessidade_req_compra as varchar(11))as datetime),cast(cast(rc.dt_emissao_req_compra as varchar(11))as datetime)))  
                   else cast(cast(rc.dt_emissao_req_compra as varchar(11))as datetime)  
                 end) between @dt_inicial and @dt_final
               )
            )
     --Filtra pelo tipo da requisição
     and (
            IsNull(rc.cd_tipo_requisicao,0) = (case IsNull(@cd_tipo_requisicao ,0)  
                                                 when 0 then  IsNull(rc.cd_tipo_requisicao,0)  
                                                 else @cd_tipo_requisicao
                                               end)
          )
     --Filtra pelo Status da Requisição  
      and (
            IsNull(rc.cd_status_requisicao,0) = (case IsNull(@cd_status_requisicao ,0)  
                                                   when 0 then  IsNull(rc.cd_status_requisicao,0)  
                                                   else @cd_status_requisicao  
                                                 end)  
          )
      --Filtragem pelo tipo de mercado - Fabio 18.07.2006
      and
      IsNull(rc.cd_tipo_mercado,1) = ( case 
                                      when (@cd_req_Compra = 0) then
                                        case @cd_tipo_mercado 
                                          when 1 then 1
                                          when 2 then 2
                                          else IsNull(rc.cd_tipo_mercado,1) 
                                        end
                                      else
                                        IsNull(rc.cd_tipo_mercado,1)
                                      end)           
  
      --Filtragem por informações do usuários
      and
      
      ( IsNull(rc.cd_requisitante,0) =  ( case 
                                            when ((@cd_comprador = 0) and (@ic_tipo_usuario <> 'S')) then @cd_usuario
                                            else IsNull(rc.cd_requisitante,0)
                                          end )
      ) and 
  
  
      ( IsNull(rc.cd_departamento,0) =  ( case 
                                            when ((@cd_comprador = 0) and (@ic_tipo_usuario = 'S')) then @cd_departamento
                                            else IsNull(rc.cd_departamento,0)
                                          end )
      ) 
      order by 
	tr.qt_prior_tipo_requisicao,  
        rc.dt_necessidade_req_compra,  
        rc.dt_emissao_req_compra,  
        rc.cd_requisicao_compra  
    
    
     if @cd_req_compra = 0  
     begin  
        Select 
          distinct  
          * 
        from
          #Requisicao_Compra  
        where   
     ( (@ic_tipo_filtro = 'T') or  
    
       ( (@ic_tipo_filtro = 'A'  )        and   
         (IsNull(cotacao_compra,0)   = 0) and   
         (cd_pedido_compra           = 0) and   
         (PedRecebido                = 0) and  
         (cd_status_requisicao       = 1) and --Aberto
         (ic_liberado_proc_compra    = 'S') ) ) or  
    
     ( (@ic_tipo_filtro = 'C') and   
       (IsNull(cotacao_compra,0) <> 0) and   
       (cd_pedido_compra = 0)  and   
       (PedRecebido      = 0)  and
       (cd_status_requisicao <> 3 ) 
     ) or  
    
      (@ic_tipo_filtro = 'P') and   
      ( (cd_status_requisicao=3 ) and
        (cd_pedido_compra <> 0)   or   
        (PedRecebido      <> 0)
         ) or  

      ( (@ic_tipo_filtro = 'R') and   
        (PedRecebido <> 0)      and
        (cd_status_requisicao = 3 ) )  
   end  
   else  
     select distinct * from #Requisicao_Compra    
  
  end  
  ----------------------------------------------------------------------------  
  if @ic_parametro = 2    -- Consulta de Itens de Requisição Compra  
  -------------------------------------------------------------------------------  
  begin   
      
    declare @cd_fase_produto int  
    declare @SQL_Temp        varchar(8000)  
    declare @SQL             varchar(8000)  
    declare @SQLFROM         VARCHAR(8000)  
    declare @SQLWHERE        VARCHAR(8000)  
    declare @DIFMES          INT  
    
    set @cd_fase_produto = ( select cd_fase_produto   
                             from Parametro_Comercial with(nolock)   
                             where cd_empresa = dbo.fn_empresa() )   
    
    declare @data_inicial datetime  
    declare @data_final   datetime   
    declare @cd_ano int  
    declare @cd_mes int  
    
    -----------------------------------------------------  
    -- Calcular as Datas  
    -----------------------------------------------------  
    SET DATEFORMAT ymd  
    
    -- Decompor data final  
    set @cd_ano = Year( Getdate() )  
    set @cd_mes = Month( Getdate() )  
    
    -- Data Final do Período  
    set @data_final = dateadd( dd , -1, Cast(Str(@cd_ano)+'-'+Str(@cd_mes)+'-01' as DateTime) )  
    
    --print 'Dt. Final'  
    --print @data_final  
    
    -- Definir a data Inicial para o cálculo Trimestral  
    set @data_inicial = dateadd( mm , -2, @data_final )  
    set @cd_mes = Month( @data_inicial )   
    set @cd_ano = Year( @data_inicial )   
    set @data_inicial = Cast(Str(@cd_ano)+'-'+Str(@cd_mes)+'-01' as DateTime)  
    
    --print 'Dt. Inicial Calc. Trim.'  
    --print @data_inicial  
    
    set @SQL_Temp = ' Select distinct rc.cd_requisicao_compra, ' +  
                       'rc.dt_emissao_req_compra, ' +  
                       'rc.dt_necessidade_req_compra, ' +  
                       'rc.qt_cotacao_req_Compra, ' +  
                       'rc.cd_tipo_requisicao, ' +  
                       'rc.cd_departamento, ' +   
                       'rc.cd_requisitante as cd_usuario, ' +  
                       'rc.cd_pedido_compra, ' +  
                       'rc.cd_plano_compra, ' +  
                       'rc.cd_status_requisicao, ' +  
		       'rc.cd_centro_custo, ' + 
                       'rc.ic_aprovada_req_compra, ' +  
        	       'rc.ic_reprovada_req_compra, ' +  
        	       'rc.ic_liberado_proc_compra, ' +   
        	       '( case IsNull(cd_tipo_mercado,1) when 1 then ''N'' else ''S'' end ) as ic_importacao, '+
        	       'rci.cd_item_requisicao_compra ' +  
            ------   
            		' into #Tmp_Requisicao_Compra ' +  
            ------  
					' from Requisicao_Compra rc with(nolock) inner join ' +  
					' Requisicao_Compra_Item rci with(nolock) on rci.cd_requisicao_compra = rc.cd_requisicao_compra '  
    
    if @cd_req_compra = 0  
    begin  
      if @cd_tipo_data = 1    
        set @SQL_Temp = @SQL_Temp + ' where (cast(cast(dt_emissao_req_compra as varchar(11))as datetime) between ' + '''' + cast(@dt_inicial as varchar(40)) + '''' + ' and ' +  
                        '''' + cast(@dt_final as varchar(40)) + '''' + '  and '  
      else if @cd_tipo_data = 2  
        set @SQL_Temp = @SQL_Temp + ' where (cast(cast(dt_necessidade_req_compra as varchar(11))as datetime) between ' + '''' + cast(@dt_inicial as varchar(40)) + '''' + ' and ' +  
                        '''' + cast(@dt_final as varchar(40)) + '''' + '  and '  
      else  
        set @SQL_Temp = @SQL_Temp + ' where (cast(cast(rci.dt_item_nec_req_compra as varchar(11))as datetime) between ' + '''' + cast(@dt_inicial as varchar(40)) + '''' + ' and ' +  
                        '''' + cast(@dt_final as varchar(40)) + '''' + '  and '  
          
    
      set @SQL_Temp = @SQL_Temp + ' (IsNull(cd_status_requisicao,0) = 1 ) ) '  
    
      if @cd_tipo_requisicao <> 0  
        set @SQL_Temp = @SQL_Temp +    
                        '  and (cd_tipo_requisicao = ' + cast(@cd_tipo_requisicao as varchar(40)) + ')'  
    
      if (@cd_comprador = 0) and (@ic_tipo_usuario <> 'S')  
        set @SQL_Temp = @SQL_Temp +    
                        '  and (cd_requisitante = ' + cast(@cd_usuario as varchar(40)) + ')'  
    
      if (@cd_comprador = 0) and (@ic_tipo_usuario = 'S')       
        set @SQL_Temp = @SQL_Temp +    
                        '  and (cd_departamento = ' + cast(@cd_departamento as varchar(40)) + ')'  
    
    end  
                            
    
    set @SQL =               ' Select rc.cd_requisicao_compra       as Requisicao, '   
                             + 'rc.dt_emissao_req_compra      as DataEmissao, '   
                             + 'rci.dt_item_nec_req_compra as DataNecessidade, '   
                             + 'dt_necessidade_req_compra, '   
                             + 'd.nm_departamento             as Departamento, '   
                             + 'rci.cd_item_requisicao_compra as Item, '   
                             + 'rci.cd_produto                as Codigo, '  
                             + 'case when IsNull(rci.cd_produto,0)>0 then pd.nm_produto when IsNull(rci.cd_servico,0)>0 then s.nm_servico else rci.nm_prod_requisicao_compra end as Nome_Produto, '
                             + 'case when IsNull(tr.ic_tipo_requisicao,''N'') = ''N'' then '   
                             + '(case when IsNull(rci.cd_produto,0)>0 then rci.nm_prod_requisicao_compra when IsNull(rci.cd_servico,0)>0 then s.nm_servico end) else '  
							 + ' mp.nm_fantasia_mat_prima end as Produto, '    
    
    if ( @cd_tipo_requisicao = 2 ) and ( @ic_tipo_requisicao = 'S' )	
      set @SQL = @SQL + ' cast(rci.ds_item_requisicao_compra as varchar(200)) + IsNull('' - '' + '  
                      + QuoteName('Medida Bruta : ', '''') + ' + '  
                      + ' rci.nm_medbruta_mat_prima,'''') '  
                      + ' + IsNull('' - '' + ' + QuoteName('Medida Acabada : ', '''') + ' + '  
                      + ' rci.nm_medacab_Mat_prima,'''')as ProdutoDescricao, '  
    else   
      set @SQL = @SQL + 'case '
                      + 'when isnull(ltrim(rtrim(cast(rci.ds_item_requisicao_compra as varchar(60)))),'''') <> '''' then '
                      + 'ltrim(rtrim(cast(rci.ds_item_requisicao_compra as varchar(60)))) '
                      + 'else '
                      + '    case when IsNull(rci.cd_produto,0)>0 then pd.nm_produto when IsNull(rci.cd_servico,0)>0 then s.nm_servico else rci.nm_prod_requisicao_compra end '
                      + 'end as ProdutoDescricao, '  
      --set @SQL = @SQL + 'case when IsNull(rci.cd_produto,0)>0 then pd.nm_produto when IsNull(rci.cd_servico,0)>0 then s.nm_servico else rci.nm_prod_requisicao_compra end as Nome_Produto, '
      --set @SQL = @SQL + ' pd.nm_produto as ProdutoDescricao, '          
    
    set @SQL = @SQL + ' rci.nm_marca_item_req_compra  as Marca, '   
                    + ' rci.qt_item_requisicao_Compra as Qtide, '  
                    + ' cast(rci.ds_obs_req_compra_item as varchar(250)) as Observacao, '  
                    + ' rci.cd_pedido_venda           as PedidoVenda, '  
                    + ' rci.cd_item_pedido_venda      as ItemPedidoVenda, '  
                    + ' rc.qt_cotacao_req_Compra      as QtideCotacoes, '   
                    + ' rc.cd_tipo_requisicao         as TipoRequisicao, '  
                    + ' rci.nm_placa, '   
					+ ' pci.qt_item_pesliq_ped_compra,'  
                    + ' rci.nm_medbruta_mat_prima,'  
                    + ' IsNull(pci.nm_medacab_mat_prima,rci.nm_medacab_mat_prima) as nm_medacab_mat_prima,'  
                    + ' um.sg_unidade_medida,'  
                    + ' plano_compra.nm_plano_compra, '  
                    + ' plano_compra.cd_mascara_plano_compra, '   
                    + ' tr.ic_tipo_requisicao, '   
                    + ' tr.nm_tipo_requisicao, '   
                    + ' tr.nm_cor_prioridade_bk, '   
                    + ' tr.nm_cor_prioridade_fg, '  
                    + ' usuario.nm_fantasia_usuario, '  
                    + ' cliente.nm_fantasia_cliente, '  
                    + ' case when rci.cd_produto>0 then dbo.fn_mascara_produto(pd.cd_produto) else s.cd_mascara_servico end as cd_mascara_produto, '
                    + ' pd.nm_produto as Nome_Produto, '  
                    + ' grupo_prod.cd_mascara_grupo_produto, '  
                    + ' rci.nm_medbruta_mat_prima, '  
		    + ' pdc.qt_mes_compra_produto, '
                    + ' ic_cotacao = '      
                    + ' case when exists ( select top 1 ci.cd_cotacao from cotacao_item ci with(nolock) '  
               + 'where ci.cd_requisicao_compra = rci.cd_requisicao_compra and '  
               + 'ci.cd_item_requisicao_compra = rci.cd_item_requisicao_compra ) then ''S'' else ''N'' end, '  
               + 'ic_retorno = '  
               + 'case when exists ( select top 1 ci.cd_cotacao from cotacao_item ci with(nolock) '  
               + 'where ci.cd_requisicao_compra = rci.cd_requisicao_compra and '  
			   + 'ci.cd_item_requisicao_compra = rci.cd_item_requisicao_compra and '
			   + 'Isnull(ic_retorno_item_cotacao, ''N'') = ''S'') then '   
			   + '''S'' else ''N'' end, '  
			   + 'ic_aberto = '   
               + 'case when exists ( select top 1 ci.cd_cotacao from cotacao_item ci with(nolock) '  
               + 'where ci.cd_requisicao_compra = rci.cd_requisicao_compra and '  
               + 'ci.cd_item_requisicao_compra = rci.cd_item_requisicao_compra and '
			   + 'Isnull(ic_retorno_item_cotacao, ''N'') = ''S'')  then ''N'' '  
			   + 'else ''S'' end, '   
			   + 'ic_atraso = '  
               + 'case when '  
               --Carlos Fernandes

               + '( isnull(rci.dt_item_nec_req_compra,rc.dt_necessidade_req_compra) + 1 <getdate() ) then ''S'' else ''N'' end, '  
			   + 'isnull(pdc.ic_cotacao_produto,''N'') as ic_cotacao_produto, '  
			   + 'case when '               
--antes
--                + '( rc.dt_necessidade_req_compra + 1 <getdate() ) then ''S'' else ''N'' end, '  
-- 			   + 'isnull(pdc.ic_cotacao_produto,''N'') as ic_cotacao_produto, '  
-- 			   + 'case when '  
               + 'rci.cd_produto is null then ''S'' else ''N'' end as ic_especial, '   
			   + 'case when IsNull(rc.ic_aprovada_req_compra,''N'') = ''N'' then ''S'' else '  
			   + '''N'' end as ic_nao_aprovada, '   
               + 'rci.cd_produto, '  
               + 'pd.nm_produto as Nome_Produto, '  
               + ' mp.nm_fantasia_mat_prima, '  
               + ' dbo.fn_consumo_medio ( '   
               + cast(@cd_fase_produto as varchar(40)) + ', rci.cd_produto, '   
               + QuoteName(cast(@data_inicial as varchar(40)), '''') + ','   
               + QuoteName(cast(@data_final as varchar(40)), '''') + ') as total, '  
               + '( select ps.qt_saldo_atual_produto '  
               + 'from Produto_Saldo ps with(nolock) '  
               + 'where ps.cd_produto = rci.cd_produto '  
               + 'and ps.cd_fase_produto = ' + cast(@cd_fase_produto as varchar(40)) + ' ) as Saldo_Estoque_Atual, '  
			   + 'grupo_prod.ic_especial_grupo_produto, '  
			   + 'pa.nm_pais, '+ 
                             'cen.nm_centro_custo'
  
  SET @SQLFROM = ' from #Tmp_Requisicao_compra rc '  
			   + 'inner join Requisicao_compra_Item rci with(nolock) '  
        	   + 'on rc.cd_requisicao_compra = rci.cd_requisicao_compra and '
        	   + 'rc.cd_item_requisicao_compra = rci.cd_item_requisicao_compra '   
        	   + 'left outer join departamento d with(nolock) '  
        	   + 'on rc.cd_departamento = d.cd_departamento '  
        	   + 'left outer join produto pd with(nolock) '   
        	   + 'on rci.cd_produto = pd.cd_produto '  
        	   + 'left outer join produto_compra pdc with(nolock) '  
        	   + 'on rci.cd_produto = pdc.cd_produto '  
        	   + 'left outer join grupo_produto grupo_prod with(nolock) '  
        	   + 'on pd.cd_grupo_produto = grupo_prod.cd_grupo_produto '  
        	   + 'left outer join tipo_requisicao tr with(nolock, index(pk_tipo_requisicao)) '  
        	   + 'on rc.cd_tipo_requisicao = tr.cd_tipo_requisicao '  
        	   + 'left outer join egisadmin.dbo.usuario usuario '  
			   + 'on rc.cd_usuario = usuario.cd_usuario '  
        	   + 'left outer join plano_compra '   
          	   + 'on IsNull(rci.cd_plano_compra,rc.cd_plano_compra) = plano_compra.cd_plano_compra '  
        	   + 'left outer join Pedido_venda PV with(nolock) '  
        	   + 'on rci.cd_pedido_venda = PV.cd_pedido_venda '  
        	   + 'left outer join cliente with(nolock) '  
        	   + 'on PV.cd_cliente = cliente.cd_cliente '
			   + 'left outer join Materia_Prima mp '  
			   + 'on mp.cd_mat_prima = rci.cd_mat_prima '  
        	   + 'left outer join pedido_compra_item pci with(nolock) '
			   + 'on pci.cd_pedido_compra = rc.cd_pedido_compra and '  
          	   + 'pci.cd_item_pedido_compra = rci.cd_item_pedido_compra '
        	   + 'left outer join unidade_medida um with(nolock) '   
			   + 'on um.cd_unidade_medida = rci.cd_unidade_medida '  
			   + 'left outer join pais pa '   
			   + 'on pa.cd_pais = rci.cd_pais  '  
                           + 'left outer join centro_custo cen on cen.cd_centro_custo = IsNull(rci.cd_centro_custo,rc.cd_centro_custo) '
			   + 'left outer join servico s with(nolock) ' 
			   + 'on s.cd_servico = rci.cd_servico '
--			   + 'on s.cd_servico = rci.cd_servico where '
               
    set @SQLWHERE = ''         
         
    if IsNull(@cd_req_compra,0) <> 0          
      set @SQLWHERE = 'where (rci.cd_requisicao_compra = ' + cast(@cd_req_Compra as varchar(40)) + ') and '          
          
        --Filtra o tipo da importação - Fabio Cesar - 18.07.2006        
    if (@cd_req_Compra = 0) and (@cd_tipo_mercado = 1)            
      set @SQLWHERE = @SQLWHERE + ' (rc.ic_importacao = ''N'') and '          
    if (@cd_req_Compra = 0) and (@cd_tipo_mercado > 1)            
      set @SQLWHERE = @SQLWHERE + ' (rc.ic_importacao = ''S'') and '          
        
 if (@SQLWHERE = '')        
   set @SQLWHERE = ' where '        
-- else        
--   set @SQLWHERE = ' where ' + @SQLWHERE --+ ' and '        
         
    set @SQLWHERE = @SQLWHERE + 'rc.ic_liberado_proc_compra = ' + QuoteName('S','''')  + ' ' + ' and '        
                     + 'isnull(rci.cd_pedido_compra,0) = 0 and isnull(rci.cd_pedido_importacao,0) = 0 ' +          
          
                     + ' order by tr.qt_prior_tipo_requisicao, '          
                     + ' rc.dt_necessidade_req_compra, '          
                     + ' rc.dt_emissao_req_compra desc, '          
                     + ' rc.cd_requisicao_compra desc, '          
                     + ' rci.cd_item_requisicao_compra '          
            
  print(@SQL_Temp + @SQL + @SQLFROM + @SQLWHERE)          
  exec(@SQL_Temp + @SQL + @SQLFROM + @SQLWHERE)          
    
  end 
   set nocount off
end
