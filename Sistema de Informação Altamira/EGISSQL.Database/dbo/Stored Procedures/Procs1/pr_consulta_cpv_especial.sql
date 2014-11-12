
CREATE  PROCEDURE pr_consulta_cpv_especial  

@cd_produto            int      = 0,    
@cd_grupo_produto      int      = 0,    
@cd_categoria_produto  int      = 0,     
@ic_importacao_produto char(1)  = '',    
@dt_inicial            datetime = '',    
@dt_final              datetime = '',    
@cd_moeda              int      = 0,    
@vl_dolar_medio        float    = 1,
@ic_parametro          int      = 0,
@cd_cliente            int      = 0,
@cd_vendedor           int      = 0,    
@ic_tipo_cpv_cliente   int      = 0,
@ic_custo_moeda_produto char(1) = 'S',
@cd_moeda_atualizacao  int      = 2,
@dt_base               datetime = '',
@cd_usuario            int      = 0 
   
-- modificada em 01-07 para verificar a operacao fiscal se tem valor comercial ou nao 
-- join de operacao fiscal com nota_saida e checa campo ic_comercial_valor='S' 
--

AS      

--Trata o Dolar médio

if isnull(@vl_dolar_medio,0) = 0 
begin

   set @vl_dolar_medio = 1

end 

------------------------------------------------------------------------------------------------
--Gera o Cálculo de PIS/COFINS 
------------------------------------------------------------------------------------------------
exec pr_gera_calculo_pis_cofins_item_nota @dt_inicial,@dt_final
------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------
--Gera a Atualização do Preço de Custo dos Produto em Outra Moeda - U$
------------------------------------------------------------------------------------------------
if @ic_custo_moeda_produto = 'S'
begin
  exec pr_atualiza_custo_moeda_produto 0,@dt_final,'S',0,@cd_usuario
end

------------------------------------------------------------------------------------------------
--Atualiza os itens da Nota com o Valor da Cotação
------------------------------------------------------------------------------------------------
--vl_moeda_cotacao
--select isnull(dbo.fn_vl_moeda_periodo(2,'07/01/2008'),1)   

update
  nota_saida_item
set
  vl_moeda_cotacao = isnull(dbo.fn_vl_moeda_periodo(2,ns.dt_nota_saida),1)   
from
  nota_saida_item i
  inner join nota_saida ns on ns.cd_nota_saida = i.cd_nota_saida
where
  ns.dt_nota_saida between @dt_inicial and @dt_final

------------------------------------------------------------------------------------------------
--Montagem da Tabela Temporária de Cálculo
------------------------------------------------------------------------------------------------
declare @vl_cotacao_diaria float
declare @dt_hoje           datetime

set @dt_hoje = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121)

select
  @vl_cotacao_diaria = isnull(dbo.fn_vl_moeda_periodo(@cd_moeda,@dt_hoje),1)
        
SELECT     

  p.cd_produto,
  dbo.fn_mascara_produto(p.cd_produto) as cd_mascara_produto,     
  p.nm_fantasia_produto,    
  p.nm_produto,    
  um.sg_unidade_medida,    

--    
--- coluna quantidade total periodo     
--    

  isnull((select     
                sum(    IsNull(nsi.qt_item_nota_saida,0)  )    
                from nota_saida_item nsi , nota_saida ns , 
                     operacao_fiscal ofi, grupo_operacao_fiscal gof,
                     tipo_operacao_fiscal tof, cliente c
                where 
                       nsi.cd_produto = p.cd_produto       
                   and nsi.dt_nota_saida between @dt_inicial and @dt_final     
                   and nsi.dt_cancel_item_nota_saida is null     
                   and nsi.dt_restricao_item_nota    is null     
                   and nsi.cd_nota_saida       = ns.cd_nota_saida    
                   and ns.cd_tipo_destinatario = 1   
                   and ns.cd_operacao_fiscal   = ofi.cd_operacao_fiscal  
	           and isnull(ofi.ic_comercial_operacao,'N') = 'S' 
                   and ofi.cd_grupo_operacao_fiscal = gof.cd_grupo_operacao_fiscal
                   and gof.cd_tipo_operacao_fiscal  = tof.cd_tipo_operacao_fiscal 
                   and tof.cd_tipo_operacao_fiscal  = 2
                   and ns.cd_cliente                = c.cd_cliente 
                   and isnull(c.ic_cpv_cliente,'S') = case when @cd_cliente = 0 and @ic_tipo_cpv_cliente = 1
                                                           then 'S' 
                                                           else
                                                             case when @ic_tipo_cpv_cliente=0 
                                                             then
                                                                isnull(c.ic_cpv_cliente,'S')
                                                             else
                                                                case when @ic_tipo_cpv_cliente=2 then 'N' end
                                                             end
                                                           end

                 group by nsi.cd_produto),0)     as    'qt_total_periodo' ,     

--    
--Valor do Produto Unitário cd_moeda = 1 em reais  cd_moeda <> 1 Dolar     
--    
	
