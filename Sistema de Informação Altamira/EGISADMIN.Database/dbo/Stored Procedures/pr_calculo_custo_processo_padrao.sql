
--CREATE PROCEDURE pr_calculo_custo_processo_padrao

CREATE PROCEDURE pr_calculo_custo_processo_padrao
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
--------------------------------------------------------------------------------------------------------- 
@ic_parametro        int,  
@cd_processo_padrao  int,
@cd_usuario          int = 0
as 

begin

	declare @cd_produto_proc_padrao     integer,
	        @cd_tipo_embalagem          integer,
	        @vl_custo_produto           float,
	        @vl_custo_embalagem         float,
	        @vl_custo_produto_processo  float,
	        @vl_total_custo_componentes float,
                @vl_total_custo_operacao    float,
	        @ic_perc_empresa            char(1),
                @vl_total_custo_processo    float

        set @vl_total_custo_componentes = 0
        set @vl_total_custo_operacao    = 0
        set @vl_total_custo_processo    = 0
	
	-------------------------------------------------------------------------------
	if @ic_parametro = 1 -- Calculo dos Custos dos Componentes no Processo Padrão
	-------------------------------------------------------------------------------
	begin

	  select @ic_perc_empresa = isnull(ic_qtd_proc_padrao_pc,'N')
	  from Parametro_Manufatura
	  where
	    cd_empresa = dbo.fn_empresa()
	
	  select 
	    ppp.cd_processo_padrao,
	    ppp.cd_produto_proc_padrao, 
	    ppp.cd_produto,
	    (pu.vl_custo_produto * isnull(pc.qt_fatcompra_produto,1)) as 'vl_custo_produto',
	    case when @ic_perc_empresa <> 'S' then
	      qt_produto_processo* (pu.vl_custo_produto * isnull(pc.qt_fatcompra_produto,1)) 
	    else 
	      (qt_produto_processo * (pu.vl_custo_produto * isnull(pc.qt_fatcompra_produto,1)))/100 end as 'vl_custo_produto_processo'
	  into #Temp
	  from 
	    processo_padrao_produto  ppp
	      left outer join 
	    Produto_Custo pu 
	      on ppp.cd_produto = pu.cd_produto
	      left outer join 
	    Produto_Compra pc 
	      on ppp.cd_produto = pc.cd_produto
	  where 
	    cd_processo_padrao = @cd_processo_padrao

-------------------------------------------------------------------------------------------
--Cálculo do Custo do Processo - Operações / Máquina
--16.02.2005
--Carlos Fernandes
-------------------------------------------------------------------------------------------
           
          --select * form processo_padrao_composicao
          --select * from mao_obra

          select 
            ppc.cd_processo_padrao,
            ppc.cd_operacao,
              o.vl_custo_operacao,
            ppc.qt_hora_setup,
            ppc.qt_hora_operacao,
            ppc.cd_maquina,
              m.vl_custo_maquina,
            CustoTotalOperacao = ( ( isnull(ppc.qt_hora_setup,0) + isnull(ppc.qt_hora_operacao,0) ) * isnull(o.vl_custo_operacao,0)    ) +
                                 ( ( isnull(ppc.qt_hora_setup,0) + isnull(ppc.qt_hora_operacao,0) ) * isnull(m.vl_custo_maquina,0)     ) +
                                 ( ( isnull(ppc.qt_hora_setup,0) + isnull(ppc.qt_hora_operacao,0) ) * isnull(se.vl_servico_especial,0) ) +
                                 ( ( isnull(ppc.qt_hora_setup,0) + isnull(ppc.qt_hora_operacao,0) ) * isnull(mo.vl_mao_obra,0)         ) 


          into
            #AuxCalculo
          from 
            processo_padrao_composicao ppc
            left outer join Operacao o          on o.cd_operacao = ppc.cd_operacao
            left outer join Maquina  m          on m.cd_maquina  = ppc.cd_maquina
            left outer join Servico_Especial se on se.cd_servico_especial = ppc.cd_servico_especial
            left outer join Mao_Obra mo         on mo.cd_mao_obra = o.cd_mao_obra
	  where 
	    ppc.cd_processo_padrao = @cd_processo_padrao
 

          select
            @vl_total_custo_operacao = sum( isnull( CustoTotalOperacao,0 )  )
	  from
            #AuxCalculo

       	  ---------------------------------------------------------------------------------
	  --Atualização da Somatória dos Custos de Componentes no Processo Padrão
	  ---------------------------------------------------------------------------------
	  select 
	    @vl_total_custo_componentes = sum( isnull(vl_custo_produto_processo,0) )
	  from #Temp    

          --Custo Total do Processo
          set @vl_total_custo_processo = @vl_total_custo_componentes + @vl_total_custo_operacao

	
          --Atualização do custo do processo Padrão

	  update Processo_Padrao
	  set
	    vl_custo_componente       = @vl_total_custo_componentes,
            vl_custo_operacao         = @vl_total_custo_operacao,
            vl_total_custo_processo   = @vl_total_custo_componentes + @vl_total_custo_operacao,
            dt_custo_processo         = getdate(),
            cd_usuario_custo_processo = @cd_usuario                        
	  where
	    cd_processo_padrao = @cd_processo_padrao

	
	  -----------------------------------------
	  --Atualização dos Custos dos Componentes
	  -----------------------------------------
	  while exists(select 'x' from #Temp)
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

		update produto_custo
		set vl_custo_produto = @vl_total_custo_processo
		from
		  processo_padrao  pp left outer join
		  produto_producao pp1    on (pp.cd_processo_padrao = pp1.cd_processo_padrao) inner join
		  Produto_custo    pc     on pp1.cd_produto = pc.cd_produto
		where 
                  pp.cd_processo_padrao = @cd_processo_padrao
	
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
	      (pu.vl_custo_produto * isnull(pc.qt_fatcompra_produto,1)) as 'vl_custo_proc_embalagem'
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
	      @cd_tipo_embalagem = cd_tipo_embalagem,
	      @vl_custo_embalagem = vl_custo_proc_embalagem
	    from #Temp1
	
	    update Processo_Padrao_Embalagem
	    set   
	      vl_custo_proc_embalagem = @vl_custo_embalagem
	    where
	      cd_processo_padrao = @cd_processo_padrao and
	      cd_tipo_embalagem = @cd_tipo_embalagem

	
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
