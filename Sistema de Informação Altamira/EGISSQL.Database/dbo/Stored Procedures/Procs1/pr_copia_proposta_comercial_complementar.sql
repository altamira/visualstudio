
CREATE PROCEDURE pr_copia_proposta_comercial_complementar
@cd_consulta_origem      int,
@cd_consulta             int, --Código da nova Proposta gerada
@cd_usuario              int
as

  --**********************************************************************************
  --Copia tabela: CONSULTA_ITEM_COMPONENTE
  --**********************************************************************************  
  select
     *
   into 
     #Consulta_Item_Componente
   from
     Consulta_Item_Componente
   where
     cd_consulta = @cd_consulta_origem

   --Atualiza código da consulta
   update
      #Consulta_Item_Componente
   set
      cd_consulta = @cd_consulta,
      cd_usuario  = @cd_usuario,
      dt_usuario  = getdate()
   where
     cd_consulta = @cd_consulta_origem
   
   --Garante que a tabela não possui sugeria anterior - Implementado no dia 01.02.2006 - Fabio César
   delete from Consulta_Item_Componente where cd_consulta = @cd_consulta

   insert into 
        Consulta_Item_Componente
   Select
        *
   from
        #Consulta_Item_Componente

  --**********************************************************************************
  --Copia tabela: CONSULTA_ITEM_COMPOSICAO
  --**********************************************************************************  
  select
     *
   into 
     #Consulta_Item_Composicao
   from
     Consulta_Item_Composicao
   where
     cd_consulta = @cd_consulta_origem

   --Atualiza código da consulta
   update
      #Consulta_Item_Composicao
   set
      cd_consulta = @cd_consulta,
      cd_usuario  = @cd_usuario,
      dt_usuario  = getdate()
   where
     cd_consulta = @cd_consulta_origem

   --Garante que a tabela não possui sugeria anterior - Implementado no dia 01.02.2006 - Fabio César
   delete from Consulta_Item_Composicao where cd_consulta = @cd_consulta
   
   insert into 
        Consulta_Item_Composicao
   Select
        *
   from
        #Consulta_Item_Composicao

  --**********************************************************************************
  --Copia tabela: CONSULTA_ITEM_EMBALAGEM
  --**********************************************************************************  
  select
     *
   into 
     #Consulta_Item_Embalagem
   from
     Consulta_Item_Embalagem
   where
     cd_consulta = @cd_consulta_origem

   --Atualiza código da consulta
   update
      #Consulta_Item_Embalagem
   set
      cd_consulta = @cd_consulta,
      cd_usuario  = @cd_usuario,
      dt_usuario  = getdate()
   where
     cd_consulta = @cd_consulta_origem
   
   --Garante que a tabela não possui sugeria anterior - Implementado no dia 01.02.2006 - Fabio César
   delete from Consulta_Item_Embalagem where cd_consulta = @cd_consulta

   insert into 
        Consulta_Item_Embalagem
   Select
        *
   from
        #Consulta_Item_Embalagem

  --**********************************************************************************
  --Copia tabela: CONSULTA_ITEM_LOTE
  --**********************************************************************************  
  select
     *
   into 
     #Consulta_Item_Lote
   from
     Consulta_Item_Lote
   where
     cd_consulta = @cd_consulta_origem

   --Atualiza código da consulta
   update
      #Consulta_Item_Lote
   set
      cd_consulta = @cd_consulta,
      cd_usuario  = @cd_usuario,
      dt_usuario  = getdate()
   where
     cd_consulta = @cd_consulta_origem
   
   --Garante que a tabela não possui sugeria anterior - Implementado no dia 01.02.2006 - Fabio César
   delete from Consulta_Item_Lote where cd_consulta = @cd_consulta

   insert into 
        Consulta_Item_Lote
   Select
        *
   from
        #Consulta_Item_Lote


  --**********************************************************************************
  --Copia tabela: CONSULTA_ITEM_OBSERVACAO
  --**********************************************************************************  
  select
     *
   into 
     #Consulta_Item_Observacao
   from
     Consulta_Item_Observacao
   where
     cd_consulta = @cd_consulta_origem

   --Atualiza código da consulta
   update
      #Consulta_Item_Observacao
   set
      cd_consulta = @cd_consulta,
      cd_usuario  = @cd_usuario,
      dt_usuario  = getdate()
   where
     cd_consulta = @cd_consulta_origem
   
   --Garante que a tabela não possui sugeria anterior - Implementado no dia 01.02.2006 - Fabio César
   delete from Consulta_Item_Observacao where cd_consulta = @cd_consulta

   insert into 
        Consulta_Item_Observacao
   Select
        *
   from
        #Consulta_Item_Observacao

  --**********************************************************************************
  --Copia tabela: CONSULTA_ITEM_ORCAMENTO
  --**********************************************************************************  
  select
     *
   into 
     #Consulta_Item_Orcamento
   from
     Consulta_Item_Orcamento
   where
     cd_consulta = @cd_consulta_origem

   --Atualiza código da consulta
   update
      #Consulta_Item_Orcamento
   set
      cd_consulta = @cd_consulta,
      cd_usuario  = @cd_usuario,
      dt_usuario  = getdate()
   where
     cd_consulta = @cd_consulta_origem
   
   --Garante que a tabela não possui sugeria anterior - Implementado no dia 01.02.2006 - Fabio César
   delete from Consulta_Item_Orcamento where cd_consulta = @cd_consulta

   insert into 
        Consulta_Item_Orcamento
   Select
        *
   from
        #Consulta_Item_Orcamento

  --**********************************************************************************
  --Copia tabela: CONSULTA_ITEM_ORCAMENTO_ALOJAMENTO
  --**********************************************************************************  
  select
     *
   into 
     #Consulta_Item_Orcamento_Alojamento
   from
     Consulta_Item_Orcamento_Alojamento
   where
     cd_consulta = @cd_consulta_origem

   --Atualiza código da consulta
   update
      #Consulta_Item_Orcamento_Alojamento
   set
      cd_consulta = @cd_consulta,
      cd_usuario  = @cd_usuario,
      dt_usuario  = getdate()
   where
     cd_consulta = @cd_consulta_origem
   
   --Garante que a tabela não possui sugeria anterior - Implementado no dia 01.02.2006 - Fabio César
   delete from Consulta_Item_Orcamento_Alojamento where cd_consulta = @cd_consulta

   insert into 
        Consulta_Item_Orcamento_Alojamento
   Select
        *
   from
        #Consulta_Item_Orcamento_Alojamento

  --**********************************************************************************
  --Copia tabela: CONSULTA_ITEM_ORCAMENTO_BUCHA_COLUNA
  --**********************************************************************************  
  select
     *
   into 
     #Consulta_Item_Orcamento_Bucha_Coluna
   from
     Consulta_Item_Orcamento_Bucha_Coluna
   where
     cd_consulta = @cd_consulta_origem

   --Atualiza código da consulta
   update
      #Consulta_Item_Orcamento_Bucha_Coluna
   set
      cd_consulta = @cd_consulta,
      cd_usuario  = @cd_usuario,
      dt_usuario  = getdate()
   where
     cd_consulta = @cd_consulta_origem
   
   --Garante que a tabela não possui sugeria anterior - Implementado no dia 01.02.2006 - Fabio César
   delete from Consulta_Item_Orcamento_Bucha_Coluna where cd_consulta = @cd_consulta

   insert into 
        Consulta_Item_Orcamento_Bucha_Coluna
   Select
        *
   from
        #Consulta_Item_Orcamento_Bucha_Coluna

  --**********************************************************************************
  --Copia tabela: CONSULTA_ITEM_ORCAMENTO_CAT
  --**********************************************************************************  
  select
     *
   into 
     #Consulta_Item_Orcamento_Cat
   from
     Consulta_Item_Orcamento_Cat
   where
     cd_consulta = @cd_consulta_origem

   --Atualiza código da consulta
   update
      #Consulta_Item_Orcamento_Cat
   set
      cd_consulta = @cd_consulta,
      cd_usuario  = @cd_usuario,
      dt_usuario  = getdate()
   where
     cd_consulta = @cd_consulta_origem
   
   --Garante que a tabela não possui sugeria anterior - Implementado no dia 01.02.2006 - Fabio César
   delete from Consulta_Item_Orcamento_Cat where cd_consulta = @cd_consulta

   insert into 
        Consulta_Item_Orcamento_Cat
   Select
        *
   from
        #Consulta_Item_Orcamento_Cat

  --**********************************************************************************
  --Copia tabela: CONSULTA_ITEM_ORCAMENTO_FURO
  --**********************************************************************************  
  select
     *
   into 
     #Consulta_Item_Orcamento_Furo
   from
     Consulta_Item_Orcamento_Furo
   where
     cd_consulta = @cd_consulta_origem

   --Atualiza código da consulta
   update
      #Consulta_Item_Orcamento_Furo
   set
      cd_consulta = @cd_consulta,
      cd_usuario  = @cd_usuario,
      dt_usuario  = getdate()
   where
     cd_consulta = @cd_consulta_origem
   
   --Garante que a tabela não possui sugeria anterior - Implementado no dia 01.02.2006 - Fabio César
   delete from Consulta_Item_Orcamento_Furo where cd_consulta = @cd_consulta

   insert into 
        Consulta_Item_Orcamento_Furo
   Select
        *
   from
        #Consulta_Item_Orcamento_Furo

  --**********************************************************************************
  --Copia tabela: CONSULTA_ITEM_ORCAMENTO_FURO_ADICIONAL
  --**********************************************************************************  
  select
     *
   into 
     #Consulta_Item_Orcamento_Furo_Adicional
   from
     Consulta_Item_Orcamento_Furo_Adicional
   where
     cd_consulta = @cd_consulta_origem

   --Atualiza código da consulta
   update
      #Consulta_Item_Orcamento_Furo_Adicional
   set
      cd_consulta = @cd_consulta,
      cd_usuario  = @cd_usuario,
      dt_usuario  = getdate()
   where
     cd_consulta = @cd_consulta_origem
   
   --Garante que a tabela não possui sugeria anterior - Implementado no dia 01.02.2006 - Fabio César
   delete from Consulta_Item_Orcamento_Furo_Adicional where cd_consulta = @cd_consulta

   insert into 
        Consulta_Item_Orcamento_Furo_Adicional
   Select
        *
   from
        #Consulta_Item_Orcamento_Furo_Adicional

  --**********************************************************************************
  --Copia tabela: CONSULTA_ITEM_ORCAMENTO_REFRIGERACAO
  --**********************************************************************************  
  select
     *
   into 
     #Consulta_Item_Orcamento_Refrigeracao
   from
     Consulta_Item_Orcamento_Refrigeracao
   where
     cd_consulta = @cd_consulta_origem

   --Atualiza código da consulta
   update
      #Consulta_Item_Orcamento_Refrigeracao
   set
      cd_consulta = @cd_consulta,
      cd_usuario  = @cd_usuario,
      dt_usuario  = getdate()
   where
     cd_consulta = @cd_consulta_origem
   
   --Garante que a tabela não possui sugeria anterior - Implementado no dia 01.02.2006 - Fabio César
   delete from Consulta_Item_Orcamento_Refrigeracao where cd_consulta = @cd_consulta

   insert into 
        Consulta_Item_Orcamento_Refrigeracao
   Select
        *
   from
        #Consulta_Item_Orcamento_Refrigeracao

  --**********************************************************************************
  --Copia tabela: CONSULTA_ITEM_ORCAMENTO_SERVICO_MANUAL
  --**********************************************************************************  
  select
     *
   into 
     #Consulta_Item_Orcamento_Servico_Manual
   from
     Consulta_Item_Orcamento_Servico_Manual
   where
     cd_consulta = @cd_consulta_origem

   --Atualiza código da consulta
   update
      #Consulta_Item_Orcamento_Servico_Manual
   set
      cd_consulta = @cd_consulta,
      cd_usuario  = @cd_usuario,
      dt_usuario  = getdate()
   where
     cd_consulta = @cd_consulta_origem
   
   --Garante que a tabela não possui sugeria anterior - Implementado no dia 01.02.2006 - Fabio César
   delete from Consulta_Item_Orcamento_Servico_Manual where cd_consulta = @cd_consulta

   insert into 
        Consulta_Item_Orcamento_Servico_Manual
   Select
        *
   from
        #Consulta_Item_Orcamento_Servico_Manual

  --**********************************************************************************
  --Copia tabela: CONSULTA_ITEM_PERDA
  --**********************************************************************************  
  select
     *
   into 
     #Consulta_Item_Perda
   from
     Consulta_Item_Perda
   where
     cd_consulta = @cd_consulta_origem

   --Atualiza código da consulta
   update
      #Consulta_Item_Perda
   set
      cd_consulta = @cd_consulta,
      cd_usuario  = @cd_usuario,
      dt_usuario  = getdate()
   where
     cd_consulta = @cd_consulta_origem
   
   --Garante que a tabela não possui sugeria anterior - Implementado no dia 01.02.2006 - Fabio César
   delete from Consulta_Item_Perda where cd_consulta = @cd_consulta

   insert into 
        Consulta_Item_Perda
   Select
        *
   from
        #Consulta_Item_Perda

  --**********************************************************************************
  --Copia tabela: CONSULTA_ITEM_SERVICO_EXTERNO
  --**********************************************************************************  
   --Houve uma solicitação para não realizar a cópia do serviço externo 01.02.2006

