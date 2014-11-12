
CREATE PROCEDURE pr_calculo_custo_processo_padrao

-----------------------------------------------------------------------
-- PROCEDURE pr_calculo_custo_processo_padrao
-----------------------------------------------------------------------
--pr_calculo_custo_processo_padrao
----------------------------------------------------------------------- 
--GBS - Global Business Solution Ltda                              2004
-----------------------------------------------------------------------
--Stored Procedure    : Microsoft SQL Server 2000 
--Autor(es)           : Daniel Duela
--Banco de Dados      : EGISSQL 
--Objetivo            : Rotinas para Calculo dos Custos dos Componentes no Processo Padrão
--Data                : 11/02/2003
--Atualização         : 04/03/2004 - Acerto no cálculo de Percentual - DANIEL DUELA/JOHNNY
--                    : 28/07/2004 - Acerto do ic_parametro para 2 na segunda parte, que 
--                                   estava indicando 1 e processando as duas
--                                   partes indevidamente. - ELIAS
--                    : 17/09/2004 - Criação de procedimento para atualizar a fórmula que esta
--                                   contida em outra fórmula. Igor 17.09.2004
--                    : 04/01/2005 - Acerto do Cabeçalho - Sérgio Cardoso
--                    : 16.02.2005 - Cálculo do Custo das Operações do processo - Carlos Fernandes
--                    : 19.02.2005 - Acrescentado o Cálculo do Serviço Especial
--                    : 15.10.2005 - Atualização da Data/Hora/Usuário que fez o Cálculo Custo - Carlos
--                    : 09.01.2006 - Cálculo por Tipo de Preço de Custo - Carlos Fernandes
--                                   Reposição/Mercado/Contábil
--                    : 20.01.2006 - Embalagem - Carlos Fernnades
--                      24/10/2006 - Incluído IsNull no cálculo de total do custo - Daniel C. neto.
--                      25/10/2006 - Incluido mais Isnull - Daniel C. Neto.
--                      10.06.2007 - Cálculo do Custo do Serviço - Carlos Fernandes
-- 16.01.2008 - Acerto da Cálculo de Custo do Processo Padrão - Carlos Fernandes
--              1) Custo do Serviço por Peça
--              2) Custo do Setup / pelo Lote Econômico ou quantidade do Processo Padrão
--              3) Custo do Composição checar se existe composição do Produto
-- 02.05.2009 - Cálculo Unitário da Matéria-Prima        - Carlos Fernandes                      
-- 25.05.2009 - Finalização do Cálculo do Custo          - Carlos Fernandes
-- 19.07.2010 - Verificação do Cálculo do Custo/Impostos - Carlos Fernandes
--------------------------------------------------------------------------------------------------------- 
@ic_parametro        int,  
@cd_processo_padrao  int,
@cd_usuario          int = 0
as 

begin

	declare @cd_produto_proc_padrao     integer,
                @cd_composicao_proc_padrao  integer,
	        @cd_tipo_embalagem          integer,
	        @vl_custo_produto           float,
                @vl_custo_servico           float,
                @vl_custo_operacao          float,
                @vl_custo_maquina           float,
                @vl_mao_obra                float,
	        @vl_custo_embalagem         float,
	        @vl_custo_produto_processo  float,
	        @vl_total_custo_componentes float,
                @vl_total_custo_operacao    float,
                @vl_total_custo_servico     float,
	        @ic_perc_empresa            char(1),
                @vl_total_custo_processo    float,
                @ic_tipo_preco_custo        char(1),
                @qt_hora_setup              float,
                @qt_hora_operacao           float

declare @ic_custo_composicao  char(1)
declare @ic_custo_mp_unitario char(1)
 
--Busca o Tipo de Preço de Custo
--Verifica o tipo de preço de custo
--Reposição/Mercado/Custo Contábil

select
   @ic_tipo_preco_custo  = isnull(ic_tipo_preco_custo,'R'),
   @ic_custo_composicao  = isnull(ic_custo_composicao,'N'),
   @ic_perc_empresa      = isnull(ic_qtd_proc_padrao_pc,'N'),
   @ic_custo_mp_unitario = isnull(ic_custo_mp_unitario,'N')