case when  @cd_moeda = 1 then     
                IsNull((select     
                sum(  (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) -    
--                       IsNull(nsi.vl_ipi,0) -     
                       IsNull(nsi.vl_desp_acess_item,0) -    
                       IsNull(nsi.vl_icms_item,0) -    
                       IsNull(nsi.vl_desp_aduaneira_item,0) -    
                       IsNull(nsi.vl_ii,0) -    
                       IsNull(nsi.vl_pis,0) -    
                       IsNull(nsi.vl_cofins,0)) ) /    sum(    IsNull(nsi.qt_item_nota_saida,0)  )    
                 from nota_saida_item nsi , nota_saida ns , 
                     operacao_fiscal ofi, grupo_operacao_fiscal gof,
                     tipo_operacao_fiscal tof

                 where nsi.cd_produto = p.cd_produto     
                      and nsi.dt_nota_saida between @dt_inicial and @dt_final     
                      and nsi.dt_cancel_item_nota_saida is null     
                      and nsi.dt_restricao_item_nota    is null     
  		      and nsi.cd_nota_saida         = ns.cd_nota_saida    
                      and ns.cd_tipo_destinatario   = 1   
                      and ns.cd_operacao_fiscal     = ofi.cd_operacao_fiscal  
	              and isnull(ofi.ic_comercial_operacao,'N') = 'S' 
                      and ofi.cd_grupo_operacao_fiscal = gof.cd_grupo_operacao_fiscal
                      and gof.cd_tipo_operacao_fiscal  = tof.cd_tipo_operacao_fiscal 
                      and tof.cd_tipo_operacao_fiscal  = 2

                 group by nsi.cd_produto),0)      
            else     
   IsNull((select     
                 sum(  ((IsNull(nsi.vl_unitario_item_nota,0) / case when isnull(vl_moeda_cotacao,0)>0 then vl_moeda_cotacao else 1 end ) *     
                       IsNull(nsi.qt_item_nota_saida,0)                          -    
--                       (IsNull(nsi.vl_ipi,0)                / case when isnull(vl_moeda_cotacao,0)>0 then vl_moeda_cotacao else 1 end )               -     
                       (IsNull(nsi.vl_desp_acess_item,0)    / case when isnull(vl_moeda_cotacao,0)>0 then vl_moeda_cotacao else 1 end )  -    
                       (IsNull(nsi.vl_icms_item,0)          / case when isnull(vl_moeda_cotacao,0)>0 then vl_moeda_cotacao else 1 end )     -    
                       (IsNull(nsi.vl_desp_aduaneira_item,0)/ case when isnull(vl_moeda_cotacao,0)>0 then vl_moeda_cotacao else 1 end )  -    
                       (IsNull(nsi.vl_ii,0)                 / case when isnull(vl_moeda_cotacao,0)>0 then vl_moeda_cotacao else 1 end )    -    
                       (IsNull(nsi.vl_pis,0)                / case when isnull(vl_moeda_cotacao,0)>0 then vl_moeda_cotacao else 1 end )   -    
                       (IsNull(nsi.vl_cofins,0)             / case when isnull(vl_moeda_cotacao,0)>0 then vl_moeda_cotacao else 1 end )) ) /    sum(    IsNull(nsi.qt_item_nota_saida,0)  )    
                 from nota_saida_item nsi , nota_saida ns, 
                      operacao_fiscal ofi, grupo_operacao_fiscal gof,
                      tipo_operacao_fiscal tof, cliente c

                 where nsi.cd_produto = p.cd_produto     
                      and nsi.dt_nota_saida between @dt_inicial and @dt_final     
                      and nsi.dt_cancel_item_nota_saida is null     
                      and nsi.dt_restricao_item_nota    is null     
                      and nsi.cd_nota_saida = ns.cd_nota_saida    
                      and ns.cd_tipo_destinatario = 1   
                      and ns.cd_operacao_fiscal = ofi.cd_operacao_fiscal  
	              and isnull(ofi.ic_comercial_operacao,'N') = 'S' 
                      and ofi.cd_grupo_operacao_fiscal = gof.cd_grupo_operacao_fiscal
                      and gof.cd_tipo_operacao_fiscal  = tof.cd_tipo_operacao_fiscal 
                      and tof.cd_tipo_operacao_fiscal  = 2
                      and ns.cd_cliente                = c.cd_cliente 
                      and isnull(c.ic_cpv_cliente,'S') = case when @cd_cliente = 0 and @ic_tipo_cpv_cliente = 1
                                                           then 'S' 
                                                           else
                                                             case when @ic_tipo_cpv_cliente=0 
                                                             then
                                                                isnull(c.ic_cpv_cliente,'S')
                                                             else
                                                                case when @ic_tipo_cpv_cliente=2 then 'N' end
                                                             end
                                                           end

                 group by nsi.cd_produto),0)      
    
            end    as 'vl_produto_unit',    
--    
--Valor do Produto Total  cd_moeda = 1 em reais  cd_moeda <> 1 Dolar     
--  
  
