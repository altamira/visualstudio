
CREATE PROCEDURE pr_rel_requisicao_faturamento


-------------------------------------------------------------------------------
--pr_rel_requisicao_faturamento
-------------------------------------------------------------------------------
--GBS-Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure       : Microsoft SQL Server 2000
--Autor(es)              : Carlos Cardoso Fernandes
--Banco de Dados         : EGISSQL
--Objetivo               : Relatório de Requisição de Faturamento.
--Data                   : 16/04/2003
--Atualizado             : 21/03/2003 - Daniel C. Neto.
--                       : - Colocado Cabeçalho.
--                       : - Colocado máscara de CEP.
--                       : - Incluído cd_destinacao_produto - Daniel C. Neto - 16/04/2003
--                       : 10/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
-----------------------------------------------------------------------------------------




@cd_inicial int,
@cd_final int,
@ic_cancelada char(1)

AS

    Declare @codigo int
    Declare @cd_destinatario int
    Declare @cd_tipo_destinatario int
    Declare @nm_razao_social varchar(100)
    Declare @nm_bairro varchar(100)
    Declare @obsfaturamento varchar(1000)
    Declare @Telefone varchar(100)
    Declare @Endereco varchar(200)

    select
      identity(int, 1, 1) as codigo,
      r.*,
      d.nm_departamento,
      c.nm_condicao_pagamento,
      ofi.cd_mascara_operacao  + ' - ' + ofi.nm_operacao_fiscal as nm_operacao_fiscal,
      td.nm_tipo_destinatario,
      cast( r.cd_transportadora as varchar(20)) + ' - '+ tra.nm_transportadora as nm_transportadora,
      r.nm_local_entrega_req_fat as nm_local_entrega,
      cast( r.cd_especie_embalagem as varchar(20)) + ' - ' + eb.nm_especie_embalagem as nm_especie_embalagem,
      Cast(null as varchar(100)) nm_razao_social,
      Cast(null as varchar(100)) nm_bairro,
      Cast(null as varchar(1000)) obsfaturamento,
      Cast(null as varchar(100)) Telefone,
      Cast(null as varchar(200)) Endereco,
      dp.nm_destinacao_produto
    Into
      #Requisicao
    from
      requisicao_faturamento r with (nolock) 
        left outer join
      Departamento d           with (nolock) 
        on d.cd_departamento = r.cd_departamento
        left outer join
      condicao_pagamento c     with (nolock) 
        on c.cd_condicao_pagamento = r.cd_condicao_pagamento_req
        left outer join
      Operacao_Fiscal ofi      with (nolock) 
        on ofi.cd_operacao_fiscal = r.cd_operacao_fiscal
        left outer join
      Tipo_Destinatario td     with (nolock) 
        on td.cd_tipo_destinatario = r.cd_tipo_destinatario
        left outer join
      Transportadora tra       with (nolock) 
        on tra.cd_transportadora = r.cd_transportadora
        left outer join
      Especie_Embalagem eb     with (nolock) 
        on eb.cd_especie_embalagem = r.cd_especie_embalagem
        left outer join
      Destinacao_Produto dp    with (nolock) 
        on dp.cd_destinacao_produto = r.cd_destinacao_produto
    where
      (r.cd_requisicao_faturamento = @cd_inicial and @cd_final = 0) or
      (r.cd_requisicao_faturamento between @cd_inicial and @cd_final and @cd_final > 0) and
      r.ic_req_fat_cancelamento = @ic_cancelada
    Order By r.cd_requisicao_faturamento

    Select * 
    Into
      #RequisicaoII
    from
     #Requisicao

    Set @codigo = 1

    While Exists (Select 'X' From #Requisicao)
    Begin

      Set @nm_razao_social = ''
      Set @nm_bairro       = ''
      Set @obsfaturamento = ''
      Set @Telefone        = ''
      Set @Endereco        = ''


      Select 
        @cd_destinatario      = cd_destinatario,
        @cd_tipo_destinatario = cd_tipo_destinatario
      From #requisicao where codigo = @codigo

      If @cd_tipo_destinatario  = 1
      Begin

        Select
          @nm_razao_social = c.nm_razao_social_cliente,
          @nm_bairro        = c.nm_bairro,
          @obsfaturamento  = c.ds_cliente,
          @Telefone         = '(' + IsNull(RTrim(LTrim(c.cd_ddd)),'') + ') ' + IsNull(RTrim(LTrim(c.cd_telefone)),''),
          @Endereco         =   Case     When CHARINDEX('-', c.cd_cep) > 0 then 
                                              IsNull(RTrim(LTrim(c.nm_endereco_cliente)),'') + ', ' + IsNull(RTrim(LTrim(c.cd_numero_endereco)),'') +' - '+ 
                                              IsNull(RTrim(LTrim(ci.nm_cidade)),'') +' - '+ IsNull(RTrim(LTrim(e.sg_estado)),'') + ISNULL(' - CEP: ' + Cast(LTRIM(RTRIM(c.cd_cep)) as varchar(09)), '')
                                         Else                                               IsNull(RTrim(LTrim(c.nm_endereco_cliente)),'') + ', ' + IsNull(RTrim(LTrim(c.cd_numero_endereco)),'') +' - '+ 
                                              IsNull(RTrim(LTrim(c.nm_endereco_cliente)),'') + ', ' + IsNull(RTrim(LTrim(c.cd_numero_endereco)),'') +' - '+ 
                                              IsNull(RTrim(LTrim(ci.nm_cidade)),'') +' - '+ IsNull(RTrim(LTrim(e.sg_estado)),'') + ISNULL(' - CEP: ' + dbo.fn_formata_mascara('99999-999',RIGHT('00000000' + IsNull(Cast(LTRIM(RTRIM(c.cd_cep)) as varchar(8)),''),8)), '') 
                                         End

        from 
          cliente c with (nolock) 
            Left Outer Join
          Estado e  with (nolock) 
            on c.cd_pais = e.cd_pais and
               c.cd_estado = e.cd_estado
            LEft Outer Join
          Cidade ci with (nolock) 
            on c.cd_pais = ci.cd_pais and
               c.cd_estado = ci.cd_estado and
               c.cd_cidade = ci.cd_cidade
        where 
          c.cd_cliente = @cd_destinatario

      
      End
      If @cd_tipo_destinatario = 2
      Begin

        Select 
          @nm_razao_social = f.nm_razao_social,
          @nm_bairro       = f.nm_bairro,
          @obsfaturamento = f.ds_fornecedor,
          @Telefone        = '(' + IsNull(RTrim(LTrim(f.cd_ddd)),'') + ') ' + IsNull(RTrim(LTrim(f.cd_telefone)),''),
          @Endereco         =   Case     When CHARINDEX('-', f.cd_cep) > 0 then 
                                              IsNull(RTrim(LTrim(f.nm_endereco_fornecedor)),'') + ', ' + IsNull(RTrim(LTrim(f.cd_numero_endereco)),'') +' - '+ 
                                              IsNull(RTrim(LTrim(ci.nm_cidade)),'') +' - '+ IsNull(RTrim(LTrim(e.sg_estado)),'') + ISNULL(' - CEP: ' + Cast(LTRIM(RTRIM(f.cd_cep)) as varchar(09)), '')
                                         Else                                               IsNull(RTrim(LTrim(f.nm_endereco_fornecedor)),'') + ', ' + IsNull(RTrim(LTrim(f.cd_numero_endereco)),'') +' - '+ 
                                              IsNull(RTrim(LTrim(f.nm_endereco_fornecedor)),'') + ', ' + IsNull(RTrim(LTrim(f.cd_numero_endereco)),'') +' - '+ 
                                              IsNull(RTrim(LTrim(ci.nm_cidade)),'') +' - '+ IsNull(RTrim(LTrim(e.sg_estado)),'') + ISNULL(' - CEP: ' + dbo.fn_formata_mascara('99999-999',RIGHT('00000000' + IsNull(Cast(LTRIM(RTRIM(f.cd_cep)) as varchar(8)),''),8)), '') 
                                         End
        from 
          Fornecedor f with (nolock) 
            Left Outer Join
          Estado e     with (nolock) 
            on f.cd_pais = e.cd_pais and
               f.cd_estado = e.cd_estado
            LEft Outer Join
          Cidade ci    with (nolock) 
            on f.cd_pais = ci.cd_pais and
               f.cd_estado = ci.cd_estado and
               f.cd_cidade = ci.cd_cidade
        where f.cd_fornecedor = @cd_destinatario

      End     
      If @cd_tipo_destinatario = 3
      Begin

        Select 
          @nm_razao_social = v.nm_fantasia_vendedor,
          @nm_bairro       = v.nm_bairro_vendedor,
          @obsfaturamento = '',
          @Telefone        = '(' + IsNull(RTrim(LTrim(v.cd_ddd_vendedor)),'') + ') ' + IsNull(RTrim(LTrim(v.cd_telefone_vendedor)),''),
          @Endereco         =   Case     When CHARINDEX('-', v.cd_cep) > 0 then 
                                              IsNull(RTrim(LTrim(v.nm_endereco_vendedor)),'') + ', ' + IsNull(RTrim(LTrim(v.cd_numero_endereco)),'') +' - '+ 
                                              IsNull(RTrim(LTrim(ci.nm_cidade)),'') +' - '+ IsNull(RTrim(LTrim(e.sg_estado)),'') + ISNULL(' - CEP: ' + Cast(LTRIM(RTRIM(v.cd_cep)) as varchar(09)), '')
                                         Else                                               IsNull(RTrim(LTrim(v.nm_endereco_vendedor)),'') + ', ' + IsNull(RTrim(LTrim(v.cd_numero_endereco)),'') +' - '+ 
                                              IsNull(RTrim(LTrim(v.nm_endereco_vendedor)),'') + ', ' + IsNull(RTrim(LTrim(v.cd_numero_endereco)),'') +' - '+ 
                                              IsNull(RTrim(LTrim(ci.nm_cidade)),'') +' - '+ IsNull(RTrim(LTrim(e.sg_estado)),'') + ISNULL(' - CEP: ' + dbo.fn_formata_mascara('99999-999',RIGHT('00000000' + IsNull(Cast(LTRIM(RTRIM(v.cd_cep)) as varchar(8)),''),8)), '') 
                                         End
        from 
          Vendedor v with (nolock)  
            Left Outer Join
          Estado e   with (nolock) 
            on v.cd_pais = e.cd_pais and
               v.cd_estado = e.cd_estado
            Left Outer Join
          Cidade ci  with (nolock) 
            on v.cd_pais = ci.cd_pais and
               v.cd_estado = ci.cd_estado and
               v.cd_cidade = ci.cd_cidade
        where v.cd_vendedor = @cd_destinatario

      End
      If @cd_tipo_destinatario = 4
      Begin

        Select 
          @nm_razao_social = t.nm_transportadora,
          @nm_bairro       = t.nm_bairro,
          @obsfaturamento = '',
          @Telefone        = '(' + IsNull(RTrim(LTrim(t.cd_ddd)),'') + ') ' + IsNull(RTrim(LTrim(t.cd_telefone)),''),
          @Endereco         =   Case     When CHARINDEX('-', t.cd_cep) > 0 then 
                                              IsNull(RTrim(LTrim(t.nm_endereco)),'') + ', ' + IsNull(RTrim(LTrim(t.cd_numero_endereco)),'') +' - '+ 
                                              IsNull(RTrim(LTrim(ci.nm_cidade)),'') +' - '+ IsNull(RTrim(LTrim(e.sg_estado)),'') + ISNULL(' - CEP: ' + Cast(LTRIM(RTRIM(t.cd_cep)) as varchar(09)), '')
                                         Else                                               IsNull(RTrim(LTrim(t.nm_endereco)),'') + ', ' + IsNull(RTrim(LTrim(t.cd_numero_endereco)),'') +' - '+ 
                                              IsNull(RTrim(LTrim(t.nm_endereco)),'') + ', ' + IsNull(RTrim(LTrim(t.cd_numero_endereco)),'') +' - '+ 
                                              IsNull(RTrim(LTrim(ci.nm_cidade)),'') +' - '+ IsNull(RTrim(LTrim(e.sg_estado)),'') + ISNULL(' - CEP: ' + dbo.fn_formata_mascara('99999-999',RIGHT('00000000' + IsNull(Cast(LTRIM(RTRIM(t.cd_cep)) as varchar(8)),''),8)), '') 
                                         End
        from 
          Transportadora t with (nolock) 
            Left Outer Join
          Estado e         with (nolock) 
            on t.cd_pais = e.cd_pais and
               t.cd_estado = e.cd_estado
            Left Outer Join
          Cidade ci        with (nolock) 
            on t.cd_pais = ci.cd_pais and
               t.cd_estado = ci.cd_estado and
               t.cd_cidade = ci.cd_cidade
        where t.cd_transportadora = @cd_destinatario

      End

      Update #RequisicaoII
      Set nm_razao_social = @nm_razao_social,
          nm_bairro       = @nm_bairro,
          obsfaturamento = @obsfaturamento,
          Telefone        = @Telefone,
          Endereco        = @Endereco
      Where
        codigo = @codigo

      Delete #Requisicao Where codigo = @codigo
      Set @codigo = @codigo + 1
    End

    Select * from #RequisicaoII



