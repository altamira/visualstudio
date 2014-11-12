
CREATE PROCEDURE pr_copia_proposta_comercial  
@cd_consulta_origem      int,  
@cd_usuario              int,  
@cd_cliente              int,
@nova                    int = 0 -- Se for diferente de Zero, só copia a proposta sem os itens
as  
  
-- Retornará ZERO se não encontrar a consulta_origem - Clelson(28.01.2005)  
declare @cd_consulta int  
set @cd_consulta = 0  

 
declare @sg_estado_cliente            varchar(2),  
        @cd_destinacao_produto        integer,  
        @cd_cliente_antigo            int  ,
        @cd_estado                    int,
        @cd_pais                      int,
        @ic_zera_preco_venda_especial char(1)
  

select
  @ic_zera_preco_venda_especial = isnull(ic_zera_preco_venda_especial,'N')
from
  parametro_copia_proposta
where
  cd_empresa = dbo.fn_empresa()
  
--Verifica se a Consulta de origem Existe  
  
if exists( select cd_consulta from Consulta where cd_consulta = @cd_consulta_origem )  
begin  
  
declare @Tabela      varchar(50)  
  
set @Tabela      = cast(DB_NAME()+'.dbo.Consulta' as varchar(50))  
  
while @cd_consulta = 0  
begin  
  
  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_consulta', @codigo = @cd_consulta output  
  
  
  --Verifica se Existe a Proposta na Tabela  
  
  if not exists(select cd_consulta from consulta where @cd_consulta = cd_consulta )  
  begin    
   --Cria uma Tabela Temporária - Consulta  
   set @cd_cliente_antigo =  (select cd_cliente  from Consulta      
          where  cd_consulta = @cd_consulta_origem)  
    
   Select  
       *  
   into 
      #Consulta  
   from  
     Consulta  
   where  
     cd_consulta = @cd_consulta_origem  
   
   --Geração da Nova Proposta  
   Update  
      #Consulta  
   Set  
      cd_cliente             = @cd_cliente,  
      cd_cliente_fatura      = @cd_cliente,  
      cd_cliente_entrega     = @cd_cliente,  
      cd_consulta            = @cd_consulta,  
      --dt_consulta            = dbo.fn_data(getdate()), --cast((CONVERT(VARCHAR(10), GETDATE(), 105)) as datetime),
      dt_consulta            = cast(convert(int,getdate(),103) as datetime),
      ic_fax_consulta        = 'N',  
      ic_email_consulta      = 'N',  
      ic_fatsmo_consulta     = 'N',  
      ic_fechada_consulta    = 'N',  
      ic_fechamento_total    = 'N',  
      ic_pedido_venda        = 'N',  
      cd_status_proposta     = 1,  
      dt_fechamento_consulta = null,  
      dt_alteracao_consulta  = null,  
      cd_usuario             = @cd_usuario,  
      dt_usuario             = getdate(),  
      nm_referencia_consulta =  (case @cd_cliente   
              when cd_cliente then  
                   nm_referencia_consulta  
              else  
             ''    
              end)  
    where  
      cd_consulta = @cd_consulta_origem  
  
   --Insere na consulta os valores presentes nas colunas  
   Insert into  
      Consulta  
   Select  
      *  
   From  
      #Consulta  
  
   Select top 1  @sg_estado_cliente     = e.sg_estado,  
                 @cd_destinacao_produto = c.cd_destinacao_produto,
                 @cd_estado             = cli.cd_estado,
                 @cd_pais               = cli.cd_pais
   From   
       Consulta c inner join   
       Cliente cli on c.cd_cliente = cli.cd_cliente inner join   
       Estado e    on cli.cd_estado = e.cd_estado  
   Where  
       --cd_consulta = @cd_consulta_origem  
       cli.cd_cliente = @cd_cliente  
  
   --Verifica se é nova proposta ou copia
   if IsNull(@nova,0) = 0 
   begin
      --Cria uma Tabela Temporária - Consulta Itens  
      Select  
        *  
      Into 
        #Consulta_Itens  
      From  
        Consulta_itens  
      Where  
        cd_consulta = @cd_consulta_origem  

       --Geração da Nova Proposta  

      Update  
        #Consulta_itens  
      Set  
         cd_consulta               = @cd_consulta,  
         dt_item_consulta          = cast((CONVERT(VARCHAR(10), GETDATE(), 105)) as datetime),
         dt_fechamento_consulta    = null,  
         ic_sel_fax_consulta       = 'N',  
         ic_sel_email_consulta     = 'N',  
         ic_email_rep_consulta     = 'N',  
         ic_email_ven_consulta     = 'N',  
         dt_perda_consulta_itens   = null,  
         ic_sel_fechamento         = 'N',  
         ic_item_perda_consulta    = 'N',  
         cd_usuario_lib_desconto   = 0,  
         dt_desconto_item_consulta = null,  
         ic_desconto_item_consulta = 'N',  
         cd_pedido_venda           = 0,  
         cd_item_pedido_venda      = 0,  
         cd_usuario                = @cd_usuario,  
         dt_usuario                = getdate(),  
         dt_validade_item_consulta   = Null,  
         cd_os_consulta              = Null,   
         cd_posicao_consulta         = Null,   
         cd_pedido_compra_consulta   = Null,   
         dt_entrega_consulta         = (Case qt_dia_entrega_consulta
                                        when 0 then	
				         cast((CONVERT(VARCHAR(10), GETDATE(), 105)) as datetime)
                                        else	
				         cast((CONVERT(VARCHAR(10), GETDATE()+ qt_dia_entrega_consulta, 105)) as datetime)
				          end),
         nm_kardex_item_consulta     =  (case @cd_cliente   
              								      when @cd_cliente_antigo then  
                   							       nm_kardex_item_consulta  
              								      else  
            									       ''    
              								      end),  

        --Atualiza o Preço de Venda 
        --Carlos 11.07.2005  

         vl_unitario_item_consulta = case when isnull(cd_produto,0)=0 and isnull(cd_servico,0)=0 and @ic_zera_preco_venda_especial='S'
                                        then
                                           0.00 
                                        else 
                                           isnull(vl_unitario_item_consulta,0) 
                                        end,

         --Atualiza o valor de lista do produto  / preço orçado

         vl_lista_item_consulta    = ( Case dbo.fn_vl_produto_cliente(isnull(cd_produto,0), @cd_cliente)  
                                          when 0 then
                                             (case when IsNull(cd_produto,0)=0 and isnull(cd_servico,0)=0 and @ic_zera_preco_venda_especial='S'
                                                 then   
                                                     0.00
                                                    --Especial         
                                                    --Carlos 11.07.2005
                                                    --vl_lista_item_consulta  
                                                else  
                                                  case when  dbo.fn_vl_venda_produto(@sg_estado_cliente, @cd_destinacao_produto, cd_produto)>0 then
                                                     dbo.fn_vl_venda_produto(@sg_estado_cliente, @cd_destinacao_produto, cd_produto)
                                                  else
                                                    vl_lista_item_consulta
                                                  end
                                                end)
                                          else       
                                            case when isnull(dbo.fn_vl_produto_cliente(isnull(cd_produto,0), @cd_cliente),0)=0   
                                                 then 0      
                                                 else
                                                   case when dbo.fn_vl_produto_cliente(isnull(cd_produto,0), @cd_cliente) >0 
                                                   then
                                                     dbo.fn_vl_produto_cliente(isnull(cd_produto,0), @cd_cliente)
                                                   else
                                                     vl_lista_item_consulta
                                                   end
                                                 end
                                          end),

         pc_ipi  =  case when isnull(cd_produto,0)>0 
                    then
                      isNull(dbo.fn_get_ipi_produto(isnull(cd_produto,0)),0)
                    else
                      pc_ipi
                    end,
         pc_icms =  case when isnull(cd_produto,0)>0 
                    then
                      dbo.fn_vl_icms_produto_estado(isnull(@cd_estado,0),isnull(@cd_pais,0),isnull(cd_produto,0))
                    else
                     pc_icms
                    end

      Where  
        cd_consulta = @cd_consulta_origem  

      --Verificar se o Item é Serviço busca o preço de lista do Serviço
      --select * from consulta_itens
      update
        #Consulta_itens
      set
        vl_lista_item_consulta = isnull(s.vl_servico,0)
      from
        #Consulta_itens ci
        inner join Servico s on s.cd_servico = ci.cd_servico
      where
        isnull(ci.cd_produto,0)=0 and
        isnull(ci.cd_servico,0)>0        
  
      Insert into  
        Consulta_itens  
      Select  
        *  
      From  
        #Consulta_itens  
       
      -- limpeza da tabela de código --Precisa ser executado antes
      exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_consulta, 'D'  

      --Realiza a cópia das tabelas complementares de venda (Ex. Consulta_Item_Componente, Consulta_Item_Embalagem)
      exec dbo.pr_copia_proposta_comercial_complementar @cd_consulta_origem, @cd_consulta, @cd_usuario  
   end    
   else   
     -- limpeza da tabela de código  
     exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_consulta, 'D'  
  
   end  
   else  
   begin   
     -- limpeza da tabela de código, pois não achou a consulta base
     exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_consulta, 'D'  
     set @cd_consulta=0  
   end    
end  
  
end  

--Retorna o código da consulta
select @cd_consulta as cd_consulta  
  