--   select
--      *
--    into 
--      #Consulta_Item_Servico_Externo
--    from
--      Consulta_Item_Servico_Externo
--    where
--      cd_consulta = @cd_consulta_origem
-- 
--    --Atualiza código da consulta
--    update
--       #Consulta_Item_Servico_Externo
--    set
--       cd_consulta = @cd_consulta,
--       cd_usuario  = @cd_usuario,
--       dt_usuario  = getdate()
--    where
--      cd_consulta = @cd_consulta_origem
   
   --Garante que a tabela não possui sugeria anterior - Implementado no dia 01.02.2006 - Fabio César
   delete from Consulta_Item_Servico_Externo where cd_consulta = @cd_consulta

--    insert into 
--         Consulta_Item_Servico_Externo
--    Select
--         *
--    from
--         #Consulta_Item_Servico_Externo

  --**********************************************************************************
  --Copia tabela: CONSULTA_ITEM_TEXTO
  --**********************************************************************************  
  select
     *
   into 
     #Consulta_Item_Texto
   from
     Consulta_Item_Texto
   where
     cd_consulta = @cd_consulta_origem

   --Atualiza código da consulta
   update
      #Consulta_Item_Texto
   set
      cd_consulta = @cd_consulta,
      cd_usuario  = @cd_usuario,
      dt_usuario  = getdate()
   where
     cd_consulta = @cd_consulta_origem
   
   --Garante que a tabela não possui sugeria anterior - Implementado no dia 01.02.2006 - Fabio César
   delete from Consulta_Item_Texto where cd_consulta = @cd_consulta

   insert into 
        Consulta_Item_Texto
   Select
        *
   from
        #Consulta_Item_Texto

  --**********************************************************************************
  --Copia tabela: CONSULTA_ITENS_ACESSORIO
  --**********************************************************************************  
  select
     *
   into 
     #Consulta_Itens_Acessorio
   from
     Consulta_Itens_Acessorio
   where
     cd_consulta = @cd_consulta_origem

   --Atualiza código da consulta
   update
      #Consulta_Itens_Acessorio
   set
      cd_consulta = @cd_consulta,
      cd_usuario  = @cd_usuario,
      dt_usuario  = getdate()
   where
     cd_consulta = @cd_consulta_origem
   
   --Garante que a tabela não possui sugeria anterior - Implementado no dia 01.02.2006 - Fabio César
   delete from Consulta_Itens_Acessorio where cd_consulta = @cd_consulta

   insert into 
        Consulta_Itens_Acessorio
   Select
        *
   from
        #Consulta_Itens_Acessorio

  --**********************************************************************************
  --Copia tabela: CONSULTA_ITENS_DESCONTO
  --**********************************************************************************  
  select
     *
   into 
     #Consulta_Itens_Desconto
   from
     Consulta_Itens_Desconto
   where
     cd_consulta = @cd_consulta_origem

   --Atualiza código da consulta
   update
      #Consulta_Itens_Desconto
   set
      cd_consulta = @cd_consulta,
      cd_usuario  = @cd_usuario,
      dt_usuario  = getdate()
   where
     cd_consulta = @cd_consulta_origem
   
   --Garante que a tabela não possui sugeria anterior - Implementado no dia 01.02.2006 - Fabio César
   delete from Consulta_Itens_Desconto where cd_consulta = @cd_consulta

   insert into 
        Consulta_Itens_Desconto
   Select
        *
   from
        #Consulta_Itens_Desconto

  --**********************************************************************************
  --Copia tabela: CONSULTA_ITENS_GRADE
  --**********************************************************************************  
  select
     *
   into 
     #Consulta_Itens_Grade
   from
     Consulta_Itens_Grade
   where
     cd_consulta = @cd_consulta_origem

   --Atualiza código da consulta
   update
      #Consulta_Itens_Grade
   set
      cd_consulta = @cd_consulta,
      cd_usuario  = @cd_usuario,
      dt_usuario  = getdate()
   where
     cd_consulta = @cd_consulta_origem
   
   --Garante que a tabela não possui sugeria anterior - Implementado no dia 01.02.2006 - Fabio César
   delete from Consulta_Itens_Grade where cd_consulta = @cd_consulta

   insert into 
        Consulta_Itens_Grade
   Select
        *
   from
        #Consulta_Itens_Grade


  --**********************************************************************************
  --Copia tabela: Orcamento_CQ
  --**********************************************************************************  
  select
     *
   into 
     #Orcamento_CQ
   from
     Orcamento_CQ
   where
     cd_consulta = @cd_consulta_origem

   --Atualiza código da consulta
   update
      #Orcamento_CQ
   set
      cd_consulta = @cd_consulta,
      cd_usuario  = @cd_usuario,
      dt_usuario  = getdate()
   where
     cd_consulta = @cd_consulta_origem
   
   --Garante que a tabela não possui sugeria anterior - Implementado no dia 01.02.2006 - Fabio César
   delete from Orcamento_CQ where cd_consulta = @cd_consulta

   insert into 
        Orcamento_CQ
   Select
        *
   from
        #Orcamento_CQ

  --**********************************************************************************
  --Copia tabela: Item_orcamento_cq
  --**********************************************************************************  
  select
     *
   into 
     #Item_orcamento_cq
   from
     Item_orcamento_cq
   where
     cd_consulta = @cd_consulta_origem

   --Atualiza código da consulta
   update
      #Item_orcamento_cq
   set
      cd_consulta = @cd_consulta,
      cd_usuario  = @cd_usuario,
      dt_usuario  = getdate()
   where
     cd_consulta = @cd_consulta_origem
   
   --Garante que a tabela não possui sugeria anterior - Implementado no dia 01.02.2006 - Fabio César
   delete from Item_orcamento_cq where cd_consulta = @cd_consulta

   insert into 
        Item_orcamento_cq
   Select
        *
   from
        #Item_orcamento_cq