case when  @cd_moeda = 1 then     
    IsNull((select     
                sum(  (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) -    
--                       IsNull(nsi.vl_ipi,0) -     
                       IsNull(nsi.vl_desp_acess_item,0) -    
                       IsNull(nsi.vl_icms_item,0) -    
                       IsNull(nsi.vl_desp_aduaneira_item,0) -    
                       IsNull(nsi.vl_ii,0) -    
                       IsNull(nsi.vl_pis,0) -    
                       IsNull(nsi.vl_cofins,0)) )    
                 from nota_saida_item nsi , nota_saida ns, 
                      operacao_fiscal ofi, grupo_operacao_fiscal gof,
                      tipo_operacao_fiscal tof, cliente c

                 where nsi.cd_produto = p.cd_produto     
                      and nsi.dt_nota_saida between @dt_inicial and @dt_final     
                      and nsi.dt_cancel_item_nota_saida is null     
                      and nsi.dt_restricao_item_nota    is null     
                      and nsi.cd_nota_saida = ns.cd_nota_saida    
                      and ns.cd_tipo_destinatario = 1   
                      and ns.cd_operacao_fiscal = ofi.cd_operacao_fiscal  
	              and isnull(ofi.ic_comercial_operacao,'N') = 'S' 
                      and ofi.cd_grupo_operacao_fiscal = gof.cd_grupo_operacao_fiscal
                      and gof.cd_tipo_operacao_fiscal  = tof.cd_tipo_operacao_fiscal 
                      and tof.cd_tipo_operacao_fiscal  = 2
                      and ns.cd_cliente                = c.cd_cliente 
                      and isnull(c.ic_cpv_cliente,'S') = case when @cd_cliente = 0 and @ic_tipo_cpv_cliente = 1
                                                           then 'S' 
                                                           else
                                                             case when @ic_tipo_cpv_cliente=0 
                                                             then
                                                                isnull(c.ic_cpv_cliente,'S')
                                                             else
                                                                case when @ic_tipo_cpv_cliente=2 then 'N' end
                                                             end
                                                           end

                 group by nsi.cd_produto),0)      
     else    
                IsNull((select     
                sum(  ((IsNull(nsi.vl_unitario_item_nota,0) / case when isnull(vl_moeda_cotacao,0)>0 then vl_moeda_cotacao else 1 end ) *     
                        IsNull(nsi.qt_item_nota_saida,0)                         -    
--                       (IsNull(nsi.vl_ipi,0)                / case when isnull(vl_moeda_cotacao,0)>0 then vl_moeda_cotacao else 1 end )               -     
                       (IsNull(nsi.vl_desp_acess_item,0)    / case when isnull(vl_moeda_cotacao,0)>0 then vl_moeda_cotacao else 1 end )    -    
                       (IsNull(nsi.vl_icms_item,0)          / case when isnull(vl_moeda_cotacao,0)>0 then vl_moeda_cotacao else 1 end )          -    
                       (IsNull(nsi.vl_desp_aduaneira_item,0)/ case when isnull(vl_moeda_cotacao,0)>0 then vl_moeda_cotacao else 1 end ) -    
                       (IsNull(nsi.vl_ii,0)                 / case when isnull(vl_moeda_cotacao,0)>0 then vl_moeda_cotacao else 1 end )                 -    
                       (IsNull(nsi.vl_pis,0)                / case when isnull(vl_moeda_cotacao,0)>0 then vl_moeda_cotacao else 1 end )                -    
                       (IsNull(nsi.vl_cofins,0)             / case when isnull(vl_moeda_cotacao,0)>0 then vl_moeda_cotacao else 1 end )) )    
                  from nota_saida_item nsi , nota_saida ns,  
                       operacao_fiscal ofi, grupo_operacao_fiscal gof,
                       tipo_operacao_fiscal tof, cliente c

                  where nsi.cd_produto = p.cd_produto     
                      and nsi.dt_nota_saida between @dt_inicial and @dt_final     
                      and nsi.dt_cancel_item_nota_saida is null     
                      and nsi.dt_restricao_item_nota    is null     
		      and nsi.cd_nota_saida            = ns.cd_nota_saida    
                      and ns.cd_tipo_destinatario      = 1   
                      and ns.cd_operacao_fiscal        = ofi.cd_operacao_fiscal  
	              and isnull(ofi.ic_comercial_operacao,'N') = 'S' 
                      and ofi.cd_grupo_operacao_fiscal = gof.cd_grupo_operacao_fiscal
                      and gof.cd_tipo_operacao_fiscal  = tof.cd_tipo_operacao_fiscal 
                      and tof.cd_tipo_operacao_fiscal  = 2
                      and ns.cd_cliente                = c.cd_cliente 
                      and isnull(c.ic_cpv_cliente,'S') = case when @cd_cliente = 0 and @ic_tipo_cpv_cliente = 1
                                                           then 'S' 
                                                           else
                                                             case when @ic_tipo_cpv_cliente=0 
                                                             then
                                                                isnull(c.ic_cpv_cliente,'S')
                                                             else
                                                                case when @ic_tipo_cpv_cliente=2 then 'N' end
                                                             end
                                                           end

                 group by nsi.cd_produto),0)  end      as 'vl_produto',    


  Cast(0 as Float)  as 'pc_venda_net_unit',    
  Cast(0 as Float)  as 'pc_venda_net',    

--    
--Valor do Custo Pre Unit-dado em dolar  cd_moeda = 1 em reais  cd_moeda <> 1 Dolar     
--  calcula o dolar medio e multiplica pelo valor unitario em dolar     

 --select vl_moeda_cotacao from nota_saida_item
 --select * from produto_historico

  --Moeda em R$ e moeda do Produto for diferente de R$
  case when @cd_moeda = 1 and ph.cd_moeda <> 1 then     
            Isnull((select
                          
                   (sum(isnull(case when isnull(nsi.vl_moeda_cotacao,0)>0 
                                    then isnull(dbo.fn_vl_moeda_periodo(2,ns.dt_nota_saida),nsi.vl_moeda_cotacao)
                                    else 1 end,0)) / count(*) )

                     * 

                     (case when isnull(ph.vl_historico_produto,0)>0
                     then
                       ph.vl_historico_produto
                     else
                       isnull(pc.vl_custo_previsto_produto,0)
                     end )             
                    from 
                       nota_saida_item nsi,
                       nota_saida ns,
                       operacao_fiscal ofi,
                       grupo_operacao_fiscal gof,
                       tipo_operacao_fiscal tof

--                          nota_saida_item       nsi                 with (nolock)
--                          inner join nota_saida ns                  with (nolock) on ns.cd_nota_saida = nsi.cd_nota_saida 
--                          left outer join operacao_fiscal ofi       with (nolock) on ofi.cd_operacao_fiscal = ns.cd_operacao_fiscal
--                          left outer join grupo_operacao_fiscal gof with (nolock) on gof.cd_grupo_operacao_fiscal = ofi.cd_grupo_operacao_fiscal
--                          left outer join tipo_operacao_fiscal  tof with (nolock) on tof.cd_tipo_operacao_fiscal  = gof.cd_tipo_operacao_fiscal
--                          left outer join Produto_Historico ph      with (nolock) on ph.cd_produto                  = nsi.cd_produto and
--                                                                                     ph.dt_historico_produto        = @dt_final      and
--                                                                                     isnull(ph.ic_tipo_historico_produto,'C')='C'    and
--                                                                                     isnull(ph.cd_moeda,1)         <> 1 


                    where    
                            nsi.cd_produto = p.cd_produto     
                        and nsi.dt_nota_saida between @dt_inicial and @dt_final     
                        and nsi.cd_nota_saida = ns.cd_nota_saida    
                        and ns.cd_tipo_destinatario = 1   
                        and ns.cd_operacao_fiscal = ofi.cd_operacao_fiscal  
	                and isnull(ofi.ic_comercial_operacao,'N') = 'S' 
                        and ofi.cd_grupo_operacao_fiscal = gof.cd_grupo_operacao_fiscal
                        and gof.cd_tipo_operacao_fiscal  = tof.cd_tipo_operacao_fiscal 
                        and tof.cd_tipo_operacao_fiscal  = 2
                        and nsi.dt_restricao_item_nota    is null     
                        and nsi.dt_cancel_item_nota_saida is null),0)         
       else     

