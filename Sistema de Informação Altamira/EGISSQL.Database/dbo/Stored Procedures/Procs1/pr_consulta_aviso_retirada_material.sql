

/****** Object:  Stored Procedure dbo.pr_consulta_aviso_retirada_material    Script Date: 13/12/2002 15:08:16 ******/

CREATE PROCEDURE pr_consulta_aviso_retirada_material
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Igor Gama
--Banco de Dados: Egissql
--Objetivo: Listar todas as entregas (retira)
--Data: 22/07/2002
--Atualizado: 
---------------------------------------------------
@ic_parametro int,
@dt_inicial datetime,
@dt_final  datetime,
@cd_cliente int,
@cd_entregador int,
@cd_nota_saida_item varchar(100)
as 
---------------------------------------------------
-- Paramentro 1 para consulta/Relatório
---------------------------------------------------
If @ic_parametro = 1
Begin

  create table #NotaSaida_duplicata(
    cd_nota_Saida int,		-- Nota Saída
    dt_duplicata varchar(1000)) -- Data da duplicatas

  Declare 
    @cd_nota_saida int,
    @cd_contador int

  Declare
    @dt_vencimento_documento varchar(10)

  Declare
    @dt_duplicata Varchar(100)


  Set @cd_nota_saida = 0
  Set @cd_contador   = 1
  Set @dt_duplicata = ''

  --Seleciona todas as notas fiscais
  select 
    IDENTITY(int, 1,1) as cd_contador,
    n.cd_nota_saida,          --Nota
    Convert(varchar(10), n.dt_nota_saida , 103) as dt_nota_saida,
    dr.cd_documento_receber,  --Nº da Duplicata
    Convert(varchar(10), dr.dt_vencimento_documento, 103) as dt_vencimento_documento   --Data do Doc.
  Into
    #Nota_Duplicata
  from
    nota_saida n 
      left outer join
    Documento_Receber dr
      on n.cd_nota_saida = dr.cd_nota_saida
      Left outer join
    Observacao_Entrega o
      on n.cd_observacao_entrega = o.cd_observacao_entrega
      Left Outer Join
    Operacao_Fiscal opf
      on n.cd_operacao_fiscal = opf.cd_operacao_fiscal
  where
    o.nm_observacao_entrega like '%Retira%' and      -- Tipo de entrega "Retira"
    n.dt_saida_nota_saida is null and                -- Data de Saída em Branco
    (n.dt_cancel_nota_saida is null or
     n.dt_nota_dev_nota_saida is null) and           -- Nota Cancelada ou devolvida
    IsNull(n.ic_entrega_nota_saida, 'N') in ('S','E') and 