from
   parametro_manufatura with (nolock) 
where
   cd_empresa = dbo.fn_empresa()


        set @vl_total_custo_componentes = 0
        set @vl_total_custo_operacao    = 0
        set @vl_total_custo_processo    = 0
        set @vl_total_custo_servico     = 0

       	
	-------------------------------------------------------------------------------
	if @ic_parametro = 1 -- Calculo dos Custos dos Componentes no Processo Padrão
	-------------------------------------------------------------------------------
	begin

	  select 
	    ppp.cd_processo_padrao,
	    ppp.cd_produto_proc_padrao, 
	    ppp.cd_produto,

            case when @ic_tipo_preco_custo = 'M' then
              pu.vl_custo_previsto_produto*isnull(pc.qt_fatcompra_produto,1) 
            else
              case when @ic_tipo_preco_custo = 'C' then
                pu.vl_custo_contabil_produto*isnull(pc.qt_fatcompra_produto,1) 
              else
               pu.vl_custo_produto*isnull(pc.qt_fatcompra_produto,1) 
              end
            end                               as 'vl_custo_produto',

            --             

            isnull(qt_produto_processo,0)     as qt_produto_processo,
            isnull(pc.qt_fatcompra_produto,1) as qt_fatcompra_produto,

            --Anterior
--             case when @ic_perc_empresa <> 'S' then  
--               qt_produto_processo* (pu.vl_custo_produto * isnull(pc.qt_fatcompra_produto,1))   
--             else   
--              (qt_produto_processo * (pu.vl_custo_produto * isnull(pc.qt_fatcompra_produto,1)))/100 end as 'vl_custo_produto_processo'  


            case when isnull(pp.qt_processo_padrao,0)=0 OR @ic_custo_mp_unitario = 'S'
            then
              1
            else
              isnull(pp.qt_processo_padrao,1)
            end 

            *

  	    case when @ic_perc_empresa <> 'S' and @ic_tipo_preco_custo = 'M' 
                 then
                  qt_produto_processo*( pu.vl_custo_previsto_produto*isnull(pc.qt_fatcompra_produto,1) )
                 else             
                   case when @ic_perc_empresa <> 'S' and @ic_tipo_preco_custo = 'C'
                     then
                       qt_produto_processo * ( pu.vl_custo_contabil_produto*isnull(pc.qt_fatcompra_produto,1) )
                     else
                      case when @ic_perc_empresa <> 'S' 
                        then
                          qt_produto_processo * (pu.vl_custo_produto * isnull(pc.qt_fatcompra_produto,1))   
                        else 
                         case when @ic_tipo_preco_custo = 'M' then
                           (qt_produto_processo * (pu.vl_custo_previsto_produto * isnull(pc.qt_fatcompra_produto,1)))/100 
                         else
                           case when @ic_tipo_preco_custo = 'C' then
                             (qt_produto_processo * (pu.vl_custo_contabil_produto * isnull(pc.qt_fatcompra_produto,1)))/100 
                           else
                             (qt_produto_processo * (pu.vl_custo_produto * isnull(pc.qt_fatcompra_produto,1)))/100 
                           end
                         end
                     end
                   end
             end    

--              * 
-- 
--              case when  isnull(p.vl_fator_conversao_produt,0)>0 then
--                 isnull(p.vl_fator_conversao_produt,0)
--              else
--                 1
--              end                                         

             as 'vl_custo_produto_processo'

	  into 
             #Temp

	  from 
	    processo_padrao_produto  ppp       with (nolock) 
            inner join      processo_padrao pp with (nolock) on pp.cd_processo_padrao = ppp.cd_processo_padrao
            left outer join Produto_Custo pu   with (nolock) on ppp.cd_produto        = pu.cd_produto
            left outer join Produto_Compra pc  with (nolock) on ppp.cd_produto        = pc.cd_produto
            left outer join produto p          with (nolock) on p.cd_produto          = ppp.cd_produto

	  where 
	    ppp.cd_processo_padrao = @cd_processo_padrao