--select * from produto_historico
--         IsNull(pc.vl_custo_previsto_produto,0)               

                     (case when isnull(ph.vl_historico_produto,0)>0
                     then
                       --Moeda em R$ e moeda do Produto for R$
                       case when ph.cd_moeda = 1 and @cd_moeda = 1 then
                          ph.vl_historico_produto --/ dbo.fn_vl_moeda_periodo(2,ph.dt_historico_produto)
                       else
                         --Moeda <> R$ e moeda do Produto for diferente de R$
                          case when @cd_moeda<>1 and ph.cd_moeda<>1   then
                            ph.vl_historico_produto --/ dbo.fn_vl_moeda_periodo(2,ph.dt_historico_produto)
                          else
                            ph.vl_historico_produto / dbo.fn_vl_moeda_periodo(2,ph.dt_historico_produto)
                          end
                       end
                     else
                      -- case when 
                       case when ph.cd_moeda = 1 then
                          isnull(pc.vl_custo_previsto_produto,0) / dbo.fn_vl_moeda_periodo(2,@dt_base)
                       else
                          isnull(pc.vl_custo_previsto_produto,0) --* dbo.fn_vl_moeda_periodo(2,@dt_base)
                       end
                     end ) 


       end  as 'vl_custo_previsto_produto_unit',    
--    
--Valor do Custo Pre Total - dado em dolar  cd_moeda = 1 em reais  cd_moeda <> 1 Dolar     
--  calcula o dolar medio e multiplica pelo valor unitario em dolar e pela quantidade do periodo     
--  VALOR MULTIPLICADO PELA QTDE TOTAL PERIODO DEPOIS DO SELECT     

  case when @cd_moeda = 1 and ph.cd_moeda <> 1 then     
            Isnull((select      
                   (sum(isnull(case when isnull(vl_moeda_cotacao,0)>0 
                                    then isnull(dbo.fn_vl_moeda_periodo(2,ns.dt_nota_saida),vl_moeda_cotacao)
                                    else 1 end,0))
                    / count(*)) 
                    * 
                    --IsNull(pc.vl_custo_previsto_produto,0)     
                     (case when isnull(ph.vl_historico_produto,0)>0
                     then
                       ph.vl_historico_produto
                     else
                       isnull(pc.vl_custo_previsto_produto,0)
                     end )             

                    from nota_saida_item nsi , nota_saida ns, 
                         operacao_fiscal ofi, grupo_operacao_fiscal gof,
                         tipo_operacao_fiscal tof

                    where    nsi.cd_produto = p.cd_produto     
                        and  nsi.dt_nota_saida between @dt_inicial and @dt_final   
                        and  nsi.cd_nota_saida = ns.cd_nota_saida    
                        and  ns.cd_tipo_destinatario = 1     
                        and  ns.cd_operacao_fiscal = ofi.cd_operacao_fiscal  
	                and isnull(ofi.ic_comercial_operacao,'N') = 'S' 
                        and ofi.cd_grupo_operacao_fiscal = gof.cd_grupo_operacao_fiscal
                        and gof.cd_tipo_operacao_fiscal  = tof.cd_tipo_operacao_fiscal 
                        and tof.cd_tipo_operacao_fiscal  = 2
                        and nsi.dt_restricao_item_nota    is null     
                        and nsi.dt_cancel_item_nota_saida is null),0)         
       else     
--         IsNull(pc.vl_custo_previsto_produto,0)               

                     (case when isnull(ph.vl_historico_produto,0)>0
                     then
                       --Moeda em R$ e moeda do Produto for R$
                       case when ph.cd_moeda = 1 and @cd_moeda = 1 then
                          ph.vl_historico_produto --/ dbo.fn_vl_moeda_periodo(2,ph.dt_historico_produto)
                       else
                         --Moeda <> R$ e moeda do Produto for diferente de R$
                          case when @cd_moeda<>1 and ph.cd_moeda<>1   then
                            ph.vl_historico_produto --/ dbo.fn_vl_moeda_periodo(2,ph.dt_historico_produto)
                          else
                            ph.vl_historico_produto / dbo.fn_vl_moeda_periodo(2,ph.dt_historico_produto)
                          end
                       end
                     else
                      -- case when 
                       case when ph.cd_moeda = 1 then
                          isnull(pc.vl_custo_previsto_produto,0) / dbo.fn_vl_moeda_periodo(2,@dt_base)
                       else
                          isnull(pc.vl_custo_previsto_produto,0) --* dbo.fn_vl_moeda_periodo(2,@dt_base)
                       end
                     end ) 

