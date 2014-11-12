
-------------------------------------------------------------------------------
--pr_zera_movimento_calculo_ativo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Zerar o cálculo do ativo fixo 
--Data             : 24.04.2006
--Alteração        : 20.01.2007
--                 : 22.01.2007 - Zera a Tabela de Contabilização - Carlos fernandes
------------------------------------------------------------------------------------
create procedure pr_zera_movimento_calculo_ativo
@ic_parametro int      = 0,
@cd_grupo_bem int      = 0,
@cd_bem       int      = 0,
@dt_inicial   datetime = '',
@dt_final     datetime = ''

as

declare @cd_calculo_bem int

--Zeramento Completo da Tabela para novos Cálculos


if @ic_parametro=9    --Toda a tabela de cálculo
begin

  --Cálculo do Ativo
  delete from calculo_bem  

  --Contabilização
  delete from ativo_contabilizacao
    
end

else
  begin

    --Montagem da Tabela Temporária
 
    select 
      *
    into 
      #Calculo_Bem
    from
      Calculo_Bem
    where
      cd_grupo_bem = case when @cd_grupo_bem = 0 then cd_grupo_bem else @cd_grupo_bem end and
      cd_bem       = case when @cd_bem = 0       then cd_bem       else @cd_bem       end and
      dt_calculo_bem between @dt_inicial and @dt_final  

    --Atualização da Tabela Valor Bem

    update
      valor_bem
    set
      vl_dep_periodo_bem       = 0,
      vl_saldo_depreciacao_bem = vl_original_bem - vl_deprec_acumulada_bem,
      vl_residual_bem          = vl_original_bem - vl_deprec_acumulada_bem,
      vl_deprec_acumulada_bem  = vl_deprec_acumulada_bem - cb.vl_calculo_bem
  
    from
      Valor_Bem vb
      inner join #Calculo_Bem cb on cb.cd_bem = vb.cd_bem
   
    --Data  

    delete from
      calculo_bem
    where
      cd_grupo_bem = case when @cd_grupo_bem = 0 then cd_grupo_bem else @cd_grupo_bem end and
      cd_bem       = case when @cd_bem = 0       then cd_bem       else @cd_bem       end and
      dt_calculo_bem between @dt_inicial and @dt_final  

    delete from 
       ativo_contabilizacao
    where
       dt_ativo_contabilizacao between @dt_inicial and @dt_final  

  end

--select * from grupo_bem
--select * from bem
--select * from valor_bem
--select * from movimento_bem
--select * from calculo_bem