--select * from processo_padrao

--Verifica se será utilizada a composição do Produto


if @ic_custo_composicao = 'S'
begin

--select * from produto_composicao

	  select 
	    @cd_processo_padrao                  as cd_processo_padrao,
	    ppp.cd_item_produto                  as cd_produto_proc_padrao, 
	    ppp.cd_produto,

            case when @ic_tipo_preco_custo = 'M' then
              pu.vl_custo_previsto_produto*isnull(pc.qt_fatcompra_produto,1) 
            else
              case when @ic_tipo_preco_custo = 'C' then
                pu.vl_custo_contabil_produto*isnull(pc.qt_fatcompra_produto,1) 
              else
               pu.vl_custo_produto*isnull(pc.qt_fatcompra_produto,1) 
              end
            end                               as 'vl_custo_produto',

            --             

            isnull(qt_produto_composicao,0)   as qt_produto_processo,
            isnull(pc.qt_fatcompra_produto,1) as qt_fatcompra_produto,

            --Anterior

--             case when @ic_perc_empresa <> 'S' then  
--               qt_produto_processo* (pu.vl_custo_produto * isnull(pc.qt_fatcompra_produto,1))   
--             else   
--              (qt_produto_processo * (pu.vl_custo_produto * isnull(pc.qt_fatcompra_produto,1)))/100 end as 'vl_custo_produto_processo'  



            --Carlos 10.01.2005  
            

            case when isnull(p.qt_processo_padrao,0)=0 OR @ic_custo_mp_unitario = 'S'
            then
              1
            else
              isnull(p.qt_processo_padrao,1)
            end 

            *

  	    case when @ic_perc_empresa <> 'S' and @ic_tipo_preco_custo = 'M' 
                 then
                  qt_produto_composicao*( pu.vl_custo_previsto_produto*isnull(pc.qt_fatcompra_produto,1) )
                 else             
                   case when @ic_perc_empresa <> 'S' and @ic_tipo_preco_custo = 'C'
                     then
                       qt_produto_composicao * ( pu.vl_custo_contabil_produto*isnull(pc.qt_fatcompra_produto,1) )
                     else
                      case when @ic_perc_empresa <> 'S' 
                        then
                          qt_produto_composicao * (pu.vl_custo_produto * isnull(pc.qt_fatcompra_produto,1))   
                        else 
                         case when @ic_tipo_preco_custo = 'M' then
                           (qt_produto_composicao * (pu.vl_custo_previsto_produto * isnull(pc.qt_fatcompra_produto,1)))/100 
                         else
                           case when @ic_tipo_preco_custo = 'C' then
                             (qt_produto_composicao * (pu.vl_custo_contabil_produto * isnull(pc.qt_fatcompra_produto,1)))/100 
                           else
                             (qt_produto_composicao * (pu.vl_custo_produto * isnull(pc.qt_fatcompra_produto,1)))/100 
                           end
                         end
                     end
                   end
             end as 'vl_custo_produto_processo'

	  into #TempComposicao
	  from 
            produto_producao pp                with (nolock)
	    inner join produto_composicao  ppp with (nolock) on ppp.cd_produto_pai   = pp.cd_produto 
            left outer join Produto_Custo  pu  with (nolock) on ppp.cd_produto       = pu.cd_produto
            left outer join Produto_Compra pc  with (nolock) on ppp.cd_produto       = pc.cd_produto
            inner join processo_padrao p       with (nolock) on p.cd_processo_padrao = pp.cd_processo_padrao
	  where 
	    pp.cd_processo_padrao = @cd_processo_padrao

--select * from produto_producao

     insert into #Temp
      select * from #TempComposicao   


end


--	  select * from #Temp