--                      (case when isnull(ph.vl_historico_produto,0)>0
--                      then
--                        case when ph.cd_moeda = 1 then
--                           ph.vl_historico_produto * dbo.fn_vl_moeda_periodo(2,ph.dt_historico_produto)
--                        else
--                           ph.vl_historico_produto / dbo.fn_vl_moeda_periodo(2,ph.dt_historico_produto)
--                        end
--                      else
--                       -- case when 
--                        case when ph.cd_moeda = 1 then
--                           isnull(pc.vl_custo_previsto_produto,0) * dbo.fn_vl_moeda_periodo(2,@dt_base)
--                        else
--                           isnull(pc.vl_custo_previsto_produto,0) / dbo.fn_vl_moeda_periodo(2,@dt_base)
--                        end
--                      end ) 

       end  as 'vl_custo_previsto_produto',     

--case when @cd_moeda <> 1 then 0     
--else     

 Isnull((select      
         (sum( case when isnull(vl_moeda_cotacao,0)>0 
               then dbo.fn_vl_moeda_periodo(2,ns.dt_nota_saida) 
               else isnull(vl_moeda_cotacao,0) end ) / count(*))         
         from nota_saida_item nsi , nota_saida ns , 
              operacao_fiscal ofi, grupo_operacao_fiscal gof,
              tipo_operacao_fiscal tof

         where    NSI.cd_produto = p.cd_produto     
             and  NSI.dt_nota_saida between @dt_inicial and @dt_final   
             and  nsi.cd_nota_saida = ns.cd_nota_saida    
             and  ns.cd_operacao_fiscal = ofi.cd_operacao_fiscal  
	     and isnull(ofi.ic_comercial_operacao,'N') = 'S' 
             and ofi.cd_grupo_operacao_fiscal = gof.cd_grupo_operacao_fiscal
             and gof.cd_tipo_operacao_fiscal  = tof.cd_tipo_operacao_fiscal 
             and tof.cd_tipo_operacao_fiscal  = 2
             and  ns.cd_tipo_destinatario = 1       
             and nsi.dt_restricao_item_nota    is null     
             and  NSI.dt_cancel_item_nota_saida is null),0)      
--end     

                                                      AS   'DolarMedio' ,    
  
  cast ('0.00' as float )                             as PC_FATOR  ,     

     
   Case    
     When ISNULL(p.ic_importacao_produto, 'N') = 'N'    
     --Custo da Última Entrada sem Impostos
     --
     Then 0    
     Else IsNull((Select top 1 dii.vl_item_pos1   
                  from
                    di_item dii 
                  where 
                    dii.cd_produto = p.cd_produto 
                  order by dii.cd_di desc),0)    
     End                                              as 'vl_custo_pos',    

--cast ('0.00' as float ) as  vl_custo_pos , 

--   Case    
--     When ISNULL(p.ic_importacao_produto, 'N') = 'N'    
--       Then 0    
--     Else IsNull((select top 1     
--                      Case     
--                        When IsNull(di.vl_moeda_di,0) = 0    
--                          Then 0    
--                        Else (IsNull(dii.vl_produto_moeda_destino,0) +    
--                              IsNull(dii.vl_ii_item_di,0) +    
--                              IsNull(dii.vl_ipi_item_di,0) +    
--                              IsNull(dii.vl_pis_item_di,0) +    
--                              IsNull(dii.vl_cof_item_di,0) +    
--                              IsNull(dii.vl_icms_item_di,0) +    
--                              IsNull(dii.vl_sis_item_di,0)) / IsNull(di.vl_moeda_di,1)    
--                      End     
--                  from nota_saida_item nsi    
--                       inner join nota_saida ns on ns.cd_nota_saida = nsi.cd_nota_saida    
--                       inner join operacao_fiscal opf on opf.cd_operacao_fiscal = nsi.cd_operacao_fiscal    
--                       inner join di_item dii on dii.cd_di = nsi.cd_di and     
--                                                 dii.cd_di_item = nsi.cd_di_item    
--                       inner join di on di.cd_di = dii.cd_di    
--                  where nsi.cd_produto = p.cd_produto  and    
--                        ns.dt_nota_saida between @dt_inicial and @dt_final and    
--                        IsNull(opf.ic_importacao_op_fiscal,'N') = 'S'    
--                  order by ns.cd_nota_saida desc),0)    
--   End as 'vl_custo_pos2' ,    

cast ('0.00' as float ) as vl_custo_pos2 ,  

--Custo Net do Cadastro de Custo do produto    

  pc.vl_net_outra_moeda  as 'CustoNetOutraMoeda',    

  --    

  Case     
    When ISNULL(p.ic_importacao_produto, 'N') = 'N'    
      Then IsNull((select top 1 IsNull(nei.vl_custo_net_nota_entrada,0)     
                   from nota_entrada_item nei    
                        inner join nota_entrada ne on ne.cd_nota_entrada = nei.cd_nota_entrada    
                   where nei.cd_produto = p.cd_produto and    
                         ne.dt_nota_entrada between @dt_inicial and @dt_final    
                   order by ne.cd_nota_entrada desc),0)       
        
    Else     
		IsNull((select     
                sum(  (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) -    
--                       IsNull(nsi.vl_ipi,0) -     
                       IsNull(nsi.vl_desp_acess_item,0) -    
                       IsNull(nsi.vl_icms_item,0) -    
                       IsNull(nsi.vl_desp_aduaneira_item,0) -    
                       IsNull(nsi.vl_ii,0) -    
                       IsNull(nsi.vl_pis,0) -    
                       IsNull(nsi.vl_cofins,0)) )    
                 from nota_saida_item nsi      
                 where nsi.cd_produto = p.cd_produto     
                      and nsi.dt_nota_saida between @dt_inicial and @dt_final     
                      and nsi.dt_cancel_item_nota_saida is null     
                 group by nsi.cd_produto),0)    
  End                      as 'CustoNet',
  cast('' as varchar(15) ) as Cliente,
  cast('' as varchar(15) ) as Vendedor,

 (case when isnull(ph.vl_historico_produto,0)>0
  then
    ph.vl_historico_produto
  else
    isnull(pc.vl_custo_previsto_produto,0)
  end )                    as CustoHistorico,
  case when @cd_moeda=1 then 
    0.00
  else
