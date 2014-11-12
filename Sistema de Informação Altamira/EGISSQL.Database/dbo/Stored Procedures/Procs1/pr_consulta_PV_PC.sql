
create procedure pr_consulta_PV_PC
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                2003                     
--Stored Procedure : SQL Server Microsoft 7.0  / 2000
--Autor (es)       : Carlos Cardoso Fernandes         
--Banco Dados      : EGISSQL
--Objetivo         : Atualização do Inventário de Gestão
--Data             : 10.09.2003
--		   : Incluido os campos do INSERT da tabela Produto_Fechamento
-----------------------------------------------------------------------------------
@nm_fantasia_produto Varchar(30),
@dt_inicial DateTime = '',
@dt_final DateTime = ''
as
  If @dt_inicial = ''
  Begin
    Set @dt_inicial = Getdate()
    Set @dt_final   = GetDate()
  End


  select
    n.cd_nota_saida + ni.cd_item_nota_saida as cd_chave,
		p.nm_fantasia_produto,
    gp.cd_mascara_grupo_produto,
		ni.nm_produto_item_nota,
		n.dt_nota_saida,
		n.cd_nota_saida,
		ni.cd_item_nota_saida,
		ni.qt_item_nota_saida,    
		n.cd_tipo_destinatario,
    d.nm_razao_social nm_razao_social_dest,
    IsNull(n.nm_fantasia_nota_saida, d.nm_fantasia) nm_fantasia_nota_saida,
		v.nm_vendedor,
		round(ni.vl_unitario_item_nota, 2) as vl_unitario_item_nota,
    IsNull(ni.pc_icms,0) pc_icms,
    IsNull(ni.pc_reducao_icms,0) pc_reducao_icms,
    case
      when IsNull(ni.pc_icms,0) <> 0
      then case
             when IsNull(ni.pc_reducao_icms,0) <> 0
             then ni.vl_unitario_item_nota  - (ni.vl_unitario_item_nota / (1 - (IsNull(ni.pc_icms,1) * IsNull(ni.pc_reducao_icms,1))) * -1)
             Else ni.vl_unitario_item_nota  - (ni.vl_unitario_item_nota / (1 - IsNull(ni.pc_icms,1)) * -1)
           end
      else ni.vl_unitario_item_nota
    end vl_liquido,
    IsNull(pvi.vl_lista_item_pedido, p.vl_produto) vl_lista,
    cast(null as float) pc_desconto,
    Isnull(me.vl_custo_contabil_produto, 0) as vl_preco_custo,
		Cast(null as float) pc_diferenca,
		gp.nm_grupo_produto
  Into
    #Auditoria
  from 
    Nota_Saida n
      Inner join
    nota_saida_item ni
      on n.cd_nota_saida = ni.cd_nota_saida
      left join 
    movimento_estoque me
      on me.cd_documento_movimento = ni.cd_nota_saida
      and me.cd_item_documento = ni.cd_item_nota_saida
      and me.cd_produto = ni.cd_produto
      and me.cd_tipo_documento_estoque = 4
      Left Outer Join
    Pedido_Venda_Item pvi
      on ni.cd_pedido_venda = pvi.cd_pedido_venda and
         ni.cd_item_pedido_venda = pvi.cd_item_pedido_venda
      Left Outer Join
    vw_destinatario d
      on n.cd_tipo_destinatario = d.cd_tipo_destinatario and
         IsNull(IsNull(IsNull(n.cd_cliente, n.cd_fornecedor),n.cd_vendedor),n.cd_transportadora) = d.cd_destinatario
      Inner join
    produto p
      on ni.cd_produto = p.cd_produto
      Inner Join
    grupo_produto gp
      on p.cd_grupo_produto = gp.cd_grupo_produto
      Inner Join
    vendedor v
      on v.cd_vendedor = n.cd_vendedor
      Inner Join
    Documento_Receber dr
      on n.cd_nota_saida = dr.cd_nota_saida
  where 
    n.cd_status_nota <> 7 and
    n.dt_nota_saida between @dt_inicial and @dt_final and
    P.nm_fantasia_produto lIKE @nm_fantasia_produto + '%'    
  order by 
    n.cd_nota_saida,
    cd_chave,
    p.nm_fantasia_produto, 
    ni.cd_mascara_produto

  Update #Auditoria
  set pc_desconto = 100 - (vl_liquido * 100/ vl_lista),
      pc_diferenca = Case when IsNull(vl_preco_custo,0) <> 0 then (vl_liquido * 100 / vl_preco_custo) - 100
                          Else 0 end

  Select * from #Auditoria