-------------------------------------------------------------------------------------------
--Cálculo do Custo do Processo - Operações / Máquina
--16.02.2005
--Carlos Fernandes
-------------------------------------------------------------------------------------------
           
          --select * from processo_padrao_composicao
          --select * from mao_obra
          --select * from servico_especial

          select 
            ppc.cd_processo_padrao,
            ppc.cd_composicao_proc_padrao,
            ppc.cd_operacao,
            isnull(o.qt_fator_conversao_operacao,0)  as qt_fator_operacao,
            isnull(o.ic_sinal_conversao_operacao,'') as ic_sinal_operacao,
            isnull(se.qt_fator_conversao_servico,0)  as qt_fator_servico,
            isnull(se.ic_sinal_conversao_servico,'') as ic_sinal_servico,

            isnull(ppc.qt_hora_setup,0)     as qt_hora_setup,
            isnull(ppc.qt_hora_operacao,0)  as qt_hora_operacao,

            ppc.cd_maquina,

            dbo.fn_calculo_conversao(isnull(o.vl_custo_operacao,0),
                                     isnull(o.qt_fator_conversao_operacao,0),
                                     isnull(o.ic_sinal_conversao_operacao,''))  as vl_custo_operacao,

            dbo.fn_calculo_conversao(isnull(m.vl_custo_maquina,0),

                                     isnull(o.qt_fator_conversao_operacao,0),
                                     isnull(o.ic_sinal_conversao_operacao,''))  as vl_custo_maquina,

            dbo.fn_calculo_conversao(isnull(se.vl_servico_especial,0),
                                     isnull(se.qt_fator_conversao_servico,0), 
                                     isnull(se.ic_sinal_conversao_servico,''))  as vl_servico_especial,

            dbo.fn_calculo_conversao(isnull(mo.vl_mao_obra,0),
                                     isnull(o.qt_fator_conversao_operacao,0),
                                     isnull(o.ic_sinal_conversao_operacao,''))  as vl_mao_obra,
           
            --Tempo Total da Operação ou Serviço

            ( isnull(ppc.qt_hora_setup,0) +  isnull(ppc.qt_hora_operacao,0) )   as TotalOperacao,

            --Custo Total da Operação 

            CustoTotalOperacao = ( ( ( isnull(ppc.qt_hora_setup,0)/
                                     case when isnull(pp.qt_processo_padrao,0)>0 
                                     then
                                       isnull(pp.qt_processo_padrao,0)
                                     else
                                       1
                                     end )

                                     + 

                                     isnull(ppc.qt_hora_operacao,0) ) * 
                                     dbo.fn_calculo_conversao(isnull(o.vl_custo_operacao,0),
                                                              isnull(o.qt_fator_conversao_operacao,0),
                                                              isnull(o.ic_sinal_conversao_operacao,''))) +

                                 ( ( ( isnull(ppc.qt_hora_setup,0)/
                                     case when isnull(pp.qt_processo_padrao,0)>0 
                                     then
                                       isnull(pp.qt_processo_padrao,0)
                                     else
                                       1
                                     end ) + 
                                     isnull(ppc.qt_hora_operacao,0) ) * 
                                     dbo.fn_calculo_conversao(isnull(m.vl_custo_maquina,0),
                                                              isnull(o.qt_fator_conversao_operacao,0),
                                                              isnull(o.ic_sinal_conversao_operacao,''))) +

                                     
                                 ( ( ( isnull(ppc.qt_hora_setup,0)/
                                     case when isnull(pp.qt_processo_padrao,0)>0 
                                     then
                                       isnull(pp.qt_processo_padrao,0)
                                     else
                                       1
                                     end ) 
                                     + 
                                     isnull(ppc.qt_hora_operacao,0) ) * 
                                     dbo.fn_calculo_conversao(isnull(se.vl_servico_especial,0),
                                                             isnull(se.qt_fator_conversao_servico,0), 
                                                             isnull(se.ic_sinal_conversao_servico,'')))+
 
                                 ( ( ( isnull(ppc.qt_hora_setup,0)/
                                     case when isnull(pp.qt_processo_padrao,0)>0 
                                     then
                                       isnull(pp.qt_processo_padrao,0)
                                     else
                                       1
                                     end ) + 
                                     isnull(ppc.qt_hora_operacao,0) ) * 
                                     dbo.fn_calculo_conversao(isnull(mo.vl_mao_obra,0),
                                                              isnull(o.qt_fator_conversao_operacao,0),
                                                              isnull(o.ic_sinal_conversao_operacao,''))),

                                     

            ppc.cd_servico_especial,
            se.ic_tipo_custo_servico,
            se.vl_minimo_servico,

            --Custo Total do Serviço
            --select * from servico_especial

            CustoTotalServico  = --Verifica se existe serviço

                                 case when isnull(ppc.cd_servico_especial,0)=0 
                                 then 0.00 
                                 else     
                                  ( ( 


--Quantidade Padrão do Processo
--                                     case when isnull(se.ic_tipo_custo_servico,'T')='T'
--                                      then
--                                        1
--                                      else 
--                                        isnull(pp.qt_processo_padrao,1)
--                                      end
--
--                                     * 
--select * from servico_especial
                                     --Custo do Servico para o Produto

                                     case when isnull(se.vl_minimo_servico,0)>0 and isnull(se.ic_tipo_custo_servico,'T')<>'K' 
                                     then
                                       case when (se.vl_minimo_servico/se.vl_servico_especial) <= pp.qt_processo_padrao
                                       then

                                        dbo.fn_calculo_conversao(isnull(se.vl_servico_especial,0),
                                                                 isnull(se.qt_fator_conversao_servico,0), 
                                                                 isnull(se.ic_sinal_conversao_servico,''))

                                       else
                                        (se.vl_minimo_servico
                                        /
                                        case when isnull(pp.qt_processo_padrao,0)>0 
                                        then
                                          pp.qt_processo_padrao
                                        else
                                          1
                                        end)
                                       end 
  
                                     else
                                       case when isnull(se.vl_minimo_servico,0)>0 and isnull(se.ic_tipo_custo_servico,'T')='K'   
                                       then               
--                                             (se.vl_minimo_servico /  
--                                             case when isnull(pp.qt_processo_padrao,0)>0   
--                                             then  
--                                               pp.qt_processo_padrao  
--                                             else  
--                                               1  
--                                             end)  
  
  
                                          case when (se.vl_minimo_servico/se.vl_servico_especial) <= pp.qt_processo_padrao  
                                          then  
                                              se.vl_servico_especial * isnull(p.qt_peso_bruto,0)
                                          else  
                                            (se.vl_minimo_servico /  
                                            case when isnull(pp.qt_processo_padrao,0)>0   
                                            then  
                                              pp.qt_processo_padrao  
                                            else  
                                              1  
                                            end)  
  
                                          end  
  
                                       else  
                                         isnull(pse.vl_custo_produto_servico,1)  
                                       end  
                                     end  

                                     *

                                    --Tempo
                                    ( case when isnull(se.ic_tipo_custo_servico,'T')='T' 
                                      then isnull(ppc.qt_hora_setup,0)
                                           /
                                           case when isnull(pp.qt_processo_padrao,0)>0 
                                           then
                                             isnull(pp.qt_processo_padrao,0)
                                           else
                                             1
                                           end
                                      else 
                                        --Peso da Produto/Preça
                                        case when isnull(se.ic_tipo_custo_servico,'T')='K' 
                                        then
                                          case when isnull(p.qt_peso_bruto,0)>0 
                                          then 1 --isnull(p.qt_peso_bruto,0) 
                                          else 1 end
                                        else
                                          1
                                        end
                                      end )
                                    
                                     + 

                                     --Tempo

                                     case when isnull(se.ic_tipo_custo_servico,'T')='T'
                                     then
                                       isnull(ppc.qt_hora_operacao,0)
                                     else
                                       0
                                     end
 
                                     ) 
                                       
                                     * 

                                     case when 
                                     dbo.fn_calculo_conversao(isnull(se.vl_servico_especial,0),
                                                             isnull(se.qt_fator_conversao_servico,0), 
                                                             isnull(se.ic_sinal_conversao_servico,''))>0 and
                                     isnull(se.vl_minimo_servico,0)=0
                                     then
                                       dbo.fn_calculo_conversao(isnull(se.vl_servico_especial,0),
                                                             isnull(se.qt_fator_conversao_servico,0), 
                                                             isnull(se.ic_sinal_conversao_servico,'')) 

                                     else
                                       1
                                     end    )

                               end,


                               isnull(pse.vl_custo_produto_servico,0) as vl_custo_produto_servico