--    dbo.fn_vl_moeda_periodo(@cd_moeda,@dt_base) / (case when @vl_cotacao_diaria>0 then @vl_cotacao_diaria else 1 end )

 dbo.fn_vl_moeda_periodo(@cd_moeda,@dt_base) / 

 Isnull((select      
         (sum( case when isnull(vl_moeda_cotacao,0)>0 
               then dbo.fn_vl_moeda_periodo(2,ns.dt_nota_saida) 
               else isnull(vl_moeda_cotacao,0) end ) / count(*))         
         from nota_saida_item nsi , nota_saida ns , 
              operacao_fiscal ofi, grupo_operacao_fiscal gof,
              tipo_operacao_fiscal tof

         where    NSI.cd_produto = p.cd_produto     
             and  NSI.dt_nota_saida between @dt_inicial and @dt_final   
             and  nsi.cd_nota_saida = ns.cd_nota_saida    
             and  ns.cd_operacao_fiscal = ofi.cd_operacao_fiscal  
	     and isnull(ofi.ic_comercial_operacao,'N') = 'S' 
             and ofi.cd_grupo_operacao_fiscal = gof.cd_grupo_operacao_fiscal
             and gof.cd_tipo_operacao_fiscal  = tof.cd_tipo_operacao_fiscal 
             and tof.cd_tipo_operacao_fiscal  = 2
             and  ns.cd_tipo_destinatario     = 1       
             and nsi.dt_restricao_item_nota    is null     
             and  NSI.dt_cancel_item_nota_saida is null),0)      

  end                      as vl_paridade

     

Into    
 #TmpCpvEspecial    

FROM     
  Produto p                            with (nolock)     
  LEFT OUTER JOIN Unidade_Medida um    with (nolock) ON p.cd_unidade_medida          = um.cd_unidade_medida    
  LEFT OUTER JOIN Produto_Custo  pc    with (nolock) ON p.cd_produto                 = pc.cd_produto    
  LEFT OUTER JOIN produto_historico ph with (nolock) on ph.cd_produto                = p.cd_produto           and 
                                                        ph.dt_historico_produto      = @dt_base               and
                                                        ph.ic_tipo_historico_produto = 'C'

WHERE    
    isnull(p.cd_produto,0) = CASE     
                     WHEN @cd_produto = 0 THEN       
                       p.cd_produto       
                     ELSE       
                       @cd_produto       
                     END    
    
 AND isnull(p.cd_grupo_produto,0) = CASE     
                            WHEN @cd_grupo_produto = 0 THEN       
                              isnull(p.cd_grupo_produto,0)    
                            ELSE       
                              @cd_grupo_produto    
                            END    
     
 AND isnull(p.cd_categoria_produto,0) = CASE     
                            WHEN @cd_categoria_produto = 0 THEN       
                              isnull(p.cd_categoria_produto,0)       
                            ELSE       
                              @cd_categoria_produto    
                            END    
     
 AND isnull(p.cd_categoria_produto, 0) <> 6     
    
  
 AND isnull(p.cd_STATUS_produto, 0) <> 2      
    
    
 AND ISNULL(p.ic_importacao_produto, 'N') = CASE     
                                              WHEN @ic_importacao_produto = 'T' THEN       
                                                ISNULL(p.ic_importacao_produto, 'N')       
                                              WHEN @ic_importacao_produto = 'S' THEN         
                                                @ic_importacao_produto    
                                              ELSE    
                                                @ic_importacao_produto    
                                              END    
    
--(%) Pré    
--    
--    

--select @vl_dolar_medio
    
--select * from #TmpCPVEspecial

Update #TmpCpvEspecial 
set 
  vl_custo_previsto_produto_unit = vl_custo_previsto_produto_unit / 
                                   case when @cd_moeda>2 then vl_paridade else 1 end,

  vl_custo_previsto_produto = case when @cd_moeda>2 
                              then 
                                 isnull( ((qt_total_periodo * vl_custo_previsto_produto_unit) * @vl_dolar_medio),0) 
                                 / vl_paridade 
 
                              else 
                                isnull( ((qt_total_periodo * vl_custo_previsto_produto) * @vl_dolar_medio),0) 
                              end

                              --*  
                              --case when @cd_moeda>2 then vl_paridade else 1 end
    
    
----*  atribui valor ao Percentual Pré Total     
Update #TmpCpvEspecial set pc_venda_net = Case      
                                            When vl_produto = 0    
                                              Then 0.00    
                                            Else    
                                              isnull( ( (vl_custo_previsto_produto / vl_produto )),0)    
                                          End                                               
    

----*  atribui valor ao Fator Total     

Update #TmpCpvEspecial set pc_fator = Case      
                                            When vl_custo_previsto_produto= 0    
                                              Then 0    
                                            Else    
                                              isnull( ( (vl_produto / vl_custo_previsto_produto )),0)    
                                          End      
    
--Update #TmpCpvEspecial set  vl_custo_pos   = pc_fator 

--Verifica se Houve seleção de Cliente/Vendedores

if isnull(@cd_cliente,0)>0 or 
   isnull(@cd_vendedor,0)>0