--     ((IsNull(n.ic_entrega_nota_saida, 'N') = @ic_entrega_nota_saida) or
--      (@ic_entrega_nota_saida = '')) and -- Notas que tenham aviso de retira  
    opf.ic_comercial_operacao = 'S' and              -- Verifica se Operação Fiscal tem valor comercial
    ((n.dt_nota_saida between @dt_inicial and @dt_final) or
    ((Isnull(@dt_inicial,0) = 0) and (Isnull(@dt_final,0) = 0))) and 
    ((n.cd_cliente = @cd_cliente) or (@cd_cliente = 0)) and 
    ((n.cd_entregador = @cd_entregador) or (@cd_entregador = 0))
  order by
    n.cd_nota_saida asc


  Select
    @cd_nota_saida = cd_nota_saida,
    @dt_vencimento_documento = dt_vencimento_documento
  From
    #Nota_Duplicata
  Where
    cd_contador = 1

  While exists(Select * from #Nota_Duplicata Where cd_contador = @cd_contador)
  Begin
  
    If @cd_nota_saida = (Select cd_nota_saida From #Nota_Duplicata
                         Where cd_contador = @cd_contador)
    Begin

      If @dt_duplicata = ''
        Set @dt_duplicata = @dt_vencimento_documento
      Else
        Set @dt_duplicata = @dt_duplicata + ', '+@dt_vencimento_documento   

    End Else Begin

      Insert into #NotaSaida_duplicata Values
      (@cd_nota_saida, @dt_duplicata)
  
      Set @dt_duplicata = ''

      Select @cd_nota_saida = cd_nota_saida,
             @dt_vencimento_documento = dt_vencimento_documento
      From   #Nota_Duplicata
      Where  cd_contador = @cd_contador 

      If @dt_duplicata = ''
        Set @dt_duplicata = @dt_vencimento_documento
      Else
        Set @dt_duplicata = @dt_duplicata + ', '+@dt_vencimento_documento   

    End

    Set @cd_contador = @cd_contador + 1

    Select @dt_vencimento_documento = dt_vencimento_documento
    From   #Nota_Duplicata
    Where  cd_contador = @cd_contador 

  End
  Insert into #NotaSaida_duplicata Values
  (@cd_nota_saida, @dt_duplicata )

--   Select * from #NotaSaida_duplicata

  --Juntando as informações das duplicatas com o 
  -- resultado da consulta para emissão do relatório

  select 
   'N' as ic_status,
    c.cd_cliente,
    c.nm_fantasia_cliente,	 --Cliente
    c.nm_razao_social_cliente,   --Razao Social Cliente
    c.dt_cadastro_cliente,       --Cadastro
    c.cd_telefone,               --Telefone
    c.cd_fax,
    (Select top 1 nm_contato_cliente From Cliente_Contato where cd_cliente = n.cd_cliente) as nm_contato,
    n.dt_saida_nota_saida,	 --Saida
    n.dt_entrega_nota_saida,	 --Entrega
    n.cd_nota_saida, 		 --Nota
    n.dt_nota_saida, 	 	 --Emissao
    n.vl_frete,                  --Frete
    n.vl_total, 		 --Valor
    n.cd_pedido_venda, 		 --Pedido
    n.ic_entrega_nota_saida,	 --Entregue
    n.nm_obs_entrega_nota_saida, --Observacao
    e.nm_entregador, 		 --Entregador
    o.cd_observacao_entrega,
    o.nm_observacao_entrega,
    IsNull(nd.dt_duplicata,'Não posue duplicata') as dt_duplicata,
    t.nm_transportadora,
    n.cd_usuario,
    n.dt_usuario
  from
    nota_saida n 
      left outer join
    cliente c 
      on n.cd_cliente = c.cd_cliente 
      left outer join
    transportadora t 
      on n.cd_transportadora = t.cd_transportadora 
      left outer join
    Entregador e 
      on n.cd_entregador = e.cd_entregador
      Left Outer Join
    Observacao_entrega o
      on n.cd_observacao_entrega = o.cd_observacao_entrega
      Inner Join    
    #NotaSaida_duplicata nd
      on n.cd_nota_saida = nd.cd_nota_saida
      Left Outer Join
    Operacao_fiscal opf
      on n.cd_operacao_fiscal = opf.cd_operacao_fiscal
  where
    o.nm_observacao_entrega like '%Retira%' and     -- Tipo de entrega "Retira"
     n.dt_saida_nota_saida is null and              -- Data de Saída em Branco
    (n.dt_cancel_nota_saida is null or
     n.dt_nota_dev_nota_saida is null) and          -- Nota Cancelada ou devolvida
    IsNull(n.ic_entrega_nota_saida, 'N') in ('E','S') and 
--     ((IsNull(n.ic_entrega_nota_saida, 'N') = @ic_entrega_nota_saida) or
--      (@ic_entrega_nota_saida = '')) and -- Notas que tenham aviso de retira  
    opf.ic_comercial_operacao = 'S' and             -- Verifica se Operação Fiscal tem valor comercial
    ((n.dt_nota_saida between @dt_inicial and @dt_final) or
    ((Isnull(@dt_inicial,0) = 0) and (Isnull(@dt_final,0) = 0))) and 
    ((n.cd_cliente = @cd_cliente) or (@cd_cliente = 0)) and 
    ((n.cd_entregador = @cd_entregador) or (@cd_entregador = 0))
  order by
    c.nm_fantasia_cliente,
    n.dt_nota_saida desc

End Else
---------------------------------------------------
-- Paramentro 2 para complemento do relatório
---------------------------------------------------
If @ic_parametro = 2
Begin

  Declare @SQL as varchar(1000)
  Set @SQL = 
    ' Select '+
    '   cd_nota_saida, '+
    '   cd_item_nota_saida, '+
    '   ds_item_nota_saida '+
    ' From '+
      ' Nota_Saida_Item '+
    ' Where '+
      ' cd_nota_saida = '+@cd_nota_saida_item

  Exec(@SQL)

end