--                                      dbo.fn_calculo_conversao(isnull(se.vl_servico_especial,0),
--                                                              isnull(se.qt_fator_conversao_servico,0), 
--                                                              isnull(se.ic_sinal_conversao_servico,'')) AS FATOR_CONV
 

          into
            #AuxCalculo

          from 
            processo_padrao_composicao ppc               with (nolock) 
            inner join processo_padrao pp                with (nolock) on pp.cd_processo_padrao   = ppc.cd_processo_padrao
            left outer join Operacao o                   with (nolock) on o.cd_operacao           = ppc.cd_operacao
            left outer join Maquina  m                   with (nolock) on m.cd_maquina            = ppc.cd_maquina
            left outer join Servico_Especial se          with (nolock) on se.cd_servico_especial  = ppc.cd_servico_especial
            left outer join Mao_Obra mo                  with (nolock) on mo.cd_mao_obra          = o.cd_mao_obra
            inner join produto_producao ppo              with (nolock) on ppo.cd_processo_padrao  = pp.cd_processo_padrao
            left outer join produto_servico_especial pse with (nolock) on pse.cd_produto          = ppo.cd_produto and
                                                                          pse.cd_servico_especial = ppc.cd_servico_especial
            left outer join produto p                    with (nolock) on p.cd_produto            = ppo.cd_produto 
	  where 
	    ppc.cd_processo_padrao = @cd_processo_padrao
 