begin

  select
    c.nm_fantasia_cliente                   as Cliente,
    v.nm_fantasia_vendedor                  as Vendedor,
    nsi.cd_produto,
    sum(IsNull(nsi.qt_item_nota_saida,0)  ) as qt_filtro,

    --Valores 

    case when  @cd_moeda = 1 --R$
    then     
               sum( (IsNull(nsi.vl_unitario_item_nota,0)
                    *IsNull(nsi.qt_item_nota_saida,0) -    
                     IsNull(nsi.vl_desp_acess_item,0) -    
                     IsNull(nsi.vl_icms_item,0) -    
                     IsNull(nsi.vl_desp_aduaneira_item,0) -    
                     IsNull(nsi.vl_ii,0) -    
                     IsNull(nsi.vl_pis,0) -    
                     IsNull(nsi.vl_cofins,0) ) / IsNull(nsi.qt_item_nota_saida,0)
                  )
    else     
                sum( (IsNull(nsi.vl_unitario_item_nota,0)    / case when isnull(vl_moeda_cotacao,0)>0 then vl_moeda_cotacao else 1 end )
                      *IsNull(nsi.qt_item_nota_saida,0) -                         
                       (IsNull(nsi.vl_desp_acess_item,0)     / case when isnull(vl_moeda_cotacao,0)>0 then vl_moeda_cotacao else 1 end )  -    
                       (IsNull(nsi.vl_icms_item,0)           / case when isnull(vl_moeda_cotacao,0)>0 then vl_moeda_cotacao else 1 end )  -    
                       (IsNull(nsi.vl_desp_aduaneira_item,0) / case when isnull(vl_moeda_cotacao,0)>0 then vl_moeda_cotacao else 1 end )  -    
                       (IsNull(nsi.vl_ii,0)                  / case when isnull(vl_moeda_cotacao,0)>0 then vl_moeda_cotacao else 1 end )  -    
                       (IsNull(nsi.vl_pis,0)                 / case when isnull(vl_moeda_cotacao,0)>0 then vl_moeda_cotacao else 1 end )  -    
                       (IsNull(nsi.vl_cofins,0)              / case when isnull(vl_moeda_cotacao,0)>0 then vl_moeda_cotacao else 1 end )  /  IsNull(nsi.qt_item_nota_saida,0)
                    )  
    
            end    as 'vl_filtro_produto_unit',

  
case when  @cd_moeda = 1 then     
                sum(  (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) -    
                       IsNull(nsi.vl_desp_acess_item,0) -    
                       IsNull(nsi.vl_icms_item,0) -    
                       IsNull(nsi.vl_desp_aduaneira_item,0) -    
                       IsNull(nsi.vl_ii,0) -    
                       IsNull(nsi.vl_pis,0) -    
                       IsNull(nsi.vl_cofins,0)) )    
     else    
               sum(  ((IsNull(nsi.vl_unitario_item_nota,0)   / case when isnull(vl_moeda_cotacao,0)>0 then vl_moeda_cotacao else 1 end ) *     
                        IsNull(nsi.qt_item_nota_saida,0)                         -    
                       (IsNull(nsi.vl_desp_acess_item,0)     / case when isnull(vl_moeda_cotacao,0)>0 then vl_moeda_cotacao else 1 end )    -    
                       (IsNull(nsi.vl_icms_item,0)           / case when isnull(vl_moeda_cotacao,0)>0 then vl_moeda_cotacao else 1 end )          -    
                       (IsNull(nsi.vl_desp_aduaneira_item,0) / case when isnull(vl_moeda_cotacao,0)>0 then vl_moeda_cotacao else 1 end ) -    
                       (IsNull(nsi.vl_ii,0)                  / case when isnull(vl_moeda_cotacao,0)>0 then vl_moeda_cotacao else 1 end )                 -    
                       (IsNull(nsi.vl_pis,0)                 / case when isnull(vl_moeda_cotacao,0)>0 then vl_moeda_cotacao else 1 end )                -    
                       (IsNull(nsi.vl_cofins,0)              / case when isnull(vl_moeda_cotacao,0)>0 then vl_moeda_cotacao else 1 end )) )    
    end      as 'vl_filtro_produto'

  into
    #AuxFiltro

  from 
    nota_saida_item nsi                       with (nolock)               
    inner join  produto    p                  with (nolock) on p.cd_produto                 = nsi.cd_produto
    inner join  nota_saida ns                 with (nolock) on ns.cd_nota_saida             = nsi.cd_nota_saida
    inner join  operacao_fiscal ofi           with (nolock) on ns.cd_operacao_fiscal        = ofi.cd_operacao_fiscal
    left outer join grupo_operacao_fiscal gof with (nolock) on gof.cd_grupo_operacao_fiscal = ofi.cd_grupo_operacao_fiscal
    left outer join tipo_operacao_fiscal tof  with (nolock) on tof.cd_tipo_operacao_fiscal  = gof.cd_tipo_operacao_fiscal
    left outer join cliente c                 with (nolock) on c.cd_cliente                 = ns.cd_cliente
    left outer join vendedor v                with (nolock) on v.cd_vendedor                = ns.cd_vendedor

   where
     nsi.cd_nota_saida = ns.cd_nota_saida and
     ns.cd_cliente     = case when @cd_cliente=0  then ns.cd_cliente  else @cd_cliente  end and
     ns.cd_vendedor    = case when @cd_vendedor=0 then ns.cd_vendedor else @cd_vendedor end and
     nsi.dt_nota_saida between @dt_inicial and @dt_final     
     and ns.cd_tipo_destinatario               = 1   
     and isnull(ofi.ic_comercial_operacao,'N') = 'S' 
     and nsi.dt_restricao_item_nota    is null     
     and nsi.dt_cancel_item_nota_saida is null
     and tof.cd_tipo_operacao_fiscal           = 2

   group by
     c.nm_fantasia_cliente,
     v.nm_fantasia_vendedor,
     nsi.cd_produto