--          select * from #AuxCalculo

          select
            @vl_total_custo_operacao = sum( isnull( CustoTotalOperacao,0 ) ),
            @vl_total_custo_servico  = sum( isnull( CustoTotalServico,0  ) )
	  from
            #AuxCalculo

-----------------------------------------------------------------------------------------------------------
--Mostra a Tabela Auxiliar
-----------------------------------------------------------------------------------------------------------

-- 	  select * 
-- 	  from
--            #AuxCalculo


      	  ---------------------------------------------------------------------------------
	  --Atualização da Somatória dos Custos de Componentes no Processo Padrão
	  ---------------------------------------------------------------------------------
	  select 
	    @vl_total_custo_componentes = sum( isnull(vl_custo_produto_processo,0) )
	  from #Temp    

          --Custo Total do Processo
          set @vl_total_custo_processo = IsNull(@vl_total_custo_componentes,0) + 
                                         IsNull(@vl_total_custo_operacao,0)    + 
                                         isnull(@vl_total_custo_servico,0)

          --Atualização do custo do processo Padrão

	  update Processo_Padrao
	  set
	    vl_custo_componente       = @vl_total_custo_componentes,
            vl_custo_operacao         = @vl_total_custo_operacao + isnull(@vl_total_custo_servico,0),
            vl_custo_servico          = @vl_total_custo_servico,
            vl_total_custo_processo   = IsNull(@vl_total_custo_componentes,0) + 
                                        IsNull(@vl_total_custo_operacao,0)    +
                                        isnull(@vl_total_custo_servico,0),
            dt_custo_processo         = getdate(),
            cd_usuario_custo_processo = @cd_usuario                        
	  where
	    cd_processo_padrao = @cd_processo_padrao

	  ------------------------------------------------
	  --Atualização dos Custos das Operações/Serviços
	  ------------------------------------------------

          while exists( select top 1 cd_processo_padrao from #AuxCalculo )
          begin
            select top 1
              @cd_composicao_proc_padrao = cd_composicao_proc_padrao,              
              @qt_hora_setup             = qt_hora_setup,
              @qt_hora_operacao          = qt_hora_operacao,
              @vl_custo_operacao         = vl_custo_operacao,
              @vl_custo_maquina          = vl_custo_maquina,
              @vl_custo_servico          = vl_servico_especial,
              @vl_mao_obra               = vl_mao_obra
            from
              #AuxCalculo

             update
               processo_padrao_composicao
             set
               vl_custo_operacao = @vl_custo_operacao,
               vl_custo_maquina  = @vl_custo_maquina,
               vl_custo_servico  = @vl_custo_servico,
               vl_custo_total    = 
                                 ( ( isnull(@qt_hora_setup,0) + isnull(@qt_hora_operacao,0) ) * isnull(@vl_custo_operacao,0)    ) +
                                 ( ( isnull(@qt_hora_setup,0) + isnull(@qt_hora_operacao,0) ) * isnull(@vl_custo_maquina,0)     ) +
                                 ( ( isnull(@qt_hora_setup,0) + isnull(@qt_hora_operacao,0) ) * isnull(@vl_custo_servico,0) ) +
                                 ( ( isnull(@qt_hora_setup,0) + isnull(@qt_hora_operacao,0) ) * isnull(@vl_mao_obra,0)         ),
               vl_custo_total_maquina  = ( ( isnull(@qt_hora_setup,0) + isnull(@qt_hora_operacao,0) ) * isnull(@vl_custo_maquina,0)), 
               vl_custo_total_operacao = ( ( isnull(@qt_hora_setup,0) + isnull(@qt_hora_operacao,0) ) * isnull(@vl_custo_operacao,0)), 
               vl_custo_total_servico  = ( ( isnull(@qt_hora_setup,0) + isnull(@qt_hora_operacao,0) ) * isnull(@vl_custo_servico,0) ) 


             where
               cd_processo_padrao        = @cd_processo_padrao and
               cd_composicao_proc_padrao = @cd_composicao_proc_padrao

             delete from #AuxCalculo
             where   
               cd_processo_padrao        = @cd_processo_padrao and
               cd_composicao_proc_padrao = @cd_composicao_proc_padrao

           
          end            
	
	  -----------------------------------------
	  --Atualização dos Custos dos Componentes
	  -----------------------------------------

	  while exists(select top 1 'x' from #Temp)
	  begin
	    select top 1
	      @cd_produto_proc_padrao    = cd_produto_proc_padrao,
	      @vl_custo_produto          = vl_custo_produto,
	      @vl_custo_produto_processo = vl_custo_produto_processo
	    from #Temp
	
	    update Processo_Padrao_Produto 
	    set   
	      vl_custo_produto          = @vl_custo_produto,
	      vl_custo_produto_processo = @vl_custo_produto_processo
	    where
	      cd_processo_padrao = @cd_processo_padrao and
	      cd_produto_proc_padrao = @cd_produto_proc_padrao
	
	    delete from #Temp
	    where
	      cd_processo_padrao     = @cd_processo_padrao and
	      cd_produto_proc_padrao = @cd_produto_proc_padrao
	  end




	  --Atualizar o valor do custo vinculado ao processo padrao
          --
          --Todos os produtos que possuem o Processo Padrão para Produção
          --
          --
          
          --select * from produto_custo

          if @ic_tipo_preco_custo = 'R' 
          begin    
		update produto_custo
		set vl_custo_produto          = IsNull(@vl_total_custo_processo,0),
                    vl_custo_producao_produto = IsNull(@vl_total_custo_processo,0)
		from
		  processo_padrao  pp left outer join
		  produto_producao pp1    on (pp.cd_processo_padrao = pp1.cd_processo_padrao) inner join
		  Produto_custo    pc     on pp1.cd_produto = pc.cd_produto
		where 
                  pp.cd_processo_padrao = @cd_processo_padrao
	  end

          if @ic_tipo_preco_custo = 'M' 
          begin    
		update produto_custo
		set vl_custo_previsto_produto = IsNull(@vl_total_custo_processo,0),
                    vl_custo_producao_produto = IsNull(@vl_total_custo_processo,0)

		from
		  processo_padrao  pp left outer join
		  produto_producao pp1    on (pp.cd_processo_padrao = pp1.cd_processo_padrao) inner join
		  Produto_custo    pc     on pp1.cd_produto = pc.cd_produto
		where 
                  pp.cd_processo_padrao = @cd_processo_padrao
	  end

	  --Atualizar o valor dos produtos vinculados nas formulas que contem o mesmo
     
	  Update processo_padrao_produto
	  set vl_custo_produto = @vl_total_custo_componentes,--     3.4056000000000002
	      vl_custo_produto_processo = case when @ic_perc_empresa <> 'S'
	        then qt_produto_processo* (pu.vl_custo_produto * isnull(pc.qt_fatcompra_produto,1)) 
	        else cast((qt_produto_processo * (pu.vl_custo_produto * isnull(pc.qt_fatcompra_produto,1)))/100 as numeric(25,4)) end
	  From
		  processo_padrao_produto a
	      inner join
		  (select pppr.cd_produto, pppr.cd_processo_padrao
		   from processo_padrao_produto pppr left outer join produto_producao ppr
		        on pppr.cd_processo_padrao <> ppr.cd_processo_padrao and
		          pppr.cd_produto = ppr.cd_produto
		   where ppr.cd_processo_padrao = @cd_processo_padrao) b
	      on a.cd_processo_padrao = b.cd_processo_padrao and
	         a.cd_produto = b.cd_produto
		    left outer join
		  Produto_Custo pu 
		    on a.cd_produto = pu.cd_produto
		    left outer join 
		  Produto_Compra pc 
		    on a.cd_produto = pc.cd_produto


	end
	
	
	-------------------------------------------------------------------------------
	if @ic_parametro = 2 -- Calculo dos Custos das Embalagens no Processo Padrão
	-------------------------------------------------------------------------------
	begin
	  select 
	    ppe.cd_processo_padrao,
	    ppe.cd_tipo_embalagem, 
	    ppe.cd_produto_embalagem,
            (pp.vl_custo_componente * pp.qt_densidade_processo * te.qt_unidade_tipo_embalagem)+           

            --Verifica o Tipo de Preço de Custo  

           case when @ic_tipo_preco_custo = 'M' then
                 (pu.vl_custo_previsto_produto * isnull(pc.qt_fatcompra_produto,1))                      
                else       
                  case when @ic_tipo_preco_custo = 'C' then
                    (pu.vl_custo_contabil_produto * isnull(pc.qt_fatcompra_produto,1))                               
                   else
                    (pu.vl_custo_produto * isnull(pc.qt_fatcompra_produto,1)) 
                   end 
                 
          end as 'vl_custo_proc_embalagem'

	  into #Temp1
	  from 
	    processo_padrao_embalagem  ppe
	      left outer join 
	    Processo_Padrao pp 
	      on ppe.cd_processo_padrao = pp.cd_processo_padrao
	      left outer join 
	    Produto_Custo pu 
	      on ppe.cd_produto_embalagem = pu.cd_produto
	      left outer join 
	    Produto_Compra pc 
	      on ppe.cd_produto_embalagem = pc.cd_produto
	      left outer join 
	    Tipo_Embalagem te 
	      on ppe.cd_tipo_embalagem = te.cd_tipo_embalagem
	  where 
	    ppe.cd_processo_padrao = @cd_processo_padrao
	
	  -----------------------------------------
	  --Atualização dos Custos das Embalagens
	  -----------------------------------------
	  while exists(select 'x' from #Temp1)
	  begin
	    select top 1
	      @cd_tipo_embalagem  = cd_tipo_embalagem,
	      @vl_custo_embalagem = vl_custo_proc_embalagem
	    from #Temp1
	
	    update Processo_Padrao_Embalagem
	      set vl_custo_proc_embalagem = @vl_custo_embalagem
	    where
	      cd_processo_padrao = @cd_processo_padrao and
	      cd_tipo_embalagem  = @cd_tipo_embalagem

	
	    delete from #Temp1
	    where
	      cd_processo_padrao = @cd_processo_padrao and
	      cd_tipo_embalagem = @cd_tipo_embalagem
	
    end

	end

  --atualizar as fórmulas que estiverem contida nos componentes da fórmula selecionada

   IF EXISTS (SELECT name FROM   sysobjects 
              WHERE  name = N'pr_calculo_custo_processo_padrao_arvore' AND type = 'P')
     exec pr_calculo_custo_processo_padrao_arvore
       @ic_parametro       = @ic_parametro,
       @cd_processo_padrao = @cd_processo_padrao


end 