--    Update #TmpCpvEspecial 
--    set 
--       vl_custo_previsto_produto = isnull( (b.qt_filtro * vl_custo_previsto_produto_unit) * @vl_dolar_medio ,0)
--    from
--      #TmpCpvEspecial a
--    inner join #Auxfiltro b on a.cd_produto = b.cd_produto 
-- 
--    --select * from #TmpCpvEspecial a
-- 
--    Update #TmpCpvEspecial 
--    set 
-- 
--       pc_venda_net = Case      
--                                             When vl_produto = 0    
--                                               Then 0.00    
--                                             Else    
--                                               isnull( ( (vl_custo_previsto_produto_unit / vl_produto_unit )),0)    
--                                           End,                                               
--     
--       pc_fator     = Case      
--                                             When vl_custo_previsto_produto= 0    
--                                               Then 0    
--                                             Else    
--                                               isnull( ( (vl_produto_unit / vl_custo_previsto_produto_unit )),0)    
--                                           End      
--    from
--      #TmpCpvEspecial a
--    inner join #Auxfiltro b on a.cd_produto = b.cd_produto 
    

   --select * from #TmpCpvEspecial order by nm_fantasia_produto
   --select * from #AuxFiltro

   --Mostra a Tabela por Cliente

    if @cd_cliente>0 and @cd_vendedor = 0
    begin
      Select 
        b.Cliente,
        '' as vendedor,
        a.cd_produto,
        a.cd_mascara_produto,
        a.nm_fantasia_produto,
        a.nm_produto,
        a.sg_unidade_medida,
        b.qt_filtro                     as qt_total_periodo,
        b.vl_filtro_produto/b.qt_filtro as vl_produto_unit,
        b.vl_filtro_produto             as vl_produto,
        a.pc_venda_net_unit,
        pc_venda_net = a.vl_custo_previsto_produto_unit/(b.vl_filtro_produto/b.qt_filtro),
        --a.pc_venda_net,
        a.vl_custo_previsto_produto_unit,
        b.qt_filtro * a.vl_custo_previsto_produto_unit as vl_custo_previsto_produto,
        a.DolarMedio,
        pc_fator = (b.vl_filtro_produto/b.qt_filtro)/a.vl_custo_previsto_produto_unit,
        a.vl_custo_pos,
        a.vl_custo_pos2,
        a.CustoNetOutraMoeda,
        a.CustoNet
      from 
        #Auxfiltro b 
        inner join #TmpCpvEspecial a on a.cd_produto = b.cd_produto 
      where
        isnull(a.qt_total_periodo,0) > 0 and
        a.nm_fantasia_produto is not null
      order by 
        b.cliente,
        a.nm_fantasia_produto    
    end

   --Mostra a Tabela por Vendedor

    if @cd_vendedor>0 and @cd_cliente = 0
    begin
      Select 
        ''                                as Cliente,
        b.Vendedor,
        a.cd_produto,
        a.cd_mascara_produto,
        a.nm_fantasia_produto,
        a.nm_produto,
        a.sg_unidade_medida,
        b.qt_filtro                       as qt_total_periodo,
        b.vl_filtro_produto/b.qt_filtro   as vl_produto_unit,
        b.vl_filtro_produto               as vl_produto,
        a.pc_venda_net_unit,
        pc_venda_net = a.vl_custo_previsto_produto_unit/(b.vl_filtro_produto/b.qt_filtro),
        a.vl_custo_previsto_produto_unit,
        b.qt_filtro * a.vl_custo_previsto_produto_unit as vl_custo_previsto_produto,
        a.DolarMedio,
        pc_fator = (b.vl_filtro_produto/b.qt_filtro)/a.vl_custo_previsto_produto_unit,
        a.vl_custo_pos,
        a.vl_custo_pos2,
        a.CustoNetOutraMoeda,
        a.CustoNet
      from 
        #Auxfiltro b 
        inner join #TmpCpvEspecial a on a.cd_produto = b.cd_produto 
      where
        isnull(a.qt_total_periodo,0) > 0 and
        a.nm_fantasia_produto is not null
      order by 
        b.Vendedor,
        a.nm_fantasia_produto    
    end

    if @cd_vendedor>0 and @cd_cliente > 0
    begin
      Select 
        b.Vendedor,
        b.Cliente,
        a.cd_produto,
        a.cd_mascara_produto,
        a.nm_fantasia_produto,
        a.nm_produto,
        a.sg_unidade_medida,
        b.qt_filtro                     as qt_total_periodo,
        b.vl_filtro_produto/b.qt_filtro as vl_produto_unit, 
        a.vl_produto,
        a.pc_venda_net_unit,
        pc_venda_net = a.vl_custo_previsto_produto_unit/(b.vl_filtro_produto/b.qt_filtro),
        a.vl_custo_previsto_produto_unit,
        b.qt_filtro * a.vl_custo_previsto_produto_unit as vl_custo_previsto_produto,
        a.DolarMedio,
        pc_fator = (b.vl_filtro_produto/b.qt_filtro)/a.vl_custo_previsto_produto_unit,
        a.vl_custo_pos,
        a.vl_custo_pos2,
        a.CustoNetOutraMoeda,
        a.CustoNet
      from 
        #Auxfiltro b 
        inner join #TmpCpvEspecial a on a.cd_produto = b.cd_produto 
      where
        isnull(a.qt_total_periodo,0) > 0 and
        a.nm_fantasia_produto is not null
      order by 
        b.Vendedor,
        b.Cliente,
        a.nm_fantasia_produto    
    end

end

else
  begin

    --Mostra a Tabela sem Filtro

    Select 
      * 
    from 
      #TmpCpvEspecial
    where
      isnull(qt_total_periodo,0) > 0 and
      nm_fantasia_produto is not null

   order by nm_fantasia_produto    

  end


